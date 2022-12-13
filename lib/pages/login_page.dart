import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/services/auth.dart';
import 'package:ndcp_mobile/services/fcm.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(authProvider).workspaceId.isEmpty) {
      // Choose workspace
      return const ChooseWorkspacePage();
    }
    if (ref.watch(authProvider).clientType == AuthClientType.unknown) {
      // Choose client type
      return const ChooseClientTypePage();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginPage'),
        leading: null,
      ),
      body: Center(
        child: Text(ref.watch(fcmTokenProvider)),
      ),
    );
  }
}

class ChooseClientTypePage extends ConsumerStatefulWidget {
  const ChooseClientTypePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ChooseClientTypePageState();
}

class ChooseClientTypePageState extends ConsumerState<ChooseClientTypePage> {
  List<Widget> clientTypesButton(BuildContext context) {
    var clientTypes = AuthClientType.userSelectable();
    return clientTypes.map((clientType) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
        onPressed: () async {
          // Submit client type
          await ref.read(authProvider.notifier).clientType(clientType);
        },
        child: Text(clientType.name),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Choose client type
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose client type'),
        leading: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: clientTypesButton(context),
        ),
      ),
    );
  }
}

class ChooseWorkspacePage extends ConsumerStatefulWidget {
  const ChooseWorkspacePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ChooseWorkspacePageState();
}

class ChooseWorkspacePageState extends ConsumerState<ChooseWorkspacePage> {
  String workspaceId = '';
  bool inSubmitWorkspaceId = false;

  @override
  Widget build(BuildContext context) {
    // Input workspace id with text field
    // Button to submit
    return Scaffold(
      appBar: AppBar(
          title: const Text('Choose workspace'),
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                          await ref
                              .read(authProvider.notifier)
                              .workspaceId(workspaceId);
                          setState(() {
                            inSubmitWorkspaceId = false;
                          });
                        },
                        child: const Text('Submit'),
                      )),
          ],
        ),
      ),
    );
  }
}
