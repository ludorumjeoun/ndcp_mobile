import 'package:json_annotation/json_annotation.dart';
import 'package:ndcp_mobile/services/auth/client_type.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';

part 'authorization.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final ClientType clientType;

  User(this.id, this.name, this.clientType);
  static final unknown = User('', '', ClientType.unknown);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  toString() => 'User(id: $id, name: $name, clientType: $clientType)';
}

@JsonSerializable()
class Authorization {
  final Workspace? workspace;
  final User? user;
  final String accessToken;
  final String refreshToken;

  Authorization({
    this.workspace,
    this.user,
    this.accessToken = '',
    this.refreshToken = '',
  });
  static final unknown = Authorization(workspace: null, user: null);

  get isSignedIn => user != null;

  factory Authorization.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorizationToJson(this);

  @override
  String toString() {
    return 'Authorization{workspace: $workspace, user: $user, accessToken: ${accessToken.isNotEmpty}, refreshToken: ${refreshToken.isNotEmpty}}';
  }
}
