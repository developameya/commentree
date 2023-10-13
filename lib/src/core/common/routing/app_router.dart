// ignore: unused_import
import 'package:auto_route/auto_route.dart';
import 'package:commentree/src/features/comment/presentation/screens/comment_screen.dart';
import 'package:commentree/src/features/home/presentation/screens/home_screen.dart';
import 'package:commentree/src/features/user/presentation/screens/user_screen.dart';
import 'package:commentree/src/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:flutter/foundation.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen|View,Route')
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
        ),
        AutoRoute(page: WelcomeRoute.page),
        AutoRoute(page: CommentRoute.page),
        AutoRoute(page: UserRoute.page),
      ];

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    resolver.next(true);
    // final isFirstUse = routeNotfier.value;
    // if (isFirstUse || resolver.route.name == WelcomeRoute.name) {
    //   resolver.next(true);
    // } else {
    //   resolver.redirect(WelcomeRoute(onResult: resolver.next));
    // }
  }
}
