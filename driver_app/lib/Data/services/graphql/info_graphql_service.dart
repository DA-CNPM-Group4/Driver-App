import 'package:driver_app/Data/providers/graphql_provider.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InfoGraphQLService {
  GraphQLClient? _client;
  final String host;

  InfoGraphQLService(this.host);

  Future<Map<String, dynamic>> getPassengerInfo(String passengerId) async {
    final QueryOptions options = QueryOptions(
      document: gql(InfoGraphQLQueryString.queryPassengerInfo(passengerId)),
    );
    final QueryResult result = await MyGraphQLProvider.baseQuery(host,
        client: _client, queryOptions: options);
    if (result.hasException) {
      debugPrint(result.exception.toString());
      Future.error(const UnexpectedException(context: "graphql-get-trips"));
    }

    return Map<String, dynamic>.from(result.data!['passengerById']);
  }
}

class InfoGraphQLQueryString {
  static String queryPassengerInfo(String passengerId) => '''
query{
   passengerById(passengerId: "$passengerId"){
       gender
       name
       phone
   }
}
''';
}
