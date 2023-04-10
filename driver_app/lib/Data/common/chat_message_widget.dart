import 'package:driver_app/Data/models/chat_message/chat_message.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessageWidget({
    Key? key,
    required this.text,
    required this.chatMessageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        mainAxisAlignment: chatMessageType == ChatMessageType.driver
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (chatMessageType == ChatMessageType.passenger)
            ProfileContainer(chatMessageType: chatMessageType),
          if (chatMessageType == ChatMessageType.passenger)
            const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(15),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            decoration: BoxDecoration(
              color: chatMessageType == ChatMessageType.driver
                  ? Colors.blue
                  : Colors.grey.shade800,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: chatMessageType == ChatMessageType.driver
                    ? const Radius.circular(15)
                    : const Radius.circular(0),
                bottomRight: chatMessageType == ChatMessageType.driver
                    ? const Radius.circular(0)
                    : const Radius.circular(15),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          if (chatMessageType == ChatMessageType.driver)
            const SizedBox(width: 15),
          if (chatMessageType == ChatMessageType.driver)
            ProfileContainer(chatMessageType: chatMessageType),
        ],
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
    required this.chatMessageType,
  });

  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: chatMessageType == ChatMessageType.driver
              ? Colors.blue
              : Colors.grey.shade800,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: chatMessageType == ChatMessageType.driver
                ? const Radius.circular(0)
                : const Radius.circular(15),
            bottomRight: chatMessageType == ChatMessageType.driver
                ? const Radius.circular(15)
                : const Radius.circular(0),
          ),
        ),
        child: chatMessageType == ChatMessageType.driver
            ? Image.asset(
                "assets/icons/face_icon.png",
                color: Colors.white,
                scale: 1.5,
              )
            : const Icon(
                Icons.person,
                color: Colors.white,
              ));
  }
}
