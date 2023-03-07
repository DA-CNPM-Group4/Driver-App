abstract class Routes {
  Routes._();
  static const WELCOME = Paths.WELCOME;
  static const LOGIN = Paths.LOGIN;
  static const PASSWORD_LOGIN = Paths.LOGIN;
  static const REGISTER = Paths.REGISTER;
  static const PASSWORD_REGISTER = Paths.PASSWORD_REGISTER;
  static const SET_UP_PROFILE = Paths.SET_UP_PROFILE;
  static const VEHICLE_REGISTRATION = Paths.VEHICLE_REGISTRATION;
  static const OTP = Paths.OTP;
  static const SPLASH = Paths.SPLASH;
}

abstract class Paths {
  Paths._();
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';
  static const PASSWORD_LOGIN = '/password-login';
  static const REGISTER = '/register';
  static const PASSWORD_REGISTER = '/password-register';
  static const SET_UP_PROFILE = '/set-up-profile';
  static const VEHICLE_REGISTRATION = '/vehicle-registration';
  static const OTP = '/otp';
  static const SPLASH = '/splash';
}
