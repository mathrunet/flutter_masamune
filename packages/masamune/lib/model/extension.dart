part of '/masamune.dart';

/// Extension methods for [ModelImageUri].
///
/// [ModelImageUri]の拡張メソッドです。
extension ModelImageUriExtensions on ModelImageUri {
  /// Get a [ImageProvider].
  ///
  /// If [defaultAssetURI] is specified, use [defaultAssetURI] if [ImageProvider] cannot be obtained.
  ///
  /// [ImageProvider]を取得します。
  ///
  /// [defaultAssetURI]が指定されている場合、[ImageProvider]が取得できない場合は[defaultAssetURI]を使用します。
  ImageProvider toImageProvider([String defaultAssetURI = "assets/image.png"]) {
    return Asset.image(value.toString(), defaultAssetURI);
  }

  /// Convert to [FormMediaValue].
  ///
  /// If [value] is empty, null is returned.
  ///
  /// [FormMediaValue]に変換します。
  ///
  /// [value]が空の場合はnullを返します。
  FormMediaValue? toFormMediaValue() {
    if (value.isEmpty) {
      return null;
    }
    return FormMediaValue(uri: value, type: FormMediaType.image);
  }
}

/// Extension methods for [ModelVideoUri].
///
/// [ModelVideoUri]の拡張メソッドです。
extension ModelVideoUriExtensions on ModelVideoUri {
  /// Convert to [FormMediaValue].
  ///
  /// If [value] is empty, null is returned.
  ///
  /// [FormMediaValue]に変換します。
  ///
  /// [value]が空の場合はnullを返します。
  FormMediaValue? toFormMediaValue() {
    if (value.isEmpty) {
      return null;
    }
    return FormMediaValue(uri: value, type: FormMediaType.video);
  }
}

/// This is an extension method of [ModelQueryBase].
///
/// [ModelQueryBase]の拡張メソッドです。
extension ModelQueryBaseExtensions<TModel extends Listenable>
    on ModelQueryBase<TModel> {
  /// Get [TModel] while monitoring it with the widget associated with [ref] in the same way as `ref.model`.
  ///
  /// `ref.model`と同じように[ref]に関連するウィジェットで監視を行いつつ[TModel]を取得します。
  TModel watch(RefHasApp ref) {
    return ref.model(this);
  }

  /// Get [TModel] stored in [ref] in the same way as `ref.model`.
  ///
  /// `ref.model`と同じように[ref]に格納されている[TModel]を取得します。
  TModel read(Ref ref) {
    return ref.model(this);
  }
}

/// Extension method of the [ModelPermissionQuery] list.
///
/// [ModelPermissionQuery]のリストの拡張メソッドです。
extension ModelPermissionQueryListExtensions on List<ModelPermissionQuery> {
  /// Convert a list of [ModelPermissionQuery] to a list of [ModelValidationQuery].
  ///
  /// [ModelPermissionQuery]のリストを[ModelValidationQuery]のリストに変換します。
  List<ModelValidationQuery> toValidationQueries(String pathDefinition) {
    return mapAndRemoveEmpty((item) {
      switch (item.user) {
        case ModelPermissionQueryUserType.allUsers:
          switch (item.permission) {
            case ModelPermissionQueryType.allowRead:
              return const AllowReadModelValidationQuery.allUsers();
            case ModelPermissionQueryType.allowWrite:
              return const AllowWriteModelValidationQuery.allUsers();
            case ModelPermissionQueryType.allowReadDocument:
              return const AllowReadDocumentModelValidationQuery.allUsers();
            case ModelPermissionQueryType.allowReadCollection:
              return const AllowReadCollectionModelValidationQuery.allUsers();
            case ModelPermissionQueryType.allowCreate:
              return const AllowCreateModelValidationQuery.allUsers();
            case ModelPermissionQueryType.allowUpdate:
              return const AllowUpdateModelValidationQuery.allUsers();
            case ModelPermissionQueryType.allowDelete:
              return const AllowDeleteModelValidationQuery.allUsers();
          }
        case ModelPermissionQueryUserType.authUsers:
          switch (item.permission) {
            case ModelPermissionQueryType.allowRead:
              return const AllowReadModelValidationQuery.authUsers();
            case ModelPermissionQueryType.allowWrite:
              return const AllowWriteModelValidationQuery.authUsers();
            case ModelPermissionQueryType.allowReadDocument:
              return const AllowReadDocumentModelValidationQuery.authUsers();
            case ModelPermissionQueryType.allowReadCollection:
              return const AllowReadCollectionModelValidationQuery.authUsers();
            case ModelPermissionQueryType.allowCreate:
              return const AllowCreateModelValidationQuery.authUsers();
            case ModelPermissionQueryType.allowUpdate:
              return const AllowUpdateModelValidationQuery.authUsers();
            case ModelPermissionQueryType.allowDelete:
              return const AllowDeleteModelValidationQuery.authUsers();
          }
        case ModelPermissionQueryUserType.userFromPath:
          final key = item.key;
          if (key is! String) {
            return null;
          }
          final paths = pathDefinition.trimQuery().trimString("/").split("/");
          if (paths.length % 2 == 0) {
            paths.removeLast();
          }
          paths.add(kUidFieldKey);
          final index = paths.indexOf(key);
          if (index < 0) {
            return null;
          }
          switch (item.permission) {
            case ModelPermissionQueryType.allowRead:
              return AllowReadModelValidationQuery.userFromPathIndex(index);
            case ModelPermissionQueryType.allowWrite:
              return AllowWriteModelValidationQuery.userFromPathIndex(index);
            case ModelPermissionQueryType.allowReadDocument:
              return AllowReadDocumentModelValidationQuery.userFromPathIndex(
                  index);
            case ModelPermissionQueryType.allowReadCollection:
              return AllowReadCollectionModelValidationQuery.userFromPathIndex(
                  index);
            case ModelPermissionQueryType.allowCreate:
              return AllowCreateModelValidationQuery.userFromPathIndex(index);
            case ModelPermissionQueryType.allowUpdate:
              return AllowUpdateModelValidationQuery.userFromPathIndex(index);
            case ModelPermissionQueryType.allowDelete:
              return AllowDeleteModelValidationQuery.userFromPathIndex(index);
          }
        case ModelPermissionQueryUserType.userFromData:
          final key = item.key;
          if (key is! String) {
            return null;
          }
          switch (item.permission) {
            case ModelPermissionQueryType.allowRead:
              return AllowReadModelValidationQuery.userFromData(key);
            case ModelPermissionQueryType.allowWrite:
              return AllowWriteModelValidationQuery.userFromData(key);
            case ModelPermissionQueryType.allowReadDocument:
              return AllowReadDocumentModelValidationQuery.userFromData(key);
            case ModelPermissionQueryType.allowReadCollection:
              return AllowReadCollectionModelValidationQuery.userFromData(key);
            case ModelPermissionQueryType.allowCreate:
              return AllowCreateModelValidationQuery.userFromData(key);
            case ModelPermissionQueryType.allowUpdate:
              return AllowUpdateModelValidationQuery.userFromData(key);
            case ModelPermissionQueryType.allowDelete:
              return AllowDeleteModelValidationQuery.userFromData(key);
          }
      }
    });
  }
}
