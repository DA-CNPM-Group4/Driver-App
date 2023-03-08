import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const h_40 = SizedBox(
      height: 40,
    );
    const h_20 = SizedBox(
      height: 20,
    );
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo_gojek.png",
          height: 100,
          width: 100,
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/banner.png",
                ),
                SizedBox(height: Get.height * 0.1),
                Text(
                  "Hi, Driver-partner! Ready to hit the road?",
                  style: textTheme.titleLarge,
                ),
                h_20,
                Text(
                  "Let's login to start receiving orders!",
                  style: textTheme.titleLarge,
                ),
                h_40,
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          Get.toNamed(Routes.LOGIN);
                        },
                        child: const Text("Log in"))),
                h_20,
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () {
                          Get.toNamed(Routes.REGISTER);
                        },
                        child: Text(
                          "REGISTER AS DRIVER-PARTNER",
                          style: textTheme.bodyLarge!
                              .copyWith(color: Colors.green),
                        ))),
                h_40,
                const Text(
                    "Click on Register to start or continue signing up, and view your registration status"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
