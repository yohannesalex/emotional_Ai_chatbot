import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/chat.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatRecieveEntity>> sendChat(
      ChatSendEntity chat,
      int valence,
      int arousal,
      int selectionThreshold,
      int resolutionLevel,
      int goalDirectedness,
      int securingRate);
}
