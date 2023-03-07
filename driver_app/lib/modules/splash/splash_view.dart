import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get.dart';

import './splash_controller.dart';
import '../welcome/welcome_view.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body:  AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset("assets/icons/splash_logo.jpg"),
        splashIconSize: 150,
        nextScreen: controller.isFirstTimeOpenApp ? const WelcomeView() : const WelcomeView(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
