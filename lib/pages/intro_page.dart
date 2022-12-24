import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';

class IntroPage extends ConsumerWidget {
  const IntroPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intro'),
      ),
      body: Focus(
        autofocus: true,
        onFocusChange: (value) {
          print('focus $value');
          if (value) {
            ref.read(authProvider.notifier).restore();
            if (ref.read(authProvider).clientType == AuthClientType.unknown) {
              Navigator.pushNamed(context, '/login');
            } else {
              Navigator.pushNamed(context, '/home');
            }

          }
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
