import 'package:driver_app/core/utils/avatar_circle/avatar_circle.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';
import 'edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

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
            "Update Information",
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
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 90,
                          width: 90,
                          child: const CircleAvatar(
                            child: AvatarCircle(
                                width: 180,
                                height: 180,
                                source: "assets/icons/profile_icon.png"),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 15,
                              child: SvgPicture.asset(
                                "assets/icons/ic_camera.svg",
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    "Please fill required fields below",
                    style: BaseTextStyle.heading2(fontSize: 16),
                  ),
                  h_20,
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
                      title: "Phone Number",
                      hint: "Enter your citizen ID",
                      controller: controller.phoneController,
                      validator: (value) =>
                          controller.phoneNumberValidator(value!),
                      textTheme: textTheme),
                  h_20,
                  titleAndText(
                      title: "Email",
                      hint: "Enter your driver license ID",
                      controller: controller.emailController,
                      validator: (value) => controller.emailValidator(value!),
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
              // var check = await controller.validateAndSave();
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
                      : const Text("Save"),
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
