import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/components/containers.dart';
import 'package:ndcp_mobile/components/header.dart';
import 'package:ndcp_mobile/components/theme.dart';
import 'package:ndcp_mobile/pages/find_workspace_modal.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/backend/requests/login_request.dart';
import 'package:ndcp_mobile/services/fcm.dart';
import 'package:ndcp_mobile/components/forms/form.dart';
import 'package:ndcp_mobile/services/frontend/router.dart';

extension AsyncValueUI on AsyncValue<void> {
  // isLoading shorthand (AsyncLoading is a subclass of AsycValue)
  bool get isLoading => this is AsyncLoading<void>;

  // show a snackbar on error only
  void showSnackBarOnError(BuildContext context) => whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
}

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Widget subpage(BuildContext context, WidgetRef ref) {
    if (ref.read(authProvider).user == null) {
      // Choose client type
      return EmployeeLoginAuthorizationSubPage((authorization) async {
        await ref
            .read(authProvider.notifier)
            .authorized(authorization);
        ref.router(this).pushReplacementPath(AppRoutePath.main);
      });
    }
    return Text(ref.watch(fcmTokenProvider));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: subpage(context, ref));
  }
}

class EmployeeLoginAuthorizationSubPage extends ConsumerStatefulWidget {
  final Function(Authorization authorization) onAuthorized;

  const EmployeeLoginAuthorizationSubPage(this.onAuthorized, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      EmployeeLoginAuthorizationSubPageState();
}

class EmployeeLoginAuthorizationSubPageState
    extends ConsumerState<EmployeeLoginAuthorizationSubPage> {
  String employeeId = '';
  String userId = '';
  String userPassword = '';

  _findWorkspaceButton(Workspace? workspace) => ElevatedButton(
      onPressed: () {
        ref
            .router(widget)
            .pushModal<Workspace>(((context) => const FindWorkspaceModal()))
            .then((Workspace? value) {
          if (value != null) {
            ref.read(authProvider.notifier).workspaceSelected(value);
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.headerBackground,
        foregroundColor: AppColors.headerText,
        textStyle: const TextStyle(
          color: AppColors.headerText,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      // left icon and right text button
      child: Row(
        children: [
          const SizedBox(
              width: 32,
              height: 32,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.local_hospital))),
          Text(workspace != null ? workspace.name : '대상 병원을 검색해주세요',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headerText.withOpacity(0.5)))
        ],
      ));

  _form() {
    final workspace = ref.watch(authProvider).workspace;
    print("workspace $workspace");
    final workspaceId = workspace?.id;
    return AppForm(
        dataset: FormDataSet(((fields) async {
      if (workspaceId == null) {
        throw const MapEntry("workspace_id", "대상 병원을 검색해주세요");
      }
      final api = ref.read(backendProvider).workspacePublicAPI;
      if (api == null) {
        throw Exception('Backend not initialized');
      }
      await api
          .authorize(LoginRequest(workspaceId, userId, userPassword))
          .then((value) {
        debugPrint("authorized $value");
        widget.onAuthorized(value);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    }))
            .addWidget(_findWorkspaceButton(workspace), label: '대상 병원을 검색해주세요')
            .addText(
                label: '아이디를 입력하세요',
                id: 'user_id',
                decoration: FormDataDecoration(
                    prefix:
                        const Icon(Icons.perm_identity, color: Colors.white)),
                onChanged: (value) => setState(() => {userId = value ?? ''}))
            .addPassword(
                label: '패스워드를 입력하세요',
                id: 'user_password',
                decoration: FormDataDecoration(
                  prefix: const Icon(Icons.password, color: Colors.white),
                ),
                onChanged: (value) =>
                    setState(() => {userPassword = value ?? ''}))
            .addSubmit(
                enabled: (workspaceId ?? '').isNotEmpty &&
                    userId.isNotEmpty &&
                    userPassword.isNotEmpty,
                label: '로그인')
            .addField(
                SwitchFormData(label: '자동로그인', id: 'remeber_authorization')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(child: NormalContainer(child: _form())),
    );
  }
}
