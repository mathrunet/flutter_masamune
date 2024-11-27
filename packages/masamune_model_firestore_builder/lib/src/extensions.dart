part of '/masamune_model_firestore_builder.dart';

extension on InterfaceType {
  bool get isIterable {
    return isDartCoreIterable ||
        isDartCoreList ||
        isDartCoreSet ||
        isDartCoreMap;
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
    } else if (isDartCoreSet) {
      return "is$nullable${RuleType.list.label}";
    } else if (isDartCoreMap) {
      return "is$nullable${RuleType.map.label}";
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

extension on ModelPermissionQueryUserType {
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

  String code([String? key, bool isReference = false]) {
    switch (this) {
      case ModelPermissionQueryUserType.allUsers:
        return "true";
      case ModelPermissionQueryUserType.authUsers:
        return "isAuthUser()";
      case ModelPermissionQueryUserType.userFromPath:
        assert(key.isNotEmpty, "key is empty.");
        if (key == "@uid" || key == null) {
          return "isSpecifiedUser(uid)";
        }
        return "isSpecifiedUser($key)";
      case ModelPermissionQueryUserType.userFromData:
        assert(key.isNotEmpty, "key is empty.");
        if (isReference) {
          return "isSpecifiedUser(getReferenceUid(getResource(), \"$key\"))";
        }
        return "isSpecifiedUser(getValue(getResource(), \"$key\"))";
    }
  }
}

extension on List<RuleValue> {
  List<IndexValue> toIndexValueList() {
    final res = <IndexValue>[];
    for (final rule in this) {
      final path = rule.pathValue.path.trimQuery().trimString("/");
      final queries = rule.annotationValue.query ?? [];
      if (queries.isEmpty) {
        continue;
      }
      // コレクションパス
      if (path.splitLength() % 2 == 1) {
        final collectionId = path.split("/").last;
        for (final query in queries) {
          final index = query.toIndexValue(collectionId, rule);
          if (index != null) {
            res.add(index);
          }
        }
        // ドキュメントパス
      } else {
        final paths = path.split("/");
        final collectionId = paths[paths.length - 2];
        for (final query in queries) {
          final index = query.toIndexValue(collectionId, rule);
          if (index != null) {
            res.add(index);
          }
        }
      }
      final mirrorPath = rule.mirrorPathValue?.path.trimQuery().trimString("/");
      final mirrorQueries = rule.annotationValue.mirrorQuery ?? [];
      if (mirrorPath != null && mirrorQueries.isNotEmpty) {
        // コレクションパス
        if (mirrorPath.splitLength() % 2 == 1) {
          final collectionId = mirrorPath.split("/").last;
          for (final query in mirrorQueries) {
            final index = query.toIndexValue(collectionId, rule);
            if (index != null) {
              res.add(index);
            }
          }
          // ドキュメントパス
        } else {
          final paths = mirrorPath.split("/");
          final collectionId = paths[paths.length - 2];
          for (final query in mirrorQueries) {
            final index = query.toIndexValue(collectionId, rule);
            if (index != null) {
              res.add(index);
            }
          }
        }
      }
    }
    return res.distinct().toList();
  }
}

extension on QueryValue {
  IndexValue? toIndexValue(String collectionId, RuleValue rule) {
    final query = this;
    final conditions =
        query.getConditionsWithParameters(rule.classValue.parameters);
    if (conditions.isEmpty || !conditions.availableIndex()) {
      return null;
    }
    final isCollectionGroup =
        conditions.any((e) => e.type == "collectionGroup");
    final descKeys = <String>{};
    for (final condition in conditions) {
      if (condition.type == "orderByDesc") {
        descKeys.add(condition.key ?? "");
      }
    }
    final fields = <String, IndexFieldValue>{};
    for (final condition in conditions) {
      if (condition.type == "collectionGroup" ||
          condition.type == "orderByAsc" ||
          condition.type == "orderByDesc" ||
          condition.type == "limit") {
        continue;
      }
      final key = condition.parameter?.jsonKey ?? condition.parameter?.name;
      if (key == null) {
        continue;
      }
      final isArray = condition.parameter?.type.isIterable ?? false;
      fields[key] = IndexFieldValue(
        name: key,
        order:
            descKeys.contains(key) ? IndexOrderType.desc : IndexOrderType.asc,
        isArray: isArray,
      );
    }
    return IndexValue(
      collectionId: collectionId,
      queryScope: isCollectionGroup
          ? IndexScopeType.collectionGroup
          : IndexScopeType.collection,
      fields: fields.values.toList(),
    );
  }
}

extension on List<IndexValue> {
  List<DynamicMap> toJson() {
    return map((e) => e.toJson()).toList();
  }
}

extension on List<QueryConditionValue> {
  bool availableIndex() {
    final keys = map((e) => e.key).toSet();
    if (keys.length < 2) {
      return false;
    }
    if (every((e) => e.type == "equalTo")) {
      return false;
    }
    return true;
  }
}
