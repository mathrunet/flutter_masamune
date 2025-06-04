// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_router/katana_router.dart";

// Project imports:
import "main.router.dart";

part "main.page.dart";

/// Application router configuration.
///
/// アプリケーションルーター設定。
@appRoute
final appRouter = AutoRouter();

void main() {
  runApp(const MyApp());
}

/// Main application widget for router demo.
///
/// Router デモ用のメインアプリケーションWidget。
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  ///
  /// MyAppウィジェットを作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MainPage(),
    );
  }
}

/// Boot route query builder for initial loading screen.
///
/// 初期ローディング画面用のBootルートクエリビルダー。
class Boot extends BootRouteQueryBuilder {
  /// Creates a Boot widget.
  ///
  /// Bootウィジェットを作成します。
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

  @override
  void onError(
      BuildContext context, BootRef ref, Object error, StackTrace stackTrace) {}
}

/// Main page widget demonstrating basic routing functionality.
///
/// 基本的なルーティング機能を実演するメインページWidget。
@PagePath("/", name: "main")
class MainPage extends StatelessWidget {
  /// Creates a MainPage widget.
  ///
  /// MainPageウィジェットを作成します。
  const MainPage({
    required this.title,
    super.key,
    @queryParam this.q,
  });

  /// Page title.
  ///
  /// ページタイトル。
  final String title;

  /// Query parameter value.
  ///
  /// クエリパラメータ値。
  final String? q;

  /// Page route query for MainPage.
  ///
  /// MainPage用のページルートクエリ。
  @pageRouteQuery
  static const query = _$MainPageQuery();

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
              onTap: () {
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

/// User page widget for displaying user information.
///
/// ユーザー情報を表示するユーザーページWidget。
@PagePath("/page/:user_id", name: "user")
class UserPage extends StatelessWidget {
  /// Creates a UserPage widget.
  ///
  /// UserPageウィジェットを作成します。
  const UserPage({
    required this.userId,
    super.key,
  });

  /// User ID from route parameter.
  ///
  /// ルートパラメータからのユーザーID。
  final String userId;

  /// Page route query for UserPage.
  ///
  /// UserPage用のページルートクエリ。
  @pageRouteQuery
  static const query = _$UserPageQuery();

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

/// Content page widget for displaying content information.
///
/// コンテンツ情報を表示するコンテンツページWidget。
@PagePath("/content/:content_id")
class ContentPage extends StatelessWidget {
  /// Creates a ContentPage widget.
  ///
  /// ContentPageウィジェットを作成します。
  const ContentPage({
    required this.contentId,
    super.key,
  });

  /// Content ID from route parameter.
  ///
  /// ルートパラメータからのコンテンツID。
  final String contentId;

  /// Page route query for ContentPage.
  ///
  /// ContentPage用のページルートクエリ。
  @pageRouteQuery
  static const query = _$ContentPageQuery();

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

/// Nested container page widget for demonstrating nested routing.
///
/// ネストしたルーティングを実演するネストコンテナページWidget。
@PagePath("/nested", name: "nested")
class NestedContainerPage extends StatefulWidget {
  /// Creates a NestedContainerPage widget.
  ///
  /// NestedContainerPageウィジェットを作成します。
  const NestedContainerPage({
    super.key,
  });

  /// Page route query for NestedContainerPage.
  ///
  /// NestedContainerPage用のページルートクエリ。
  @pageRouteQuery
  static const query = _$NestedContainerPageQuery();

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

/// First inner page widget for nested routing demonstration.
///
/// ネストルーティング実演用の最初の内部ページWidget。
@HiddenPage(key: InnerPageType.type1)
class InnerPage1 extends StatelessWidget {
  /// Creates an InnerPage1 widget.
  ///
  /// InnerPage1ウィジェットを作成します。
  const InnerPage1({super.key});

  /// Page route query for InnerPage1.
  ///
  /// InnerPage1用のページルートクエリ。
  static const query = _$InnerPage1Query();

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

/// Second inner page widget for nested routing demonstration.
///
/// ネストルーティング実演用の2番目の内部ページWidget。
@HiddenPage(key: InnerPageType.type2)
class InnerPage2 extends StatelessWidget {
  /// Creates an InnerPage2 widget.
  ///
  /// InnerPage2ウィジェットを作成します。
  const InnerPage2({super.key});

  /// Page route query for InnerPage2.
  ///
  /// InnerPage2用のページルートクエリ。
  static const query = _$InnerPage2Query();

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

/// Enum defining inner page types for nested routing.
///
/// ネストルーティング用の内部ページタイプを定義するEnum。
enum InnerPageType {
  /// First inner page type.
  ///
  /// 最初の内部ページタイプ。
  type1(
    icon: Icons.people,
    label: "people",
  ),

  /// Second inner page type.
  ///
  /// 2番目の内部ページタイプ。
  type2(
    icon: Icons.settings,
    label: "settings",
  );

  /// Creates an InnerPageType.
  ///
  /// InnerPageTypeを作成します。
  const InnerPageType({
    required this.icon,
    required this.label,
  });

  /// Icon for the page type.
  ///
  /// ページタイプのアイコン。
  final IconData icon;

  /// Label for the page type.
  ///
  /// ページタイプのラベル。
  final String label;

  /// Route query builder for the page type.
  ///
  /// ページタイプのルートクエリビルダー。
  RouteQueryBuilder get builder {
    switch (this) {
      case InnerPageType.type1:
        return InnerPage1.query;
      case InnerPageType.type2:
        return InnerPage2.query;
    }
  }

  /// Route query for the page type.
  ///
  /// ページタイプのルートクエリ。
  RouteQuery get query {
    switch (this) {
      case InnerPageType.type1:
        return InnerPage1.query();
      case InnerPageType.type2:
        return InnerPage2.query();
    }
  }
}
