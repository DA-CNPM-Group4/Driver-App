import 'package:driver_app/Data/models/requests/get_chatmessage_history_response.dart';
import 'package:driver_app/Data/providers/api_provider.dart';
import 'package:driver_app/core/exceptions/bussiness_exception.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';

class ChatAPIService {
  Future<ChatMessageHistoryResponseBody> getChatLog(
      {required String tripId}) async {
    try {
      var body = {"tripId": tripId};
      var response = await APIHandlerImp.instance.post(
        body,
        '/Chat/Chat/GetChats',
        useToken: true,
      );
      if (response.data["status"]) {
        return ChatMessageHistoryResponseBody.fromJson(response.data['data']);
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "Trip-GetIncome", debugMessage: e.toString()));
    }
  }
}
