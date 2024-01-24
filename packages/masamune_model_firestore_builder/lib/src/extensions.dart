part of '/masamune_model_firestore_builder.dart';

extension _DartTypeExtensions on DartType {
  bool get isNullable {
    return toString().endsWith("?");
  }

  String get aliasName {
    final aliasElement = alias?.element;
    if (aliasElement != null) {
      return aliasElement.name;
    }
    return toString();
  }

  String toRuleFunction() {
    final nullable = isNullable ? "Nullable" : "";
    if (isDartCoreString) {
      return "is$nullable${RuleType.string.label}";
    } else if (isDartCoreBool) {
      return "is$nullable${RuleType.bool.label}";
    } else if (isDartCoreInt) {
      return "is$nullable${RuleType.int.label}";
    } else if (isDartCoreDouble) {
      return "is$nullable${RuleType.double.label}";
    } else if (isDartCoreList) {
      return "is$nullable${RuleType.list.label}";
    } else if (isDartCoreMap) {
      return "is$nullable${RuleType.map.label}";
    } else if (isDartCoreSet) {
      return "is$nullable${RuleType.list.label}";
    } else if (isDartCoreEnum) {
      return "is${nullable}Enum";
    } else {
      final aliasName = this.aliasName.trimStringRight("?");
      for (final type in RuleModelFieldValueType.values) {
        if (type.label != aliasName) {
          continue;
        }
        return "is$nullable${type.label}";
      }
    }
    return "";
  }
}

/// Extension method of [ModelPermissionQueryType].
///
/// [ModelPermissionQueryType]の拡張メソッド。
extension ModelPermissionQueryTypeExtension on ModelPermissionQueryType {
  /// Class Name.
  ///
  /// クラス名。
  String get className {
    switch (this) {
      case ModelPermissionQueryType.allowRead:
        return "AllowReadModelPermissionQuery";
      case ModelPermissionQueryType.allowWrite:
        return "AllowWriteModelPermissionQuery";
      case ModelPermissionQueryType.allowReadDocument:
        return "AllowReadDocumentModelPermissionQuery";
      case ModelPermissionQueryType.allowReadCollection:
        return "AllowReadCollectionModelPermissionQuery";
      case ModelPermissionQueryType.allowCreate:
        return "AllowCreateModelPermissionQuery";
      case ModelPermissionQueryType.allowUpdate:
        return "AllowUpdateModelPermissionQuery";
      case ModelPermissionQueryType.allowDelete:
        return "AllowDeleteModelPermissionQuery";
    }
  }

  String get code {
    switch (this) {
      case ModelPermissionQueryType.allowRead:
        return "allow read";
      case ModelPermissionQueryType.allowWrite:
        return "allow write";
      case ModelPermissionQueryType.allowReadDocument:
        return "allow get";
      case ModelPermissionQueryType.allowReadCollection:
        return "allow list";
      case ModelPermissionQueryType.allowCreate:
        return "allow create";
      case ModelPermissionQueryType.allowUpdate:
        return "allow update";
      case ModelPermissionQueryType.allowDelete:
        return "allow delete";
    }
  }
}

/// Extension method of [ModelPermissionQueryUserType].
///
/// [ModelPermissionQueryUserType]の拡張メソッド。
extension ModelPermissionQueryUserTypeExtension
    on ModelPermissionQueryUserType {
  /// Method Name.
  ///
  /// メソッド名。
  String get methodName {
    switch (this) {
      case ModelPermissionQueryUserType.allUsers:
        return "allUsers";
      case ModelPermissionQueryUserType.authUsers:
        return "authUsers";
      case ModelPermissionQueryUserType.userFromPath:
        return "userFromPath";
      case ModelPermissionQueryUserType.userFromData:
        return "userFromData";
    }
  }

  String code([String? key]) {
    switch (this) {
      case ModelPermissionQueryUserType.allUsers:
        return "true";
      case ModelPermissionQueryUserType.authUsers:
        return "isAuthUser()";
      case ModelPermissionQueryUserType.userFromPath:
        assert(key.isNotEmpty, "key is empty.");
        return "isSpecifiedUser($key)";
      case ModelPermissionQueryUserType.userFromData:
        assert(key.isNotEmpty, "key is empty.");
        return "isSpecifiedUser($key)";
    }
  }
}
