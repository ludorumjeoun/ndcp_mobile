import 'package:json_annotation/json_annotation.dart';
import 'package:ndcp_mobile/services/backend/requests/workspace_request.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest extends WorkspaceRequest {
  @override
  final String workspaceId;
  final String userId;
  final String userPassword;

  LoginRequest(this.workspaceId, this.userId, this.userPassword);
}

@JsonSerializable()
class RefreshTokenLoginRequest extends WorkspaceRequest {
  @override
  final String workspaceId;
  final String refreshToken;

  RefreshTokenLoginRequest(this.workspaceId, this.refreshToken);
}
