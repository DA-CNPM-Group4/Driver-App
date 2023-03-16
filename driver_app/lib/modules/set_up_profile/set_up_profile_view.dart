import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';
import 'set_up_profile_controller.dart';

class SetUpProfileView extends GetView<SetUpProfileController> {
  const SetUpProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const h_10 = SizedBox(
      height: 10,
    );
    const h_20 = SizedBox(
      height: 20,
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          title: Text(
            "Set up your profile",
            style: BaseTextStyle.heading2(fontSize: 20),
          ),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please fill required fields below",
                    style: BaseTextStyle.heading2(fontSize: 16),
                  ),
                  h_20,
                  Text(
                    "Gender",
                    style: BaseTextStyle.body1(fontSize: 14),
                  ),
                  Obx(
                    () => ListTile(
                      title: const Text("Male"),
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: Radio(
                        value: true,
                        groupValue: controller.defaultGender.value,
                        onChanged: (value) {
                          controller.defaultGender.value = value as bool;
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      title: const Text("Female"),
                      leading: Radio(
                        value: false,
                        groupValue: controller.defaultGender.value,
                        onChanged: (value) {
                          controller.defaultGender.value = value as bool;
                        },
                      ),
                    ),
                  ),
                  h_10,
                  titleAndText(
                      title: "Full Name",
                      hint: "e.g. Adit Brahmana",
                      textTheme: textTheme,
                      controller: controller.nameController,
                      validator: (value) => controller.nameValidator(value!)),
                  h_20,
                  titleAndText(
                      title: "Current Address",
                      hint: "Enter your current address",
                      controller: controller.addressController,
                      validator: (value) => controller.addressValidator(value!),
                      textTheme: textTheme),
                  h_20,
                  titleAndText(
                      title: "Citizen ID",
                      hint: "Enter your citizen ID",
                      controller: controller.idController,
                      validator: (value) => controller.idValidator(value!),
                      textTheme: textTheme),
                  h_20,
                  titleAndText(
                      title: "Driver license ID",
                      hint: "Enter your driver license ID",
                      controller: controller.driverLicenseController,
                      validator: (value) =>
                          controller.driverLicenseValidator(value!),
                      textTheme: textTheme),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: ElevatedButton(
            onPressed: () async {
              var check = await controller.validateAndSave();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
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

  Widget titleAndText(
      {required String title,
      required String hint,
      required TextTheme textTheme,
      TextEditingController? controller,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: BaseTextStyle.heading1(fontSize: 14),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          validator: (value) => validator != null ? validator(value) : null,
          onSaved: (value) {},
          inputFormatters: [],
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
