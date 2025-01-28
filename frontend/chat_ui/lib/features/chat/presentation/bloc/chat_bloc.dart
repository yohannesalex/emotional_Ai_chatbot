import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/chat.dart';
import '../../domain/usecases/send_chat.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendChatUseCase _sendChatUseCase;

  ChatBloc(this._sendChatUseCase) : super(InitialState()) {
    on<SendChatEvent>((event, emit) async {
      emit(LoadingState());
      final result = await _sendChatUseCase(SendParams(
          chat: event.chat,
          valence: event.valence,
          arousal: event.arousal,
          selectionThreshold: event.selectionThresholdl,
          resolutionLevel: event.resolutionLevel,
          goalDirectedness: event.goalDirectedness,
          securingRate: event.securingRate));

      result.fold((failure) {
        emit(const ErrorState(message: 'unable to load'));
      }, (data) {
        emit(LoadedSingleChatState(chat: data));
      });
    });
  }
}
