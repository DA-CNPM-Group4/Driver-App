import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../routes/app_routes.dart';
import '../controllers/password_controller.dart';

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
                  "assets/phone_icon.png",
                  height: 80,
                ),
                h_10,
                Text(
                  "Type your password!",
                  style: textTheme.headline1,
                ),
                h_10,
                Text(
                  "In order to secure your account, we recommend you to input a strong password",
                  style: textTheme.headline2,
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
                if(controller.validateAndSave()){
                  Get.toNamed(Routes.SET_UP_PROFILE);
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text("Confirm"),
            ),
          ),
        ),
      ),
    );
  }
}
