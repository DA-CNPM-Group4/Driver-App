import 'package:driver_app/modules/login/login_binding.dart';
import 'package:driver_app/modules/login/login_view.dart';
import 'package:driver_app/modules/password_login/password_login_view.dart';
import 'package:driver_app/modules/password_login/password_login_binding.dart';
import 'package:driver_app/modules/password_register/password_binding.dart';
import 'package:driver_app/modules/password_register/password_view.dart';
import 'package:driver_app/modules/register/register_view.dart';
import 'package:driver_app/modules/register/register_binding.dart';
import 'package:driver_app/modules/otp/otp_view.dart';
import 'package:driver_app/modules/otp/otp_binding.dart';
import 'package:driver_app/modules/splash/splash_view.dart';
import 'package:driver_app/modules/splash/splash_binding.dart';

import 'package:get/get.dart';
import '../modules/request/request_binding.dart';
import '../modules/request/request_view.dart';
import '../modules/user/user_binding.dart';
import '../modules/user/user_view.dart';
import 'app_routes.dart';

import 'package:driver_app/modules/welcome/welcome_view.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Paths.WELCOME,
      page: () => const WelcomeView(),
    ),
    GetPage(
      name: Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: Paths.PASSWORD_LOGIN,
      page: () => const PasswordLoginView(),
      binding: PasswordLoginBinding(),
    ),
    GetPage(
      name: Paths.PASSWORD_REGISTER,
      page: () => const PasswordView(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Paths.REQUEST,
      page: () => const RequestView(),
      binding: RequestBinding(),
    ),
    GetPage(
      name: Paths.USER,
      page: () => const UserView(),
      binding: UserBinding(),
    ),
  ];
}
