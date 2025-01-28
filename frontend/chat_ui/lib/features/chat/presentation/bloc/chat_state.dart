part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class InitialState extends ChatState {}

class LoadingState extends ChatState {}

class SuccessState extends ChatState {}

class LoadedSingleChatState extends ChatState {
  final ChatRecieveEntity chat;

  const LoadedSingleChatState({required this.chat});
}

class ErrorState extends ChatState {
  final String message;

  const ErrorState({required this.message});
}
