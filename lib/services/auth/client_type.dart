import 'package:json_annotation/json_annotation.dart';


@JsonEnum()
enum ClientType {
  unknown('unknown', '미선택', false),
  doctor('doctor', '의사', true),
  nurse('nurse', '간호사', true),
  monitor('monitor', '모니터링', true),
  patient('carer', '간병인', false),
  guardian('guardian', '보호자', false),
  ;

  const ClientType(this.code, this.name, this.isStaff);
  final String code;
  final String name;
  final bool isStaff;

  bool get isUserSelectable {
    return code != ClientType.unknown.code;
  }

  String suffix(String? name) {
    return name != null ? '$name님' : '';
  }

  factory ClientType.fromCode(String code) {
    return ClientType.values.firstWhere((element) => element.code == code,
        orElse: () => ClientType.unknown);
  }
  static const List<ClientType> listSignedIn = [
    ClientType.doctor,
    ClientType.nurse,
    ClientType.monitor,
    ClientType.nurse,
    ClientType.patient
  ];
  static List<ClientType> userSelectable() {
    return ClientType.values
        .where((element) => element.isUserSelectable)
        .toList();
  }
}
