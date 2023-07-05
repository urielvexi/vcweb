import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:websocket_chat/websocket_chat.dart';
import 'package:webtest/const.dart';
import 'package:webtest/controller/chat_controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => WebsocketChat(
          messages: controller.messages.value,
          title: 'Zendesk chat'.tr,
          hintText: 'Escribe un mensaje',
          bubblePrimaryColor: primaryColor,
          bubbleBotColor: Colors.green[400]!,
          scrollController: controller.scrollController,
          msgController: controller.msgController,
          onTap: () {
            controller.sendMessage(
              controller.msgController.text,
            );
          }
      ),
    );
  }
}