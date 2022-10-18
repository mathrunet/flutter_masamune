part of katana_router_annotation;

/// Annotation defining the page.
///
/// Specify the path of the page in [path] as it is.
///
/// When [redirect] is set, it is possible to write reroute settings for only that page.
///
/// It is possible to tie objects (including enums, etc.) to pages by specifying [key].
///
/// ページを定義するアノテーション。
///
/// [path]にページのパスをそのまま指定します。
///
/// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
///
/// [key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。
///
/// ```dart
/// @PagePath("/test")
/// class TestWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text("Test")),
///       body: Center(child: Text("Body")),
///     );
///   }
/// }
/// ```
class PagePath {
  /// Annotation defining the page.
  ///
  /// Specify the path of the page in [path] as it is.
  ///
  /// When [redirect] is set, it is possible to write reroute settings for only that page.
  ///
  /// It is possible to tie objects (including enums, etc.) to pages by specifying [key].
  ///
  /// ページを定義するアノテーション。
  ///
  /// [path]にページのパスをそのまま指定します。
  ///
  /// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
  ///
  /// [key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。
  ///
  /// ```dart
  /// @PagePath("/test")
  /// class TestWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text("Test")),
  ///       body: Center(child: Text("Body")),
  ///     );
  ///   }
  /// }
  /// ```
  const PagePath(
    this.path, {
    this.key,
    this.redirect = const [],
  });

  /// Page path.
  ///
  /// ページパス。
  final String path;

  /// Key object of the page.
  ///
  /// Can be retrieved from `RouteQuery`. Please use it to identify the current page in nested navigation tabs, etc.
  ///
  /// ページのキーオブジェクト。
  ///
  /// `RouteQuery`から取り出すことが可能です。ネストナビゲーションのタブなどで現在のページを識別するためにご利用ください。
  final Object? key;

  /// Reroute settings.
  ///
  /// When [redirect] is set, it is possible to write reroute settings for only that page.
  ///
  /// Only `RerouteQuery` and classes that extend it are used by the builder.
  ///
  /// リルート設定。
  ///
  /// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
  ///
  /// `RerouteQuery`とそれを継承したクラスのみがbuilderで利用されます。
  final List<Object> redirect;
}

/// Pages for use in nested navigators rather than at the top level.
///
/// If used with this, it will not be accessible via deep linking.
///
/// When [redirect] is set, it is possible to write reroute settings that correspond only to that page.
///
/// It is possible to tie objects (including enums, etc.) to pages by specifying [key].
///
/// トップレベルではなくネストされたナビゲーターで用いるためのページ。
///
/// これで使用した場合、ディープリンクでのアクセスができなくなります。
///
/// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
///
/// [key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。
///
/// ```dart
/// @NestedPage()
/// class TestWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text("Test")),
///       body: Center(child: Text("Body")),
///     );
///   }
/// }
/// ```
const nestedPage = NestedPage();

/// Pages for use in nested navigators rather than at the top level.
///
/// If used with this, it will not be accessible via deep linking.
///
/// When [redirect] is set, it is possible to write reroute settings that correspond only to that page.
///
/// It is possible to tie objects (including enums, etc.) to pages by specifying [key].
///
/// トップレベルではなくネストされたナビゲーターで用いるためのページ。
///
/// これで使用した場合、ディープリンクでのアクセスができなくなります。
///
/// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
///
/// [key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。
///
/// ```dart
/// @NestedPage()
/// class TestWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text("Test")),
///       body: Center(child: Text("Body")),
///     );
///   }
/// }
/// ```
class NestedPage {
  /// Pages for use in nested navigators rather than at the top level.
  ///
  /// If used with this, it will not be accessible via deep linking.
  ///
  /// When [redirect] is set, it is possible to write reroute settings that correspond only to that page.
  ///
  /// It is possible to tie objects (including enums, etc.) to pages by specifying [key].
  ///
  /// トップレベルではなくネストされたナビゲーターで用いるためのページ。
  ///
  /// これで使用した場合、ディープリンクでのアクセスができなくなります。
  ///
  /// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
  ///
  /// [key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。
  ///
  /// ```dart
  /// @NestedPage()
  /// class TestWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text("Test")),
  ///       body: Center(child: Text("Body")),
  ///     );
  ///   }
  /// }
  /// ```
  const NestedPage({
    this.key,
    this.redirect = const [],
  });

  /// Key object of the page.
  ///
  /// Can be retrieved from `RouteQuery`. Please use it to identify the current page in nested navigation tabs, etc.
  ///
  /// ページのキーオブジェクト。
  ///
  /// `RouteQuery`から取り出すことが可能です。ネストナビゲーションのタブなどで現在のページを識別するためにご利用ください。
  final Object? key;

  /// Reroute settings.
  ///
  /// When [redirect] is set, it is possible to write reroute settings for only that page.
  ///
  /// Only `RerouteQuery` and classes that extend it are used by the builder.
  ///
  /// リルート設定。
  ///
  /// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
  ///
  /// `RerouteQuery`とそれを継承したクラスのみがbuilderで利用されます。
  final List<Object> redirect;
}
