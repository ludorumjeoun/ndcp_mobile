import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/frontend/router.dart';

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
            ref
                .read(authProvider.notifier)
                .restore()
                .then(
                    (auth) => ref.read(authProvider.notifier).authorized(auth))
                .whenComplete(() {
              if (ref.read(authProvider).isSignedIn) {
                ref.router().pushReplacement(AppRoutePath.main);
              } else {
                ref.router().pushReplacement(AppRoutePath.login);
              }
            });
          }
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
