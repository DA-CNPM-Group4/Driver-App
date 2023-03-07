import 'package:driver_app/routes/app_routes.dart';
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
            Text(
              "Enter your registered phone number to log in",
              style: textTheme.displayLarge,
            ),
            h_20,
            LoginByPhoneTextField(
                textTheme: textTheme,
                formKey: controller.formKey,
                errorText: controller.error.value,
                validation: controller.phoneNumberValidator,
                textEditingController: controller.phoneNumberController,
                key: controller.formKey),
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Continue"),
                )),
          ),
        ),
      ),
    );
  }
}

typedef TextFieldValidation = String? Function(String value);

class LoginByPhoneTextField extends StatelessWidget {
  const LoginByPhoneTextField({
    super.key,
    required this.textTheme,
    required this.textEditingController,
    required this.formKey,
    required this.validation,
    required this.errorText,
  });

  final TextTheme textTheme;
  final Key formKey;
  final TextEditingController textEditingController;
  final TextFieldValidation validation;
  final String? errorText;
  @override
  Widget build(BuildContext context) {
    return Row(
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
                    style: textTheme.displaySmall,
                  )
                ],
              )),
        ),
        const SizedBox(
          width: 5,
        ),
        Form(
          key: formKey,
          child: Flexible(
            child: Obx(
              () => TextFormField(
                controller: textEditingController,
                validator: (value) => validation(value!),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  errorText: errorText,
                  hintText: '123xxxxxxx',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
