import 'package:driver_app/core/constants/enum.dart';

class BackendEnviroment {
  static ComunicationMode mode = ComunicationMode.BackDoLogic;
  static bool isPoor = true;

  static String host = "https://dacnpmbe11.azurewebsites.net/api";
  static GraphQLEnviroment graphQLEnviroment = GraphQLEnviroment();

  static checkDevelopmentMode({bool isUseEmulator = false}) {
    assert(() {
      if (isUseEmulator) {
        host = "http://10.0.2.2:8001/api";
      } else {
        host = "http://192.168.1.4:8001/api";
      }
      graphQLEnviroment.checkDevelopmentMode();
      return true;
    }());
  }

  static bool checkV2Comunication() {
    {
      return mode == ComunicationMode.BackDoLogic;
    }
  }
}

class GraphQLEnviroment {
  String graphqlHost = 'https://dacnpmbe11.azurewebsites/';

  String tripPath = 'trip/graphql';
  String infoPath = 'info/graphql';

  String get tripHost => graphqlHost + tripPath;
  String get infoHost => graphqlHost + infoPath;

  checkDevelopmentMode({bool isUseEmulator = false}) {
    assert(() {
      if (isUseEmulator) {
        graphqlHost = "http://10.0.2.2:8001/";
      } else {
        graphqlHost = "http://192.168.1.4:8001/";
      }
      return true;
    }());
  }
}
