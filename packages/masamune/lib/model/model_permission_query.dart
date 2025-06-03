part of "/masamune.dart";

/// {@macro model_permission_query_permission_type_allow_read}
///
/// {@macro model_permission_query}
class AllowReadModelPermissionQuery implements ModelPermissionQuery {
  const AllowReadModelPermissionQuery._({
    required this.permission,
    required this.user,
    this.key,
  });

  @override
  final ModelPermissionQueryType permission;

  @override
  final ModelPermissionQueryUserType user;

  @override
  final Object? key;

  /// {@macro model_permission_query_permission_type_allow_read}
  ///
  /// {@macro model_permission_query_user_type_all_users}
  ///
  /// {@macro model_permission_query}
  const AllowReadModelPermissionQuery.allUsers()
      : this._(
          permission: ModelPermissionQueryType.allowRead,
          user: ModelPermissionQueryUserType.allUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_read}
  ///
  /// {@macro model_permission_query_user_type_auth_users}
  ///
  /// {@macro model_permission_query}
  const AllowReadModelPermissionQuery.authUsers()
      : this._(
          permission: ModelPermissionQueryType.allowRead,
          user: ModelPermissionQueryUserType.authUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_read}
  ///
  /// {@macro model_permission_query_user_type_user_from_path_index}
  ///
  /// {@macro model_permission_query}
  const AllowReadModelPermissionQuery.userFromPath([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowRead,
          user: ModelPermissionQueryUserType.userFromPath,
          key: key ?? kUidFieldKey,
        );

  /// {@macro model_permission_query_permission_type_allow_read}
  ///
  /// {@macro model_permission_query_user_type_user_from_data}
  ///
  /// {@macro model_permission_query}
  const AllowReadModelPermissionQuery.userFromData([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowRead,
          user: ModelPermissionQueryUserType.userFromData,
          key: key ?? kUidFieldKey,
        );
}

/// {@macro model_permission_query_permission_type_allow_write}
///
/// {@macro model_permission_query}
class AllowWriteModelPermissionQuery implements ModelPermissionQuery {
  const AllowWriteModelPermissionQuery._({
    required this.permission,
    required this.user,
    this.key,
  });

  @override
  final ModelPermissionQueryType permission;

  @override
  final ModelPermissionQueryUserType user;

  @override
  final Object? key;

  /// {@macro model_permission_query_permission_type_allow_write}
  ///
  /// {@macro model_permission_query_user_type_all_users}
  ///
  /// {@macro model_permission_query}
  const AllowWriteModelPermissionQuery.allUsers()
      : this._(
          permission: ModelPermissionQueryType.allowWrite,
          user: ModelPermissionQueryUserType.allUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_write}
  ///
  /// {@macro model_permission_query_user_type_auth_users}
  ///
  /// {@macro model_permission_query}
  const AllowWriteModelPermissionQuery.authUsers()
      : this._(
          permission: ModelPermissionQueryType.allowWrite,
          user: ModelPermissionQueryUserType.authUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_write}
  ///
  /// {@macro model_permission_query_user_type_user_from_path_index}
  ///
  /// {@macro model_permission_query}
  const AllowWriteModelPermissionQuery.userFromPath([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowWrite,
          user: ModelPermissionQueryUserType.userFromPath,
          key: key ?? kUidFieldKey,
        );

  /// {@macro model_permission_query_permission_type_allow_write}
  ///
  /// {@macro model_permission_query_user_type_user_from_data}
  ///
  /// {@macro model_permission_query}
  const AllowWriteModelPermissionQuery.userFromData([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowWrite,
          user: ModelPermissionQueryUserType.userFromData,
          key: key ?? kUidFieldKey,
        );
}

/// {@macro model_permission_query_permission_type_allow_read_document}
///
/// {@macro model_permission_query}
class AllowReadDocumentModelPermissionQuery implements ModelPermissionQuery {
  const AllowReadDocumentModelPermissionQuery._({
    required this.permission,
    required this.user,
    this.key,
  });

  @override
  final ModelPermissionQueryType permission;

  @override
  final ModelPermissionQueryUserType user;

  @override
  final Object? key;

  /// {@macro model_permission_query_permission_type_allow_read_document}
  ///
  /// {@macro model_permission_query_user_type_all_users}
  ///
  /// {@macro model_permission_query}
  const AllowReadDocumentModelPermissionQuery.allUsers()
      : this._(
          permission: ModelPermissionQueryType.allowReadDocument,
          user: ModelPermissionQueryUserType.allUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_read_document}
  ///
  /// {@macro model_permission_query_user_type_auth_users}
  ///
  /// {@macro model_permission_query}
  const AllowReadDocumentModelPermissionQuery.authUsers()
      : this._(
          permission: ModelPermissionQueryType.allowReadDocument,
          user: ModelPermissionQueryUserType.authUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_read_document}
  ///
  /// {@macro model_permission_query_user_type_user_from_path_index}
  ///
  /// {@macro model_permission_query}
  const AllowReadDocumentModelPermissionQuery.userFromPath([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowReadDocument,
          user: ModelPermissionQueryUserType.userFromPath,
          key: key ?? kUidFieldKey,
        );

  /// {@macro model_permission_query_permission_type_allow_read_document}
  ///
  /// {@macro model_permission_query_user_type_user_from_data}
  ///
  /// {@macro model_permission_query}
  const AllowReadDocumentModelPermissionQuery.userFromData([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowReadDocument,
          user: ModelPermissionQueryUserType.userFromData,
          key: key ?? kUidFieldKey,
        );
}

/// {@macro model_permission_query_permission_type_allow_read_collection}
///
/// {@macro model_permission_query}
class AllowReadCollectionModelPermissionQuery implements ModelPermissionQuery {
  const AllowReadCollectionModelPermissionQuery._({
    required this.permission,
    required this.user,
    this.key,
  });

  @override
  final ModelPermissionQueryType permission;

  @override
  final ModelPermissionQueryUserType user;

  @override
  final Object? key;

  /// {@macro model_permission_query_permission_type_allow_read_collection}
  ///
  /// {@macro model_permission_query_user_type_all_users}
  ///
  /// {@macro model_permission_query}
  const AllowReadCollectionModelPermissionQuery.allUsers()
      : this._(
          permission: ModelPermissionQueryType.allowReadCollection,
          user: ModelPermissionQueryUserType.allUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_read_collection}
  ///
  /// {@macro model_permission_query_user_type_auth_users}
  ///
  /// {@macro model_permission_query}
  const AllowReadCollectionModelPermissionQuery.authUsers()
      : this._(
          permission: ModelPermissionQueryType.allowReadCollection,
          user: ModelPermissionQueryUserType.authUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_read_collection}
  ///
  /// {@macro model_permission_query_user_type_user_from_path_index}
  ///
  /// {@macro model_permission_query}
  const AllowReadCollectionModelPermissionQuery.userFromPath([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowReadCollection,
          user: ModelPermissionQueryUserType.userFromPath,
          key: key ?? kUidFieldKey,
        );

  /// {@macro model_permission_query_permission_type_allow_read_collection}
  ///
  /// {@macro model_permission_query_user_type_user_from_data}
  ///
  /// {@macro model_permission_query}
  const AllowReadCollectionModelPermissionQuery.userFromData([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowReadCollection,
          user: ModelPermissionQueryUserType.userFromData,
          key: key ?? kUidFieldKey,
        );
}

/// {@macro model_permission_query_permission_type_allow_create}
///
/// {@macro model_permission_query}
class AllowCreateModelPermissionQuery implements ModelPermissionQuery {
  const AllowCreateModelPermissionQuery._({
    required this.permission,
    required this.user,
    this.key,
  });

  @override
  final ModelPermissionQueryType permission;

  @override
  final ModelPermissionQueryUserType user;

  @override
  final Object? key;

  /// {@macro model_permission_query_permission_type_allow_create}
  ///
  /// {@macro model_permission_query_user_type_all_users}
  ///
  /// {@macro model_permission_query}
  const AllowCreateModelPermissionQuery.allUsers()
      : this._(
          permission: ModelPermissionQueryType.allowCreate,
          user: ModelPermissionQueryUserType.allUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_create}
  ///
  /// {@macro model_permission_query_user_type_auth_users}
  ///
  /// {@macro model_permission_query}
  const AllowCreateModelPermissionQuery.authUsers()
      : this._(
          permission: ModelPermissionQueryType.allowCreate,
          user: ModelPermissionQueryUserType.authUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_create}
  ///
  /// {@macro model_permission_query_user_type_user_from_path_index}
  ///
  /// {@macro model_permission_query}
  const AllowCreateModelPermissionQuery.userFromPath([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowCreate,
          user: ModelPermissionQueryUserType.userFromPath,
          key: key ?? kUidFieldKey,
        );

  /// {@macro model_permission_query_permission_type_allow_create}
  ///
  /// {@macro model_permission_query_user_type_user_from_data}
  ///
  /// {@macro model_permission_query}
  const AllowCreateModelPermissionQuery.userFromData([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowCreate,
          user: ModelPermissionQueryUserType.userFromData,
          key: key ?? kUidFieldKey,
        );
}

/// {@macro model_permission_query_permission_type_allow_update}
///
/// {@macro model_permission_query}
class AllowUpdateModelPermissionQuery implements ModelPermissionQuery {
  const AllowUpdateModelPermissionQuery._({
    required this.permission,
    required this.user,
    this.key,
  });

  @override
  final ModelPermissionQueryType permission;

  @override
  final ModelPermissionQueryUserType user;

  @override
  final Object? key;

  /// {@macro model_permission_query_permission_type_allow_update}
  ///
  /// {@macro model_permission_query_user_type_all_users}
  ///
  /// {@macro model_permission_query}
  const AllowUpdateModelPermissionQuery.allUsers()
      : this._(
          permission: ModelPermissionQueryType.allowUpdate,
          user: ModelPermissionQueryUserType.allUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_update}
  ///
  /// {@macro model_permission_query_user_type_auth_users}
  ///
  /// {@macro model_permission_query}
  const AllowUpdateModelPermissionQuery.authUsers()
      : this._(
          permission: ModelPermissionQueryType.allowUpdate,
          user: ModelPermissionQueryUserType.authUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_update}
  ///
  /// {@macro model_permission_query_user_type_user_from_path_index}
  ///
  /// {@macro model_permission_query}
  const AllowUpdateModelPermissionQuery.userFromPath([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowUpdate,
          user: ModelPermissionQueryUserType.userFromPath,
          key: key ?? kUidFieldKey,
        );

  /// {@macro model_permission_query_permission_type_allow_update}
  ///
  /// {@macro model_permission_query_user_type_user_from_data}
  ///
  /// {@macro model_permission_query}
  const AllowUpdateModelPermissionQuery.userFromData([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowUpdate,
          user: ModelPermissionQueryUserType.userFromData,
          key: key ?? kUidFieldKey,
        );
}

/// {@macro model_permission_query_permission_type_allow_delete}
///
/// {@macro model_permission_query}
class AllowDeleteModelPermissionQuery implements ModelPermissionQuery {
  const AllowDeleteModelPermissionQuery._({
    required this.permission,
    required this.user,
    this.key,
  });

  @override
  final ModelPermissionQueryType permission;

  @override
  final ModelPermissionQueryUserType user;

  @override
  final Object? key;

  /// {@macro model_permission_query_permission_type_allow_delete}
  ///
  /// {@macro model_permission_query_user_type_all_users}
  ///
  /// {@macro model_permission_query}
  const AllowDeleteModelPermissionQuery.allUsers()
      : this._(
          permission: ModelPermissionQueryType.allowDelete,
          user: ModelPermissionQueryUserType.allUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_delete}
  ///
  /// {@macro model_permission_query_user_type_auth_users}
  ///
  /// {@macro model_permission_query}
  const AllowDeleteModelPermissionQuery.authUsers()
      : this._(
          permission: ModelPermissionQueryType.allowDelete,
          user: ModelPermissionQueryUserType.authUsers,
        );

  /// {@macro model_permission_query_permission_type_allow_delete}
  ///
  /// {@macro model_permission_query_user_type_user_from_path_index}
  ///
  /// {@macro model_permission_query}
  const AllowDeleteModelPermissionQuery.userFromPath([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowDelete,
          user: ModelPermissionQueryUserType.userFromPath,
          key: key ?? kUidFieldKey,
        );

  /// {@macro model_permission_query_permission_type_allow_delete}
  ///
  /// {@macro model_permission_query_user_type_user_from_data}
  ///
  /// {@macro model_permission_query}
  const AllowDeleteModelPermissionQuery.userFromData([String? key])
      : this._(
          permission: ModelPermissionQueryType.allowDelete,
          user: ModelPermissionQueryUserType.userFromData,
          key: key ?? kUidFieldKey,
        );
}
