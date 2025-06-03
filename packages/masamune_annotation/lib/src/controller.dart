part of "/masamune_annotation.dart";

/// Annotation for creating queries for controllers.
///
/// You can define a query to retrieve the controller at `static const query = _$(class name)ControllerQuery()`.
///
/// Used for classes inheriting from `ChangeNotifier`.
///
/// If [autoDisposeWhenUnreferenced] is set to `true`, it will automatically dispose of [Controller] when it is no longer referenced by any widget.
///
/// コントローラー用のクエリを作成するためのアノテーション。
///
/// `static const query = _$(クラス名)ControllerQuery()`にコントローラーを取得するためのクエリを定義できます。
///
/// `ChangeNotifier`を継承したクラスに対して利用します。
///
/// [autoDisposeWhenUnreferenced]を`true`にした場合、[Controller]がどのウィジェットにも参照されなくなったときに自動的に破棄します。
///
/// ```dart
/// @controller
/// @listenables
/// class UserController extends ChangeNotifier {
///   UserController();
///
///   static const query = _$UserControllerQuery();
/// }
/// ```
class Controller {
  /// Annotation for creating queries for controllers.
  ///
  /// You can define a query to retrieve the controller at `static const query = _$(class name)ControllerQuery()`.
  ///
  /// Used for classes inheriting from `ChangeNotifier`.
  ///
  /// If [autoDisposeWhenUnreferenced] is set to `true`, it will automatically dispose of [Controller] when it is no longer referenced by any widget.
  ///
  /// コントローラー用のクエリを作成するためのアノテーション。
  ///
  /// `static const query = _$(クラス名)ControllerQuery()`にコントローラーを取得するためのクエリを定義できます。
  ///
  /// `ChangeNotifier`を継承したクラスに対して利用します。
  ///
  /// [autoDisposeWhenUnreferenced]を`true`にした場合、[Controller]がどのウィジェットにも参照されなくなったときに自動的に破棄します。
  ///
  /// ```dart
  /// @controller
  /// @listenables
  /// class UserController extends ChangeNotifier {
  ///   UserController();
  ///
  ///   static const query = _$UserControllerQuery();
  /// }
  /// ```
  const Controller({
    this.autoDisposeWhenUnreferenced = true,
  });

  /// Returns `true` if [Controller] should be automatically destroyed when it is no longer referenced by any widget.
  ///
  /// [Controller]がどのウィジェットにも参照されなくなったときに自動的に破棄する場合`true`を返します。
  final bool autoDisposeWhenUnreferenced;
}
