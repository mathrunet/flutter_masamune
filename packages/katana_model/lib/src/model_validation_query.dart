part of '/katana_model.dart';

/// {@template model_validation_query_permission_type}
/// Specifies the permission type for validation.
///
/// バリデーション用のパーミッションタイプを指定します。
/// {@endtemplate}
enum ModelValidationQueryPermissionType {
  /// {@template model_validation_query_permission_type_allow_read}
  /// Allow all reads (documents and collections).
  ///
  /// 読み込み（ドキュメントおよびコレクション）をすべて許可します。
  /// {@endtemplate}
  allowRead,

  /// {@template model_validation_query_permission_type_allow_write}
  /// Allows all writing (creating, updating, and deleting documents).
  ///
  /// 書き込み（ドキュメントの作成、更新、削除）をすべて許可します。
  /// {@endtemplate}
  allowWrite,

  /// {@template model_validation_query_permission_type_allow_read_document}
  /// Allows reading (documents).
  ///
  /// If [allowRead] is specified, it takes precedence.
  ///
  /// 読み込み（ドキュメントのみ）を許可します。
  ///
  /// [allowRead]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  allowReadDocument,

  /// {@template model_validation_query_permission_type_allow_read_collection}
  /// Allows reading (collections only).
  ///
  /// If [allowRead] is specified, it takes precedence.
  ///
  /// 読み込み（コレクションのみ）を許可します。
  ///
  /// [allowRead]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  allowReadCollection,

  /// {@template model_validation_query_permission_type_allow_write}
  /// Allows only document creation.
  ///
  /// If [allowWrite] is specified, it takes precedence.
  ///
  /// ドキュメントの作成のみを許可します。
  ///
  /// [allowWrite]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  allowCreate,

  /// {@template model_validation_query_permission_type_allow_update}
  /// Allows only document updates.
  ///
  /// If [allowWrite] is specified, it takes precedence.
  ///
  /// ドキュメントの更新のみを許可します。
  ///
  /// [allowWrite]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  allowUpdate,

  /// {@template model_validation_query_permission_type_allow_delete}
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

/// {@template model_validation_query_user_type}
/// Specify the target user for which you want to specify [ModelValidationQueryPermissionType].
///
/// [ModelValidationQueryPermissionType]を指定する対象のユーザーを指定します。
/// {@endtemplate}
enum ModelValidationQueryUserType {
  /// {@template model_validation_query_user_type_all_users}
  /// All users.
  ///
  /// すべてのユーザー。
  /// {@endtemplate}
  allUsers,

  /// {@template model_validation_query_user_type_auth_users}
  /// Authenticated users.
  ///
  /// If [DatabaseValidator.onRetrieveUserId] does not return [Null], this is the user.
  ///
  /// If [allUsers] is specified, it takes precedence.
  ///
  /// 認証済みのユーザー。
  ///
  /// [DatabaseValidator.onRetrieveUserId]が[Null]を返さない場合このユーザーとなります。
  ///
  /// [allUsers]が指定されている場合はそちらが優先されます。
  /// {@endtemplate}
  authUsers,

  /// {@template model_validation_query_user_type_client_user}
  /// Authenticated users who are currently authenticated on the app.
  ///
  /// Authentication on the app runtime is synonymous with [authUsers].
  ///
  /// If [allUsers] or [authUsers] is specified, it takes precedence.
  ///
  /// Both [userFromPath] and [userFromData] can be specified at the same time.
  ///
  /// 認証済みユーザーのうち、現在アプリ上で認証しているユーザー。
  ///
  /// アプリランタイム上での認証だと[authUsers]と同義になります。
  ///
  /// [allUsers]や[authUsers]が指定されている場合はそちらが優先されます。
  ///
  /// [userFromPath]と[userFromData]とは同時に指定可能です。
  /// {@endtemplate}
  clientUser,

  /// {@template model_validation_query_user_type_user_from_path}
  /// An authenticated user whose user ID matches the dynamic value specified by `:key` in the document or collection path and the user ID authenticated on the app.
  ///
  /// If [allUsers] or [authUsers] is specified, it takes precedence.
  ///
  /// Both [clientUser] and [userFromData] can be specified at the same time.
  ///
  /// 認証済みユーザーのうち、ドキュメントやコレクションのパス中の`:key`で指定する動的な値とアプリ上で認証しているユーザーIDが一致するユーザー。
  ///
  /// [allUsers]や[authUsers]が指定されている場合はそちらが優先されます。
  ///
  /// [clientUser]と[userFromData]とは同時に指定可能です。
  ///
  /// ```
  /// // Path definition
  /// /collection/:document_id
  /// // Actual path
  /// /collection/ABCDEFG
  /// // Definition
  /// ModelValidationQueryUserType.userFromPath("document_id")
  /// -> Allow users whose user ID is `ABCDEFG
  /// ```
  /// {@endtemplate}
  userFromPath,

  /// {@template model_validation_query_user_type_user_from_data}
  /// An authenticated user whose user ID matches the value of a field with `key` in the document to be read or written and the user ID authenticated on the app.
  ///
  /// If [allUsers] or [authUsers] is specified, it takes precedence.
  ///
  /// Both [clientUser] and [userFromPath] can be specified at the same time.
  ///
  /// 認証済みユーザーのうち、読み込みや書き込み対象のドキュメント中に`key`を持つフィールドの値ととアプリ上で認証しているユーザーIDが一致するユーザー。
  ///
  /// [allUsers]や[authUsers]が指定されている場合はそちらが優先されます。
  ///
  /// [clientUser]と[userFromPath]とは同時に指定可能です。
  ///
  /// ```
  /// // Document data
  /// {
  ///   "user": "ABCDEFG",
  ///   "name": "ABCD",
  ///   "age": 20,
  /// }
  /// // Definition
  /// ModelValidationQueryUserType.userFromData("user")
  /// -> Allow users whose user ID is `ABCDEFG
  /// ```
  /// {@endtemplate}
  userFromData;
}

/// {@template model_validation_query}
/// Define the validation query to be used by [DatabaseValidator].
///
/// Basically, if a listing exists on [ModelQuery], permissions are specified in a white list format.
///
/// You can specify attributes to allow by specifying [permission] or [user].
///
/// [DatabaseValidator]で使用するバリデーションクエリを定義します。
///
/// 基本的には[ModelQuery]上でリストが存在している場合、ホワイトリスト形式でパーミッションが指定されます。
///
/// [permission]や[user]を指定して許可をする属性を指定できます。
/// {@endtemplate}
abstract class ModelValidationQuery {
  /// {@template model_validation_query}
  /// Define the validation query to be used by [DatabaseValidator].
  ///
  /// Basically, if a listing exists on [ModelQuery], permissions are specified in a white list format.
  ///
  /// You can specify attributes to allow by specifying [permission] or [user].
  ///
  /// [DatabaseValidator]で使用するバリデーションクエリを定義します。
  ///
  /// 基本的には[ModelQuery]上でリストが存在している場合、ホワイトリスト形式でパーミッションが指定されます。
  ///
  /// [permission]や[user]を指定して許可をする属性を指定できます。
  /// {@endtemplate}
  const ModelValidationQuery({
    required this.permission,
    required this.user,
    this.key,
  });

  /// {@macro model_validation_query_permission_type}
  final ModelValidationQueryPermissionType permission;

  /// {@macro model_validation_query_user_type}
  final ModelValidationQueryUserType user;

  /// Specify the target key to be used in [ModelValidationQueryUserType].
  ///
  /// [ModelValidationQueryUserType]で用いる対象のキーを指定します。
  final String? key;
}

/// {@macro model_validation_query_permission_type_allow_read}
///
/// {@macro model_validation_query}
class AllowReadModelValidationQuery extends ModelValidationQuery {
  const AllowReadModelValidationQuery._({
    required super.permission,
    required super.user,
    super.key,
  }) : super();

  /// {@macro model_validation_query_permission_type_allow_read}
  ///
  /// {@macro model_validation_query_user_type_all_users}
  ///
  /// {@macro model_validation_query}
  const AllowReadModelValidationQuery.allUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowRead,
          user: ModelValidationQueryUserType.allUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_read}
  ///
  /// {@macro model_validation_query_user_type_auth_users}
  ///
  /// {@macro model_validation_query}
  const AllowReadModelValidationQuery.authUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowRead,
          user: ModelValidationQueryUserType.authUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_read}
  ///
  /// {@macro model_validation_query_user_type_client_user}
  ///
  /// {@macro model_validation_query}
  const AllowReadModelValidationQuery.clientUser()
      : this._(
          permission: ModelValidationQueryPermissionType.allowRead,
          user: ModelValidationQueryUserType.clientUser,
        );

  /// {@macro model_validation_query_permission_type_allow_read}
  ///
  /// {@macro model_validation_query_user_type_userFromPath}
  ///
  /// {@macro model_validation_query}
  const AllowReadModelValidationQuery.userFromPath(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowRead,
          user: ModelValidationQueryUserType.userFromPath,
          key: key,
        );

  /// {@macro model_validation_query_permission_type_allow_read}
  ///
  /// {@macro model_validation_query_user_type_userFromData}
  ///
  /// {@macro model_validation_query}
  const AllowReadModelValidationQuery.userFromData(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowRead,
          user: ModelValidationQueryUserType.userFromData,
          key: key,
        );
}

/// {@macro model_validation_query_permission_type_allow_write}
///
/// {@macro model_validation_query}
class AllowWriteModelValidationQuery extends ModelValidationQuery {
  const AllowWriteModelValidationQuery._({
    required super.permission,
    required super.user,
    super.key,
  }) : super();

  /// {@macro model_validation_query_permission_type_allow_write}
  ///
  /// {@macro model_validation_query_user_type_all_users}
  ///
  /// {@macro model_validation_query}
  const AllowWriteModelValidationQuery.allUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowWrite,
          user: ModelValidationQueryUserType.allUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_write}
  ///
  /// {@macro model_validation_query_user_type_auth_users}
  ///
  /// {@macro model_validation_query}
  const AllowWriteModelValidationQuery.authUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowWrite,
          user: ModelValidationQueryUserType.authUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_write}
  ///
  /// {@macro model_validation_query_user_type_client_user}
  ///
  /// {@macro model_validation_query}
  const AllowWriteModelValidationQuery.clientUser()
      : this._(
          permission: ModelValidationQueryPermissionType.allowWrite,
          user: ModelValidationQueryUserType.clientUser,
        );

  /// {@macro model_validation_query_permission_type_allow_write}
  ///
  /// {@macro model_validation_query_user_type_userFromPath}
  ///
  /// {@macro model_validation_query}
  const AllowWriteModelValidationQuery.userFromPath(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowWrite,
          user: ModelValidationQueryUserType.userFromPath,
          key: key,
        );

  /// {@macro model_validation_query_permission_type_allow_write}
  ///
  /// {@macro model_validation_query_user_type_userFromData}
  ///
  /// {@macro model_validation_query}
  const AllowWriteModelValidationQuery.userFromData(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowWrite,
          user: ModelValidationQueryUserType.userFromData,
          key: key,
        );
}

/// {@macro model_validation_query_permission_type_allow_read_document}
///
/// {@macro model_validation_query}
class AllowReadDocumentModelValidationQuery extends ModelValidationQuery {
  const AllowReadDocumentModelValidationQuery._({
    required super.permission,
    required super.user,
    super.key,
  }) : super();

  /// {@macro model_validation_query_permission_type_allow_read_document}
  ///
  /// {@macro model_validation_query_user_type_all_users}
  ///
  /// {@macro model_validation_query}
  const AllowReadDocumentModelValidationQuery.allUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadDocument,
          user: ModelValidationQueryUserType.allUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_read_document}
  ///
  /// {@macro model_validation_query_user_type_auth_users}
  ///
  /// {@macro model_validation_query}
  const AllowReadDocumentModelValidationQuery.authUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadDocument,
          user: ModelValidationQueryUserType.authUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_read_document}
  ///
  /// {@macro model_validation_query_user_type_client_user}
  ///
  /// {@macro model_validation_query}
  const AllowReadDocumentModelValidationQuery.clientUser()
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadDocument,
          user: ModelValidationQueryUserType.clientUser,
        );

  /// {@macro model_validation_query_permission_type_allow_read_document}
  ///
  /// {@macro model_validation_query_user_type_userFromPath}
  ///
  /// {@macro model_validation_query}
  const AllowReadDocumentModelValidationQuery.userFromPath(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadDocument,
          user: ModelValidationQueryUserType.userFromPath,
          key: key,
        );

  /// {@macro model_validation_query_permission_type_allow_read_document}
  ///
  /// {@macro model_validation_query_user_type_userFromData}
  ///
  /// {@macro model_validation_query}
  const AllowReadDocumentModelValidationQuery.userFromData(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadDocument,
          user: ModelValidationQueryUserType.userFromData,
          key: key,
        );
}

/// {@macro model_validation_query_permission_type_allow_read_collection}
///
/// {@macro model_validation_query}
class AllowReadCollectionModelValidationQuery extends ModelValidationQuery {
  const AllowReadCollectionModelValidationQuery._({
    required super.permission,
    required super.user,
    super.key,
  }) : super();

  /// {@macro model_validation_query_permission_type_allow_read_collection}
  ///
  /// {@macro model_validation_query_user_type_all_users}
  ///
  /// {@macro model_validation_query}
  const AllowReadCollectionModelValidationQuery.allUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadCollection,
          user: ModelValidationQueryUserType.allUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_read_collection}
  ///
  /// {@macro model_validation_query_user_type_auth_users}
  ///
  /// {@macro model_validation_query}
  const AllowReadCollectionModelValidationQuery.authUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadCollection,
          user: ModelValidationQueryUserType.authUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_read_collection}
  ///
  /// {@macro model_validation_query_user_type_client_user}
  ///
  /// {@macro model_validation_query}
  const AllowReadCollectionModelValidationQuery.clientUser()
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadCollection,
          user: ModelValidationQueryUserType.clientUser,
        );

  /// {@macro model_validation_query_permission_type_allow_read_collection}
  ///
  /// {@macro model_validation_query_user_type_userFromPath}
  ///
  /// {@macro model_validation_query}
  const AllowReadCollectionModelValidationQuery.userFromPath(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadCollection,
          user: ModelValidationQueryUserType.userFromPath,
          key: key,
        );

  /// {@macro model_validation_query_permission_type_allow_read_collection}
  ///
  /// {@macro model_validation_query_user_type_userFromData}
  ///
  /// {@macro model_validation_query}
  const AllowReadCollectionModelValidationQuery.userFromData(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowReadCollection,
          user: ModelValidationQueryUserType.userFromData,
          key: key,
        );
}

/// {@macro model_validation_query_permission_type_allow_create}
///
/// {@macro model_validation_query}
class AllowCreateModelValidationQuery extends ModelValidationQuery {
  const AllowCreateModelValidationQuery._({
    required super.permission,
    required super.user,
    super.key,
  }) : super();

  /// {@macro model_validation_query_permission_type_allow_create}
  ///
  /// {@macro model_validation_query_user_type_all_users}
  ///
  /// {@macro model_validation_query}
  const AllowCreateModelValidationQuery.allUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowCreate,
          user: ModelValidationQueryUserType.allUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_create}
  ///
  /// {@macro model_validation_query_user_type_auth_users}
  ///
  /// {@macro model_validation_query}
  const AllowCreateModelValidationQuery.authUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowCreate,
          user: ModelValidationQueryUserType.authUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_create}
  ///
  /// {@macro model_validation_query_user_type_client_user}
  ///
  /// {@macro model_validation_query}
  const AllowCreateModelValidationQuery.clientUser()
      : this._(
          permission: ModelValidationQueryPermissionType.allowCreate,
          user: ModelValidationQueryUserType.clientUser,
        );

  /// {@macro model_validation_query_permission_type_allow_create}
  ///
  /// {@macro model_validation_query_user_type_userFromPath}
  ///
  /// {@macro model_validation_query}
  const AllowCreateModelValidationQuery.userFromPath(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowCreate,
          user: ModelValidationQueryUserType.userFromPath,
          key: key,
        );

  /// {@macro model_validation_query_permission_type_allow_create}
  ///
  /// {@macro model_validation_query_user_type_userFromData}
  ///
  /// {@macro model_validation_query}
  const AllowCreateModelValidationQuery.userFromData(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowCreate,
          user: ModelValidationQueryUserType.userFromData,
          key: key,
        );
}

/// {@macro model_validation_query_permission_type_allow_update}
///
/// {@macro model_validation_query}
class AllowUpdateModelValidationQuery extends ModelValidationQuery {
  const AllowUpdateModelValidationQuery._({
    required super.permission,
    required super.user,
    super.key,
  }) : super();

  /// {@macro model_validation_query_permission_type_allow_update}
  ///
  /// {@macro model_validation_query_user_type_all_users}
  ///
  /// {@macro model_validation_query}
  const AllowUpdateModelValidationQuery.allUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowUpdate,
          user: ModelValidationQueryUserType.allUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_update}
  ///
  /// {@macro model_validation_query_user_type_auth_users}
  ///
  /// {@macro model_validation_query}
  const AllowUpdateModelValidationQuery.authUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowUpdate,
          user: ModelValidationQueryUserType.authUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_update}
  ///
  /// {@macro model_validation_query_user_type_client_user}
  ///
  /// {@macro model_validation_query}
  const AllowUpdateModelValidationQuery.clientUser()
      : this._(
          permission: ModelValidationQueryPermissionType.allowUpdate,
          user: ModelValidationQueryUserType.clientUser,
        );

  /// {@macro model_validation_query_permission_type_allow_update}
  ///
  /// {@macro model_validation_query_user_type_userFromPath}
  ///
  /// {@macro model_validation_query}
  const AllowUpdateModelValidationQuery.userFromPath(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowUpdate,
          user: ModelValidationQueryUserType.userFromPath,
          key: key,
        );

  /// {@macro model_validation_query_permission_type_allow_update}
  ///
  /// {@macro model_validation_query_user_type_userFromData}
  ///
  /// {@macro model_validation_query}
  const AllowUpdateModelValidationQuery.userFromData(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowUpdate,
          user: ModelValidationQueryUserType.userFromData,
          key: key,
        );
}

/// {@macro model_validation_query_permission_type_allow_delete}
///
/// {@macro model_validation_query}
class AllowDeleteModelValidationQuery extends ModelValidationQuery {
  const AllowDeleteModelValidationQuery._({
    required super.permission,
    required super.user,
    super.key,
  }) : super();

  /// {@macro model_validation_query_permission_type_allow_delete}
  ///
  /// {@macro model_validation_query_user_type_all_users}
  ///
  /// {@macro model_validation_query}
  const AllowDeleteModelValidationQuery.allUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowDelete,
          user: ModelValidationQueryUserType.allUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_delete}
  ///
  /// {@macro model_validation_query_user_type_auth_users}
  ///
  /// {@macro model_validation_query}
  const AllowDeleteModelValidationQuery.authUsers()
      : this._(
          permission: ModelValidationQueryPermissionType.allowDelete,
          user: ModelValidationQueryUserType.authUsers,
        );

  /// {@macro model_validation_query_permission_type_allow_delete}
  ///
  /// {@macro model_validation_query_user_type_client_user}
  ///
  /// {@macro model_validation_query}
  const AllowDeleteModelValidationQuery.clientUser()
      : this._(
          permission: ModelValidationQueryPermissionType.allowDelete,
          user: ModelValidationQueryUserType.clientUser,
        );

  /// {@macro model_validation_query_permission_type_allow_delete}
  ///
  /// {@macro model_validation_query_user_type_userFromPath}
  ///
  /// {@macro model_validation_query}
  const AllowDeleteModelValidationQuery.userFromPath(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowDelete,
          user: ModelValidationQueryUserType.userFromPath,
          key: key,
        );

  /// {@macro model_validation_query_permission_type_allow_delete}
  ///
  /// {@macro model_validation_query_user_type_userFromData}
  ///
  /// {@macro model_validation_query}
  const AllowDeleteModelValidationQuery.userFromData(String key)
      : this._(
          permission: ModelValidationQueryPermissionType.allowDelete,
          user: ModelValidationQueryUserType.userFromData,
          key: key,
        );
}
