import 'package:equatable/equatable.dart';

class ChatSendEntity extends Equatable {
  final String text;

  const ChatSendEntity({
    required this.text,
  });
  @override
  List<Object?> get props => [text];
}

class ChatRecieveEntity extends Equatable {
  final String response;
  final int anger;
  final int sadness;

  const ChatRecieveEntity({
    required this.response,
    required this.anger,
    required this.sadness,
  });
  @override
  List<Object?> get props => [response, anger, sadness];
}
