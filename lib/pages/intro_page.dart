import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/components/containers.dart';
import 'package:ndcp_mobile/components/header.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/frontend/router.dart';

final counter = StateProvider((ref) => 0);

class IntroPage extends ConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Focus(
        autofocus: true,
        onFocusChange: (value) async {
          if (value == false) {
            return;
          }
          // wait a seconds.
          await Future.delayed(const Duration(seconds: 1));
          ref.read(counter.notifier).state++;
          final count = ref.read(counter);
          print('focus $value $count');
          await ref
              .read(authProvider.notifier)
              .restore()
              .then((auth) => ref.read(authProvider.notifier).authorized(auth));
          print(
              'restore complete, isSignedIn: ${ref.read(authProvider).isSignedIn}, count: $count');
          final isSignedIn = ref.read(authProvider).isSignedIn;
          if (isSignedIn) {
            ref.router(this).pushReplacementPath(AppRoutePath.main);
          } else {
            ref.router(this).pushReplacementPath(AppRoutePath.login);
          }
        },
        child: const Center(
          child: NormalContainer(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
