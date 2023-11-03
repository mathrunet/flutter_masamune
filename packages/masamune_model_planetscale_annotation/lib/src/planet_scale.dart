part of masamune_model_planetscale_annotation;

/// Annotation to make Masamune's model available to PlanetScale.
///
/// Use with `@CollectionModelPath`, `freezed`, etc.
/// `@CollectionModelPath` is required and `@DocumentModelPath` cannot be used.
///
/// Please specify the path so that it is the first layer in `@CollectionModelPath`.
///
/// Also, be sure to use [PlanetScalePrimaryField] to specify the primary key.
///
/// MasamuneのモデルをPlanetScaleで利用できるようにするためのアノテーション。
///
/// `@CollectionModelPath`や`freezed`などと共に利用してください。
/// `@CollectionModelPath`は必須です。`@DocumentModelPath`は使用できません。
///
///　`@CollectionModelPath`にはそのパスが第1階層になるように指定してください。
///
/// また、必ず[PlanetScalePrimaryField]を利用してプライマリーキーを指定してください。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @planetScale
/// @CollectionModelPath("user")
/// class UserModel with _$UserModel {
///   const factory UserModel({
///     @planetScalePrimaryField required String id,
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
/// * see https://pub.dev/packages/masamune
/// * see https://pub.dev/packages/freezed
const planetScale = PlanetScale();

/// Annotation to make Masamune's model available to PlanetScale.
///
/// Use with `@CollectionModelPath`, `freezed`, etc.
/// `@CollectionModelPath` is required and `@DocumentModelPath` cannot be used.
///
/// Please specify the path so that it is the first layer in `@CollectionModelPath`.
///
/// Also, be sure to use [PlanetScalePrimaryField] to specify the primary key.
///
/// MasamuneのモデルをPlanetScaleで利用できるようにするためのアノテーション。
///
/// `@CollectionModelPath`や`freezed`などと共に利用してください。
/// `@CollectionModelPath`は必須です。`@DocumentModelPath`は使用できません。
///
///　`@CollectionModelPath`にはそのパスが第1階層になるように指定してください。
///
/// また、必ず[PlanetScalePrimaryField]を利用してプライマリーキーを指定してください。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @planetScale
/// @CollectionModelPath("user")
/// class UserModel with _$UserModel {
///   const factory UserModel({
///     @planetScalePrimaryField required String id,
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
/// * see https://pub.dev/packages/masamune
/// * see https://pub.dev/packages/freezed
class PlanetScale {
  /// Annotation to make Masamune's model available to PlanetScale.
  ///
  /// Use with `@CollectionModelPath`, `freezed`, etc.
  /// `@CollectionModelPath` is required and `@DocumentModelPath` cannot be used.
  ///
  /// Please specify the path so that it is the first layer in `@CollectionModelPath`.
  ///
  /// Also, be sure to use [PlanetScalePrimaryField] to specify the primary key.
  ///
  /// MasamuneのモデルをPlanetScaleで利用できるようにするためのアノテーション。
  ///
  /// `@CollectionModelPath`や`freezed`などと共に利用してください。
  /// `@CollectionModelPath`は必須です。`@DocumentModelPath`は使用できません。
  ///
  ///　`@CollectionModelPath`にはそのパスが第1階層になるように指定してください。
  ///
  /// また、必ず[PlanetScalePrimaryField]を利用してプライマリーキーを指定してください。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @planetScale
  /// @CollectionModelPath("user")
  /// class UserModel with _$UserModel {
  ///   const factory UserModel({
  ///     @planetScalePrimaryField required String id,
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
  /// * see https://pub.dev/packages/masamune
  /// * see https://pub.dev/packages/freezed
  const PlanetScale({
    this.modelDirPath = "firebase/functions/src/models",
    this.prismaSchemaFilePath = "firebase/functions/prisma/schema.prisma",
  });

  /// Specify the path to the directory that contains the files for the Typescript model.
  ///
  /// Typescriptのモデル用のファイルを格納するディレクトリへのパスを指定します。
  final String modelDirPath;

  /// Specifies the file path for the Prisma schema.
  ///
  /// Prismaのスキーマの用のファイルパスを指定します。
  final String prismaSchemaFilePath;
}
