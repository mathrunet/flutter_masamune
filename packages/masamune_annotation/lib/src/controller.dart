part of masamune_annotation;

/// Annotation for creating queries for controllers.
///
/// You can define a query to retrieve the controller at `static const query = _$(class name)ControllerQuery()`.
///
/// Used for classes inheriting from `ChangeNotifier`.
///
/// コントローラー用のクエリを作成するためのアノテーション。
///
/// `static const query = _$(クラス名)ControllerQuery()`にコントローラーを取得するためのクエリを定義できます。
///
/// `ChangeNotifier`を継承したクラスに対して利用します。
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
const controller = Controller();

/// Annotation for creating queries for controllers.
///
/// You can define a query to retrieve the controller at `static const query = _$(class name)ControllerQuery()`.
///
/// Used for classes inheriting from `ChangeNotifier`.
///
/// コントローラー用のクエリを作成するためのアノテーション。
///
/// `static const query = _$(クラス名)ControllerQuery()`にコントローラーを取得するためのクエリを定義できます。
///
/// `ChangeNotifier`を継承したクラスに対して利用します。
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
  /// コントローラー用のクエリを作成するためのアノテーション。
  ///
  /// `static const query = _$(クラス名)ControllerQuery()`にコントローラーを取得するためのクエリを定義できます。
  ///
  /// `ChangeNotifier`を継承したクラスに対して利用します。
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
  const Controller();
}
