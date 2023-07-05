class SocketMessageModel {
  final int type;
  final String message;
  final String? zendeskToken;

  const SocketMessageModel({
    required this.type,
    required this.message,
    this.zendeskToken,
  });

  factory SocketMessageModel.fromJson(Map<String, dynamic> json) => SocketMessageModel(
    type: json['type'],
    message: json['message'],
    zendeskToken: json['zendesk_token'],
  );
}