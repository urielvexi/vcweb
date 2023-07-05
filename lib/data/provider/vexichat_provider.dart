import 'package:get/get.dart';

class VexichatProvider extends GetConnect {
  @override
  void onInit() {
    baseUrl = 'http://localhost:3000';
    super.onInit();
  }

  /// Conexion al websocket del chat
  Future<GetSocket> connectToChat() async {
    return socket('/');
  }
}