part of masamune_annotation;

/// Annotation for creating a documentation model.
///
/// Specify the path for the document in [path].
///
/// Use with `freezed`, etc.
///
/// You can define a query to get the document model in `static const document = _$(class name)DocumentQuery()`.
///
/// ドキュメントモデルを作成するためのアノテーション。
///
/// [path]にドキュメント用のパスを指定します。
///
/// `freezed`などと共に利用してください。
///
/// `static const document = _$(クラス名)DocumentQuery()`にドキュメントモデルを取得するためのクエリを定義できます。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @DocumentModelPath("user/doc")
/// class UserModel with _$UserModel {
///   const factory UserModel({
///     @Default("") String name,
///     @Default("") String description,
///   }) = _UserModel;
///   const UserModel._();
///
///   factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);
///
///   static const document = _$UserModelDocumentQuery();
/// }
/// ```
///
/// * see https://pub.dev/packages/freezed
class DocumentModelPath {
  /// Annotation for creating a documentation model.
  ///
  /// Specify the path for the document in [path].
  ///
  /// Use with `freezed`, etc.
  ///
  /// You can define a query to get the document model in `static const document = _$(class name)DocumentQuery()`.
  ///
  /// ドキュメントモデルを作成するためのアノテーション。
  ///
  /// [path]にドキュメント用のパスを指定します。
  ///
  /// `freezed`などと共に利用してください。
  ///
  /// `static const document = _$(クラス名)DocumentQuery()`にドキュメントモデルを取得するためのクエリを定義できます。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @DocumentModelPath("user/doc")
  /// class UserModel with _$UserModel {
  ///   const factory UserModel({
  ///     @Default("") String name,
  ///     @Default("") String description,
  ///   }) = _UserModel;
  ///   const UserModel._();
  ///
  ///   factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);
  ///
  ///   static const document = _$UserModelDocumentQuery();
  /// }
  /// ```
  ///
  /// * see https://pub.dev/packages/freezed
  const DocumentModelPath(this.path);

  /// Path for documentation.
  ///
  /// ドキュメント用のパス。
  final String path;
}
