import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/client_type.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/backend/requests/login.dart';

abstract class DummyAPI implements RemoteAPI {
  @override
  String get endpoint => '';
}

class DummyPublicGatewayAPI extends DummyAPI implements PublicGatewayAPI {
  @override
  Future<Workspace> findWorkspace(String workspaceId) async {
    return Workspace('dummy-workpsace', workspaceId);
  }
}

class DummyPublicWorkspaceAPI extends DummyAPI implements PublicWorkspaceAPI {
  @override
  final Workspace workspace;

  DummyPublicWorkspaceAPI(this.workspace);

  @override
  Future<Authorization> authorize(LoginRequest request) async {
    if (request.employeeId.isNotEmpty) {
      return Authorization(workspace, AuthClientType.doctor, 'dummy-token');
    }
    return Authorization(workspace, AuthClientType.patient, 'dummy-token');
  }
}

class DummyAuthorizedWorkspaceAPI extends DummyAPI
    implements AuthorizedWorkspaceAPI {
  @override
  final Authorization authorization;

  DummyAuthorizedWorkspaceAPI(this.authorization);

  @override
  Workspace get workspace => authorization.workspace;
}
