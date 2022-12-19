part of masamune_annotation;

/// Create a query to retrieve form controllers.
///
/// Use with `freezed`, etc.
///
/// `static const form = _$(class name)FormQuery()` to get the query.
///
/// フォームコントローラーを取得するためのクエリーを作成します。
///
/// `freezed`などと共に利用してください。
///
/// `static const form = _$(クラス名)FormQuery()`でクエリーを取得します。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// class LoginValue with _$LoginValuee {
///   const factory LoginValue({
///     @Default("") String email,
///     @Default("") String password,
///   }) = _LoginValue;
///   const LoginValue._();
///
///   factory LoginValue.fromJson(Map<String, Object?> json) => _$LoginValueFromJson(json);
///
///   static const form = _$LoginValueFormQuery();
/// }
/// ```
///
/// * see https://pub.dev/packages/freezed
const formValue = FormValue();

/// Create a query to retrieve form controllers.
///
/// Use with `freezed`, etc.
///
/// `static const form = _$(class name)FormQuery()` to get the query.
///
/// フォームコントローラーを取得するためのクエリーを作成します。
///
/// `freezed`などと共に利用してください。
///
/// `static const form = _$(クラス名)FormQuery()`でクエリーを取得します。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// class LoginValue with _$LoginValuee {
///   const factory LoginValue({
///     @Default("") String email,
///     @Default("") String password,
///   }) = _LoginValue;
///   const LoginValue._();
///
///   factory LoginValue.fromJson(Map<String, Object?> json) => _$LoginValueFromJson(json);
///
///   static const form = _$LoginValueFormQuery();
/// }
/// ```
///
/// * see https://pub.dev/packages/freezed
class FormValue {
  /// Create a query to retrieve form controllers.
  ///
  /// Use with `freezed`, etc.
  ///
  /// `static const form = _$(class name)FormQuery()` to get the query.
  ///
  /// フォームコントローラーを取得するためのクエリーを作成します。
  ///
  /// `freezed`などと共に利用してください。
  ///
  /// `static const form = _$(クラス名)FormQuery()`でクエリーを取得します。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// class LoginValue with _$LoginValuee {
  ///   const factory LoginValue({
  ///     @Default("") String email,
  ///     @Default("") String password,
  ///   }) = _LoginValue;
  ///   const LoginValue._();
  ///
  ///   factory LoginValue.fromJson(Map<String, Object?> json) => _$LoginValueFromJson(json);
  ///
  ///   static const form = _$LoginValueFormQuery();
  /// }
  /// ```
  ///
  /// * see https://pub.dev/packages/freezed
  const FormValue();
}
