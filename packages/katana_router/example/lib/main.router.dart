// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, depend_on_referenced_packages

// **************************************************************************
// RouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:katana_router/katana_router.dart';

// Project imports:
import 'package:katana_router_example/main.dart' as _$1;

export 'package:katana_router_example/main.dart'
    show MainPage, UserPage, ContentPage, NestedContainerPage;

class AutoRouter extends AppRouter {
  AutoRouter({
    super.unknown,
    super.boot,
    super.initialPath,
    super.initialQuery,
    super.redirect = const [],
    super.observers = const [],
    super.redirectLimit = 5,
    super.navigatorKey,
    super.restorationScopeId,
    super.defaultTransitionQuery,
    List<RouteQueryBuilder>? pages,
    super.reportsRouteUpdateToEngine = true,
    super.backgroundWidget = const Scaffold(),
    super.loggerAdapters,
  }) : super(
            pages: pages ??
                [
                  _$1.UserPage.query,
                  _$1.NestedContainerPage.query,
                  _$1.ContentPage.query,
                  _$1.MainPage.query
                ]);

  static const userPage = _$1.UserPage.query;

  static const nestedContainerPage = _$1.NestedContainerPage.query;

  static const contentPage = _$1.ContentPage.query;

  static const mainPage = _$1.MainPage.query;

  Map<RouteQueryBuilder, String> queryMap = {
    _$1.UserPage.query: "/page/:user_id",
    _$1.NestedContainerPage.query: "/nested",
    _$1.ContentPage.query: "/content/:content_id",
    _$1.MainPage.query: "/"
  };
}
