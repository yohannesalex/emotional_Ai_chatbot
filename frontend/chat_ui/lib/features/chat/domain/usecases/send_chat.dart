import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class SendChatUseCase implements UseCase<void, SendParams> {
  final ChatRepository chatRepository;
  SendChatUseCase(this.chatRepository);
  @override
  Future<Either<Failure, ChatRecieveEntity>> call(SendParams sendParams) async {
    return await chatRepository.sendChat(
        sendParams.chat,
        sendParams.valence,
        sendParams.arousal,
        sendParams.selectionThreshold,
        sendParams.resolutionLevel,
        sendParams.goalDirectedness,
        sendParams.securingRate);
  }
}

class SendParams extends Equatable {
  final ChatSendEntity chat;
  final int valence;
  final int arousal;
  final int selectionThreshold;
  final int resolutionLevel;
  final int goalDirectedness;
  final int securingRate;

  const SendParams(
      {required this.chat,
      required this.valence,
      required this.arousal,
      required this.selectionThreshold,
      required this.resolutionLevel,
      required this.goalDirectedness,
      required this.securingRate});
  @override
  List<Object?> get props => [
        chat,
        valence,
        arousal,
        selectionThreshold,
        resolutionLevel,
        goalDirectedness,
        securingRate
      ];
}
