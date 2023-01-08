import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/components/theme.dart';
import 'package:ndcp_mobile/pages/intro_page.dart';
import 'package:ndcp_mobile/pages/login_page.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/fcm.dart';
import 'package:ndcp_mobile/services/frontend/router.dart';

import 'services/auth/client_type.dart';

Future<void> main() async {
  final container = ProviderContainer();
  WidgetsFlutterBinding.ensureInitialized();
  container.read(fcmTokenProvider.notifier).init();
  container.read(pushMessageProvider.notifier).init();
  await container.read(backendProvider.notifier).init();
  return runApp(
      UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: AppTheme.themeByClientType(
          ref.watch(authProvider).user?.clientType ?? ClientType.unknown),
      title: 'Flutter Demo',
      routes: AppRouter.routes,
      initialRoute: '/',
    );
  }
}
