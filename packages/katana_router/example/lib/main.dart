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
  TransitionQuery get initialRouteQuery => TransitionQuery.fade;
}
