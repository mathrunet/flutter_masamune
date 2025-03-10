part of '/masamune_annotation.dart';

/// Create a query to retrieve form controllers.
///
/// Use with `freezed`, etc.
///
/// `static const form = _$(class name)FormQuery()` to get the query.
///
/// If [autoDisposeWhenUnreferenced] is set to `true`, it will automatically dispose of [FormValue] when it is no longer referenced by any widget.
///
/// フォームコントローラーを取得するためのクエリーを作成します。
///
/// `freezed`などと共に利用してください。
///
/// `static const form = _$(クラス名)FormQuery()`でクエリーを取得します。
///
/// [autoDisposeWhenUnreferenced]を`true`にした場合、[FormValue]がどのウィジェットにも参照されなくなったときに自動的に破棄します。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// abstract class LoginValue with _$LoginValuee {
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
/// If [autoDisposeWhenUnreferenced] is set to `true`, it will automatically dispose of [FormValue] when it is no longer referenced by any widget.
///
/// フォームコントローラーを取得するためのクエリーを作成します。
///
/// `freezed`などと共に利用してください。
///
/// `static const form = _$(クラス名)FormQuery()`でクエリーを取得します。
///
/// [autoDisposeWhenUnreferenced]を`true`にした場合、[FormValue]がどのウィジェットにも参照されなくなったときに自動的に破棄します。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// abstract class LoginValue with _$LoginValuee {
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
  /// If [autoDisposeWhenUnreferenced] is set to `true`, it will automatically dispose of [FormValue] when it is no longer referenced by any widget.
  ///
  /// フォームコントローラーを取得するためのクエリーを作成します。
  ///
  /// `freezed`などと共に利用してください。
  ///
  /// `static const form = _$(クラス名)FormQuery()`でクエリーを取得します。
  ///
  /// [autoDisposeWhenUnreferenced]を`true`にした場合、[FormValue]がどのウィジェットにも参照されなくなったときに自動的に破棄します。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// abstract class LoginValue with _$LoginValuee {
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
  const FormValue({
    this.autoDisposeWhenUnreferenced = true,
  });

  /// Returns `true` if [ControllerGroup] should be automatically destroyed when it is no longer referenced by any widget.
  ///
  /// [ControllerGroup]がどのウィジェットにも参照されなくなったときに自動的に破棄する場合`true`を返します。
  final bool autoDisposeWhenUnreferenced;
}
