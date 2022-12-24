import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/pages/intro_page.dart';
import 'package:ndcp_mobile/pages/login_page.dart';
import 'package:ndcp_mobile/services/fcm.dart';

void main() {
  final container = ProviderContainer();
  WidgetsFlutterBinding.ensureInitialized();
  container.read(fcmTokenProvider.notifier).init();
  container.read(pushMessageProvider.notifier).init();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      routes: {
        '/': (context) => const IntroPage(),
        '/login': (context) => const LoginPage()
      },
      initialRoute: '/',
    );
  }
}
