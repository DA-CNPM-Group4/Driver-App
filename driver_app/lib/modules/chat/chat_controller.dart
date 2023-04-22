import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/Data/models/chat_message/chat_message.dart';
import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/realtime_models/firestore_chat.dart';
import 'package:driver_app/Data/models/realtime_models/firestore_message.dart';
import 'package:driver_app/Data/services/firebase/firestore_database_service.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';
import 'package:driver_app/core/utils/utils.dart';
import 'package:driver_app/modules/dashboard_page/dashboard_page_controller.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lifecycle_controller.dart';

class ChatController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  final isLoading = false.obs;

  late final DriverEntity driverInfo;
  String? tripId;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final scrollController = ScrollController();

  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatStreamController;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatStreamlistener;

  @override
  void onInit() async {
    super.onInit();
    driverInfo = await lifeCycleController.getDriver;
  }

  Future<void> addMessage() async {
    isLoading.value = true;
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      isLoading.value = false;
      return;
    }

    final newMessage = FirestoreMessageModel(
        message: textController.text,
        senderId: driverInfo.accountId,
        senderName: driverInfo.name,
        date: Utils.currentDateTime);
    try {
      if (tripId == null) {
        throw const UnexpectedException();
      } else {
        await FireStoreDatabaseService.instance
            .sendMessage(data: newMessage, tripId: tripId!);
      }
    } catch (e) {
      showSnackBar("Error", "Cant send message");
    } finally {
      isLoading.value = false;
      textController.clear();
    }
  }

  Future<void> initChat(String passengerId, String newTripId) async {
    tripId = newTripId;
    messages.clear();
    FireStoreDatabaseService.instance.createChat(
        data: FirestoreChatModel(
            driverId: driverInfo.accountId,
            passengerId: passengerId,
            createTime: Utils.currentDateTime),
        tripId: newTripId);
    chatStreamController =
        FireStoreDatabaseService.instance.getChatStream(tripId: newTripId);

    chatStreamlistener = chatStreamController.listen((event) async {
      for (var docAdd in event.docChanges) {
        if (docAdd.type == DocumentChangeType.added) {
          final chat = FirestoreMessageModel.fromJson(docAdd.doc.data()!);
          messages.add(
            ChatMessage(
              text: chat.message,
              chatMessageType: chat.senderId != driverInfo.accountId
                  ? ChatMessageType.passenger
                  : ChatMessageType.driver,
            ),
          );
          Get.find<DashboardPageController>().newMessage.value++;
        }
      }
    });
  }

  Future<void> resetState() async {
    tripId = null;
    await chatStreamlistener?.cancel();
  }

  void popBack() {
    Get.back();
  }
}
