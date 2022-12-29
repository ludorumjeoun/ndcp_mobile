import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/components/header.dart';
import 'package:ndcp_mobile/components/theme.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/fcm.dart';
import 'package:ndcp_mobile/services/frontend/router.dart';

class DoctorMainPage extends ConsumerStatefulWidget {
  const DoctorMainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DoctorMainPageState();
}

class DoctorMainPageState extends ConsumerState<DoctorMainPage> {
  _drawerHeader() {
    final user = ref.watch(authProvider).user;
    return DrawerHeader(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ref.watch(authProvider).workspace?.name ?? '',
            style: AppTextStyle.headerTitle),
        Text("${user?.clientType.suffix(user.name)} 안녕하세요"),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header('Main'),
      endDrawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          // header with workspace and user info
          _drawerHeader(),
          // setting button with icon
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () {
              // signout
              ref.read(authProvider.notifier).logout().whenComplete(() {
                ref.router().pushReplacement(AppRoutePath.login);
              });
            },
          ),
        ]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ref.watch(authProvider).user?.name ?? 'no user'),
            Text(ref.watch(fcmTokenProvider))
          ],
        ),
      ),
    );
  }
}
