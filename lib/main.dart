import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/components/theme.dart';
import 'package:ndcp_mobile/pages/intro_page.dart';
import 'package:ndcp_mobile/pages/login_page.dart';
import 'package:ndcp_mobile/pages/main_page.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/fcm.dart';
import 'package:ndcp_mobile/services/frontend/router.dart';

void main() {
  final container = ProviderContainer();
  WidgetsFlutterBinding.ensureInitialized();
  container.read(fcmTokenProvider.notifier).init();
  container.read(pushMessageProvider.notifier).init();
  container.read(backendProvider.notifier).init();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: AppTheme.theme,
      title: 'Flutter Demo',
      home: const IntroPage(),
    );
  }
}
