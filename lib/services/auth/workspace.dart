import 'package:json_annotation/json_annotation.dart';

part 'workspace.g.dart';

@JsonSerializable()
class Workspace {
  final String name;
  final String id;

  Workspace(this.name, this.id);

  static final unknown = Workspace('', '');
  factory Workspace.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceToJson(this);

  @override
  String toString() {
    return 'Workspace{name: $name, id: $id}';
  }
}
