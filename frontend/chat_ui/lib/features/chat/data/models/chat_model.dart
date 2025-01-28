import '../../domain/entities/chat.dart';

class ChatSendModel extends ChatSendEntity {
  const ChatSendModel({
    required super.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }

  static ChatSendModel toModel(ChatSendEntity chat) {
    return ChatSendModel(
      text: chat.text,
    );
  }
}

class ChatRecieveModel extends ChatRecieveEntity {
  const ChatRecieveModel({
    required super.response,
    required super.anger,
    required super.sadness,
  });
  factory ChatRecieveModel.fromJson(Map<String, dynamic> json) {
    return ChatRecieveModel(
      response: json['response'],
      anger: json['anger_level'],
      sadness: json['sadness_level'],
    );
  }
}
