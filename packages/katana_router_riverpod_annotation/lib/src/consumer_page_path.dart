part of katana_router_riverpod_annotation;

/// Annotation defining the page.
/// ページを定義するアノテーション。
///
/// Specify the path of the page in [path] as it is.
/// [path]にページのパスをそのまま指定します。
///
/// When [reroute] is set, it is possible to write reroute settings for only that page.
/// [reroute]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
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
class ConsumerPagePath {
  /// Annotation defining the page.
  /// ページを定義するアノテーション。
  ///
  /// Specify the path of the page in [path] as it is.
  /// [path]にページのパスをそのまま指定します。
  ///
  /// When [reroute] is set, it is possible to write reroute settings for only that page.
  /// [reroute]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
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
  const ConsumerPagePath(
    this.path, {
    this.reroute = const [],
  });

  /// Page path.
  /// ページパス。
  final String path;

  /// Reroute settings.
  /// リルート設定。
  ///
  /// When [reroute] is set, it is possible to write reroute settings for only that page.
  /// [reroute]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
  ///
  /// Only `RerouteQuery` and classes that extend it are used by the builder.
  /// `RerouteQuery`とそれを継承したクラスのみがbuilderで利用されます。
  final List<Object> reroute;
}
