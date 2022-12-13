part of auth;

abstract class IAuthRepository {
  Future<Authorization> workspaceId(String workspaceId);
  Future<Authorization> login(LoginRequest request);
}

class LoginRequest {
  final String workspaceId;
  final AuthClientType clientType;
  final String userId;
  final String userPassword;

  LoginRequest(
      this.workspaceId, this.clientType, this.userId, this.userPassword);
}
