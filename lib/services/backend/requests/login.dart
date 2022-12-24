import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable(createFactory: false)
abstract class LoginRequest {
  String get workspaceId;
  String get employeeId;
  String get userId;
  String get userPassword;
}

@JsonSerializable()
class EmployeeLoginRequest extends LoginRequest {
  @override
  final String workspaceId;
  @override
  final String employeeId;
  @override
  final String userId;
  @override
  final String userPassword;

  EmployeeLoginRequest(
      this.workspaceId, this.employeeId, this.userId, this.userPassword);
}

@JsonSerializable(includeIfNull: true)
class NonEmployeeLoginRequest extends LoginRequest {
  @override
  final String workspaceId;
  @override
  final String userId;
  @override
  final String userPassword;

  @override
  final employeeId = '';

  NonEmployeeLoginRequest(this.workspaceId, this.userId, this.userPassword);
}
