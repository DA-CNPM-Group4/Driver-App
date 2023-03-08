import 'package:driver_app/routes/app_routes.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import './register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
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
                  "Enter your primary phone number to register",
                  style: textTheme.displayLarge,
                ),
                h_10,
                Row(
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
                    Obx(
                      () => Form(
                        key: controller.phoneFormKey,
                        child: Flexible(
                          child: TextFormField(
                            controller: controller.phoneNumberController,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                controller.phoneNumberValidator(value!),
                            onSaved: (value) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              hintText: '123xxxxxxx',
                              errorText: controller.phoneError.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                h_10,
                 Text(
                  "Enter your Email to register",
                  style: textTheme.displayLarge,
                ),
                Row(
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
                    Obx(
                      () => Form(
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
                              errorText: controller.emailError.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: ElevatedButton(
            onPressed: () async {
              var check = await controller.validateAndSave();

              if (check) {
                Get.toNamed(Routes.OTP);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
