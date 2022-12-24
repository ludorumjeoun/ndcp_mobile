import 'package:json_annotation/json_annotation.dart';
import 'package:ndcp_mobile/services/auth/client_type.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';

part 'authorization.g.dart';

@JsonSerializable()
class Authorization {
  final Workspace workspace;
  final AuthClientType clientType;
  final String token;


  Authorization(this.workspace, this.clientType, this.token);
  static final unknown =
      Authorization(Workspace.unknown, AuthClientType.unknown, '');

  factory Authorization.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorizationToJson(this);
}
