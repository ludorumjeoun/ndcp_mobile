part of auth;

enum AuthClientType {
  unknown('unknown', '미선택', false),
  doctor('doctor', '의사', true),
  nurse('nurse', '간호사', true),
  monitor('monitor', '모니터링', true),
  patient('carer', '간병인', false),
  ;

  const AuthClientType(this.code, this.name, this.isStaff);
  final String code;
  final String name;
  final bool isStaff;

  bool get isUserSelectable {
    return code != AuthClientType.unknown.code;
  }

  factory AuthClientType.fromCode(String code) {
    return AuthClientType.values.firstWhere((element) => element.code == code,
        orElse: () => AuthClientType.unknown);
  }

  static List<AuthClientType> userSelectable() {
    return AuthClientType.values
        .where((element) => element.isUserSelectable)
        .toList();
  }
}
