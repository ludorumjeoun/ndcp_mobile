library auth;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/services/env.dart';

part 'auth/client_type.dart';
part 'auth/authorization.dart';
part 'auth/repository.dart';

final authProvider = StateNotifierProvider<AuthNotifier, Authorization>(
  (ref) => AuthNotifier(Env.current.authRepository),
);

class AuthNotifier extends StateNotifier<Authorization> {
  AuthNotifier(this.repo)
      : super(Authorization('', AuthClientType.unknown, ''));

  final IAuthRepository repo;

  Future<void> clientType(AuthClientType clientType) async {
    state = Authorization(state.workspaceId, clientType, '');
  }

  Future<void> workspaceId(String workspaceId) async {
    state = await repo.workspaceId(workspaceId);
  }

  Future<void> login(LoginRequest request) async {
    state = await repo.login(request);
  }
}

class AuthRepositoryDummy implements IAuthRepository {
  @override
  Future<Authorization> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return Authorization(
        request.workspaceId, request.clientType, 'dummy-token');
  }

  @override
  Future<Authorization> workspaceId(String workspaceId) async {
    await Future.delayed(const Duration(seconds: 3));
    return Authorization(workspaceId, AuthClientType.unknown, '');
  }
}
