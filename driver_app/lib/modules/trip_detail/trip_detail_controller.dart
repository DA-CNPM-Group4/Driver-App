import 'package:driver_app/Data/models/chat_message/chat_message.dart';
import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/trip_feedback_response.dart';
import 'package:driver_app/Data/models/requests/trip_response.dart';
import 'package:driver_app/Data/services/rest/driver_api_service.dart';
import 'package:driver_app/Data/services/graphql/graphql_service.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripDetailController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();
  final scrollController = ScrollController();

  late Rxn<DriverEntity> driver;
  late DriverEntity _driverEntity;

  Map<String, dynamic>? passengerInfo;
  late TripResponse trip;
  late TripFeedbackResponse feedback;
  List<ChatMessage>? chatHistory;

  final RxBool isLoadinginfo = false.obs;
  final RxBool isLoadingFeedback = false.obs;
  final RxBool isRate = false.obs;
  final RxBool isLoadingChatHistory = false.obs;
  final RxBool isHaveChatLog = false.obs;

  @override
  void onInit() async {
    super.onInit();
    trip = Get.arguments as TripResponse;

    driver = await lifeCycleController.getRXDriver;
    _driverEntity = await lifeCycleController.getDriver;

    isLoadinginfo.value = true;
    isLoadingFeedback.value = true;
    isLoadingChatHistory.value = true;

    try {
      passengerInfo = await GraphQLService.infoGraphQLService
          .getPassengerInfo(trip.passengerId);

      debugPrint(passengerInfo.toString());
    } catch (e) {
      showSnackBar("Failed", "Failed to get passenger info");
    } finally {
      isLoadinginfo.value = false;
    }

    try {
      feedback = await DriverAPIService.tripApi.getTripFeedback(trip.tripId);
      isRate.value = true;
    } catch (e) {
      isRate.value = false;
    } finally {
      isLoadingFeedback.value = false;
    }

    try {
      var chatLog =
          await DriverAPIService.chatAPI.getChatLog(tripId: trip.tripId);
      chatHistory = chatLog.toChatMessage(_driverEntity.accountId);
      debugPrint("Length");
      debugPrint(chatHistory?.length.toString() ?? "0");
      isHaveChatLog.value = true;
    } catch (e) {
      debugPrint(e.toString());
      isHaveChatLog.value = false;
    } finally {
      isLoadingChatHistory.value = false;
    }
  }
}
