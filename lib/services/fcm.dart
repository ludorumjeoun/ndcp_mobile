import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final fcmTokenProvider = StateNotifierProvider<FCMTokenNotifier, String>(
  (ref) => FCMTokenNotifier(),
);
final pushMessageProvider =
    StateNotifierProvider<PushMessageNotifier, List<RemoteMessage>>(
  (ref) => PushMessageNotifier(),
);

class FCMTokenNotifier extends StateNotifier<String> {
  FCMTokenNotifier() : super('');

  void init() async {
    await Firebase.initializeApp();
    final token = await FirebaseMessaging.instance.getToken();
    state = token ?? '';
    print(state);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

class PushMessageNotifier extends StateNotifier<List<RemoteMessage>> {
  PushMessageNotifier() : super([]);

  void init() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      state = [...state, message];
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      state = [...state, message];
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
