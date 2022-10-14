import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katana_router/katana_router.dart';
import 'test.dart';

void main() {
  runApp(const MyApp());
}

final appRoute = AppRouter(
  boot: Boot(),
  pages: [
    MainPage.query,
    UserPage.query,
    ContentPage.query,
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRoute,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MainPage(),
    );
  }
}

class Boot extends BootPageQueryBuilder {
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
  RouteQuery get initialRouteQuery => RouteQuery.fade;
}
