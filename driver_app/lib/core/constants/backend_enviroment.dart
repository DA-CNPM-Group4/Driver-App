class BackendEnviroment {
  static String host = "https://dacnpmbe11.azurewebsites.net/api";
  static bool isPoor = true;

  static checkDevelopmentMode() {
    assert(() {
      host = "http://192.168.1.14:8001/api";
      return true;
    }());
  }
}
