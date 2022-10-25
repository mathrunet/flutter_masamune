part of katana_listenables_annotation;

/// Annotation to create a class to put together `Listenable`.
///
/// Define the class as follows and use build_runner for code generation.
///
/// `Listenable`をまとめるためのクラスを作成するアノテーション。
///
/// 下記のようにクラスを定義してbuild_runnerでコードジェネレーションを行ないます。
///
/// ```dart
/// @listenables
/// class ListenableValue with _$ListenableValue, ChangeNotifier {
///   factory ListenableValue({
///     required TextEditingController controller,
///     ValueNotifier<String> value,
///   }) = _ListenableValue;
/// }
/// ```
///
/// You can create an object with initial values based on the generated class.
///
/// 生成されたクラスを元に初期値を入れオブジェクトを作成できます。
///
/// ```dart
/// final listenable = ListenableValue(
///   controller: TextEditingController(text: "initial value"),
///   value: ValueNotifier("initial")
/// );
/// ```
///
/// Within the generated object, all classes inheriting from the defined `Listenable` are automatically monitored, and all are notified to the grouping object (here `ListenableValue`).
///
/// By using `addListener`, it is not necessary to add, remove, or dispose of multiple Listenable objects, and the code can be simplified.
///
/// 生成されたオブジェクト内では定義された`Listenable`を継承したクラスはすべて自動で監視され、すべてグループ化したオブジェクト（ここでは`ListenableValue`）に通知されます。
///
/// これを`addListener`することで複数のListenableオブジェクトをaddListener、removeListener、disposeする必要がなくコードが簡略化可能になります。
const listenables = Listenables();

/// Annotation to create a class to put together `Listenable`.
///
/// Define the class as follows and use build_runner for code generation.
///
/// `Listenable`をまとめるためのクラスを作成するアノテーション。
///
/// 下記のようにクラスを定義してbuild_runnerでコードジェネレーションを行ないます。
///
/// ```dart
/// @listenables
/// class ListenableValue with _$ListenableValue, ChangeNotifier {
///   factory ListenableValue({
///     required TextEditingController controller,
///     ValueNotifier<String> value,
///   }) = _ListenableValue;
/// }
/// ```
///
/// You can create an object with initial values based on the generated class.
///
/// 生成されたクラスを元に初期値を入れオブジェクトを作成できます。
///
/// ```dart
/// final listenable = ListenableValue(
///   controller: TextEditingController(text: "initial value"),
///   value: ValueNotifier("initial")
/// );
/// ```
///
/// Within the generated object, all classes inheriting from the defined `Listenable` are automatically monitored, and all are notified to the grouping object (here `ListenableValue`).
///
/// By using `addListener`, it is not necessary to add, remove, or dispose of multiple Listenable objects, and the code can be simplified.
///
/// 生成されたオブジェクト内では定義された`Listenable`を継承したクラスはすべて自動で監視され、すべてグループ化したオブジェクト（ここでは`ListenableValue`）に通知されます。
///
/// これを`addListener`することで複数のListenableオブジェクトをaddListener、removeListener、disposeする必要がなくコードが簡略化可能になります。
class Listenables {
  /// Annotation to create a class to put together `Listenable`.
  ///
  /// Define the class as follows and use build_runner for code generation.
  ///
  /// `Listenable`をまとめるためのクラスを作成するアノテーション。
  ///
  /// 下記のようにクラスを定義してbuild_runnerでコードジェネレーションを行ないます。
  ///
  /// ```dart
  /// @listenables
  /// class ListenableValue with _$ListenableValue, ChangeNotifier {
  ///   factory ListenableValue({
  ///     required TextEditingController controller,
  ///     ValueNotifier<String> value,
  ///   }) = _ListenableValue;
  /// }
  /// ```
  ///
  /// You can create an object with initial values based on the generated class.
  ///
  /// 生成されたクラスを元に初期値を入れオブジェクトを作成できます。
  ///
  /// ```dart
  /// final listenable = ListenableValue(
  ///   controller: TextEditingController(text: "initial value"),
  ///   value: ValueNotifier("initial")
  /// );
  /// ```
  ///
  /// Within the generated object, all classes inheriting from the defined `Listenable` are automatically monitored, and all are notified to the grouping object (here `ListenableValue`).
  ///
  /// By using `addListener`, it is not necessary to add, remove, or dispose of multiple Listenable objects, and the code can be simplified.
  ///
  /// 生成されたオブジェクト内では定義された`Listenable`を継承したクラスはすべて自動で監視され、すべてグループ化したオブジェクト（ここでは`ListenableValue`）に通知されます。
  ///
  /// これを`addListener`することで複数のListenableオブジェクトをaddListener、removeListener、disposeする必要がなくコードが簡略化可能になります。
  const Listenables();
}
