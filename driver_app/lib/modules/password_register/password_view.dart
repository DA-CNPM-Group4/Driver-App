import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver_app/routes/app_routes.dart';
import './password_controller.dart';

class PasswordView extends GetView<PasswordController> {
  const PasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icons/phone_icon.png",
                  height: 80,
                ),
                const SizedBox(height: 12),
                Text(
                  "Type your password!",
                  style: BaseTextStyle.heading2(),
                ),
                const SizedBox(height: 18),
                Text(
                  "In order to secure your account, we recommend you to input a strong password",
                  style: BaseTextStyle.body2(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Text(
                  "Password",
                  style: BaseTextStyle.heading2(fontSize: 20),
                ),
                Form(
                  key: controller.formKey,
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) => controller.passwordValidator(value!),
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      hintText: 'Type password right here...',
                      hintStyle:
                          BaseTextStyle.body3(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ElevatedButton(
              onPressed: () async {
                if (controller.validateAndSave()) {
                  await controller.registerDriver();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Confirm"),
            ),
          ),
        ),
      ),
    );
  }
}
