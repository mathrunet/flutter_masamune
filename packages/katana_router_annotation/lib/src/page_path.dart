part of "/katana_router_annotation.dart";

/// Annotation defining the page.
///
/// Specify the path of the page in [path] as it is.
///
/// When [redirect] is set, it is possible to write reroute settings for only that page.
///
/// You can give a name to a page by specifying [name], and you can bind an object (including enums, etc.) to a page by specifying [key]. All of these can be obtained from `RouteQuery`.
///
/// ページを定義するアノテーション。
///
/// [path]にページのパスをそのまま指定します。
///
/// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
///
/// [name]を指定することでページに名前をつけることができ、[key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。これらはすべて`RouteQuery`から取得することができます。
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
  /// You can give a name to a page by specifying [name], and you can bind an object (including enums, etc.) to a page by specifying [key]. All of these can be obtained from `RouteQuery`.
  ///
  /// ページを定義するアノテーション。
  ///
  /// [path]にページのパスをそのまま指定します。
  ///
  /// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
  ///
  /// [name]を指定することでページに名前をつけることができ、[key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。これらはすべて`RouteQuery`から取得することができます。
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
    this.name,
    this.transition,
    this.redirect = const [],
    this.implementType,
  });

  /// Page path.
  ///
  /// ページパス。
  final String path;

  /// Page Name.
  ///
  /// ページの名前。
  final String? name;

  /// Key object of the page.
  ///
  /// Can be retrieved from `RouteQuery`. Please use it to identify the current page in nested navigation tabs, etc.
  ///
  /// ページのキーオブジェクト。
  ///
  /// `RouteQuery`から取り出すことが可能です。ネストナビゲーションのタブなどで現在のページを識別するためにご利用ください。
  final Object? key;

  /// Specifies page transitions.
  ///
  /// Specify `TransitionQuery` for [transition].
  ///
  /// ページのトランジションを指定します。
  ///
  /// [transition]には`TransitionQuery`を指定します。
  final Object? transition;

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

  /// Specify a class that extends `RouteQueryBuilder` to enable page swapping.
  ///
  /// `RouteQueryBuilder`を継承したクラスを指定してページを入れ替え可能にします。
  final Type? implementType;
}

/// Pages to be used in nested navigators instead of at the top level or to intentionally not set URLs.
///
/// If used with this, it will not be accessible via deep linking.
///
/// When [redirect] is set, it is possible to write reroute settings that correspond only to that page.
///
/// You can give a name to a page by specifying [name], and you can bind an object (including enums, etc.) to a page by specifying [key]. All of these can be obtained from `RouteQuery`.
///
/// トップレベルではなくネストされたナビゲーターで用いたり、意図的にURLを設定しないためのページ。
///
/// これで使用した場合、ディープリンクでのアクセスができなくなります。
///
/// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
///
/// [name]を指定することでページに名前をつけることができ、[key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。これらはすべて`RouteQuery`から取得することができます。
///
/// ```dart
/// @HiddenPage()
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
const hiddenPage = HiddenPage();

@Deprecated("Use `hiddenPage` instead.")
const nestedPage = hiddenPage;

/// Pages to be used in nested navigators instead of at the top level or to intentionally not set URLs.
///
/// If used with this, it will not be accessible via deep linking.
///
/// When [redirect] is set, it is possible to write reroute settings that correspond only to that page.
///
/// You can give a name to a page by specifying [name], and you can bind an object (including enums, etc.) to a page by specifying [key]. All of these can be obtained from `RouteQuery`.
///
/// トップレベルではなくネストされたナビゲーターで用いたり、意図的にURLを設定しないためのページ。
///
/// これで使用した場合、ディープリンクでのアクセスができなくなります。
///
/// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
///
/// [name]を指定することでページに名前をつけることができ、[key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。これらはすべて`RouteQuery`から取得することができます。
///
/// ```dart
/// @HiddenPage()
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
class HiddenPage {
  /// Pages to be used in nested navigators instead of at the top level or to intentionally not set URLs.
  ///
  /// If used with this, it will not be accessible via deep linking.
  ///
  /// When [redirect] is set, it is possible to write reroute settings that correspond only to that page.
  ///
  /// You can give a name to a page by specifying [name], and you can bind an object (including enums, etc.) to a page by specifying [key]. All of these can be obtained from `RouteQuery`.
  ///
  /// トップレベルではなくネストされたナビゲーターで用いたり、意図的にURLを設定しないためのページ。
  ///
  /// これで使用した場合、ディープリンクでのアクセスができなくなります。
  ///
  /// [redirect]を設定するとそのページのみに対応するリルート設定を記述することが可能です。
  ///
  /// [name]を指定することでページに名前をつけることができ、[key]を指定することでページにオブジェクト（enumなども含む）を紐付けることが可能です。これらはすべて`RouteQuery`から取得することができます。
  ///
  /// ```dart
  /// @HiddenPage()
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
  const HiddenPage({
    this.key,
    this.name,
    this.transition,
    this.redirect = const [],
    this.implementType,
  });

  /// Page Name.
  ///
  /// ページの名前。
  final String? name;

  /// Key object of the page.
  ///
  /// Can be retrieved from `RouteQuery`. Please use it to identify the current page in nested navigation tabs, etc.
  ///
  /// ページのキーオブジェクト。
  ///
  /// `RouteQuery`から取り出すことが可能です。ネストナビゲーションのタブなどで現在のページを識別するためにご利用ください。
  final Object? key;

  /// Specifies page transitions.
  ///
  /// Specify `TransitionQuery` for [transition].
  ///
  /// ページのトランジションを指定します。
  ///
  /// [transition]には`TransitionQuery`を指定します。
  final Object? transition;

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

  /// Specify a class that extends `RouteQueryBuilder` to enable page swapping.
  ///
  /// `RouteQueryBuilder`を継承したクラスを指定してページを入れ替え可能にします。
  final Type? implementType;
}

@Deprecated("NestedPage is changed to HiddenPage.")
typedef NestedPage = HiddenPage;
