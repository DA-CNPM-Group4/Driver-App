import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/core/constants/backend_enviroment.dart';
import 'package:driver_app/firebase_options.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/routes/app_pages.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  BackendEnviroment.setTestHost("http://10.0.2.2:8001/api");

  WidgetsFlutterBinding.ensureInitialized();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(VehicleEntityAdapter());
    Hive.registerAdapter(DriverEntityAdapter());
  }
  await Hive.initFlutter();
  await Hive.openBox("box");

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Wait for a trip |', () {
    testWidgets("Login flow |", (WidgetTester tester) async {
      // Initialize the app
      await _initApp(tester);

      // Navigate to the login screen
      await _navigateFromWelcomeToLogin(tester);

      // Log in with email and password
      await _loginWithEmailAndPassword(tester);
    });
  });
}

Future<void> _initApp(WidgetTester tester) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await tester.pumpWidget(
    GetMaterialApp(
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: baseTheme(),
      builder: EasyLoading.init(),
      smartManagement: SmartManagement.keepFactory,
      onInit: () {
        Get.put(LifeCycleController(), permanent: true);
      },
    ),
  );
}


Future<void> _navigateFromWelcomeToLogin(WidgetTester tester) async {
  final loginFinder = find.byKey(const Key("welcome_login_btn"));
  await tester.tap(loginFinder);
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('login_email_field')), findsOneWidget);
}

Future<void> _loginWithEmailAndPassword(WidgetTester tester) async {
  final emailFinder = find.byKey(const Key('login_email_field'));
  final phoneFinder = find.byKey(const Key("login_phone_field"));
  await tester.enterText(emailFinder, 'changkho6313@gmail.com');
  await tester.enterText(phoneFinder, '123456333');
  await tester.tap(find.byKey(const Key('login_login_btn')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  // await Future.delayed(const Duration(seconds: 1));

  final passwordFinder = find.byKey(const Key("password_login_password_field"));
  await tester.enterText(passwordFinder, '123456');
  await tester.tap(find.byKey(const Key('password_login_login_btn')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  // await Future.delayed(const Duration(seconds: 20));

  await tester.pumpAndSettle(const Duration(seconds: 5));
  expect(find.byKey(const Key('home_active_inactive_btn')), findsOneWidget);
  // final bookingBikeFinder = find.byKey(const Key("home_booking_bike"));
  // await tester.tap(bookingBikeFinder);
  // await tester.pumpAndSettle();
  // await Future.delayed(const Duration(seconds: 2));
  //
  // final searchBoxFinder = find.byKey(const Key("find_transportation_box_search_field"));
  // await tester.tap(searchBoxFinder);
  // await tester.pumpAndSettle();
  // await Future.delayed(const Duration(seconds: 2));
}
