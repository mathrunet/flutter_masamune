part of '/masamune_model_firebase_data_connect_annotation.dart';

/// Annotation for use as a data scheme for FirebaseDataConnect.
///
/// Use with [CollectionModelPath] and [DocumentModelPath].
///
/// Use with `freezed`, etc.
///
/// By specifying [schemeDirPath], you can specify the directory where the schema files will be output.
///
/// By specifying [connectorDirPath], you can specify a directory to output connector files.
///
/// FirebaseDataConnectのデータスキームとして利用するためのアノテーション。
///
/// [CollectionModelPath]や[DocumentModelPath]と共に利用してください。
///
/// `freezed`などと共に利用してください。
///
/// [schemeDirPath]を指定することで、スキーマファイルを出力するディレクトリを指定できます。
///
/// [connectorDirPath]を指定することで、コネクタファイルを出力するディレクトリを指定できます。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @firebaseDataConnect
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
const firebaseDataConnect = FirebaseDataConnect();

/// Annotation for use as a data scheme for FirebaseDataConnect.
///
/// Use with [CollectionModelPath] and [DocumentModelPath].
///
/// Use with `freezed`, etc.
///
/// By specifying [schemaDirPath], you can specify the directory where the schema files will be output.
///
/// By specifying [connectorDirPath], you can specify a directory to output connector files.
///
/// FirebaseDataConnectのデータスキームとして利用するためのアノテーション。
///
/// [CollectionModelPath]や[DocumentModelPath]と共に利用してください。
///
/// `freezed`などと共に利用してください。
///
/// [schemaDirPath]を指定することで、スキーマファイルを出力するディレクトリを指定できます。
///
/// [connectorDirPath]を指定することで、コネクタファイルを出力するディレクトリを指定できます。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @firebaseDataConnect
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
class FirebaseDataConnect {
  /// Annotation for use as a data scheme for FirebaseDataConnect.
  ///
  /// Use with [CollectionModelPath] and [DocumentModelPath].
  ///
  /// Use with `freezed`, etc.
  ///
  /// By specifying [schemaDirPath], you can specify the directory where the schema files will be output.
  ///
  /// By specifying [connectorDirPath], you can specify a directory to output connector files.
  ///
  /// FirebaseDataConnectのデータスキームとして利用するためのアノテーション。
  ///
  /// [CollectionModelPath]や[DocumentModelPath]と共に利用してください。
  ///
  /// `freezed`などと共に利用してください。
  ///
  /// [schemaDirPath]を指定することで、スキーマファイルを出力するディレクトリを指定できます。
  ///
  /// [connectorDirPath]を指定することで、コネクタファイルを出力するディレクトリを指定できます。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @firebaseDataConnect
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
  const FirebaseDataConnect({
    this.schemaDirPath = "firebase/dataconnect/schema",
    this.connectorDirPath = "firebase/dataconnect/default-connector",
  });

  /// Specify the directory where the schema files will be output.
  ///
  /// スキーマファイルを出力するディレクトリを指定します。
  final String schemaDirPath;

  /// Specify a directory to output connector files.
  ///
  /// コネクタファイルを出力するディレクトリを指定します。
  final String connectorDirPath;
}
