import 'package:chat_ui/features/chat/data/data_sources/remote_data_source.dart';
import 'package:chat_ui/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_ui/features/chat/domain/repositories/chat_repository.dart';
import 'package:chat_ui/features/chat/domain/usecases/send_chat.dart';
import 'package:chat_ui/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // bloc
  sl.registerFactory(() => ChatBloc(
        sl(),
      ));

  // Usecases
  sl.registerLazySingleton(() => SendChatUseCase(sl()));
  //repo
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
        chatRemoteDataSource: sl(),
        networkInfo: sl(),
      ));
  //Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(client: sl()));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
