part of '/katana_router_annotation.dart';

/// Annotation to map each widget parameter to a query parameter in the page path.
///
/// For example, if a request is made with the path `/search?q=text` in the following case, the `text` character is passed to `query`.
///
/// 各ウィジェットのパラメーターとページパスのクエリーパラメーターを対応するためのアノテーション。
///
/// 例えば下記の場合`/search?q=text`というパスでリクエストが行われた場合、`text`の文字が`query`に渡されます。
///
/// ```dart
/// @PagePath("/search")
/// class Test extends StatelessWidget {
///   const Test({
///     @QueryParam("q") required String query,
///     super.key
///   });
///
/// }
/// ```
const queryParam = QueryParam();

/// Annotation to map each widget parameter to a query parameter in the page path.
///
/// For example, if a request is made with the path `/search?q=text` in the following case, the `text` character is passed to `query`.
///
/// 各ウィジェットのパラメーターとページパスのクエリーパラメーターを対応するためのアノテーション。
///
/// 例えば下記の場合`/search?q=text`というパスでリクエストが行われた場合、`text`の文字が`query`に渡されます。
///
/// ```dart
/// @PagePath("/search")
/// class Test extends StatelessWidget {
///   const Test({
///     @QueryParam("q") required String query,
///     super.key
///   });
///
/// }
/// ```
class QueryParam {
  /// Annotation to map each widget parameter to a query parameter in the page path.
  ///
  /// For example, if a request is made with the path `/search?q=text` in the following case, the `text` character is passed to `query`.
  ///
  /// 各ウィジェットのパラメーターとページパスのクエリーパラメーターを対応するためのアノテーション。
  ///
  /// 例えば下記の場合`/search?q=text`というパスでリクエストが行われた場合、`text`の文字が`query`に渡されます。
  ///
  /// ```dart
  /// @PagePath("/search")
  /// class Test extends StatelessWidget {
  ///   const Test({
  ///     @QueryParam("q") required String query,
  ///     super.key
  ///   });
  ///
  /// }
  /// ```
  const QueryParam([this.name]);

  /// Name of parameter.
  ///
  /// パラメータの名前。
  final String? name;
}
