import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/backend/dummy_backend.dart';

class Env {
  static final IEnvironment current = DummyEnv();
}

abstract class IEnvironment {
  PublicGatewayAPI get apiGateway;
  PublicWorkspaceAPI getPublicWorkspaceAPI(Workspace workspace);
  AuthorizedWorkspaceAPI getAuthorizedWorkspaceAPI(Authorization authorization);
}

class DummyEnv extends IEnvironment {
  @override
  PublicGatewayAPI get apiGateway => DummyPublicGatewayAPI();

  @override
  PublicWorkspaceAPI getPublicWorkspaceAPI(Workspace workspace) {
    return DummyPublicWorkspaceAPI(workspace);
  }

  @override
  AuthorizedWorkspaceAPI getAuthorizedWorkspaceAPI(
      Authorization authorization) {
    return DummyAuthorizedWorkspaceAPI(authorization);
  }

}
