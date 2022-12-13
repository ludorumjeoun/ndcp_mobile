import 'package:ndcp_mobile/services/auth.dart';

class Env {
  static final IEnvironment current = DummyEnv();
}

abstract class IEnvironment {
  IAuthRepository get authRepository;
}

class DummyEnv extends IEnvironment {
  @override
  IAuthRepository get authRepository => AuthRepositoryDummy();
}
