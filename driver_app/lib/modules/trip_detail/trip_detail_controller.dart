import 'package:driver_app/Data/models/chat_message/chat_message.dart';
import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/trip_feedback_response.dart';
import 'package:driver_app/Data/models/requests/trip_response.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:get/get.dart';

class TripDetailController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  late Rxn<DriverEntity> driver;
  late DriverEntity _driverEntity;

  late TripResponse trip;
  late TripFeedbackResponse feedback;
  late List<ChatMessage>? chatHistory;
  var isLoading = false.obs;

  RxBool isRate = false.obs;
  RxBool isChatLoaded = false.obs;

  int star = 2;
  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    trip = Get.arguments as TripResponse;

    driver = await lifeCycleController.getRXDriver;
    _driverEntity = await lifeCycleController.getDriver;
    try {
      feedback = await DriverAPIService.tripApi.getTripFeedback(trip.tripId);
      isRate.value = true;
    } catch (e) {
      isRate.value = false;
    }
    try {
      var chatLog =
          await DriverAPIService.chatAPI.getChatLog(tripId: trip.tripId);
      chatHistory = chatLog.toChatMessage(_driverEntity.accountId);
      isChatLoaded.value = true;
    } catch (e) {
      isChatLoaded.value = false;
    }
    isLoading.value = false;
  }
}
