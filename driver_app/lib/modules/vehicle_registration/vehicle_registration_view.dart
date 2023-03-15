import 'package:driver_app/routes/app_routes.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'vehicle_registration_controller.dart';

class VehicleRegistrationView extends GetView<VehicleRegistrationController> {
  const VehicleRegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const h_20 = SizedBox(
      height: 20,
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Vehicle Registration',
            style: BaseTextStyle.heading4(fontSize: 18),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
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
                  titleAndText(
                      title: "Number plate",
                      hint: "e.g 60B3-XXXXXX",
                      textTheme: textTheme,
                      controller: controller.numberPlateController,
                      validator: (value) =>
                          controller.numberPlateValidator(value!)),
                  h_20,
                  titleAndText(
                      title: "Vehicle Name",
                      hint: "e.g Samsung Galaxy",
                      textTheme: textTheme,
                      controller: controller.vehicleNameController,
                      validator: (value) =>
                          controller.ownerNameValidator(value!)),
                  h_20,
                  titleAndText(
                      title: "Vehicle brand",
                      hint: "Click here to select",
                      textTheme: textTheme,
                      onTap: () {
                        Get.bottomSheet(
                          bottomSheet(textTheme: textTheme),
                          isDismissible: true,
                        );
                      },
                      controller: controller.vehicleBrandController,
                      validator: (value) =>
                          controller.vehicleBrandValidator(value!),
                      disable: true,
                      icon: Icons.arrow_drop_down),
                  h_20,
                  titleAndText(
                    title: "Vehicle type",
                    hint: "Input vehicle type",
                    controller: controller.vehicleType,
                    validator: (value) =>
                        controller.vehicleTypeValidator(value!),
                    textTheme: textTheme,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: ElevatedButton(
              onPressed: () async {
                var check = await controller.validateAndSave();

                if (check) {
                  await controller.register();
                  Get.snackbar("Register successfully",
                      "You can access our system from now on",
                      colorText: Colors.black,
                      backgroundColor: Colors.grey[200]);
                }
                Get.offAllNamed(Routes.WELCOME);
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
      ),
    );
  }

  Widget titleAndText(
      {required String title,
      required String hint,
      required TextTheme textTheme,
      TextEditingController? controller,
      IconData? icon,
      bool? disable,
      TextInputFormatter? format,
      Function()? onTap,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: BaseTextStyle.heading2(fontSize: 14),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          readOnly: disable ?? false,
          validator: (value) => validator != null ? validator(value) : null,
          onSaved: (value) {},
          onTap: onTap,
          obscureText: false,
          decoration: InputDecoration(hintText: hint, suffixIcon: Icon(icon)),
        ),
      ],
    );
  }

  Widget bottomSheet({required TextTheme textTheme}) {
    return Container(
        height: Get.height * 0.7,
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
                        var value = controller.setUpProfileController
                                    .selectedIndex.value ==
                                0
                            ? controller.motorcycleBrand[itemBuilder]
                            : controller.carBrand[itemBuilder];
                        return ListTile(
                          onTap: () {
                            controller.selectedItem.value = itemBuilder;
                            controller.vehicleBrandController.text = value;
                            Get.back();
                          },
                          title: Text(
                            value,
                            style: BaseTextStyle.heading2(fontSize: 18),
                          ),
                        );
                      },
                      itemCount: controller
                                  .setUpProfileController.selectedIndex.value ==
                              0
                          ? controller.motorcycleBrand.length
                          : controller.carBrand.length,
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
}
