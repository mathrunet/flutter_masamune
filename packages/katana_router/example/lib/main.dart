import 'package:flutter/material.dart';
import 'package:katana_router/katana_router.dart';

part "main.m.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

@immutable
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MainPage"),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text("UserPage"),
              onTap: () {
                context.navigator.pushPage(UserPage.query(userId: "aaaa"));
              },
            ),
            ListTile(
              title: const Text("ContentPage"),
              onTap: () {
                context.navigator
                    .pushPage(ContentPage.query(contentId: "bbbb"));
              },
            )
          ],
        ));
  }
}

@PagePath("/page/{user_id}")
class UserPage extends _$UserPage {
  const factory UserPage({required String userId}) = _UserPage;
  const UserPage._();

  @override
  Widget build(BuildContext context, PageRef<$UserPage> page) {
    final userId = page.value.userId;

    return Scaffold(
      appBar: AppBar(title: const Text("UserPage")),
      body: Center(
        child: Text(userId),
      ),
    );
  }

  static const query = _$UserPageQuery();
}

@PagePath("/content/{content_id}")
class ContentPage extends _$ContentPage {
  const factory ContentPage({
    required String contentId,
  }) = _ContentPage;
  const ContentPage._();

  @override
  Widget build(BuildContext context, PageRef<$ContentPage> page) {
    final contentId = page.value.contentId;

    return Scaffold(
      appBar: AppBar(title: const Text("ContentPage")),
      body: Center(
        child: Text(contentId),
      ),
    );
  }

  static const query = _$ContentPageQuery();
}
