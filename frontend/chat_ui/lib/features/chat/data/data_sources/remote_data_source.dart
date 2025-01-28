import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/constant.dart';
import '../../../../core/error/exeptions.dart';
import '../models/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatRecieveModel> sendChat(
      ChatSendModel chat,
      int valence,
      int arousal,
      int selectionThreshold,
      int resolutionLevel,
      int goalDirectedness,
      int securingRate);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  ChatRemoteDataSourceImpl({required this.client});

  @override
  Future<ChatRecieveModel> sendChat(
      ChatSendModel chat,
      int valence,
      int arousal,
      int selectionThreshold,
      int resolutionLevel,
      int goalDirectedness,
      int securingRate) async {
    final uri = Uri.parse(Uris.baseUrl);
    final jsonBody = {
      "valence_level": valence,
      "arousal_level": arousal,
      "selection_threshold": selectionThreshold,
      "resolution_level": resolutionLevel,
      "goal_directedness": goalDirectedness,
      "securing_rate": securingRate,
      "message": chat.text,
    };

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(jsonBody),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return ChatRecieveModel.fromJson(json.decode(response.body));
    }
  }
}
