part of katana_prefs_annotation;

/// Annotation to define values to be handled in Shared Preferences and to enable type-safe storage and retrieval.
///
/// Define the class as follows and use build_runner for code generation.
///
/// Shared Preferencesで取り扱う値を定義しタイプセーフに保存・取得を可能にするためのアノテーション。
///
/// 下記のようにクラスを定義してbuild_runnerでコードジェネレーションを行ないます。
///
/// ```dart
/// @prefs
/// class PrefsValue with _$PrefsValue, ChangeNotifier {
///   factory PrefsValue({
///     String? userToken,
///     @Default(1.0) double valumeSetting,
///   }) = _PrefsValue;
/// }
/// ```
///
/// You can create an object with initial values based on the generated class.
///
/// 生成されたクラスを元に初期値を入れオブジェクトを作成できます。
///
/// ```dart
/// final prefs = PrefsValue(
///   userToken: "abcdefg...",
///   valumeSetting: 0.5,
/// );
/// ```
///
/// The generated objects have the methods `get()` and `set()` available for each value. Execution of each method allows the value to be retrieved and stored.
///
/// It is also possible to monitor value updates when each value's `set()` is executed by `addListener` on the generated object itself.
///
/// 生成されたオブジェクトは各値で`get()`と`set()`のメソッドが利用可能です。それぞれのメソッドを実行すると値の取得と保存が可能になります。
///
/// また生成されたオブジェクト自体を`addListener`することで各値の`set()`が実行されたときに値の更新を監視することが可能です。
///
/// ```dart
/// final userToken = prefs.userToken.get();
/// await prefs.userToken.set("new user token");
/// ```
const prefs = Prefs();

/// Annotation to define values to be handled in Shared Preferences and to enable type-safe storage and retrieval.
///
/// Define the class as follows and use build_runner for code generation.
///
/// Shared Preferencesで取り扱う値を定義しタイプセーフに保存・取得を可能にするためのアノテーション。
///
/// 下記のようにクラスを定義してbuild_runnerでコードジェネレーションを行ないます。
///
/// ```dart
/// @prefs
/// class PrefsValue with _$PrefsValue, ChangeNotifier {
///   factory PrefsValue({
///     String? userToken,
///     @Default(1.0) double valumeSetting,
///   }) = _PrefsValue;
/// }
/// ```
///
/// You can create an object with initial values based on the generated class.
///
/// 生成されたクラスを元に初期値を入れオブジェクトを作成できます。
///
/// ```dart
/// final prefs = PrefsValue(
///   userToken: "abcdefg...",
///   valumeSetting: 0.5,
/// );
/// ```
///
/// The generated objects have the methods `get()` and `set()` available for each value. Execution of each method allows the value to be retrieved and stored.
///
/// It is also possible to monitor value updates when each value's `set()` is executed by `addListener` on the generated object itself.
///
/// 生成されたオブジェクトは各値で`get()`と`set()`のメソッドが利用可能です。それぞれのメソッドを実行すると値の取得と保存が可能になります。
///
/// また生成されたオブジェクト自体を`addListener`することで各値の`set()`が実行されたときに値の更新を監視することが可能です。
///
/// ```dart
/// final userToken = prefs.userToken.get();
/// await prefs.userToken.set("new user token");
/// ```
class Prefs {
  /// Annotation to define values to be handled in Shared Preferences and to enable type-safe storage and retrieval.
  ///
  /// Define the class as follows and use build_runner for code generation.
  ///
  /// Shared Preferencesで取り扱う値を定義しタイプセーフに保存・取得を可能にするためのアノテーション。
  ///
  /// 下記のようにクラスを定義してbuild_runnerでコードジェネレーションを行ないます。
  ///
  /// ```dart
  /// @prefs
  /// class PrefsValue with _$PrefsValue, ChangeNotifier {
  ///   factory PrefsValue({
  ///     String? userToken,
  ///     @Default(1.0) double valumeSetting,
  ///   }) = _PrefsValue;
  /// }
  /// ```
  ///
  /// You can create an object with initial values based on the generated class.
  ///
  /// 生成されたクラスを元に初期値を入れオブジェクトを作成できます。
  ///
  /// ```dart
  /// final prefs = PrefsValue(
  ///   userToken: "abcdefg...",
  ///   valumeSetting: 0.5,
  /// );
  /// ```
  ///
  /// The generated objects have the methods `get()` and `set()` available for each value. Execution of each method allows the value to be retrieved and stored.
  ///
  /// It is also possible to monitor value updates when each value's `set()` is executed by `addListener` on the generated object itself.
  ///
  /// 生成されたオブジェクトは各値で`get()`と`set()`のメソッドが利用可能です。それぞれのメソッドを実行すると値の取得と保存が可能になります。
  ///
  /// また生成されたオブジェクト自体を`addListener`することで各値の`set()`が実行されたときに値の更新を監視することが可能です。
  ///
  /// ```dart
  /// final userToken = prefs.userToken.get();
  /// await prefs.userToken.set("new user token");
  /// ```
  const Prefs();
}
