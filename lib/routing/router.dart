import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sql_offline/ui/usuario/usuario_page.dart';
import '../data/repository/auth_repository.dart';
import '../ui/auth/login/login_page.dart';
import '../ui/home/home_page.dart';
import 'routes.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      redirect: _redirect,
      refreshListenable: authRepository,
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) => LoginPage(
            viewModel: context.read(),
          ),
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) => HomePage(
            viewModel: context.read(),
          ),
          routes: [
            GoRoute(
              path: Routes.usuario,
              builder: (context, state) => UsuarioPage(
                viewModel: context.read(),
              ),
            ),
          ],
        ),
      ],
    );

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final usuarioLogado = await context.read<AuthRepository>().isAuthenticated;

  final loggingIn = state.matchedLocation == Routes.login;
  if (!usuarioLogado) {
    return Routes.login;
  }

  if (loggingIn) {
    return Routes.home;
  }

  return null;
}
