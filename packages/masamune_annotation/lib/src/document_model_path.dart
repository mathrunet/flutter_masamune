part of '/masamune_annotation.dart';

/// Annotation for creating a documentation model.
///
/// Specify the path for the document in [path].
///
/// Use with `freezed`, etc.
///
/// You can define a query to get the document model in `static const document = _$(class name)DocumentQuery()`.
///
/// You can duplicate the same data to another path by defining a path in [mirror].
///
/// You can specify a default model adapter by specifying [adapter].
///
/// You can define access rights to the model by specifying [permission] or [mirrorPermission].
///
/// Each data can be retrieved with `document.mirror` and can be `loaded` and `saved` in the same way.
///
/// In addition, by using `saveSync` and `deleteSync`, data can be saved and deleted synchronously.
///
/// It can be used to achieve relationships in NoSQL databases with follow/follow implementations.
///
/// ドキュメントモデルを作成するためのアノテーション。
///
/// [path]にドキュメント用のパスを指定します。
///
/// `freezed`などと共に利用してください。
///
/// `static const document = _$(クラス名)DocumentQuery()`にドキュメントモデルを取得するためのクエリを定義できます。
///
/// [mirror]にパスを定義すると別のパスに同じデータを複製することができます。
///
/// [adapter]を指定することでデフォルトのモデルアダプターを指定することができます。
///
/// [permission]や[mirrorPermission]を指定するとモデルへのアクセス権を定義することができます。
///
/// それぞれのデータは`document.mirror`で取得でき、同じように`load`や`save`ができるようになります。
///
/// さらに`saveSync`や`deleteSync`を利用することで、同期的にデータの保存や削除が行なえます。
///
/// フォロー・フォロワーの実装でNoSQLデータベースにおけるリレーションを実現するために利用することが可能です。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @DocumentModelPath("user/doc")
/// abstract class UserModel with _$UserModel {
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
  /// You can duplicate the same data to another path by defining a path in [mirror].
  ///
  /// You can specify a default model adapter by specifying [adapter].
  ///
  /// You can define access rights to the model by specifying [permission] or [mirrorPermission].
  ///
  /// Each data can be retrieved with `document.mirror` and can be `loaded` and `saved` in the same way.
  ///
  /// In addition, by using `saveSync` and `deleteSync`, data can be saved and deleted synchronously.
  ///
  /// It can be used to achieve relationships in NoSQL databases with follow/follow implementations.
  ///
  /// ドキュメントモデルを作成するためのアノテーション。
  ///
  /// [path]にドキュメント用のパスを指定します。
  ///
  /// `freezed`などと共に利用してください。
  ///
  /// `static const document = _$(クラス名)DocumentQuery()`にドキュメントモデルを取得するためのクエリを定義できます。
  ///
  /// [mirror]にパスを定義すると別のパスに同じデータを複製することができます。
  ///
  /// [adapter]を指定することでデフォルトのモデルアダプターを指定することができます。
  ///
  /// [permission]や[mirrorPermission]を指定するとモデルへのアクセス権を定義することができます。
  ///
  /// それぞれのデータは`document.mirror`で取得でき、同じように`load`や`save`ができるようになります。
  ///
  /// さらに`saveSync`や`deleteSync`を利用することで、同期的にデータの保存や削除が行なえます。
  ///
  /// フォロー・フォロワーの実装でNoSQLデータベースにおけるリレーションを実現するために利用することが可能です。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @DocumentModelPath("user/doc")
  /// abstract class UserModel with _$UserModel {
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
  const DocumentModelPath(
    this.path, {
    this.mirror,
    this.adapter,
    this.endpoint,
    this.permission,
    this.mirrorPermission,
    this.docsPath = "documents/docs",
    this.comment,
  });

  /// Path for documentation.
  ///
  /// ドキュメント用のパス。
  final String path;

  /// Path for mirror documents.
  ///
  /// ミラードキュメント用のパス。
  final String? mirror;

  /// Specifies the default adapter.
  ///
  /// デフォルトのアダプターを指定します。
  final Object? adapter;

  /// Endpoints for accessing the API.
  ///
  /// APIにアクセスするためのエンドポイント。
  final String? endpoint;

  /// The path (relative path) to which the document will be generated.
  ///
  /// ドキュメントを生成する際の生成先のパス（相対パス）。
  final String docsPath;

  /// Comments to be assigned to the collection.
  ///
  /// コレクションに付与するコメント。
  final String? comment;

  /// List to define permissions.
  ///
  /// If [Null], all are allowed; if [List] is empty, all are denied.
  ///
  /// If `firebase/firestore.rules` exists, Firestore rules are automatically generated when `build_runner` is run.
  ///
  /// パーミッションを定義するためのリスト。
  ///
  /// [Null]の場合はすべて許可となり、[List]が空の場合はすべて拒否となります。
  ///
  /// `firebase/firestore.rules`が存在している場合、`build_runner`実行時Firestoreのルールを自動生成します。
  final List<ModelPermissionQuery>? permission;

  /// List to define permissions for [mirror].
  ///
  /// If [Null], all are allowed; if [List] is empty, all are denied.
  /// Even in the case of [Null], if [permission] is not [Null], it takes precedence.
  ///
  /// If `firebase/firestore.rules` exists, Firestore rules are automatically generated when `build_runner` is run.
  ///
  /// [mirror]用のパーミッションを定義するためのリスト。
  ///
  /// [Null]の場合はすべて許可となり、[List]が空の場合はすべて拒否となります。
  /// また、[Null]の場合でも[permission]が[Null]でない場合はそちらが優先されます。
  ///
  /// `firebase/firestore.rules`が存在している場合、`build_runner`実行時Firestoreのルールを自動生成します。
  final List<ModelPermissionQuery>? mirrorPermission;
}
