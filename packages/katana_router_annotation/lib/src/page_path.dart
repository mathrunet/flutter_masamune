part of katana_router_annotation;

/// Annotation defining the page.
///
/// Specify the path of the page in [path] as it is.
///
/// When [redirect] is set, it is possible to write reroute settings for only that page.
///
/// ページを定義するアノテーション。
///
/// [path]にページのパスをそのまま指定します。
///
/// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
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
  /// ページを定義するアノテーション。
  ///
  /// [path]にページのパスをそのまま指定します。
  ///
  /// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
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
    this.redirect = const [],
  });

  /// Page path.
  ///
  /// ページパス。
  final String path;

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
