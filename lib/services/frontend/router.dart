import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/pages/doctors/doctor_main_page.dart';
import 'package:ndcp_mobile/pages/find_workspace_modal.dart';
import 'package:ndcp_mobile/pages/intro_page.dart';
import 'package:ndcp_mobile/pages/login_page.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/auth/client_type.dart';

final routerProvider = Provider<AppRouter>((ref) {
  return AppRouter(ref);
});

extension WidgetRefRouterExtension on WidgetRef {
  AppRouterState router(Widget widget, {BuildContext? context}) =>
      read(routerProvider).of(context ?? this.context, widget);
}

enum AppRoutePath {
  intro,
  login,
  workspaceSearch,
  main(allowedTypes: ClientType.listSignedIn);

  const AppRoutePath({this.allowedTypes = ClientType.values});
  final List<ClientType> allowedTypes;
}

class AppRouterState {
  final NavigatorState _navigator;
  final Widget _widget;
  final AppRouter _router;
  AppRouterState(this._router, this._widget, this._navigator);

  Future<T?> pushModal<T>(WidgetBuilder builder) {
    return _navigator.push(MaterialPageRoute<T>(
      builder: builder,
    ));
  }

  Future<T?> pushPath<T>(AppRoutePath path) {
    debugPrint('push $path from $_widget');
    return _navigator.pushNamed(_nameWithPath(path));
  }

  pushReplacementPath(AppRoutePath path) {
    debugPrint('pushReplacement $path from $_widget');
    return _navigator.pushReplacementNamed(_nameWithPath(path));
  }

  pop([dynamic result]) {
    _navigator.pop(result);
  }

  String _nameWithPath(AppRoutePath path) {
    final isSignedIn = _router.ref.read(authProvider).isSignedIn;
    if (isSignedIn == false) {
      switch (path) {
        case AppRoutePath.intro:
          return '/';
        case AppRoutePath.login:
          return '/login';
        case AppRoutePath.workspaceSearch:
          return '/login/workspace';
        default:
          throw UnimplementedError();
      }
    }
    final clientType = _router.ref.read(authProvider).user?.clientType;
    if (clientType == ClientType.doctor) {
      switch (path) {
        case AppRoutePath.main:
          return '/doctor/';
        default:
          throw UnimplementedError();
      }
    }
    throw UnimplementedError();
  }
}

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const IntroPage(),
    '/login': (context) => const LoginPage(),
    '/doctor/': (context) => const DoctorMainPage(),
  };

  final Ref ref;
  AppRouter(this.ref);

  AppRouterState of(BuildContext context, Widget widget) {
    return AppRouterState(this, widget, Navigator.of(context));
  }
}
