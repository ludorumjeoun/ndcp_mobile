import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/env.dart';
import 'package:ndcp_mobile/services/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/requests/login.dart';

final authProvider = StateNotifierProvider<IAuthNotifier, Authorization>(
  (ref) => AuthNotifier(),
);

abstract class IAuthNotifier extends StateNotifier<Authorization> {
  final IEnvironment env = Env.current;
  IAuthNotifier() : super(Authorization.unknown);

  Future<Response> restore();
  Future<Response<Authorization>> authorized(LoginRequest request);
  Future<void> logout();
}

class AuthNotifier extends IAuthNotifier {
  @override
  Future<Response<Authorization>> authorized(LoginRequest request) {
    // TODO: implement authorized
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Response> restore() {
    // TODO: implement restore
    throw UnimplementedError();
  }
}

// class AuthNotifier extends IAuthNotifier {
//   AuthNotifier();

//   @override
//   restore() async {
//     final prefs = await SharedPreferences.getInstance();
//     print('restore');
//     print(prefs.getString('auth') ?? 'nothing');
//     try {
//       env.apiGateway.findWorkspace()
//       final res = await repo.restore(prefs.getString('auth') ?? '');
//       if (res.isSuccess) {
//         state = res.dataOrElse(Authorization.unknown);
//       }
//       print(state);
//       return res;
//     } on FormatException {
//       print('format exception');
//       return Response.success(Authorization.unknown);
//     } catch (e) {
//       return Response.fail(e);
//     }
//   }

//   @override
//   clientType(AuthClientType clientType) async {
//     state = Authorization(state.workspace, clientType, '');
//   }

//   @override
//   workspace(String workspaceId) async {
//     final response = await repo.workspace(workspaceId);
//     final workspace = response.dataOrElse(Workspace.unknown);
//     state = Authorization(workspace.id, AuthClientType.unknown, '');
//     return response;
//   }

//   @override
//   login(LoginRequest request) async {
//     final response = await repo.login(request);
//     state = response.dataOrElse(Authorization.unknown);
//     final json = jsonEncode(state.toJson());
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth', json);
//     print('auth: $json');
//     return response;
//   }

//   @override
//   Future<void> logout() async {
//     state = Authorization.unknown;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     return;
//   }
// }
