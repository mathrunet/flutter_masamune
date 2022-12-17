import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katana_router/katana_router.dart';

import 'main.router.dart';

part 'main.page.dart';

@appRoute
final appRouter = AutoRouter();

void main() {
  AutoRouter.setPathUrlStrategy();
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

@PagePath("/", name: "main")
class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.title,
    @queryParam this.q,
  });

  final String title;
  final String? q;

  @pageRouteQuery
  static const query = _$MainPage();

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
              onTap: () async {
                await context.router.push<String>(
                  UserPage.query(userId: "UserID"),
                  TransitionQuery.fullscreen,
                );
              },
            ),
            ListTile(
              title: const Text("ContentPage"),
              onTap: () async {
                await context.router
                    .replace<int>(ContentPage.query(contentId: "ContentID"));
              },
            ),
            ListTile(
              title: const Text("NestedPage"),
              onTap: () async {
                context.router.push(NestedContainerPage.query());
              },
            ),
            ListTile(
              title: const Text("Pop"),
              onTap: () {
                context.router.pop();
              },
            ),
            ListTile(
              title: Text("query: $q"),
            )
          ],
        ));
  }
}

@PagePath("/page/:user_id", name: "user")
class UserPage extends StatelessWidget {
  const UserPage({
    super.key,
    required this.userId,
  });
  final String userId;

  @pageRouteQuery
  static const query = _$UserPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UserPage")),
      body: Center(
        child: Text(userId),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.pop("Back to MainPage");
        },
        child: const Icon(Icons.abc),
      ),
    );
  }
}

@PagePath("/content/:content_id")
class ContentPage extends StatelessWidget {
  const ContentPage({
    super.key,
    required this.contentId,
  });

  final String contentId;

  @pageRouteQuery
  static const query = _$ContentPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ContentPage")),
      body: Center(
        child: Text(contentId),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.pop(100);
        },
        child: const Icon(Icons.abc),
      ),
    );
  }
}

@PagePath("/nested", name: "nested")
class NestedContainerPage extends StatefulWidget {
  const NestedContainerPage({
    super.key,
  });

  @pageRouteQuery
  static const query = _$NestedContainerPage();

  @override
  State<StatefulWidget> createState() => _NestedContainerPageState();
}

class _NestedContainerPageState extends State<NestedContainerPage> {
  final router = AppRouter(
    initialQuery: InnerPage1.query(),
    defaultTransitionQuery: TransitionQuery.fade,
    pages: [
      ...InnerPageType.values.map((e) => e.builder),
    ],
  );

  @override
  void initState() {
    super.initState();
    router.addListener(handledOnUpdate);
  }

  void handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    router.removeListener(handledOnUpdate);
    router.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = router.currentQuery;
    return Scaffold(
      appBar: AppBar(title: const Text("NestedPage")),
      body: Router.withConfig(config: router),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          router.push(
            InnerPageType.values[value].query,
          );
        },
        currentIndex: query?.key<InnerPageType>()?.index ?? 0,
        items: InnerPageType.values.map((type) {
          return BottomNavigationBarItem(
            icon: Icon(type.icon),
            label: type.label,
          );
        }).toList(),
      ),
    );
  }
}

@NestedPage(key: InnerPageType.type1)
class InnerPage1 extends StatelessWidget {
  const InnerPage1({super.key});

  static const query = _$InnerPage1();

  @override
  Widget build(BuildContext context) {
    final current = context.rootRouter.currentQuery;
    return Center(
      child: TextButton(
        onPressed: () {
          context.rootRouter.pop();
        },
        child: Text("To Innerpage2 ${current?.name}"),
      ),
    );
  }
}

@NestedPage(key: InnerPageType.type2)
class InnerPage2 extends StatelessWidget {
  const InnerPage2({super.key});

  static const query = _$InnerPage2();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          context.router.push(InnerPage1.query());
        },
        child: const Text("To Innerpage1"),
      ),
    );
  }
}

enum InnerPageType {
  type1(
    icon: Icons.people,
    label: "people",
  ),
  type2(
    icon: Icons.settings,
    label: "settings",
  );

  const InnerPageType({
    required this.icon,
    required this.label,
  });

  final IconData icon;

  final String label;

  RouteQueryBuilder get builder {
    switch (this) {
      case InnerPageType.type1:
        return InnerPage1.query;
      case InnerPageType.type2:
        return InnerPage2.query;
    }
  }

  RouteQuery get query {
    switch (this) {
      case InnerPageType.type1:
        return InnerPage1.query();
      case InnerPageType.type2:
        return InnerPage2.query();
    }
  }
}
