import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/backend/dummy_backend.dart';

import 'requests/login_request.dart';

final backendProvider = StateNotifierProvider<IBackendNotifier, Backend>(
  (ref) => DummyBackendNotifier(),
);

abstract class IBackendNotifier extends StateNotifier<Backend> {
  IBackendNotifier() : super(Backend(null, null, null));

  Future<void> init();
  Future<void> initWorkspace(Workspace workspace);
  Future<void> initAuthorizedWorkspace(Authorization authorization);
}

class Backend {
  final PublicGatewayAPI? gatewayPublicAPI;
  final PublicWorkspaceAPI? workspacePublicAPI;
  final AuthorizedWorkspaceAPI? workspaceAuthorizedAPI;

  Backend(this.gatewayPublicAPI, this.workspacePublicAPI,
      this.workspaceAuthorizedAPI);
}

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
  Future<Authorization> generateToken(String refreshToken);
  Future<Authorization> authorize(LoginRequest request);
}

abstract class AuthorizedWorkspaceAPI
    implements APIGuardAuthorize<Authorization>, APITargetWorkspace {}
