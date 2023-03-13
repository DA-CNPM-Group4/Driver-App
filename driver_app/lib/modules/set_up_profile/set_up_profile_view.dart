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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(130),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You'll register as a:",
                    style: BaseTextStyle.heading1(fontSize: 18),
                  ),
                  h_20,
                  Obx(
                    () => ListTile(
                      leading: Image.asset(
                        controller.vehicles[controller.selectedIndex.value].img,
                        height: 50,
                      ),
                      title: Text(
                          controller
                              .vehicles[controller.selectedIndex.value].name,
                          style: BaseTextStyle.heading4(fontSize: 20)),
                      trailing: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: const StadiumBorder(
                                      side: BorderSide(color: Colors.green))),
                              onPressed: () {
                                Get.bottomSheet(
                                  bottomSheet(textTheme: textTheme),
                                  isDismissible: true,
                                );
                              },
                              child: Text("Change",
                                  style: BaseTextStyle.heading4(
                                      fontSize: 16, color: Colors.green)))),
                    ),
                  )
                ],
              ),
            ),
          ),
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
                  Text(
                    "Contact",
                    style: BaseTextStyle.body1(fontSize: 14),
                  ),
                  h_10,
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/flag.png",
                                  height: 20,
                                  width: 20,
                                ),
                                Text(
                                  "+84",
                                  style: BaseTextStyle.heading2(fontSize: 16),
                                )
                              ],
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: controller.phoneNumberController,
                          validator: (value) =>
                              controller.phoneNumberValidator(value!),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration:
                              const InputDecoration(hintText: '123xxxxxxx'),
                        ),
                      ),
                    ],
                  ),
                  h_20,
                  titleAndText(
                      title: "Email Address",
                      hint: "Only gmail Ids are accepted",
                      controller: controller.emailController,
                      validator: (value) => controller.emailValidator(value!),
                      textTheme: textTheme),
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
              // var check = await controller.validateAndSave();
              // if (check) {
              Get.toNamed(Routes.VEHICLE_REGISTRATION);
              // }
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

  Widget bottomSheet({required TextTheme textTheme}) {
    return Container(
        height: Get.height * 0.5,
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(right: 20),
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      "assets/icons/x_icon.png",
                      height: 30,
                      width: 30,
                    ),
                    onPressed: () {
                      Get.back();
                    })),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    "What do you want to register for?",
                    style: BaseTextStyle.heading2(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (_, itemBuilder) {
                        return ListTile(
                          onTap: () {
                            controller.selectedIndex.value = itemBuilder;
                            Get.back();
                          },
                          leading: Image.asset(
                            controller.vehicles[itemBuilder].img,
                            height: 40,
                          ),
                          title: Text(
                            controller.vehicles[itemBuilder].name,
                            style: BaseTextStyle.heading2(fontSize: 18),
                          ),
                          subtitle: Text(
                            controller.vehicles[itemBuilder].description,
                            style: BaseTextStyle.body1(fontSize: 14),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                        );
                      },
                      itemCount: controller.vehicles.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ))
          ],
        ));
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
