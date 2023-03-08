import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver_app/routes/app_routes.dart';
import './password_controller.dart';

class PasswordView extends GetView<PasswordController> {
  const PasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var h_10 = const SizedBox(
      height: 10,
    );
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
                h_10,
                Text(
                  "Type your password!",
                  style: textTheme.displayLarge,
                ),
                h_10,
                Text(
                  "In order to secure your account, we recommend you to input a strong password",
                  style: textTheme.displayMedium,
                ),
                h_10,
                Form(
                  key: controller.formKey,
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) => controller.passwordValidator(value!),
                    controller: controller.passwordController,
                    decoration: const InputDecoration(
                        hintText: 'type password right here'),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: () {
                if (controller.validateAndSave()) {
                  Get.toNamed(Routes.SET_UP_PROFILE);
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
