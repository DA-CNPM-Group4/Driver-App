import 'package:driver_app/modules/login/login_binding.dart';
import 'package:driver_app/modules/login/login_view.dart';
import 'package:driver_app/modules/register/register_view.dart';
import 'package:driver_app/modules/register/register_binding.dart';
import 'package:driver_app/modules/otp/otp_view.dart';
import 'package:driver_app/modules/otp/otp_binding.dart';
import 'package:driver_app/modules/splash/splash_view.dart';
import 'package:driver_app/modules/splash/splash_binding.dart';

import 'package:get/get.dart';
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
      name: Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
