import 'package:flutter/material.dart';
import 'package:katana_router/katana_router.dart';
import 'test.dart';

void main() {
  runApp(const MyApp());
}

const appRoute = AppRouter(
  home: MainPage.query,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MainPage(),
    );
  }
}
