part of katana_router_annotation;

/// Annotation to map each widget parameter to a variable in the page root.
///
/// Write `@ParaPathParam(\"user_id\")` as a parameter annotation to link the `user_id` in the path to the class argument `userId` as in the example below.
///
/// If [name] is set to [Null], the parameter name itself, i.e. `userId`, is used.
///
/// 各ウィジェットのパラメーターとページのルートの変数を対応するためのアノテーション。
///
/// 下記の例のようにパス内の`user_id`をクラス引数の`userId`に紐付けるために`@ParaPathParam("user_id")`をパラメータのアノテーションとして記述します。
///
/// [name]を[Null]にした場合はパラメーターの名前そのもの、つまり`userId`が利用されます。
///
/// ```dart
/// @PagePath("/user/:user_id")
/// class Test extends StatelessWidget {
///   const Test({
///     @ParaParam("user_id") required String userId,
///     super.key
///   });
///
/// }
/// ```
const pageParam = PageParam();

/// Annotation to map each widget parameter to a variable in the page root.
///
/// Write `@ParaPathParam(\"user_id\")` as a parameter annotation to link the `user_id` in the path to the class argument `userId` as in the example below.
///
/// If [name] is set to [Null], the parameter name itself, i.e. `userId`, is used.
///
/// 各ウィジェットのパラメーターとページのルートの変数を対応するためのアノテーション。
///
/// 下記の例のようにパス内の`user_id`をクラス引数の`userId`に紐付けるために`@ParaPathParam("user_id")`をパラメータのアノテーションとして記述します。
///
/// [name]を[Null]にした場合はパラメーターの名前そのもの、つまり`userId`が利用されます。
///
/// ```dart
/// @PagePath("/user/:user_id")
/// class Test extends StatelessWidget {
///   const Test({
///     @ParaParam("user_id") required String userId,
///     super.key
///   });
///
/// }
/// ```
class PageParam {
  /// Annotation to map each widget parameter to a variable in the page root.
  ///
  /// Write `@ParaPathParam(\"user_id\")` as a parameter annotation to link the `user_id` in the path to the class argument `userId` as in the example below.
  ///
  /// If [name] is set to [Null], the parameter name itself, i.e. `userId`, is used.
  ///
  /// 各ウィジェットのパラメーターとページのルートの変数を対応するためのアノテーション。
  ///
  /// 下記の例のようにパス内の`user_id`をクラス引数の`userId`に紐付けるために`@ParaPathParam("user_id")`をパラメータのアノテーションとして記述します。
  ///
  /// [name]を[Null]にした場合はパラメーターの名前そのもの、つまり`userId`が利用されます。
  ///
  /// ```dart
  /// @PagePath("/user/:user_id")
  /// class Test extends StatelessWidget {
  ///   const Test({
  ///     @ParaParam("user_id") required String userId,
  ///     super.key
  ///   });
  ///
  /// }
  /// ```
  const PageParam([this.name]);

  /// Name of parameter.
  ///
  /// パラメータの名前。
  final String? name;
}
