import 'package:driver_app/routes/app_routes.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import './login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const h_20 = SizedBox(
      height: 20,
    );
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/login_icon.png",
              height: 80,
            ),
            h_20,
            Obx(() => controller.isUsingEmail.value
                ? Text(
                    "Enter your registered Email address to log in",
                    style: BaseTextStyle.heading3(),
                  )
                : Text(
                    "Enter your registered phone number to log in",
                    style: textTheme.displayLarge,
                  )),
            h_20,
            Obx(
              () => controller.isUsingEmail.value
                  ? Row(
                      children: [
                        SizedBox(
                          width: 85,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: BaseColor.green,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Email",
                                    style: textTheme.displaySmall,
                                  )
                                ],
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Form(
                          key: controller.emailFormKey,
                          child: Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: controller.emailController,
                              validator: (value) =>
                                  controller.emailValidator(value!),
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                hintText: 'Someemail@Email.com',
                                errorText: controller.error.value,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: 85,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/flag.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "+84",
                                    style: textTheme.displayMedium,
                                  )
                                ],
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Form(
                          key: controller.phoneFormKey,
                          child: Flexible(
                            child: Obx(
                              () => TextFormField(
                                keyboardType: TextInputType.number,
                                controller: controller.phoneNumberController,
                                validator: (value) =>
                                    controller.phoneNumberValidator(value!),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  errorText: controller.error.value,
                                  hintText: '123xxxxxxx',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            h_20,
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: BaseColor.hint),
                onPressed: () {
                  controller.changeLoginMethod();
                },
                child: Obx(() {
                  if (controller.isUsingEmail.value) {
                    return const Text("Login By Phone");
                  } else {
                    return const Text("Login By Email");
                  }
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Or",
                style: BaseTextStyle.heading1(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: BaseColor.blue),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          fit: BoxFit.cover),
                      const SizedBox(
                        width: 5.0,
                      ),
                      const Text('Sign-in with Google')
                    ],
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: ElevatedButton(
            onPressed: () async {
              if (await controller.validateAndSave()) {
                Get.toNamed(Routes.PASSWORD_LOGIN);
              }
              Get.toNamed(Routes.PASSWORD_LOGIN);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Continue"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
