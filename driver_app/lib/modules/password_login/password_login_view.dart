import 'package:driver_app/routes/app_routes.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import './password_login_controller.dart';

class PasswordLoginView extends GetView<PasswordLoginController> {
  const PasswordLoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
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
              "assets/icons/phone_icon.png",
              height: 80,
            ),
            const SizedBox(height: 20),
            Text(
              "Enter your password to access our system",
              style: BaseTextStyle.heading2(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Form(
              key: controller.formKey,
              child: TextFormField(
                controller: controller.passwordController,
                validator: (value) => controller.passwordValidator(value!),
                obscureText: true,
                decoration:
                    const InputDecoration(hintText: 'Enter your password'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: ElevatedButton(
              onPressed: () async {
                if (controller.validateAndSave()) {
                  await controller.login();
                  Get.toNamed(Routes.DASHBOARD_PAGE);
                }
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
              )),
        ),
      ),
    );
  }
}
