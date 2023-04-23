import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';

class CustomModalSheet {
  static Future<void> buildChoosePhotoBottom({
    required BuildContext context,
    required VoidCallback onTappedCamera,
    required VoidCallback onTappedGallery,
  }) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        barrierColor: Colors.black.withOpacity(0.5),
        constraints: BoxConstraints(
            maxHeight: 150 + MediaQuery.of(context).padding.bottom),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 6),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                GestureDetector(
                    onTap: onTappedCamera,
                    child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(top: 16, bottom: 12),
                        child: Row(
                          children: [
                            Image.asset('assets/icons/icon_camera.png',
                                width: 24, height: 24),
                            const SizedBox(width: 12),
                            Text("Open Camera",
                                style: BaseTextStyle.subtitle1(
                                  color: BaseColor.black,
                                ))
                          ],
                        ))),
                const Divider(),
                GestureDetector(
                    onTap: onTappedGallery,
                    child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(top: 16, bottom: 12),
                        child: Row(
                          children: [
                            Image.asset('assets/icons/icon_library.png',
                                width: 24, height: 24),
                            const SizedBox(width: 12),
                            Text("Choose from Gallery",
                                style: BaseTextStyle.subtitle1(
                                  color: BaseColor.black,
                                ))
                          ],
                        )))
              ]));
        });
  }

  static Future<void> buildAddOptionBottomWithTwoBtn({
    required BuildContext context,
    Color? backgroundColor,
    Color? barrierColor,
    String? firstOptionIcon,
    String? secondOptionIcon,
    required String firstOptionLabel,
    required String secondOptionLabel,
    required VoidCallback onFirstOptionTap,
    required VoidCallback onSecondOptionTap,
  }) {
    return showModalBottomSheet(
        backgroundColor: backgroundColor ?? Colors.white,
        barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
        constraints: BoxConstraints(
            maxHeight: 150 + MediaQuery.of(context).padding.bottom),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 6),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                GestureDetector(
                    onTap: onFirstOptionTap,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 16, bottom: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                                firstOptionIcon ??
                                    'assets/icons/action/icon_manual_add.png',
                                width: 24,
                                height: 24),
                            const SizedBox(width: 12),
                            Text(firstOptionLabel,
                                style: BaseTextStyle.subtitle1(
                                    color: Colors.black))
                          ]),
                    )),
                const Divider(),
                GestureDetector(
                    onTap: onSecondOptionTap,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 16, bottom: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                                secondOptionIcon ??
                                    'assets/icons/action/icon_manual_add.png',
                                width: 24,
                                height: 24),
                            const SizedBox(width: 12),
                            Text(secondOptionLabel,
                                style: BaseTextStyle.subtitle1(
                                    color: Colors.black))
                          ]),
                    ))
              ]));
        });
  }
}
