import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/backend/requests/login_request.dart';
import 'package:ndcp_mobile/services/fcm.dart';
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
    if (ref.watch(authProvider).workspace == null) {
      // Choose workspace
      return FindWorkspaceSubPage((workspace) =>
          {ref.read(authProvider.notifier).workspaceSelected(workspace)});
    } else if (ref.watch(authProvider).user == null) {
      // Choose client type
      return EmployeeLoginAuthorizationSubPage((authorization) {
        ref
            .read(authProvider.notifier)
            .authorized(authorization)
            .then((value) => ref.router().pushReplacement(AppRoutePath.main));
      });
    }
    return Text(ref.watch(fcmTokenProvider));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginPage'),
        leading: null,
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: subpage(context, ref),
                )
              ],
            )),
      ),
    );
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
  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: '아이디',
          ),
          onChanged: (value) {
            userId = value;
          },
        ),
        TextField(
          decoration: const InputDecoration(
            labelText: '비밀번호',
          ),
          onChanged: (value) {
            userPassword = value;
          },
        ),
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
          onPressed: isProgress
              ? null
              : () {
                  setState(() {
                    isProgress = true;
                  });
                  final workspaceId = ref.read(authProvider).workspace?.id;
                  if (workspaceId == null) {
                    throw Exception('Workspace not selected');
                  }
                  final api = ref.read(backendProvider).workspacePublicAPI;
                  if (api == null) {
                    throw Exception('Backend not initialized');
                  }
                  api
                      .authorize(
                          LoginRequest(workspaceId, userId, userPassword))
                      .then((value) {
                    widget.onAuthorized(value);
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.toString())),
                    );
                  }).whenComplete(() {
                    setState(() {
                      isProgress = false;
                    });
                  });
                },
          child: const Text('로그인'),
        )
      ],
    );
  }
}

class FindWorkspaceSubPage extends ConsumerStatefulWidget {
  final Function(Workspace workspace) onChooseWorkspace;
  const FindWorkspaceSubPage(this.onChooseWorkspace, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FindWorkspaceSubPageState();
}

class FindWorkspaceSubPageState extends ConsumerState<FindWorkspaceSubPage> {
  String workspaceId = '';
  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    // Input workspace id with text field
    // Button to submit
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: '병원을 선택하세요',
          ),
          onChanged: (value) => workspaceId = value,
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: isProgress
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(36)),
                    onPressed: () async {
                      setState(() {
                        isProgress = true;
                      });
                      final workspace = await ref
                          .read(backendProvider)
                          .gatewayPublicAPI
                          ?.findWorkspace(workspaceId);
                      setState(() {
                        isProgress = false;
                      });
                      if (workspace != null) {
                        widget.onChooseWorkspace(workspace);
                      }
                    },
                    child: const Text('Submit'),
                  )),
      ],
    );
  }
}
