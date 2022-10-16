// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators

// **************************************************************************
// RouterGenerator
// **************************************************************************

import 'package:katana_router/katana_router.dart';
import 'package:katana_router_example/test.dart';
export 'package:katana_router/katana_router.dart';
export 'package:katana_router_example/test.dart';

class AppRouter extends AppRouterBase {
  AppRouter({
    super.unknown,
    super.boot,
    super.initialPath = "/",
    super.redirect = const [],
    super.observers = const [],
    super.redirectLimit = 5,
    super.navigatorKey,
    super.restorationScopeId,
    super.defaultRouteQuery,
  }) : super(pages: [MainPage.query, ContentPage.query, UserPage.query]);

  static const mainPage = MainPage.query;

  static const contentPage = ContentPage.query;

  static const userPage = UserPage.query;

  Map<RouteQueryBuilder, String> queryMap = {
    MainPage.query: "/",
    ContentPage.query: "/content/:content_id",
    UserPage.query: "/page/:user_id"
  };
}
