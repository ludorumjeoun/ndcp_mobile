import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/pages/doctor_main_page.dart';
import 'package:ndcp_mobile/pages/intro_page.dart';
import 'package:ndcp_mobile/pages/login_page.dart';
import 'package:ndcp_mobile/pages/main_page.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/client_type.dart';

final routerProvider = Provider<AppRouter>((ref) {
  return AppRouter(ref);
});

extension RouterExtension on WidgetRef {
  AppRouterState router() => read(routerProvider).of(context);
}

enum AppRoutePath {
  intro,
  login,
  main(allowedTypes: ClientType.listSignedIn);

  const AppRoutePath({this.allowedTypes = ClientType.values});
  final List<ClientType> allowedTypes;
}

class AppRouterState {
  final NavigatorState _navigator;
  final AppRouter _router;
  AppRouterState(this._router, this._navigator);
  push(AppRoutePath path) {
    _navigator.push(_router._router(path));
  }

  pushReplacement(AppRoutePath path) {
    _navigator.pushReplacement(_router._router(path));
  }

  pop() {
    _navigator.pop();
  }
}

class AppRouter {
  final Ref ref;
  AppRouter(this.ref);

  AppRouterState of(BuildContext context) {
    return AppRouterState(this, Navigator.of(context));
  }

  Route _router(AppRoutePath path) {
    return MaterialPageRoute(
      builder: (context) => _widget(path),
    );
  }

  Widget _widget(AppRoutePath path) {
    if (ref.read(authProvider).isSignedIn == false) {
      switch (path) {
        case AppRoutePath.intro:
          return const IntroPage();
        case AppRoutePath.login:
          return const LoginPage();
        default:
          debugPrint('route $path');
          return const IntroPage();
      }
    }
    switch (path) {
      case AppRoutePath.intro:
        return const IntroPage();
      case AppRoutePath.login:
        return const LoginPage();
      case AppRoutePath.main:
        return const DoctorMainPage();
      default:
        debugPrint('route $path');
        return const IntroPage();
    }
  }
}
