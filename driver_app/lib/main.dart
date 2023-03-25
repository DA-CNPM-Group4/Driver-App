import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/core/constants/backend_enviroment.dart';
import 'package:driver_app/routes/app_pages.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

void main() async {
  BackendEnviroment.checkDevelopmentMode();
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
    Hive.registerAdapter(VehicleEntityAdapter());
    Hive.registerAdapter(DriverEntityAdapter());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
