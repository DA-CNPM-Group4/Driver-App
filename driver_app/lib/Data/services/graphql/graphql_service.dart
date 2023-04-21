import 'package:driver_app/Data/services/graphql/info_graphql_service.dart';
import 'package:driver_app/Data/services/graphql/trip_graphql_service.dart';
import 'package:driver_app/core/constants/backend_enviroment.dart';

class GraphQLService {
  static final InfoGraphQLService infoGraphQLService =
      InfoGraphQLService(BackendEnviroment.graphQLEnviroment.infoHost);
  static final TripGraphQLService tripGraphQLService =
      TripGraphQLService(BackendEnviroment.graphQLEnviroment.tripHost);
}
