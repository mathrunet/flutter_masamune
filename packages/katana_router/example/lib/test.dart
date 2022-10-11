import 'dart:math';

import 'package:flutter/material.dart';
import 'package:katana_router/katana_router.dart';

part "test.router.dart";

@PagePath("/")
class MainPage extends _$MainPage {
  const factory MainPage() = _MainPage;
  const MainPage._();

  static const query = _$MainPageQuery;

  @override
  Widget build(BuildContext context, PageRef<$MainPage> page) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          page.value =
              page.value.copyWith(userId: Random().rangeInt(0, 100).toString());
        },
        child: Icon(Icons.abc),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          page.value = page.value
              .copyWith(contentId: Random().rangeInt(0, 100).toString());
        },
        child: Icon(Icons.abc),
      ),
    );
  }

  static const query = _$ContentPageQuery();
}
