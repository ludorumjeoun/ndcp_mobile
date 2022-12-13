part of auth;

class Authorization {
  final String workspaceId;
  final AuthClientType clientType;
  final String token;

  Authorization(this.workspaceId, this.clientType, this.token);
}
