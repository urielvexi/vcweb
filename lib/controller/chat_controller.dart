import 'dart:async';
import 'dart:convert';
import 'dart:js';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:websocket_chat/models/chat_message_model.dart';
import 'package:webtest/data/models/socket_message_model.dart';
import 'package:webtest/data/provider/vexichat_provider.dart';

class ChatController extends GetxController {
  /* -------------------------------------------------------------------------- */
  /*                                 CONTROLLERS                                */
  /* -------------------------------------------------------------------------- */
  ScrollController scrollController = ScrollController();
  TextEditingController msgController = TextEditingController();
  final _chatProvider = Get.find<VexichatProvider>();


  /* -------------------------------------------------------------------------- */
  /*                                  VARIABLES                                 */
  /* -------------------------------------------------------------------------- */

  RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  GetSocket? _socket;

  /* -------------------------------------------------------------------------- */
  /*                                 LIFECYCLES                                 */
  /* -------------------------------------------------------------------------- */

  @override
  void onInit() {
    listenMessages();
    //scrollManager();
    super.onInit();
  }

  @override
  void onClose() {
    _socket?.close();
    super.onClose();
  }

  /* -------------------------------------------------------------------------- */
  /*                                   METHODS                                  */
  /* -------------------------------------------------------------------------- */

  scrollManager(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    /*Timer(
      const Duration(milliseconds: 300),
          () => scrollController.jumpTo(scrollController.position.maxScrollExtent),
    );*/

  }

  void sendMessage(String message) {
    _socket?.send(jsonEncode(
        {
          'type': 1,
          'message': message,
        }
    ));
    messages.add(
      ChatMessageModel(
        message: message,
        date: DateTime.now(),
        isMe: true,
      ),
    );
    msgController.clear();
    scrollManager();
  }

  void _handleMessage(
      SocketMessageModel message,
      GetSocket socket,
      ) async {
    if (message.type == 0) {
      // Enviar datos del usuario al socket
      context.callMethod('zE', ['messenger', 'hide']);
      socket.send(jsonEncode(
          {
            'type': 0,
            'name': 'USUARIO WEB ANONIMO',
            'external_id': 'web${Random().nextInt(1000)}',
          }
      ));
    } else if (message.type == 2) {
      //Mostrar vista nativa de Zendesk
      if (message.zendeskToken != null) {
        print('Iniciando sesión en Zendesk');
        //await ZendeskMessaging.loginUser(jwt: message.zendeskToken!);s

        //await context.callMethod('zE', ['messenger', 'loginUser', allowInterop((callback) {callback(message.zendeskToken!);})]);
        print('Mostrando vista de Zendesk');
        context.callMethod('zE', ['messenger', 'open']);
        context.callMethod('zE', ['messenger', 'show']);
        //ZendeskMessaging.show();
      }
    }
    messages.add(
      ChatMessageModel(
        message: message.message,
        date: DateTime.now(),
        isMe: false,
      ),
    );
  }

  /// Escucha los mensajes que vienen del websocket
  void listenMessages() {
    _chatProvider.connectToChat().then((socket) {
      _socket = socket;
      socket.onMessage((data) {
        print(data);
        final message = SocketMessageModel.fromJson(
          jsonDecode(data),
        );
        _handleMessage(message, socket);
      });
      socket.on('message', (data) {
        print(data);
        messages.add(data);
      });
      socket.onOpen(() {
        print('Socket opened');
      });
      socket.onClose((_) {
        print('Socket closed');
        print(_);
      });
      socket.onError((err) {
        print('Socket error: $err');
      });

      socket.connect();
    });
  }
}