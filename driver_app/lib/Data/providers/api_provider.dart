import 'dart:convert';
import 'dart:io';
import 'package:driver_app/core/constants/backend_enviroment.dart';
import 'package:dio/dio.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';
import 'package:driver_app/core/utils/secure_storage.dart';
import 'package:flutter/material.dart';

abstract class APIHandlerInterface {
  Future<Response> get(String endpoint, {Map<String, dynamic>? query});
  Future<Response> post(var body, String endpoint,
      {Map<String, dynamic>? query});
  Future<Response> put(var body, String endpoint,
      {Map<String, dynamic>? query});

  Future<void> storeRefreshToken(String token);
  Future<void> storeAccessToken(String token);
  Future<void> storeIdentity(String token);

  Future<String?> getRefreshToken();
  Future<String?> getAccessToken();
  Future<String?> getIdentity();

  Future<void> deleteToken();
}

class APIHandlerImp implements APIHandlerInterface {
  static late final String host;
  static late final Dio client;

  static final APIHandlerImp _singleton = APIHandlerImp._internal();
  static APIHandlerImp get instance => _singleton;

  factory APIHandlerImp() {
    return _singleton;
  }

  APIHandlerImp._internal() {
    host = BackendEnviroment.host;
    client = Dio();
  }

  Future<Map<String, String>> _buildHeader({
    bool useToken = false,
    bool useRefereshToken = false,
  }) async {
    var baseHeader = {
      HttpHeaders.dateHeader: DateTime.now().millisecondsSinceEpoch.toString(),
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
      "device": "app"
    };
    baseHeader["X-Api-Key"] = "ApplicationKey";

    if (useToken) {
      String? token =
          !useRefereshToken ? await getAccessToken() : await getRefreshToken();
      if (token != "") {
        baseHeader["Authorization"] = "Bearer $token";
      }
    }
    return baseHeader;
  }

  static Uri buildUrlWithQuery(String endpoint, Map<String, dynamic> query) {
    return query.isEmpty
        ? Uri.parse(host + endpoint).replace(queryParameters: query)
        : Uri.parse(host + endpoint);
  }

  @override
  Future<Response> post(
    var body,
    String endpoint, {
    bool useToken = false,
    Map<String, dynamic>? query,
  }) async {
    Response response = await client.post(host + endpoint,
        data: json.encode(body),
        queryParameters: query,
        options: Options(headers: await _buildHeader(useToken: useToken)));

    if (response.statusCode == 401) {
      if (useToken) {
        return await _handleRefreshToken(
            HttpMethod.POST, endpoint, body, query, useToken);
      }
    }

    return response;
  }

  @override
  Future<Response> get(
    String endpoint, {
    dynamic body,
    bool useToken = false,
    Map<String, dynamic>? query,
  }) async {
    Response response = await client.get(
      host + endpoint,
      queryParameters: query,
      data: jsonEncode(body),
      options: Options(
        headers: await _buildHeader(useToken: useToken),
      ),
    );

    if (response.statusCode == 401) {
      if (useToken) {
        return await _handleRefreshToken(
            HttpMethod.GET, endpoint, body, query, useToken);
      }
    }

    return response;
  }

  @override
  Future<Response> put(
    body,
    String endpoint, {
    bool useToken = false,
    Map<String, dynamic>? query,
  }) async {
    Response response = await client.put(
      host + endpoint,
      queryParameters: query,
      data: json.encode(body),
      options: Options(
        headers: await _buildHeader(useToken: useToken),
      ),
    );

    if (response.statusCode == 401) {
      if (useToken) {
        return await _handleRefreshToken(
            HttpMethod.PUT, endpoint, body, query, useToken);
      }
    }

    return response;
  }

  @override
  Future<String?> getAccessToken() async {
    return await SecureStorage.storage.read(key: "accessToken");
  }

  @override
  Future<void> storeAccessToken(String token) async {
    return await SecureStorage.storage.write(key: "accessToken", value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await SecureStorage.storage.read(key: "refreshToken");
  }

  @override
  Future<void> storeRefreshToken(String token) async {
    await SecureStorage.storage.write(key: "token", value: token);
  }

  @override
  Future<void> storeIdentity(String id) async {
    await SecureStorage.storage.write(key: "id", value: id);
  }

  @override
  Future<String?> getIdentity() async {
    return SecureStorage.storage.read(key: "id");
  }

  @override
  Future<void> deleteToken() async {
    await SecureStorage.storage.deleteAll();
  }

  Future<Response<dynamic>> _handleRefreshToken(HttpMethod method,
      String endpoint, body, Map<String, dynamic>? query, bool useToken) async {
    await refreshToken();
    switch (method) {
      case HttpMethod.GET:
        return await client.get(
          host + endpoint,
          data: json.encode(body),
          queryParameters: query,
          options: Options(
            headers: await _buildHeader(useToken: useToken),
          ),
        );
      case HttpMethod.PUT:
        return await client.put(
          host + endpoint,
          data: json.encode(body),
          queryParameters: query,
          options: Options(
            headers: await _buildHeader(useToken: useToken),
          ),
        );
      case HttpMethod.POST:
        return await client.post(
          host + endpoint,
          data: json.encode(body),
          queryParameters: query,
          options: Options(
            headers: await _buildHeader(useToken: useToken),
          ),
        );
    }
  }

  Future<void> refreshToken() async {
    debugPrint("Refresh Token Start");
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    var body = {
      'AccessToken': accessToken,
      'RefreshToken': refreshToken,
    };

    try {
      var response = await post(body, "/Authentication/RetriveTokens");

      if (response.data['status'] ?? false) {
        await storeAccessToken(response.data['accessToken']);
        await storeRefreshToken(response.data['refreshToken']);
      } else {
        Future.error(const RefreshTokenException());
      }
    } catch (e) {
      Future.error(const RefreshTokenException());
    }
  }
}

enum HttpMethod {
  GET,
  PUT,
  POST,
}
