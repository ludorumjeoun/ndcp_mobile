import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/backend/requests/login_request.dart';
import 'package:ndcp_mobile/services/frontend/router.dart';
import 'package:ndcp_mobile/services/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = StateNotifierProvider<IAuthNotifier, Authorization>(
  (ref) => AuthNotifier(ref),
);

abstract class IAuthNotifier extends StateNotifier<Authorization> {
  IAuthNotifier(super.state);

  Future<Authorization> restore();
  Future<void> workspaceSelected(Workspace workspace);
  Future<void> authorized(Authorization authorization);
  Future<void> logout();
}

class AuthNotifier extends IAuthNotifier {
  static const String restoreKey = 'authorization';
  final Ref ref;
  AuthNotifier(this.ref) : super(Authorization.unknown);

  @override
  Future<void> authorized(Authorization authorization) async {
    await ref
        .read(backendProvider.notifier)
        .initAuthorizedWorkspace(authorization);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(restoreKey, jsonEncode(authorization.toJson()));
    state = authorization;
  }

  @override
  Future<void> logout() async {
    await ref.read(backendProvider.notifier).init();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(restoreKey);
    state = Authorization.unknown;
  }

  @override
  Future<Authorization> restore() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final stringAuth = jsonDecode(prefs.getString(restoreKey) ?? '');
      debugPrint('Restoring authorization: $stringAuth');
      final localAuth = Authorization.fromJson(stringAuth);
      final localWorkspace = localAuth.workspace;
      if (localWorkspace == null) {
        return Authorization.unknown;
      }
      final workspace = await ref
          .read(backendProvider)
          .gatewayPublicAPI
          ?.findWorkspace(localWorkspace.id);
      if (workspace == null) {
        return Authorization.unknown;
      }
      debugPrint('Restored workspace: $workspace');
      await workspaceSelected(workspace);
      final nextAuth = await ref
          .read(backendProvider)
          .workspacePublicAPI
          ?.generateToken(localAuth.refreshToken);
      debugPrint('Restored authorization: $nextAuth');
      if (nextAuth == null) {
        return Authorization.unknown;
      }
      final auth = Authorization(
          workspace: workspace,
          user: nextAuth.user,
          accessToken: nextAuth.accessToken,
          refreshToken: localAuth.refreshToken);
      return auth;
    } on FormatException {
      debugPrint('$runtimeType:restore format exception');
      return Authorization.unknown;
    } catch (e) {
      debugPrint('$runtimeType:restore $e');
      return Authorization.unknown;
    }
  }

  @override
  Future<void> workspaceSelected(Workspace workspace) async {
    await ref.read(backendProvider.notifier).initWorkspace(workspace);
    state = Authorization(workspace: workspace);
  }
}
