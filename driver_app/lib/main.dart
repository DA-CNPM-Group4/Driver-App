import 'package:driver_app/data/model/driver_entity.dart';
import 'package:driver_app/data/model/vehicle_list_entity.dart';
import 'package:driver_app/routes/app_pages.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:driver_app/themes/references_resource_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await setup();

  runApp(GetMaterialApp(
    title: "Application",
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
    theme: baseTheme(),
  ));
}

Future<void> setup() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(DriverEntityAdapter());
    Hive.registerAdapter(VehicleListEntityAdapter());
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  var box = await Hive.openBox("box");
  // await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
