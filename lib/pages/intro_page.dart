import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/services/auth.dart';
import 'package:ndcp_mobile/services/fcm.dart';

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
            Timer(const Duration(seconds: 3), () {
              Navigator.pushNamed(context, '/login');
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
