import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/views/widgets/main_layout.dart';
import 'package:jiburo_app/features/chat/views/message_detail_screen.dart';
import 'package:jiburo_app/features/chat/views/message_screen.dart';
import 'package:jiburo_app/features/home/views/home_screen.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_last_screen.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_screen.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_search_screen.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_second_screen.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_third_screen.dart';
import 'package:jiburo_app/features/lost_post/views/post_detail_screen.dart';
import 'package:jiburo_app/features/notification/views/notification_screen.dart';
import 'package:jiburo_app/features/auth/views/login_screen.dart';
import 'package:jiburo_app/core/views/not_found_screen.dart';
import 'package:jiburo_app/features/save/save_screen.dart';
import 'package:jiburo_app/core/views/splash_loading_screen.dart';
import 'package:jiburo_app/features/user/views/my_page_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppPaths.splash,
  errorBuilder: (context, state) => NotFoundScreen(),
  routes: [
    GoRoute(
      path: AppPaths.splash,
      builder: (context, state) => SplashLoadingScreen(),
    ),
    GoRoute(path: AppPaths.login, builder: (context, state) => LoginScreen()),
    GoRoute(
      path: AppPaths.notify,
      builder: (context, state) => NotificationScreen(),
    ),
    goRoute(
      path: AppPaths.postDetailPath,
      builder: (id) => PostDetailScreen(id: id!),
    ),
    GoRoute(
      path: AppPaths.addPost,
      builder: (context, state) => AddPostScreen(),
    ),
    GoRoute(
      path: AppPaths.addPostSearch,
      builder: (context, state) => AddPostSearchScreen(),
    ),
    GoRoute(
      path: AppPaths.addPostSecond,
      builder: (context, state) => AddPostSecondScreen(),
    ),
    GoRoute(
      path: AppPaths.addPostThird,
      builder: (context, state) => AddPostThirdScreen(),
    ),
    GoRoute(
      path: AppPaths.addPostLast,
      builder: (context, state) => AddPostLastScreen(),
    ),
    goRoute(
      path: '${AppPaths.message}/:id',
      builder: (id) => MessageDetailScreen(id: id!),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        statefulShellBranch(path: AppPaths.home, page: HomeScreen()),
        statefulShellBranch(path: AppPaths.message, page: MessageScreen()),
        statefulShellBranch(
          path: AppPaths.save,
          page: SaveScreen(),
          sub: [
            goRoute(path: '${AppPaths.save}/:id', builder: (id) => Container()),
          ],
        ),
        statefulShellBranch(
          path: AppPaths.profile,
          page: MyPageScreen(),
          sub: [
            goRoute(
              path: '${AppPaths.profile}/:id',
              builder: (id) => Container(),
            ),
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
