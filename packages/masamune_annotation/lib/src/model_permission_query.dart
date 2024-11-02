part of '/masamune_annotation.dart';

/// {@template model_permission_query_type}
/// Specifies the permission type for validation.
///
/// バリデーション用のパーミッションタイプを指定します。
/// {@endtemplate}
enum ModelPermissionQueryType {
  /// {@template model_permission_query_type_allow_read}
  /// Allow all reads (documents and collections).
  ///
  /// 読み込み（ドキュメントおよびコレクション）をすべて許可します。
  /// {@endtemplate}
  allowRead,

  /// {@template model_permission_query_type_allow_write}
  /// Allows all writing (creating, updating, and deleting documents).
  ///
  /// 書き込み（ドキュメントの作成、更新、削除）をすべて許可します。
  /// {@endtemplate}
  allowWrite,

  /// {@template model_permission_query_type_allow_read_document}
  /// Allows reading (documents).
  ///
  /// If [allowRead] is specified, it takes precedence.
  ///
  /// 読み込み（ドキュメントのみ）を許可します。
  ///
  /// [allowRead]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  allowReadDocument,

  /// {@template model_permission_query_type_allow_read_collection}
  /// Allows reading (collections only).
  ///
  /// If [allowRead] is specified, it takes precedence.
  ///
  /// 読み込み（コレクションのみ）を許可します。
  ///
  /// [allowRead]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  allowReadCollection,

  /// {@template model_permission_query_type_allow_write}
  /// Allows only document creation.
  ///
  /// If [allowWrite] is specified, it takes precedence.
  ///
  /// ドキュメントの作成のみを許可します。
  ///
  /// [allowWrite]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  allowCreate,

  /// {@template model_permission_query_type_allow_update}
  /// Allows only document updates.
  ///
  /// If [allowWrite] is specified, it takes precedence.
  ///
  /// ドキュメントの更新のみを許可します。
  ///
  /// [allowWrite]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  allowUpdate,

  /// {@template model_permission_query_type_allow_delete}
  /// Allows only document deletion.
  ///
  /// If [allowWrite] is specified, it takes precedence.
  ///
  /// ドキュメントの削除のみを許可します。
  ///
  /// [allowWrite]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  allowDelete;
}

/// {@template model_permission_query_user_type}
/// Specify the target user for which you want to specify [ModelPermissionQueryType].
///
/// [ModelPermissionQueryType]を指定する対象のユーザーを指定します。
/// {@endtemplate}
enum ModelPermissionQueryUserType {
  /// {@template model_permission_query_user_type_all_users}
  /// All users.
  ///
  /// すべてのユーザー。
  /// {@endtemplate}
  allUsers,

  /// {@template model_permission_query_user_type_auth_users}
  /// Authenticated users.
  ///
  /// If [allUsers] is specified, it takes precedence.
  ///
  /// 認証済みのユーザー。
  ///
  /// [allUsers]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  authUsers,

  /// {@template model_permission_query_user_type_user_from_path_index}
  /// An authenticated user whose user ID matches the dynamic value specified by `:key` in the document or collection path and the user ID authenticated on the app.
  ///
  /// If [Null] is specified, a comparison with the document ID is performed.
  ///
  /// If [allUsers] or [authUsers] is specified, it takes precedence.
  ///
  /// [userFromData] can be specified at the same time.
  ///
  /// 認証済みユーザーのうち、ドキュメントやコレクションのパス中の`:key`で指定する動的な値とアプリ上で認証しているユーザーIDが一致するユーザー。
  ///
  /// [Null]を指定するとドキュメントIDとの比較が行われます。
  ///
  /// [allUsers]や[authUsers]が指定されている場合はそちらが優先されます。
  ///
  /// [userFromData]とは同時に指定可能です。
  ///
  /// ```
  /// // Path definition
  /// /collection/:document_id
  /// // Actual path
  /// /collection/ABCDEFG
  /// // Definition
  /// ModelPermissionQueryUserType.userFromPath("document_id")
  /// -> Allow users whose user ID is `ABCDEFG
  /// ```
  /// {@endtemplate}
  userFromPath,

  /// {@template model_permission_query_user_type_user_from_data}
  /// An authenticated user whose user ID matches the value of a field with `key` in the document to be read or written and the user ID authenticated on the app.
  ///
  /// [Null] or `@uid` will cause a comparison with the document ID.
  ///
  /// If [allUsers] or [authUsers] is specified, it takes precedence.
  ///
  /// [userFromPath] can be specified at the same time.
  ///
  /// 認証済みユーザーのうち、読み込みや書き込み対象のドキュメント中に`key`を持つフィールドの値ととアプリ上で認証しているユーザーIDが一致するユーザー。
  ///
  /// [Null]もしくは`@uid`を指定するとドキュメントIDとの比較が行われます。
  ///
  /// [allUsers]や[authUsers]が指定されている場合はそちらが優先されます。
  ///
  /// [userFromPath]とは同時に指定可能です。
  ///
  /// ```
  /// // Document data
  /// {
  ///   "user": "ABCDEFG",
  ///   "name": "ABCD",
  ///   "age": 20,
  /// }
  /// // Definition
  /// ModelPermissionQueryUserType.userFromData("user")
  /// -> Allow users whose user ID is `ABCDEFG
  /// ```
  /// {@endtemplate}
  userFromData;
}

/// {@template model_permission_query}
/// Define a query to validate data permissions.
///
/// If a list exists on [CollectionModelPath.permission] or [DocumentModelPath.permission], permissions are basically specified in white list format.
///
/// If `firebase/firestore.rules` exists, generate rules for Firestore.
///
/// データのパーミッションを検証するクエリを定義します。
///
/// [CollectionModelPath.permission]や[DocumentModelPath.permission]上のでリストが存在している場合、基本的にはホワイトリスト形式でパーミッションが指定されます。
///
/// `firebase/firestore.rules`が存在している場合、Firestore用のルールを生成します。
///
/// [permission]や[user]を指定して許可をする属性を指定できます。
/// {@endtemplate}
abstract class ModelPermissionQuery {
  /// {@macro model_permission_query}
  const ModelPermissionQuery();

  /// {@macro model_permission_query_type}
  ModelPermissionQueryType get permission;

  /// {@macro model_permission_query_user_type}
  ModelPermissionQueryUserType get user;

  /// Specify the target key to be used in [ModelPermissionQueryUserType].
  ///
  /// [ModelPermissionQueryUserType]で用いる対象のキーを指定します。
  Object? get key;
}
