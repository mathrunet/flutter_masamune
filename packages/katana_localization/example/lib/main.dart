import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katana_router/katana_router.dart';
import 'test.dart';

import 'main.router.dart';

@appRoute
final appRouter = AppRouter();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MainPage(),
    );
  }
}

class Boot extends BootRouteQueryBuilder {
  const Boot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  FutureOr<void> onInit(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  TransitionQuery get initialTransitionQuery => TransitionQuery.fade;
}

class Localize {
  const Localize._();

  static const _map = {
    "ja": _$LocalizejaJP(Locale("ja", "JP")),
  };

  _$LocalizeBase of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    if (!_map.containsKey(lang)) {
      return _map.entries.first.value;
    }
    return _map[lang]!;
  }
}

class _$LocalizejaJP extends _$LocalizeBase {
  const _$LocalizejaJP(super.locale);

  @override
  String get aaa => "aaa";
}

abstract class _$LocalizeBase {
  const _$LocalizeBase(this.locale);

  final Locale locale;

  String get aaa => throw UnimplementedError();
}
