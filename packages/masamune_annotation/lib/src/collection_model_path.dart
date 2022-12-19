part of masamune_annotation;

/// Annotation to create a collection model.
///
/// Documentation is also created together.
///
/// Specify the path for the collection in [path].
///
/// Use with `freezed`, etc.
///
/// You can define a query to get the document model in `static const document = _$(class name)DocumentQuery()`.
///
/// You can define a query to retrieve the collection model in `static const collection = _$(class name)CollectionQuery()`.
///
/// コレクションモデルを作成するためのアノテーション。
///
/// ドキュメントも一緒に作成されます。
///
/// [path]にコレクション用のパスを指定します。
///
/// `freezed`などと共に利用してください。
///
/// `static const document = _$(クラス名)DocumentQuery()`にドキュメントモデルを取得するためのクエリを定義できます。
///
/// `static const collection = _$(クラス名)CollectionQuery()`にコレクションモデルを取得するためのクエリを定義できます。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("user")
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
///
///   static const collection = _$UserModelCollectionQuery();
/// }
/// ```
///
/// * see https://pub.dev/packages/freezed
class CollectionModelPath {
  /// Annotation to create a collection model.
  ///
  /// Specify the path for the collection in [path].
  ///
  /// Use with `freezed`, etc.
  ///
  /// You can define a query to get the document model in `static const document = _$(class name)DocumentQuery()`.
  ///
  /// You can define a query to retrieve the collection model in `static const collection = _$(class name)CollectionQuery()`.
  ///
  /// コレクションモデルを作成するためのアノテーション。
  ///
  /// [path]にコレクション用のパスを指定します。
  ///
  /// `freezed`などと共に利用してください。
  ///
  /// `static const document = _$(クラス名)DocumentQuery()`にドキュメントモデルを取得するためのクエリを定義できます。
  ///
  /// `static const collection = _$(クラス名)CollectionQuery()`にコレクションモデルを取得するためのクエリを定義できます。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @CollectionModelPath("user")
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
  ///
  ///   static const collection = _$UserModelCollectionQuery();
  /// }
  /// ```
  ///
  /// * see https://pub.dev/packages/freezed
  const CollectionModelPath(this.path);

  /// Path for collection.
  ///
  /// コレクション用のパス。
  final String path;
}
