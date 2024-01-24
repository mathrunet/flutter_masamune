part of '/masamune_model_firestore_builder.dart';

extension _InterfaceTypeExtensions on InterfaceType {
  bool get isNullable {
    return toString().endsWith("?");
  }

  List<InterfaceType> get allTypes {
    return [this, ...allSupertypes];
  }

  bool get isModelRef {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelRefBase\<[^>]+\>")),
    );
  }

  bool get isModelCounter {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelCounter")),
    );
  }

  bool get isModelTimestamp {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelTimestamp")),
    );
  }

  bool get isModelDate {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelDate")),
    );
  }

  bool get isModelSearch {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelSearch")),
    );
  }

  bool get isModelToken {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelToken")),
    );
  }

  bool get isModelUri {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelUri")),
    );
  }

  bool get isModelImageUri {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelImageUri")),
    );
  }

  bool get isModelVideoUri {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelVideoUri")),
    );
  }

  bool get isModelGeoValue {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelGeoValue")),
    );
  }

  bool get isModelLocale {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelLocale")),
    );
  }

  bool get isModelLocalizedValue {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelLocalizedValue")),
    );
  }

  bool get isModelCommand {
    return allTypes.any(
      (e) => e.toString().startsWith(RegExp(r"^ModelCommandBase")),
    );
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
    } else if (isModelRef) {
      return "is$nullable${RuleModelFieldValueType.modelRef.label}";
    } else if (isModelCounter) {
      return "is$nullable${RuleModelFieldValueType.modelCounter.label}";
    } else if (isModelTimestamp) {
      return "is$nullable${RuleModelFieldValueType.modelTimestamp.label}";
    } else if (isModelDate) {
      return "is$nullable${RuleModelFieldValueType.modelDate.label}";
    } else if (isModelSearch) {
      return "is$nullable${RuleModelFieldValueType.modelSearch.label}";
    } else if (isModelToken) {
      return "is$nullable${RuleModelFieldValueType.modelToken.label}";
    } else if (isModelUri) {
      return "is$nullable${RuleModelFieldValueType.modelUri.label}";
    } else if (isModelImageUri) {
      return "is$nullable${RuleModelFieldValueType.modelImageUri.label}";
    } else if (isModelVideoUri) {
      return "is$nullable${RuleModelFieldValueType.modelVideoUri.label}";
    } else if (isModelGeoValue) {
      return "is$nullable${RuleModelFieldValueType.modelGeoValue.label}";
    } else if (isModelLocale) {
      return "is$nullable${RuleModelFieldValueType.modelLocale.label}";
    } else if (isModelLocalizedValue) {
      return "is$nullable${RuleModelFieldValueType.modelLocalizedValue.label}";
    } else if (isModelCommand) {
      return "is$nullable${RuleModelFieldValueType.modelCommand.label}";
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
