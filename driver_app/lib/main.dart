import 'package:driver_app/modules/location_test/location_test_view.dart';
import 'package:driver_app/data/model/driver_entity.dart';
import 'package:driver_app/data/model/vehicle_list_entity.dart';
import 'package:driver_app/routes/app_pages.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

void main() async {
  await setup();

  runApp(GetMaterialApp(
    title: "Application",
    // home: const TestUpdateLocation(),
    // initialRoute: AppPages.INITIAL,
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
    theme: baseTheme(),
  ));
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("box");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(DriverEntityAdapter());
    Hive.registerAdapter(VehicleListEntityAdapter());
  }
  // await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
