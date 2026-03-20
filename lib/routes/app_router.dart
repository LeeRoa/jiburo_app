import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/routes/app_paths.dart';
import 'package:jiburo_app/screens/home/home_page.dart';
import 'package:jiburo_app/screens/home/notification_page.dart';
import 'package:jiburo_app/screens/login/login_page.dart';
import 'package:jiburo_app/screens/message_page.dart';
import 'package:jiburo_app/screens/not_found_page.dart';
import 'package:jiburo_app/screens/save_page.dart';
import 'package:jiburo_app/screens/splash_loading_page.dart';
import 'package:jiburo_app/widgets/main_layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppPaths.splash,
  errorBuilder: (context, state) => NotFoundPage(),
  routes: [
    GoRoute(
      path: AppPaths.splash,
      builder: (context, state) => SplashLoadingPage(),
    ),
    GoRoute(path: AppPaths.login, builder: (context, state) => LoginPage()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        statefulShellBranch(
          path: AppPaths.home,
          page: HomePage(),
          sub: [
            goRoute(path: AppPaths.notify, builder: (_) => NotificationPage()),
          ],
        ),
        statefulShellBranch(
          path: AppPaths.message,
          page: MessagePage(),
          sub: [
            goRoute(
              path: '${AppPaths.message}/:id',
              builder: (id) => Container(),
            ),
          ],
        ),
        statefulShellBranch(
          path: AppPaths.save,
          page: SavePage(),
          sub: [
            goRoute(path: '${AppPaths.save}/:id', builder: (id) => Container()),
          ],
        ),
      ],
    ),
  ],
);

GoRoute goRoute({
  required String path,
  required Widget Function(String? id) builder,
}) {
  return GoRoute(
    path: path,
    builder: (context, state) {
      final id = state.pathParameters['id'];
      return builder(id);
    },
  );
}

StatefulShellBranch statefulShellBranch({
  required String path,
  required Widget page,
  List<RouteBase>? sub,
}) {
  return StatefulShellBranch(
    routes: [
      GoRoute(path: path, builder: (context, state) => page, routes: sub ?? []),
    ],
  );
}
