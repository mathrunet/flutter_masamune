part of '/masamune_builder.dart';

const _kUidFieldKey = "@uid";

/// Parsed value for permissions.
///
/// パーミッション用のパースされた値。
@immutable
class PermissionValue {
  const PermissionValue._({
    required this.type,
    required this.user,
    required this.rawValue,
    this.key,
  });

  static final _permissionValueRegExp =
      RegExp(r"([a-zA-Z0-9_-]+)\.([a-zA-Z0-9_-]+)\(([^\)]*)\)");

  /// Parsed value for permissions.
  ///
  /// パーミッション用のパースされた値。
  static PermissionValue from(String value) {
    final match = _permissionValueRegExp.firstMatch(value);
    if (match == null) {
      throw ArgumentError.value(value, "value");
    }
    return PermissionValue._(
      rawValue: value,
      type: match.group(1)!,
      user: match.group(2)!,
      key: match.group(3)?.trim().trimString("'").trimString('"'),
    );
  }

  /// Raw value passed.
  ///
  /// 渡された生の値。
  final String rawValue;

  /// Permission Type.
  ///
  /// パーミッションのタイプ。
  final String type;

  /// Permission user type.
  ///
  /// パーミッションのユーザータイプ。
  final String user;

  /// Permission key.
  ///
  /// パーミッションのキー。
  final String? key;

  @override
  String toString() {
    return "$runtimeType($type, $user, $key)";
  }

  /// Convert [ModelPermissionQuery] to [ModelValidationQuery].
  ///
  /// [ModelPermissionQuery]を[ModelValidationQuery]に変換します。
  String toValidationQueryString(PathValue path) {
    switch (user) {
      case "allUsers":
        switch (type) {
          case "AllowReadModelPermissionQuery":
            return "AllowReadModelValidationQuery.allUsers()";
          case "AllowWriteModelPermissionQuery":
            return "AllowWriteModelValidationQuery.allUsers()";
          case "AllowReadDocumentModelPermissionQuery":
            return "AllowReadDocumentModelValidationQuery.allUsers()";
          case "AllowReadCollectionModelPermissionQuery":
            return "AllowReadCollectionModelValidationQuery.allUsers()";
          case "AllowCreateModelPermissionQuery":
            return "AllowCreateModelValidationQuery.allUsers()";
          case "AllowUpdateModelPermissionQuery":
            return "AllowUpdateModelValidationQuery.allUsers()";
          case "AllowDeleteModelPermissionQuery":
            return "AllowDeleteModelValidationQuery.allUsers()";
        }
        break;
      case "authUsers":
        switch (type) {
          case "AllowReadModelPermissionQuery":
            return "AllowReadModelValidationQuery.authUsers()";
          case "AllowWriteModelPermissionQuery":
            return "AllowWriteModelValidationQuery.authUsers()";
          case "AllowReadDocumentModelPermissionQuery":
            return "AllowReadDocumentModelValidationQuery.authUsers()";
          case "AllowReadCollectionModelPermissionQuery":
            return "AllowReadCollectionModelValidationQuery.authUsers()";
          case "AllowCreateModelPermissionQuery":
            return "AllowCreateModelValidationQuery.authUsers()";
          case "AllowUpdateModelPermissionQuery":
            return "AllowUpdateModelValidationQuery.authUsers()";
          case "AllowDeleteModelPermissionQuery":
            return "AllowDeleteModelValidationQuery.authUsers()";
        }
        break;
      case "userFromPath":
        final rulePath = path.rulePath;
        final convertedKey = path.keyFromRulePath(key);
        if (convertedKey.isEmpty) {
          return "";
        }
        final paths = rulePath.split("/");
        if (paths.length % 2 == 0) {
          paths.removeLast();
        }
        paths.add(_kUidFieldKey);
        final index = paths.indexOf("{$convertedKey}");
        if (index < 0) {
          return "";
        }
        switch (type) {
          case "AllowReadModelPermissionQuery":
            return "AllowReadModelValidationQuery.userFromPathIndex($index)";
          case "AllowWriteModelPermissionQuery":
            return "AllowWriteModelValidationQuery.userFromPathIndex($index)";
          case "AllowReadDocumentModelPermissionQuery":
            return "AllowReadDocumentModelValidationQuery.userFromPathIndex($index)";
          case "AllowReadCollectionModelPermissionQuery":
            return "AllowReadCollectionModelValidationQuery.userFromPathIndex($index)";
          case "AllowCreateModelPermissionQuery":
            return "AllowCreateModelValidationQuery.userFromPathIndex($index)";
          case "AllowUpdateModelPermissionQuery":
            return "AllowUpdateModelValidationQuery.userFromPathIndex($index)";
          case "AllowDeleteModelPermissionQuery":
            return "AllowDeleteModelValidationQuery.userFromPathIndex($index)";
        }
        break;
      case "userFromData":
        final trimedKey = key?.trimString("'").trimString('"');
        if (trimedKey is! String) {
          return "";
        }
        switch (type) {
          case "AllowReadModelPermissionQuery":
            return "AllowReadModelValidationQuery.userFromData(\"$trimedKey\")";
          case "AllowWriteModelPermissionQuery":
            return "AllowWriteModelValidationQuery.userFromData(\"$trimedKey\")";
          case "AllowReadDocumentModelPermissionQuery":
            return "AllowReadDocumentModelValidationQuery.userFromData(\"$trimedKey\")";
          case "AllowReadCollectionModelPermissionQuery":
            return "AllowReadCollectionModelValidationQuery.userFromData(\"$trimedKey\")";
          case "AllowCreateModelPermissionQuery":
            return "AllowCreateModelValidationQuery.userFromData(\"$trimedKey\")";
          case "AllowUpdateModelPermissionQuery":
            return "AllowUpdateModelValidationQuery.userFromData(\"$trimedKey\")";
          case "AllowDeleteModelPermissionQuery":
            return "AllowDeleteModelValidationQuery.userFromData(\"$trimedKey\")";
        }
        break;
    }
    return "";
  }
}
