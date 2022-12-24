import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';

import 'requests/login.dart';

abstract class Client {}

abstract class RemoteAPI {
  String get endpoint;
}

abstract class APIGuard {}

abstract class APIGuardPublic extends APIGuard {}

abstract class APIGuardAuthorize<AUTH> extends APIGuard {
  AUTH get authorization;
}

abstract class APITarget {}

abstract class APITargetGateway extends APITarget {}

abstract class APITargetWorkspace extends APITarget {
  Workspace get workspace;
}

abstract class PublicGatewayAPI implements APIGuardPublic, APITargetGateway {
  Future<Workspace> findWorkspace(String workspaceId);
}

abstract class AuthorizedGatewayAPI
    implements APIGuardAuthorize<Authorization>, APITargetGateway {}

abstract class PublicWorkspaceAPI
    implements APIGuardPublic, APITargetWorkspace {
  Future<Authorization> authorize(LoginRequest request);
}

abstract class AuthorizedWorkspaceAPI
    implements APIGuardAuthorize<Authorization>, APITargetWorkspace {}
