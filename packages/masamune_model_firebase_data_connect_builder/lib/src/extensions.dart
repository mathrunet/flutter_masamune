part of "/masamune_model_firebase_data_connect_builder.dart";

extension on InterfaceType {
  /// Convert to type for parameters.
  ///
  /// By giving [reference], the conversion is performed in the case of a reference type.
  ///
  /// パラメーター向けのタイプに変換します。
  ///
  /// [reference]を与えることで、参照型の場合の変換を行います。
  String toParameterType({
    ReferenceValue? reference,
  }) {
    final nullable = isNullable ? "" : "!";
    if (isDartCoreString) {
      return "${SchemaType.string.label}$nullable";
    } else if (isDartCoreBool) {
      return "${SchemaType.bool.label}$nullable";
    } else if (isDartCoreInt) {
      return "${SchemaType.int.label}$nullable";
    } else if (isDartCoreDouble) {
      return "${SchemaType.float.label}$nullable";
    } else if (isDartCoreList) {
      return "${SchemaType.any.label}$nullable";
    } else if (isDartCoreSet) {
      return "${SchemaType.any.label}$nullable";
    } else if (isDartCoreMap) {
      return "${SchemaType.any.label}$nullable";
    } else if (isDartCoreEnum) {
      return "${SchemaType.string.label}$nullable";
    } else if (isModelRef) {
      if (reference?.type == ReferenceValueType.single) {
        if (_MasamuneModelFirebaseDataConnectBuilder.schemas
            .any((e) => e.classValue.name == reference?.modelType)) {
          return "${reference!.modelType}_Key";
        }
      }
      return "${SchemaType.any.label}$nullable";
    } else if (isModelCounter) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelTimestamp) {
      return "${SchemaType.timestamp.label}$nullable";
    } else if (isModelDate) {
      return "${SchemaType.date.label}$nullable";
    } else if (isModelTime) {
      return "${SchemaType.timestamp.label}$nullable";
    } else if (isModelTimestampRange) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelDateRange) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelTimeRange) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelSearch) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelToken) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelUri) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelImageUri) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelVideoUri) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelGeoValue) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelVectorValue) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelLocale) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelLocalizedValue) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelCommand) {
      return "${SchemaType.any.label}$nullable";
    }
    return "${SchemaType.any.label}$nullable";
  }

  /// Convert to type for schema.
  ///
  /// By giving [reference], the conversion is performed in the case of a reference type.
  ///
  /// スキーマ向けのタイプに変換します。
  ///
  /// [reference]を与えることで、参照型の場合の変換を行います。
  String toSchemaType({
    ReferenceValue? reference,
  }) {
    final nullable = isNullable ? "" : "!";
    if (isDartCoreString) {
      return "${SchemaType.string.label}$nullable";
    } else if (isDartCoreBool) {
      return "${SchemaType.bool.label}$nullable";
    } else if (isDartCoreInt) {
      return "${SchemaType.int.label}$nullable";
    } else if (isDartCoreDouble) {
      return "${SchemaType.float.label}$nullable";
    } else if (isDartCoreList) {
      return "${SchemaType.any.label}$nullable";
    } else if (isDartCoreSet) {
      return "${SchemaType.any.label}$nullable";
    } else if (isDartCoreMap) {
      return "${SchemaType.any.label}$nullable";
    } else if (isDartCoreEnum) {
      return "${SchemaType.string.label}$nullable";
    } else if (isModelRef) {
      if (reference?.type == ReferenceValueType.single) {
        if (_MasamuneModelFirebaseDataConnectBuilder.schemas
            .any((e) => e.classValue.name == reference?.modelType)) {
          return reference!.modelType;
        }
      }
      return "${SchemaType.any.label}$nullable";
    } else if (isModelCounter) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelTimestamp) {
      return "${SchemaType.timestamp.label}$nullable";
    } else if (isModelDate) {
      return "${SchemaType.date.label}$nullable";
    } else if (isModelTime) {
      return "${SchemaType.timestamp.label}$nullable";
    } else if (isModelTimestampRange) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelDateRange) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelTimeRange) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelSearch) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelToken) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelUri) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelImageUri) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelVideoUri) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelGeoValue) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelVectorValue) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelLocale) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelLocalizedValue) {
      return "${SchemaType.any.label}$nullable";
    } else if (isModelCommand) {
      return "${SchemaType.any.label}$nullable";
    }
    return "${SchemaType.any.label}$nullable";
  }

  /// Check if it is [dynamic].
  ///
  /// [dynamic]かどうかをチェックします。
  bool isAny({
    ReferenceValue? reference,
  }) {
    final type = toSchemaType(reference: reference);
    return type.startsWith(SchemaType.any.label);
  }
}

extension on ParamaterValue {
  /// Outputs parameter codes for the schema.
  ///
  /// スキーマ向けのパラメーターコードを出力します。
  String schemaCode({String prefix = "  "}) {
    if (IgnoredValue.contains(name)) {
      throw Exception("$name is a reserved word.");
    }
    final type = this.type.toSchemaType(reference: reference);
    final col =
        jsonKey.isEmpty || jsonKey == name ? "" : " @col(name: \"$jsonKey\")";
    final ref = reference != null ? " @ref" : "";
    return "$prefix${name.toCamelCase()}: $type$col$ref";
  }

  /// Output parameter code for Upsert.
  ///
  /// Upsert向けのパラメーターコードを出力します。
  String upsertParameterCode({String prefix = "  "}) {
    if (IgnoredValue.contains(name)) {
      throw Exception("$name is a reserved word.");
    }
    final type = this.type.toParameterType(reference: reference);
    return "$prefix\$${name.toCamelCase()}: $type,";
  }

  /// Output field codes for Upsert.
  ///
  /// Upsert向けのフィールドコードを出力します。
  String upsertFieldCode({String prefix = "    "}) {
    if (IgnoredValue.contains(name)) {
      throw Exception("$name is a reserved word.");
    }
    return "$prefix${name.toCamelCase()}: \$${name.toCamelCase()},";
  }

  /// Outputs field codes for Read.
  ///
  /// Read向けのフィールドコードを出力します。
  String retrieveFieldCode({String prefix = "    "}) {
    if (IgnoredValue.contains(name)) {
      throw Exception("$name is a reserved word.");
    }
    final typeString = type.toSchemaType(reference: reference);
    final referenceType =
        _MasamuneModelFirebaseDataConnectBuilder.schemas.firstWhereOrNull(
      (e) => e.classValue.name == typeString,
    );
    if (referenceType != null) {
      final additionalPrefix = "$prefix  ";
      var res = "$prefix${name.toCamelCase()} {\n";
      res += "${additionalPrefix}uid,\n";
      for (final field in referenceType.classValue.parameters) {
        res += "${field.retrieveFieldCode(prefix: additionalPrefix)}\n";
      }
      return "$res$prefix},";
    }
    return "$prefix${name.toCamelCase()},";
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

  /// Actual code.
  ///
  /// 実際のコード。
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

  /// Actual code.
  ///
  /// 実際のコード。
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

/// Extension method of [ModelDatabaseQuery].
///
/// [ModelDatabaseQuery]の拡張メソッド。
extension QueryConditionValueListExtension on List<QueryConditionValue> {
  /// Converted to Where code.
  ///
  /// Whereのコードに変換。
  List<String> toWhereCode() {
    // 同じキーでまとめる
    final res = <String>[];
    final map = <String, List<QueryConditionValue>>{};
    for (final condition in this) {
      final key = condition.key?.toCamelCase();
      if (key == null) {
        continue;
      }
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(condition);
    }
    for (final entry in map.entries) {
      final key = entry.key;
      final conditions = entry.value;
      if (conditions.isEmpty) {
        continue;
      }

      final tmp = conditions._toWhereValueCode(key);
      if (tmp.isNotEmpty) {
        res.add("        { $key: { $tmp } },");
      }
    }
    return res;
  }

  String _toWhereValueCode(String key) {
    final conditions = <String>[];
    if (every(
      (e) =>
          e.type == "lessThan" ||
          e.type == "lessThanOrEqualTo" ||
          e.type == "greaterThan" ||
          e.type == "greaterThanOrEqualTo",
    )) {
      final greaterThanOrEqualTo =
          firstWhereOrNull((e) => e.type == "greaterThanOrEqualTo");
      if (greaterThanOrEqualTo != null) {
        conditions.add("ge: \$${key}GreaterThanOrEqualTo");
      } else {
        final greaterThan = firstWhereOrNull((e) => e.type == "greaterThan");
        if (greaterThan != null) {
          conditions.add("gt: \$${key}GreaterThan");
        }
      }
      final lessThanOrEqualTo =
          firstWhereOrNull((e) => e.type == "lessThanOrEqualTo");
      if (lessThanOrEqualTo != null) {
        conditions.add("le: \$${key}LessThanOrEqualTo");
      } else {
        final lessThan = firstWhereOrNull((e) => e.type == "lessThan");
        if (lessThan != null) {
          conditions.add("lt: \$${key}LessThan");
        }
      }
      return conditions.join(", ");
    } else {
      final filtered = where(
        (e) =>
            e.type != "lessThan" &&
            e.type != "lessThanOrEqualTo" &&
            e.type != "greaterThan" &&
            e.type != "greaterThanOrEqualTo",
      ).first;
      switch (filtered.type) {
        case "equalTo":
          return "eq: \$${key}EqualTo";
        case "notEqualTo":
          return "ne: \$${key}NotEqualTo";
        case "arrayContains":
          return "includes: \$${key}ArrayContains";
        case "arrayContainsAny":
          return "includes: \$${key}ArrayContainsAny";
        case "whereIn":
          return "in: \$${key}WhereIn";
        case "whereNotIn":
          return "nin: \$${key}WhereNotIn";
        case "isNull":
          return "isNull: true";
        case "isNotNull":
          return "isNull: false";
        case "like":
          return "contains: \$${key}Like";
      }
    }
    return "";
  }

  /// Converted to orderBy code.
  ///
  /// orderByのコードに変換。
  List<String> toOrderByCode() {
    // 同じキーでまとめる
    final res = <String>[];
    final map = <String, QueryConditionValue>{};
    for (final condition in this) {
      final key = condition.key;
      if (key == null) {
        continue;
      }
      if (map[key] != null) {
        continue;
      }
      map[key] = condition;
    }
    for (final entry in map.entries) {
      final key = entry.key;
      final condition = entry.value;
      final isAsc = condition.type == "orderByAsc";

      res.add("$key: ${isAsc ? "ASC" : "DESC"},");
    }
    return res;
  }

  /// Converted to required query parameters.
  ///
  /// 必須のクエリパラメーターに変換。
  String toRequiredQueryParameters() {
    return mapAndRemoveEmpty((e) {
      if (e.type == "limit" ||
          e.type == "collectionGroup" ||
          e.type == "orderByAsc" ||
          e.type == "orderByDesc" ||
          e.type == "whereIn" ||
          e.type == "whereNotIn" ||
          e.type == "arrayContainsAny") {
        return null;
      }
      if (e.parameter?.type.isNullable ?? false) {
        return null;
      }
      final filterType = e.type.toFilterType();
      if (filterType.isEmpty) {
        return null;
      }
      if (e.parameter?.type.isAny() ?? false) {
        return "${e.key?.toCamelCase() ?? ""}${e.type.toPascalCase()}: filterAnyValue(filterQuery(query.query.filters.firstWhere((e) => e.type == ModelQueryFilterType.$filterType && e.key == \"${e.key?.toCamelCase() ?? ""}\"), query))";
      } else {
        return "${e.key?.toCamelCase() ?? ""}${e.type.toPascalCase()}: filterQuery(query.query.filters.firstWhere((e) => e.type == ModelQueryFilterType.$filterType && e.key == \"${e.key?.toCamelCase() ?? ""}\"), query)";
      }
    }).join(", ");
  }

  /// Converted to optional query parameters.
  ///
  /// 任意のクエリパラメーターに変換。
  String toOptionalQueryParameters() {
    return mapAndRemoveEmpty((e) {
      if (e.type == "limit" ||
          e.type == "collectionGroup" ||
          e.type == "orderByAsc" ||
          e.type == "orderByDesc") {
        return null;
      }
      if (e.type == "whereIn" ||
          e.type == "whereNotIn" ||
          e.type == "arrayContainsAny") {
        final filterType = e.type.toFilterType();
        if (filterType.isEmpty) {
          return null;
        }
        if (e.parameter?.type.isAny() ?? false) {
          return ".${e.key?.toCamelCase() ?? ""}${e.type.toPascalCase()}(filterAnyValue(filterQueryWithNullable(query.query.filters.firstWhereOrNull((e) => e.type == ModelQueryFilterType.$filterType && e.key == \"${e.key?.toCamelCase() ?? ""}\"), query)))";
        } else {
          return ".${e.key?.toCamelCase() ?? ""}${e.type.toPascalCase()}(filterQueryWithNullable(query.query.filters.firstWhereOrNull((e) => e.type == ModelQueryFilterType.$filterType && e.key == \"${e.key?.toCamelCase() ?? ""}\"), query))";
        }
      } else {
        if (e.parameter?.type.isNullable != true) {
          return null;
        }
        final filterType = e.type.toFilterType();
        if (filterType.isEmpty) {
          return null;
        }
        if (e.parameter?.type.isAny() ?? false) {
          return ".${e.key?.toCamelCase() ?? ""}${e.type.toPascalCase()}(filterAnyValue(filterQueryWithNullable(query.query.filters.firstWhereOrNull((e) => e.type == ModelQueryFilterType.$filterType && e.key == \"${e.key?.toCamelCase() ?? ""}\"), query)))";
        } else {
          return ".${e.key?.toCamelCase() ?? ""}${e.type.toPascalCase()}(filterQueryWithNullable(query.query.filters.firstWhereOrNull((e) => e.type == ModelQueryFilterType.$filterType && e.key == \"${e.key?.toCamelCase() ?? ""}\"), query))";
        }
      }
    }).join("");
  }
}

extension on String? {
  String toFilterType() {
    switch (this) {
      case "equalTo":
        return "equalTo";
      case "notEqualTo":
        return "notEqualTo";
      case "lessThan":
        return "lessThan";
      case "lessThanOrEqualTo":
        return "lessThanOrEqualTo";
      case "greaterThan":
        return "greaterThan";
      case "greaterThanOrEqualTo":
        return "greaterThanOrEqualTo";
      case "arrayContains":
        return "arrayContains";
      case "arrayContainsAny":
        return "arrayContainsAny";
      case "whereIn":
        return "whereIn";
      case "whereNotIn":
        return "whereNotIn";
      case "isNull":
        return "isNull";
      case "isNotNull":
        return "isNotNull";
      case "like":
        return "like";
      case "geoHash":
        return "geoHash";
    }
    return "";
  }
}
