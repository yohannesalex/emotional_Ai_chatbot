import 'package:chat_ui/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/bloc/parameters_bloc.dart';
import 'injection_container.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChatBloc(sl())),
        BlocProvider(create: (_) => ParametersBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/home',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return _buildPageRoute(ChatScreen());
            default:
              return null;
          }
        },
        theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 63, 81, 243),
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 63, 81, 243))),
      ),
    );
  }

  PageRouteBuilder _buildPageRoute(Widget page, {bool fromMiddleDown = false}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin =
            fromMiddleDown ? const Offset(0.0, 0.0) : const Offset(1.0, 0.0);
        final end = fromMiddleDown ? const Offset(0.0, 1.0) : Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
