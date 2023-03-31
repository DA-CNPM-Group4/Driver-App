import 'dart:convert';
import 'dart:io';
import 'package:driver_app/Data/models/requests/login_response.dart';
import 'package:driver_app/core/constants/backend_enviroment.dart';
import 'package:dio/dio.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  static late final FlutterSecureStorage _storage;
  static late final Dio client;

  static final APIHandlerImp _singleton = APIHandlerImp._internal();
  static APIHandlerImp get instance => _singleton;

  factory APIHandlerImp() {
    return _singleton;
  }

  APIHandlerImp._internal() {
    host = BackendEnviroment.host;
    _storage = const FlutterSecureStorage();
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
    return response;
  }

  @override
  Future<Response> get(
    String endpoint, {
    bool useToken = false,
    Map<String, dynamic>? query,
  }) async {
    Response response = await client.get(
      host + endpoint,
      queryParameters: query,
      options: Options(
        headers: await _buildHeader(useToken: useToken),
      ),
    );
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
    return response;
  }

  Future<void> refreshToken() async {
    try {
      var accessToken = await APIHandlerImp.instance.getAccessToken();
      var refreshToken = await APIHandlerImp.instance.getRefreshToken();

      var response = await APIHandlerImp.instance.post(
        {
          'AccessToken': accessToken,
          'RefreshToken': refreshToken,
        },
        "/Authentication/RetriveTokens",
      );
      if (response.data['status']) {
        var body = LoginResponseBody.fromJson(response.data['data']);

        await storeRefreshToken(body.refreshToken);
        await storeAccessToken(body.accessToken);
        await storeIdentity(body.accountId);
      } else {
        return Future.error(UnexpectedException(
          message: "Something Happend Please Login Again",
          context: "Refresh Token",
          debugMessage: response.data['message'],
        ));
      }
    } catch (e) {
      await APIHandlerImp.instance.deleteToken();
      return Future.error(UnexpectedException(
          context: "Refresh Token", debugMessage: e.toString()));
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: "accessToken");
  }

  @override
  Future<void> storeAccessToken(String token) async {
    return await _storage.write(key: "accessToken", value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refreshToken");
  }

  @override
  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: "token", value: token);
  }

  @override
  Future<void> storeIdentity(String id) async {
    await _storage.write(key: "id", value: id);
  }

  @override
  Future<String?> getIdentity() async {
    return await _storage.read(key: "id");
  }

  @override
  Future<void> deleteToken() async {
    await _storage.deleteAll();
  }
}
