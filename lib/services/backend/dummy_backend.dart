import 'dart:async';
import 'dart:convert';

import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/client_type.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/backend/requests/login_request.dart';
import 'package:ndcp_mobile/services/response.dart';

class DummyBackendNotifier extends IBackendNotifier {
  @override
  Future<void> init() async {
    state = Backend(DummyPublicGatewayAPI(), null, null);
  }

  @override
  Future<void> initWorkspace(Workspace workspace) async {
    state = Backend(
        state.gatewayPublicAPI, DummyPublicWorkspaceAPI(workspace), null);
  }

  @override
  Future<void> initAuthorizedWorkspace(Authorization authorization) async {
    state = Backend(state.gatewayPublicAPI, state.workspacePublicAPI,
        DummyAuthorizedWorkspaceAPI(authorization));
  }
}

abstract class DummyAPI implements RemoteAPI {
  @override
  String get endpoint => '';

  Future<RES?> request<REQ, RES>(REQ req, RES? res) async {
    await Future.delayed(const Duration(seconds: 1), () => null);
    return res;
  }
}

class DummyPublicGatewayAPI extends DummyAPI implements PublicGatewayAPI {
  @override
  Future<Workspace> findWorkspace(String workspaceId) async {
    final res = await request(workspaceId, Workspace('비투엔 늘 병원', workspaceId));
    if (res == null) {
      throw APIFailure(404, 'Workspace not found');
    }
    return res;
  }
}

class DummyPublicWorkspaceAPI extends DummyAPI implements PublicWorkspaceAPI {
  @override
  final Workspace workspace;

  DummyPublicWorkspaceAPI(this.workspace);

  @override
  Future<Authorization> authorize(LoginRequest request) async {
    final authedUser = User('dummy-user', "홍길동", ClientType.doctor);
    final res = await this.request(
        request,
        Authorization(
            workspace: workspace,
            user: authedUser,
            accessToken: 'dummy-access-token',
            refreshToken: jsonEncode({
              'workspaceId': workspace.id,
              'userId': authedUser.id,
              'userName': authedUser.name,
              'clientType': authedUser.clientType.code,
            })));
    if (res == null) {
      throw APIFailure(404, 'User not found');
    }
    return res;
  }

  @override
  Future<Authorization> generateToken(String refreshToken) async {
    final json = jsonDecode(refreshToken);
    final workspaceId = json['workspaceId'] as String;
    final userId = json['userId'] as String;
    final userName = json['userName'] as String;
    final clientType = ClientType.fromCode(json['clientType'] as String);
    final res = await request(
        refreshToken,
        Authorization(
          workspace: Workspace(workspaceId, workspaceId),
          user: User(userId, userName, clientType),
          accessToken: 'dummy-access-token',
        ));
    if (res == null) {
      throw APIFailure(404, 'User not found');
    }
    return res;
  }
}

class DummyAuthorizedWorkspaceAPI extends DummyAPI
    implements AuthorizedWorkspaceAPI {
  @override
  final Authorization authorization;

  DummyAuthorizedWorkspaceAPI(this.authorization);

  @override
  Workspace get workspace => authorization.workspace!;
}
