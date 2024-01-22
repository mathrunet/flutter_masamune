part of '/katana_model.dart';

/// An object that validates information in the database.
///
/// The [onRetrieveUserId] field specifies the process of retrieving the authenticated user ID.
///
/// データベースの情報をバリデートするオブジェクト。
///
/// [onRetrieveUserId]には、認証済みのユーザーIDを取得する処理を指定します。
@immutable
class DatabaseValidator {
  const DatabaseValidator({
    required this.onRetrieveUserId,
  });

  /// The process of retrieving the authenticated user ID.
  ///
  /// If [Null] is passed, it is assumed to be unauthenticated.
  ///
  /// 認証済みのユーザーIDを取得する処理。
  ///
  /// [Null]が渡された場合は認証してないとみなされます。
  final FutureOr<String?> Function() onRetrieveUserId;

  /// This is the process before loading the document.
  ///
  /// Specify the query passed from the document in [query].
  ///
  /// ドキュメントを読み込むまえの処理です。
  ///
  /// [query]にドキュメントから渡されたクエリを指定します。
  Future<void> onPreloadDocument(ModelAdapterDocumentQuery query) async {
    final validationQueries = query.query.validationQueries
        ?.where(
          (e) =>
              e.permission == ModelValidationQueryPermissionType.allowRead ||
              e.permission ==
                  ModelValidationQueryPermissionType.allowReadDocument,
        )
        .toList()
        .sortTo((a, b) {
      final permission = a.permission.index.compareTo(b.permission.index);
      if (permission != 0) {
        return permission;
      }
      return a.user.index.compareTo(b.user.index);
    });
    if (validationQueries == null) {
      return;
    }
    if (validationQueries.isEmpty) {
      throw DatabaseValidationExcepction(
        "Not permitted: OnLoadDocument at ${query.query.path} $validationQueries",
      );
    }
    final userId = await onRetrieveUserId();
    for (final validationQuery in validationQueries) {
      if (!validationQuery._checkPermission(
        query: query.query,
        userId: userId,
      )) {
        throw DatabaseValidationExcepction(
          "Not permitted: OnLoadDocument at ${query.query.path} $validationQueries",
        );
      }
    }
  }

  /// This is the process after the document has been read.
  ///
  /// Specify the query passed from the document in [query].
  ///
  /// Specify the value read in [value].
  ///
  /// ドキュメントを読み込んだ後の処理です。
  ///
  /// [query]にドキュメントから渡されたクエリを指定します。
  ///
  /// [value]に読み込んだ値を指定します。
  Future<void> onPostloadDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap? value,
  ) async {
    final validationQueries = query.query.validationQueries
        ?.where(
          (e) =>
              e.permission == ModelValidationQueryPermissionType.allowRead ||
              e.permission ==
                  ModelValidationQueryPermissionType.allowReadDocument,
        )
        .toList()
        .sortTo((a, b) {
      final permission = a.permission.index.compareTo(b.permission.index);
      if (permission != 0) {
        return permission;
      }
      return a.user.index.compareTo(b.user.index);
    });
    if (validationQueries == null) {
      return;
    }
    if (validationQueries.isEmpty) {
      throw DatabaseValidationExcepction(
        "Not permitted: OnLoadedDocument at ${query.query.path} $validationQueries $value",
      );
    }
    final userId = await onRetrieveUserId();
    for (final validationQuery in validationQueries) {
      if (!validationQuery._checkPermissionWithValue(
        query: query.query,
        userId: userId,
        value: value,
      )) {
        throw DatabaseValidationExcepction(
          "Not permitted: OnLoadedDocument at ${query.query.path} $validationQueries $value",
        );
      }
    }
  }

  /// This is the process before loading the collection.
  ///
  /// Specify the query passed from the collection in [query].
  ///
  /// コレクションを読み込むまえの処理です。
  ///
  /// [query]にコレクションから渡されたクエリを指定します。
  Future<void> onPreloadCollection(ModelAdapterCollectionQuery query) async {
    final validationQueries = query.query.validationQueries
        ?.where(
          (e) =>
              e.permission == ModelValidationQueryPermissionType.allowRead ||
              e.permission ==
                  ModelValidationQueryPermissionType.allowReadCollection,
        )
        .toList()
        .sortTo((a, b) {
      final permission = a.permission.index.compareTo(b.permission.index);
      if (permission != 0) {
        return permission;
      }
      return a.user.index.compareTo(b.user.index);
    });
    if (validationQueries == null) {
      return;
    }
    if (validationQueries.isEmpty) {
      throw DatabaseValidationExcepction(
        "Not permitted: OnLoadCollection at ${query.query.path} $validationQueries",
      );
    }
    final userId = await onRetrieveUserId();
    for (final validationQuery in validationQueries) {
      if (!validationQuery._checkPermission(
        query: query.query,
        userId: userId,
      )) {
        throw DatabaseValidationExcepction(
          "Not permitted: OnLoadCollection at ${query.query.path} $validationQueries",
        );
      }
    }
  }

  /// This is the process after the collection is read.
  ///
  /// Specify the query passed from the collection in [query].
  ///
  /// Specify the value read in [value].
  ///
  /// コレクションを読み込んだ後の処理です。
  ///
  /// [query]にコレクションから渡されたクエリを指定します。
  ///
  /// [value]に読み込んだ値を指定します。
  Future<void> onPostloadCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap>? value,
  ) async {
    final validationQueries = query.query.validationQueries
        ?.where(
          (e) =>
              e.permission == ModelValidationQueryPermissionType.allowRead ||
              e.permission ==
                  ModelValidationQueryPermissionType.allowReadCollection,
        )
        .toList()
        .sortTo((a, b) {
      final permission = a.permission.index.compareTo(b.permission.index);
      if (permission != 0) {
        return permission;
      }
      return a.user.index.compareTo(b.user.index);
    });
    if (validationQueries == null) {
      return;
    }
    if (validationQueries.isEmpty) {
      throw DatabaseValidationExcepction(
        "Not permitted: OnLoadedCollection at ${query.query.path} $validationQueries $value",
      );
    }
    final userId = await onRetrieveUserId();
    for (final validationQuery in validationQueries) {
      for (final document in (value?.values ?? <DynamicMap>[])) {
        if (!validationQuery._checkPermissionWithValue(
          query: query.query,
          userId: userId,
          value: document,
        )) {
          throw DatabaseValidationExcepction(
            "Not permitted: OnLoadedCollection at ${query.query.path} $validationQueries $value",
          );
        }
      }
    }
  }

  /// This is the process when saving a document.
  ///
  /// Specify the query passed from the document in [query].
  ///
  /// Specify the value before saving in [oldValue].
  ///
  /// Specify the value after saving in [newValue].
  ///
  /// If [oldValue] has no value and [newValue] has a value, it is considered a new creation.
  ///
  /// If [oldValue] has a value and [newValue] has a value, it is considered an update.
  ///
  /// ドキュメントを保存する時の処理です。
  ///
  /// [query]にドキュメントから渡されたクエリを指定します。
  ///
  /// [oldValue]に保存前の値を指定します。
  ///
  /// [newValue]に保存後の値を指定します。
  ///
  /// [oldValue]に値がなく、[newValue]に値がある場合は、新規作成とみなされます。
  ///
  /// [oldValue]に値があり、[newValue]に値がある場合は、更新とみなされます。
  Future<void> onSaveDocument(
    ModelAdapterDocumentQuery query, {
    DynamicMap? oldValue,
    required DynamicMap newValue,
  }) async {
    // 新規作成
    if (oldValue.isEmpty && newValue.isNotEmpty) {
      final validationQueries = query.query.validationQueries
          ?.where(
            (e) =>
                e.permission == ModelValidationQueryPermissionType.allowWrite ||
                e.permission == ModelValidationQueryPermissionType.allowCreate,
          )
          .toList()
          .sortTo((a, b) {
        final permission = a.permission.index.compareTo(b.permission.index);
        if (permission != 0) {
          return permission;
        }
        return a.user.index.compareTo(b.user.index);
      });
      if (validationQueries == null) {
        return;
      }
      if (validationQueries.isEmpty) {
        throw DatabaseValidationExcepction(
          "Not permitted: OnCreateDocument at ${query.query.path} $validationQueries $newValue",
        );
      }
      final userId = await onRetrieveUserId();
      for (final validationQuery in validationQueries) {
        if (!validationQuery._checkPermission(
              query: query.query,
              userId: userId,
            ) ||
            !validationQuery._checkPermissionWithValue(
              query: query.query,
              userId: userId,
              value: newValue,
            )) {
          throw DatabaseValidationExcepction(
            "Not permitted: OnCreateDocument at ${query.query.path} $validationQueries $newValue",
          );
        }
      }
      // 更新
    } else if (oldValue.isNotEmpty && newValue.isNotEmpty) {
      final validationQueries = query.query.validationQueries
          ?.where(
            (e) =>
                e.permission == ModelValidationQueryPermissionType.allowWrite ||
                e.permission == ModelValidationQueryPermissionType.allowUpdate,
          )
          .toList()
          .sortTo((a, b) {
        final permission = a.permission.index.compareTo(b.permission.index);
        if (permission != 0) {
          return permission;
        }
        return a.user.index.compareTo(b.user.index);
      });
      if (validationQueries == null) {
        return;
      }
      if (validationQueries.isEmpty) {
        throw DatabaseValidationExcepction(
          "Not permitted: OnUpdateDocument at ${query.query.path} $validationQueries $oldValue -> $newValue",
        );
      }
      final userId = await onRetrieveUserId();
      for (final validationQuery in validationQueries) {
        if (!validationQuery._checkPermission(
              query: query.query,
              userId: userId,
            ) ||
            !validationQuery._checkPermissionWithValue(
              query: query.query,
              userId: userId,
              value: newValue,
            )) {
          throw DatabaseValidationExcepction(
            "Not permitted: OnUpdateDocument at ${query.query.path} $validationQueries $oldValue -> $newValue",
          );
        }
      }
    }
  }

  /// This is the process when deleting a document.
  ///
  /// Specify the query passed from the document in [query].
  ///
  /// ドキュメントを削除する時の処理です。
  ///
  /// [query]にドキュメントから渡されたクエリを指定します。
  Future<void> onDeleteDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap? oldValue,
  ) async {
    final validationQueries = query.query.validationQueries
        ?.where(
          (e) =>
              e.permission == ModelValidationQueryPermissionType.allowWrite ||
              e.permission == ModelValidationQueryPermissionType.allowDelete,
        )
        .toList()
        .sortTo((a, b) {
      final permission = a.permission.index.compareTo(b.permission.index);
      if (permission != 0) {
        return permission;
      }
      return a.user.index.compareTo(b.user.index);
    });
    if (validationQueries == null) {
      return;
    }
    if (validationQueries.isEmpty) {
      throw DatabaseValidationExcepction(
        "Not permitted: OnDeleteDocument at ${query.query.path} $validationQueries $oldValue",
      );
    }
    final userId = await onRetrieveUserId();
    for (final validationQuery in validationQueries) {
      if (!validationQuery._checkPermission(
            query: query.query,
            userId: userId,
          ) ||
          !validationQuery._checkPermissionWithValue(
            query: query.query,
            userId: userId,
            value: oldValue,
          )) {
        throw DatabaseValidationExcepction(
          "Not permitted: OnDeleteDocument at ${query.query.path} $validationQueries $oldValue",
        );
      }
    }
  }
}

/// Defines errors during database validation.
///
/// Specify the error message in [message].
///
/// データベースのバリデーション時のエラーを定義します。
///
/// [message]にエラーメッセージを指定します。
class DatabaseValidationExcepction implements Exception {
  /// Defines errors during database validation.
  ///
  /// Specify the error message in [message].
  ///
  /// データベースのバリデーション時のエラーを定義します。
  ///
  /// [message]にエラーメッセージを指定します。
  const DatabaseValidationExcepction([this.message]);

  /// A message describing a validation error.
  ///
  /// バリデーションエラーを説明するメッセージ。
  final Object? message;

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "DatabaseValidationExcepction";
    return "DatabaseValidationExcepction: $message";
  }
}
