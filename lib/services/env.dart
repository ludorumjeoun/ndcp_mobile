import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/backend/dummy_backend.dart';

class Env {
  static final IEnvironment current = DummyEnv();
}

abstract class IEnvironment {
  PublicGatewayAPI get apiGateway;
  PublicWorkspaceAPI getPublicWorkspaceAPI(String workspaceId);
  AuthorizedWorkspaceAPI getAuthorizedWorkspaceAPI(
      String workspaceId, String authorization);
}

class DummyEnv extends IEnvironment {
  @override
  PublicGatewayAPI get apiGateway => DummyPublicGatewayAPI();

  @override
  PublicWorkspaceAPI getPublicWorkspaceAPI(String workspaceId) {
    return DummyPublicWorkspaceAPI(workspaceId);
  }

  @override
  AuthorizedWorkspaceAPI getAuthorizedWorkspaceAPI(
      String workspaceId, String authorization) {
    return DummyAuthorizedWorkspaceAPI(workspaceId, authorization);
  }

}
