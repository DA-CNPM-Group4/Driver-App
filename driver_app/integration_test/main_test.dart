import 'package:dio/dio.dart';
import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
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

const String IPv4Address = "172.17.58.72";

void main() async {
  // BackendEnviroment.checkDevelopmentMode(isUseEmulator: true);

  WidgetsFlutterBinding.ensureInitialized();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(VehicleEntityAdapter());
    Hive.registerAdapter(DriverEntityAdapter());
  }
  await Hive.initFlutter();
  await Hive.openBox("box");

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("Accept a trip | ", () {
    testWidgets("Accept a trip Flow....", (WidgetTester tester) async {
      // Initialize the app
      await _initApp(tester);

      // Navigate from Welcome to Login screen
      await _navigateFromWelcomeToLogin(tester);

      // Login with email and password
      await _loginWithEmailAndPassword(tester);

      // Send a request (fake)
      sendTripRequest();

      // Wait to receive request and show dialog
      await _testReceiveRequestAndShowDialog(tester: tester);

      // Driver cancel request
      await _testCancelRequestAndVerifyDialogDisappear(tester: tester);

      // Send a request (fake)
      sendTripRequest();

      // Wait to receive request and show dialog
      await _testReceiveRequestAndShowDialog(tester: tester);

      // Driver accept request
      await _testAcceptRequest(tester: tester);

      // Driver pick passenger
      await _testPickedPassengerButton(tester: tester);

      // Driver complete trip
      await _testCompletedTripButton(tester: tester);
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
  await tester.tap(find.byKey(const Key("welcome_login_btn")));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('welcome_login_btn')), findsNothing);
  expect(find.byKey(const Key('login_email_field')), findsOneWidget);
}

Future<void> _loginWithEmailAndPassword(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('login_login_btn')));
  await tester.pumpAndSettle();
  expect(find.text("This field must be filled"), findsOneWidget);
  expect(find.text("This field is required"), findsOneWidget);

  await tester.enterText(find.byKey(const Key('login_email_field')), 'changkho6310@gmail.com');
  await tester.enterText(find.byKey(const Key("login_phone_field")), '0938267365');
  await tester.tap(find.byKey(const Key('login_login_btn')));
  await tester.pumpAndSettle(const Duration(seconds: 1));

  await tester.tap(find.byKey(const Key('password_login_login_btn')));
  await tester.pumpAndSettle();
  expect(find.text("This field must be filled"), findsOneWidget);

  await tester.enterText(find.byKey(const Key("password_login_password_field")), '123456');
  await tester.tap(find.byKey(const Key('password_login_login_btn')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect(find.byKey(const Key('password_login_login_btn')), findsNothing);

  final activeToggleFinder = find.byKey(const Key('home_active_inactive_btn'));
  await tester.tap(activeToggleFinder);
  await tester.pumpAndSettle(const Duration(seconds: 1));
  // await tester.pump(const Duration(seconds: 6));
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

Future<void> _testAcceptRequest({
  required WidgetTester tester,
}) async {
  await tester.pump(const Duration(seconds: 2));

  expect(
    find.byKey(const Key('request_view_accept_request')),
    findsOneWidget,
    reason: "No request received",
  );

  await tester.tap(find.byKey(const Key('request_view_accept_request')));
  await tester.pumpAndSettle(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 2));

  expect(
    find.byKey(const Key('request_view_accept_request')),
    findsNothing,
    reason: "Clicked accept_request button but its still visible",
  );
}

Future<void> _testPickedPassengerButton({
  required WidgetTester tester,
}) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 500));

  expect(
    find.byKey(const Key('confirm_order_picked_passenger')),
    findsOneWidget,
    reason: "No picked_passenger button received",
  );

  await tester.tap(find.byKey(const Key('confirm_order_picked_passenger')));
  await tester.pumpAndSettle(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));

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
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));

  expect(
    find.byKey(const Key('confirm_order_complete_trip')),
    findsNothing,
    reason: "Clicked complete_trip button but it still visible",
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

  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));

  await tester.tap(find.byKey(const Key('request_view_cancel_request')));
  await tester.pumpAndSettle();

  expect(
    find.byKey(const Key('request_view_cancel_request')),
    findsNothing,
    reason: "Driver canceled but request dialog still visible",
  );
}

Future<void> sendTripRequest() async {
  try {
    final dio = Dio();
    // const url = "http://$IPv4Address:8001/api/Trip/TripRequest/SendRequest";
    const url = "https://dacnpmbe.azurewebsites.net/api/Trip/TripRequest/SendRequest";
    final data = {
      "PassengerId": "67c09099-4100-4b87-8651-fa0c25ddbf15",
      "StaffId": "00000000-0000-0000-0000-000000000000",
      "RequestStatus": "FindingDriver",
      "PassengerNote": "Fast!!!",
      "Distance": 2.0,
      "Destination":
          "10 Đinh Tiên Hoàng, Quận 1, Thành phố Hồ Chí Minh, Vietnam",
      "LatDesAddr": 10.78573657763354,
      "LongDesAddr": 106.70259905373288,
      "StartAddress":
          "227 Đ. Nguyễn Văn Cừ, Quận 5, Thành phố Hồ Chí Minh, Vietnam",
      "LatStartAddr": 10.762835,
      "LongStartAddr": 106.6824817,
      "PassengerPhone": "123456111",
      "Price": 45923,
      "VehicleType": "Motorbike"
    };

    final headers = {
      "x-api-key": "ApplicationKey",
    };

    dio.options.headers.addAll(headers);
    dio
        .post(
      url,
      data: data,
    )
        .then((value) {
      debugPrint(value.toString());
    });
  } on DioError catch (e) {
    debugPrint("Error sending request: $e");
  }
}
