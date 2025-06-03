part of "/masamune_annotation.dart";

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
/// You can duplicate the same data to another path by defining a path in [mirror].
///
/// You can specify a default model adapter by specifying [adapter].
///
/// You can define access rights to the model by specifying [permission] or [mirrorPermission].
///
/// You can define conditional queries to the database by specifying [query] or [mirrorQuery].
///
/// Each data can be retrieved with `document.mirror` or `collection.mirror` and can be `loaded` or `saved` in the same way.
///
/// In addition, by using `saveSync` and `deleteSync`, data can be saved and deleted synchronously.
///
/// It can be used to achieve relationships in NoSQL databases with follow/follow implementations.
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
/// [mirror]にパスを定義すると別のパスに同じデータを複製することができます。
///
/// [adapter]を指定することでデフォルトのモデルアダプターを指定することができます。
///
/// [permission]や[mirrorPermission]を指定するとモデルへのアクセス権を定義することができます。
///
/// [query]や[mirrorQuery]を指定することでデータベースへの条件付きクエリを定義することができます。
///
/// それぞれのデータは`document.mirror`や`collection.mirror`で取得でき、同じように`load`や`save`ができるようになります。
///
/// さらに`saveSync`や`deleteSync`を利用することで、同期的にデータの保存や削除が行なえます。
///
/// フォロー・フォロワーの実装でNoSQLデータベースにおけるリレーションを実現するために利用することが可能です。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("user")
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
  /// You can duplicate the same data to another path by defining a path in [mirror].
  ///
  /// You can specify a default model adapter by specifying [adapter].
  ///
  /// You can define access rights to the model by specifying [permission] or [mirrorPermission].
  ///
  /// You can define conditional queries to the database by specifying [query] or [mirrorQuery].
  ///
  /// Each data can be retrieved with `document.mirror` or `collection.mirror` and can be `loaded` or `saved` in the same way.
  ///
  /// In addition, by using `saveSync` and `deleteSync`, data can be saved and deleted synchronously.
  ///
  /// It can be used to achieve relationships in NoSQL databases with follow/follow implementations.
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
  /// [mirror]にパスを定義すると別のパスに同じデータを複製することができます。
  ///
  /// [adapter]を指定することでデフォルトのモデルアダプターを指定することができます。
  ///
  /// [permission]や[mirrorPermission]を指定するとモデルへのアクセス権を定義することができます。
  ///
  /// [query]や[mirrorQuery]を指定することでデータベースへの条件付きクエリを定義することができます。
  ///
  /// それぞれのデータは`document.mirror`や`collection.mirror`で取得でき、同じように`load`や`save`ができるようになります。
  ///
  /// さらに`saveSync`や`deleteSync`を利用することで、同期的にデータの保存や削除が行なえます。
  ///
  /// フォロー・フォロワーの実装でNoSQLデータベースにおけるリレーションを実現するために利用することが可能です。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @CollectionModelPath("user")
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
  ///
  ///   static const collection = _$UserModelCollectionQuery();
  /// }
  /// ```
  ///
  /// * see https://pub.dev/packages/freezed
  const CollectionModelPath(
    this.path, {
    this.mirror,
    this.adapter,
    this.endpoint,
    this.permission,
    this.mirrorPermission,
    this.docsPath = "documents/docs",
    this.comment,
    this.query,
    this.mirrorQuery,
  });

  /// Path for collection.
  ///
  /// コレクション用のパス。
  final String path;

  /// Path for mirror collection.
  ///
  /// ミラーコレクション用のパス。
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

  /// A list to define queries to the database.
  ///
  /// Only queries to the RDB with conditions defined here are allowed.
  /// If no conditions are specified, it is always permitted.
  ///
  /// If you use FirebaseDataConnect, this specification is required; if you use Firestore, RealtimeDatabase, or LocalDatabase, use it to restrict queries.
  ///
  /// データベースへのクエリを定義するためのリスト。
  ///
  /// RDBへの条件を指定したクエリはこちらで定義したものしか許可されません。
  /// 条件を指定しない場合は、常時許可となります。
  ///
  /// FirebaseDataConnectを利用する場合、こちらの指定は必須となります。FirestoreやRealtimeDatabase、LocalDatabaseを利用する場合、クエリーを制限するために利用します。
  final List<ModelDatabaseQueryGroup>? query;

  /// List to define queries to the database for [mirror].
  ///
  /// Only queries to the RDB with conditions defined here are allowed.
  /// If no conditions are specified, it is always permitted.
  ///
  /// If you use FirebaseDataConnect, this specification is required; if you use Firestore, RealtimeDatabase, or LocalDatabase, use it to restrict queries.
  ///
  /// [mirror]用のデータベースへのクエリを定義するためのリスト。
  ///
  /// RDBへの条件を指定したクエリはこちらで定義したものしか許可されません。
  /// 条件を指定しない場合は、常時許可となります。
  ///
  /// FirebaseDataConnectを利用する場合、こちらの指定は必須となります。FirestoreやRealtimeDatabase、LocalDatabaseを利用する場合、クエリーを制限するために利用します。
  final List<ModelDatabaseQueryGroup>? mirrorQuery;
}
