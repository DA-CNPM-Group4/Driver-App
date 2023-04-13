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

  final passwordFinder = find.byKey(const Key("password_login_password_field"));
  await tester.enterText(passwordFinder, '123456');
  await tester.tap(find.byKey(const Key('password_login_login_btn')));
  await tester.pumpAndSettle(const Duration(seconds: 1));

  final activeToggleFinder = find.byKey(const Key('home_active_inactive_btn'));
  await tester.tap(activeToggleFinder);
  await tester.pumpAndSettle(const Duration(seconds: 10));

  // First request
  await _testReceiveRequestAndShowDialog(tester: tester);
  await _testCancelRequestAndVerifyDialogDisappear(tester: tester);

  // Second request
  await _testReceiveRequestAndShowDialog(tester: tester);
  await _testAcceptRequest(tester: tester);
  await _testPickedPassengerButton(tester: tester);
  await _testCompletedTripButton(tester: tester);
}

Future<bool> _testReceiveRequestAndShowDialog({
  required WidgetTester tester,
}) async {
  // Wait for a request from customer or timeout (60s)
  final customerRequestReceived = await Future.any([
    _waitForCustomerRequest(tester, 60),
  ]);

  // Check if the request is received in a specific time period.
  expect(customerRequestReceived, true,
      reason: 'Did not receive request from customer for 60s');

  return customerRequestReceived;
}

Future<void> _testPickedPassengerButton({
  required WidgetTester tester,
}) async {
  expect(
    find.byKey(const Key('confirm_order_picked_passenger')),
    findsOneWidget,
    reason: "No picked_passenger button received",
  );

  await tester.pump(const Duration(seconds: 2));

  await tester.tap(find.byKey(const Key('confirm_order_picked_passenger')));
  await tester.pumpAndSettle();

  expect(
    find.byKey(const Key('confirm_order_picked_passenger')),
    findsNothing,
    reason: "Clicked picked_passenger button but it still visible",
  );
}

Future<void> _testCompletedTripButton({
  required WidgetTester tester,
}) async {
  await tester.pump(const Duration(seconds: 2));
  expect(
    find.byKey(const Key('confirm_order_complete_trip')),
    findsOneWidget,
    reason:
        "Clicked picked_passenger button but can not find complete trip button",
  );

  await tester.tap(find.byKey(const Key('confirm_order_complete_trip')));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  expect(
    find.byKey(const Key('confirm_order_complete_trip')),
    findsNothing,
    reason: "Clicked complete_trip button but it still visible",
  );
}

Future<void> _testAcceptRequest({
  required WidgetTester tester,
}) async {
  expect(
    find.byKey(const Key('request_view_accept_request')),
    findsOneWidget,
    reason: "No request received",
  );

  await tester.pump(const Duration(seconds: 2));

  await tester.tap(find.byKey(const Key('request_view_accept_request')));
  await tester.pumpAndSettle(const Duration(seconds: 5));

  expect(
    find.byKey(const Key('request_view_accept_request')),
    findsNothing,
    reason: "Clicked accept_request button but its still visible",
  );
}

Future<void> _testCancelRequestAndVerifyDialogDisappear({
  required WidgetTester tester,
}) async {
  expect(
    find.byKey(const Key('request_view_cancel_request')),
    findsOneWidget,
    reason: "No request received",
  );

  await tester.pump(const Duration(seconds: 2));

  await tester.tap(find.byKey(const Key('request_view_cancel_request')));
  await tester.pumpAndSettle();

  expect(
    find.byKey(const Key('request_view_cancel_request')),
    findsNothing,
    reason: "Driver canceled but request dialog still visible",
  );
}

Future<bool> _waitForCustomerRequest(
    WidgetTester tester, int waitingTime) async {
  bool requestFound = false;

  for (int i = 0; i < waitingTime; i++) {
    await tester.pump(const Duration(seconds: 1));
    if (find
            .byKey(const Key("request_view_cancel_request"))
            .evaluate()
            .isNotEmpty &&
        find
            .byKey(const Key("request_view_accept_request"))
            .evaluate()
            .isNotEmpty) {
      requestFound = true;
      break;
    }
  }
  return requestFound;
}
