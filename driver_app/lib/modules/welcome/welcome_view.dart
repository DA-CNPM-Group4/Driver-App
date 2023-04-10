import 'package:driver_app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightSafeArea = size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  color: Colors.grey, shape: BoxShape.circle),
              child: const Center(
                  child: Text(
                "EN",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.center,
          child: SafeArea(
            child: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: heightSafeArea * 0.3,
                    child: Image.asset('assets/images/banner.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text("Hi, Driver-partner! Ready to hit the road?",
                        style: BaseTextStyle.heading2(fontSize: 20)),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text("Let's login to start receiving orders!",
                        style: BaseTextStyle.heading2(fontSize: 20)),
                  ),
                  Container(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 32),
                      width: double.infinity,
                      height: 72,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            Get.toNamed(Routes.LOGIN);
                          },
                          child: const Text("Log in"))),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(
                          side: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: Text(
                        "REGISTER AS DRIVER-PARTNER",
                        style: BaseTextStyle.body1(
                            color: Color.fromARGB(255, 10, 105, 26),
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "By logging in or registering, you agree to our ",
                        style: BaseTextStyle.body1(color: BaseColor.black),
                      ),
                      TextSpan(
                        text: "Terms of service ",
                        style: BaseTextStyle.body1(color: Colors.blue),
                      ),
                      TextSpan(
                        text: "and ",
                        style: BaseTextStyle.body1(color: BaseColor.black),
                      ),
                      TextSpan(
                        text: "Privacy policy",
                        style: BaseTextStyle.body1(color: Colors.blue),
                      ),
                    ])),
                  )
                ],
              ),
            )),
          ),
        ));
  }
}
