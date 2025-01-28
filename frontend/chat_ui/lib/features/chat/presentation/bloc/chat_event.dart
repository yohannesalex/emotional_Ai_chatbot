part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendChatEvent extends ChatEvent {
  final ChatSendEntity chat;
  final int valence;
  final int arousal;
  final int selectionThresholdl;
  final int resolutionLevel;
  final int goalDirectedness;
  final int securingRate;

  const SendChatEvent(
      this.chat,
      this.valence,
      this.arousal,
      this.selectionThresholdl,
      this.resolutionLevel,
      this.goalDirectedness,
      this.securingRate);
  @override
  List<Object> get props => [chat];
}
