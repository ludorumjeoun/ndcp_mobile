import 'package:json_annotation/json_annotation.dart';
import 'package:ndcp_mobile/services/backend/requests/request.dart';

part 'workspace_request.g.dart';

@JsonSerializable(createFactory: false)
abstract class WorkspaceRequest extends Request {
  String get workspaceId;
}
