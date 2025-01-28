import 'package:dartz/dartz.dart';
import '../../../../core/error/exeptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../data_sources/remote_data_source.dart';
import '../models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl(
      {required this.chatRemoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ChatRecieveEntity>> sendChat(
      ChatSendEntity chat,
      int valence,
      int arousal,
      int selectionThreshold,
      int resolutionLevel,
      int goalDirectedness,
      int securingRate) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await chatRemoteDataSource.sendChat(
            ChatSendModel.toModel(chat),
            valence,
            arousal,
            selectionThreshold,
            resolutionLevel,
            goalDirectedness,
            securingRate);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
