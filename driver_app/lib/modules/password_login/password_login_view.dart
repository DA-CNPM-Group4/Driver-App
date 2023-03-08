import 'package:flutter/material.dart';

import 'package:get/get.dart';

import './password_login_controller.dart';

class PasswordLoginView extends GetView<PasswordLoginController> {
  const PasswordLoginView({Key? key}) : super(key: key);
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
              "assets/icons/phone_icon.png",
              height: 80,
            ),
            h_20,
            Text(
              "Enter your password to access our system",
              style: textTheme.displayLarge,
            ),
            h_20,
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
