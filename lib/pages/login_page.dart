import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/auth/client_type.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/fcm.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Widget subpage(BuildContext context, WidgetRef ref) {
    if (ref.watch(authProvider).workspace.id.isEmpty) {
      // Choose workspace
    } else if (ref.watch(authProvider).clientType == AuthClientType.unknown) {
      // Choose client type
      return EmployeeLoginAuthorizationSubPage((employeeId, userId, password) {
        final auth = ref.read(authProvider.notifier);
        final state = ref.read(authProvider);
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
  final Function(String employeeId, String userId, String password) onSubmit;

  const EmployeeLoginAuthorizationSubPage(this.onSubmit, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      EmployeeLoginAuthorizationSubPageState();
}

class EmployeeLoginAuthorizationSubPageState
    extends ConsumerState<EmployeeLoginAuthorizationSubPage> {
  String employeeId = '';
  String userId = '';
  String password = '';
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: '사번',
          ),
          onChanged: (value) {
            employeeId = value;
          },
        ),
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
            password = value;
          },
        ),
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
          onPressed: isSubmitting
              ? null
              : () => widget.onSubmit(employeeId, userId, password),
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
  bool inSubmitWorkspaceId = false;

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
            border: OutlineInputBorder(),
            labelText: 'Workspace ID',
          ),
          onChanged: (value) => workspaceId = value,
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: inSubmitWorkspaceId
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(36)),
                    onPressed: () async {
                      print('workspaceId: $workspaceId');
                      // Submit workspace id with text field
                      setState(() {
                        inSubmitWorkspaceId = true;
                      });
                      setState(() {
                        inSubmitWorkspaceId = false;
                      });
                    },
                    child: const Text('Submit'),
                  )),
      ],
    );
  }
}
