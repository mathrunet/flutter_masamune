part of masamune_annotation;

/// Annotation to create a query for a group of controllers.
///
/// You can define a query to retrieve the controller at `static const query = _$(class name)ControllerGroupQuery()`.
///
/// Multiple `ChangeNotifier`s can be grouped together in `katana_listenables` and used as a controller group.
///
/// コントローラーグループ用のクエリを作成するためのアノテーション。
///
/// `static const query = _$(クラス名)ControllerGroupQuery()`にコントローラーを取得するためのクエリを定義できます。
///
/// `katana_listenables`で複数の`ChangeNotifier`をまとめた上でコントローラーグループとして利用することが可能です。
///
/// ```dart
/// @listenables
/// @controllerGroup
/// class PageControllerGroup with _$PageControllerGroup, ChangeNotifier {
///   factory ${className}ControllerGroup({
///     TextEditingController? textEditingController,
///     FocusNode? focusNode,
///   }) = _PageControllerGroup;
///   PageControllerGroup._();
///
///   static const query = _$PageControllerGroupQuery();
/// }
/// ```
///
/// * see https://pub.dev/packages/katana_listenables
const controllerGroup = ControllerGroup();

/// Annotation to create a query for a group of controllers.
///
/// You can define a query to retrieve the controller at `static const query = _$(class name)ControllerGroupQuery()`.
///
/// Multiple `ChangeNotifier`s can be grouped together in `katana_listenables` and used as a controller group.
///
/// コントローラーグループ用のクエリを作成するためのアノテーション。
///
/// `static const query = _$(クラス名)ControllerGroupQuery()`にコントローラーを取得するためのクエリを定義できます。
///
/// `katana_listenables`で複数の`ChangeNotifier`をまとめた上でコントローラーグループとして利用することが可能です。
///
/// ```dart
/// @listenables
/// @controllerGroup
/// class PageControllerGroup with _$PageControllerGroup, ChangeNotifier {
///   factory ${className}ControllerGroup({
///     TextEditingController? textEditingController,
///     FocusNode? focusNode,
///   }) = _PageControllerGroup;
///   PageControllerGroup._();
///
///   static const query = _$PageControllerGroupQuery();
/// }
/// ```
///
/// * see https://pub.dev/packages/katana_listenables
class ControllerGroup {
  /// Annotation to create a query for a group of controllers.
  ///
  /// You can define a query to retrieve the controller at `static const query = _$(class name)ControllerGroupQuery()`.
  ///
  /// Multiple `ChangeNotifier`s can be grouped together in `katana_listenables` and used as a controller group.
  ///
  /// コントローラーグループ用のクエリを作成するためのアノテーション。
  ///
  /// `static const query = _$(クラス名)ControllerGroupQuery()`にコントローラーを取得するためのクエリを定義できます。
  ///
  /// `katana_listenables`で複数の`ChangeNotifier`をまとめた上でコントローラーグループとして利用することが可能です。
  ///
  /// ```dart
  /// @listenables
  /// @controllerGroup
  /// class PageControllerGroup with _$PageControllerGroup, ChangeNotifier {
  ///   factory ${className}ControllerGroup({
  ///     TextEditingController? textEditingController,
  ///     FocusNode? focusNode,
  ///   }) = _PageControllerGroup;
  ///   PageControllerGroup._();
  ///
  ///   static const query = _$PageControllerGroupQuery();
  /// }
  /// ```
  ///
  /// * see https://pub.dev/packages/katana_listenables
  const ControllerGroup();
}
