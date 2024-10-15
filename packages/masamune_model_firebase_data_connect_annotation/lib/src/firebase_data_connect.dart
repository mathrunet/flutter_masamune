part of '/masamune_model_firebase_data_connect_annotation.dart';

/// Annotation for use as a data scheme for FirebaseDataConnect.
///
/// Use with [CollectionModelPath] and [DocumentModelPath].
///
/// Use with `freezed`, etc.
///
/// Specify the root directory of DataConnect by specifying [dataConnectorDirPath].
///
/// By specifying [schemaDirPath], you can specify the directory where the schema files will be output.
///
/// By specifying [dartDirPath], you can specify the directory to output Dart files.
///
/// By specifying [dartPackage], you can specify the Dart package name.
///
/// FirebaseDataConnectのデータスキームとして利用するためのアノテーション。
///
/// [CollectionModelPath]や[DocumentModelPath]と共に利用してください。
///
/// `freezed`などと共に利用してください。
///
/// [dataConnectorDirPath]を指定してDataConnectのルートディレクトリを指定します。
///
/// [schemaDirPath]を指定することで、スキーマファイルを出力するディレクトリを指定できます。
///
/// [dartDirPath]を指定することで、Dart用のファイルを出力するディレクトリを指定できます。
///
/// [dartPackage]を指定することで、Dartのパッケージ名を指定できます。
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
/// Specify the root directory of DataConnect by specifying [dataConnectorRootDirPath].
///
/// By specifying [schemaDirPath], you can specify the directory where the schema files will be output.
///
/// By specifying [dartDirPath], you can specify the directory to output Dart files.
///
/// By specifying [dartPackage], you can specify the Dart package name.
///
/// FirebaseDataConnectのデータスキームとして利用するためのアノテーション。
///
/// [CollectionModelPath]や[DocumentModelPath]と共に利用してください。
///
/// `freezed`などと共に利用してください。
///
/// [dataConnectorRootDirPath]を指定してDataConnectのルートディレクトリを指定します。
///
/// [schemaDirPath]を指定することで、スキーマファイルを出力するディレクトリを指定できます。
///
/// [dartDirPath]を指定することで、Dart用のファイルを出力するディレクトリを指定できます。
///
/// [dartPackage]を指定することで、Dartのパッケージ名を指定できます。
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
  /// Specify the root directory of DataConnect by specifying [dataConnectorRootDirPath].
  ///
  /// By specifying [schemaDirPath], you can specify the directory where the schema files will be output.
  ///
  /// By specifying [dartDirPath], you can specify the directory to output Dart files.
  ///
  /// By specifying [dartPackage], you can specify the Dart package name.
  ///
  /// FirebaseDataConnectのデータスキームとして利用するためのアノテーション。
  ///
  /// [CollectionModelPath]や[DocumentModelPath]と共に利用してください。
  ///
  /// `freezed`などと共に利用してください。
  ///
  /// [dataConnectorRootDirPath]を指定してDataConnectのルートディレクトリを指定します。
  ///
  /// [schemaDirPath]を指定することで、スキーマファイルを出力するディレクトリを指定できます。
  ///
  /// [dartDirPath]を指定することで、Dart用のファイルを出力するディレクトリを指定できます。
  ///
  /// [dartPackage]を指定することで、Dartのパッケージ名を指定できます。
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
    this.dataConnectorRootDirPath = "firebase/dataconnect",
    this.dartDirPath = "lib/dataconnect",
    this.dartPackage = "connector",
  });

  /// Specify the root directory of DataConnect.
  ///
  /// DataConnectのルートディレクトリを指定します。
  final String dataConnectorRootDirPath;

  /// Specify the directory where the schema files will be output.
  ///
  /// スキーマファイルを出力するディレクトリを指定します。
  final String schemaDirPath;

  /// Specify the directory to output Dart files.
  ///
  /// Dart用のファイルを出力するディレクトリを指定します。
  final String dartDirPath;

  /// Specify the Dart package name.
  ///
  /// Dartのパッケージ名を指定します。
  final String dartPackage;
}
