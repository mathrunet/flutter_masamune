part of '/masamune_model_firebase_data_connect_builder.dart';

/// Create an Adapter class.
///
/// Pass the class information defined in [classValue] and the value for the schema in [schemas].
///
/// Adapterクラスを作成します。
///
/// [classValue]に定義されたクラス情報、[schemas]にスキーマ用の値を渡します。
List<Spec> adapterClass(
  ClassValue classValue,
  List<SchemaValue> schemas,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${classValue.name}"
        ..abstract = true
        ..extend = const Reference("FirebaseDataConnectModelAdapterBase")
        ..constructors.addAll([
          Constructor(
            (c) => c..constant = true,
          ),
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "loadDocument"
              ..modifier = MethodModifier.async
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("Future<Map<String, dynamic>>")
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "query"
                    ..type = const Reference("ModelAdapterDocumentQuery"),
                )
              ])
              ..body = Code(
                "await initialize(); if (!query.reload || query.reference) { final res = await localDatabase.loadDocument(query); if (res != null) { return res; } } final path = query.query.path.trimQuery().trimString(\"/\"); ${schemas.map((e) => e.toLoadDocument(schemas)).join(" ")} throw UnimplementedError(\"This path is not implemented: \$path\");",
              ),
          ),
          Method(
            (m) => m
              ..name = "loadCollection"
              ..modifier = MethodModifier.async
              ..annotations.addAll([const Reference("override")])
              ..returns =
                  const Reference("Future<Map<String, Map<String, dynamic>>>")
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "query"
                    ..type = const Reference("ModelAdapterCollectionQuery"),
                )
              ])
              ..body = Code(
                "await initialize(); if (!query.reload) { final res = await localDatabase.loadCollection(query); if (res != null) { return res; } } final path = query.query.path.trimQuery().trimString(\"/\"); ${schemas.map((e) => e.toLoadCollection(schemas)).join(" ")} throw UnimplementedError(\"This path is not implemented: \$path\");",
              ),
          ),
          Method(
            (m) => m
              ..name = "saveDocument"
              ..modifier = MethodModifier.async
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("Future<void>")
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "query"
                    ..type = const Reference("ModelAdapterDocumentQuery"),
                ),
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = const Reference("Map<String, dynamic>"),
                )
              ])
              ..body = Code(
                "await initialize(); final path = query.query.path.trimQuery().trimString(\"/\"); ${schemas.map((e) => e.toSaveDocument(schemas)).join(" ")} throw UnimplementedError(\"This path is not implemented: \$path\");",
              ),
          ),
          Method(
            (m) => m
              ..name = "deleteDocument"
              ..modifier = MethodModifier.async
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("Future<void>")
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "query"
                    ..type = const Reference("ModelAdapterDocumentQuery"),
                ),
              ])
              ..body = Code(
                "await initialize(); final path = query.query.path.trimQuery().trimString(\"/\"); ${schemas.map((e) => e.toDeleteDocument(schemas)).join(" ")} throw UnimplementedError(\"This path is not implemented: \$path\");",
              ),
          )
        ]),
    ),
  ];
}

extension on SchemaValue {
  String toLoadDocument(List<SchemaValue> schemas) {
    final path = documentPathRegExp;
    if (path == null) {
      return "";
    }
    final connector =
        "${firebaseDataConnectAnnotationValue.dartPackage.toPascalCase()}Connector";
    return "if($path.hasMatch(path)){ final ref = await $connector.instance.${classValue.name.toCamelCase()}Document( uid: ${classValue.name.toPascalCase()}DocumentVariablesUid(uid: path)).execute(); final value = ref.data.${classValue.name.toCamelCase()}; if (value == null) { return {}; } final res = { ${toLoadParameters(schemas)} }; ${toLoadReferences(schemas)} await localDatabase.syncDocument(query, res); return res; }";
  }

  String toLoadCollection(List<SchemaValue> schemas) {
    final path = collectionPathRegExp;
    if (path == null) {
      return "";
    }
    final connector =
        "${firebaseDataConnectAnnotationValue.dartPackage.toPascalCase()}Connector";
    return "if($path.hasMatch(path)){ switch(query.query.name){ ${modelAnnotationValue.query?.map((query) => _toLoadCollection(schemas, query)).join("") ?? ""} default: final ref = await $connector.instance.${classValue.name.toCamelCase()}Collection().execute(); final res = <String, Map<String, dynamic>>{}; for (final value in ref.data.${classValue.name.toCamelCase()}s) { final uid = value.uid.trimQuery().trimString(\"/\").last(); res[uid] = { ${toLoadParameters(schemas)} }; ${toLoadReferences(schemas, querySuffix: "create().")} } await localDatabase.syncCollection(query, res); return res; } }";
  }

  String _toLoadCollection(List<SchemaValue> schemas, QueryValue query) {
    final conditions = query.getConditionsWithParameters(classValue.parameters);
    final connector =
        "${firebaseDataConnectAnnotationValue.dartPackage.toPascalCase()}Connector";
    return "case \"_${query.name.toCamelCase()}Query\": final ref = await $connector.instance.${classValue.name.toCamelCase()}${query.name.toPascalCase()}Query(${conditions.toRequiredQueryParameters()})${conditions.toOptionalQueryParameters()}.execute(); final res = <String, Map<String, dynamic>>{}; for (final value in ref.data.${classValue.name.toCamelCase()}s) { final uid = value.uid.trimQuery().trimString(\"/\").last(); res[uid] = { ${toLoadParameters(schemas)} }; ${toLoadReferences(schemas, querySuffix: "create().")} } await localDatabase.syncCollection(query, res); return res;";
  }

  String toSaveDocument(List<SchemaValue> schemas) {
    final path = documentPathRegExp;
    if (path == null) {
      return "";
    }
    final connector =
        "${firebaseDataConnectAnnotationValue.dartPackage.toPascalCase()}Connector";
    return "if($path.hasMatch(path)){ var ref = $connector.instance.upsert${classValue.name.toPascalCase()}( uid: path, ${toSaveParameters(schemas)} ); ${toSaveNullableParameters(schemas)} ${toSaveReferences(schemas)} await ref.execute(); await localDatabase.saveDocument(query, value); return; }";
  }

  String toDeleteDocument(List<SchemaValue> schemas) {
    final path = documentPathRegExp;
    if (path == null) {
      return "";
    }
    final connector =
        "${firebaseDataConnectAnnotationValue.dartPackage.toPascalCase()}Connector";
    return "if($path.hasMatch(path)){ await $connector.instance.delete${classValue.name.toPascalCase()}( uid: Delete${classValue.name.toPascalCase()}VariablesUid(uid: path) ).execute(); await localDatabase.deleteDocument(query); return; }";
  }

  String? get documentPathRegExp {
    final path = modelAnnotationValue.path;
    if (path == null) {
      return null;
    }
    return "RegExp(r\"^${"$path/:uid".replaceAllMapped(
          RegExp(r":([^/]+)"),
          (match) => "([^/]+)",
        ).trimString("/")}\$\")";
  }

  String? get collectionPathRegExp {
    final path = modelAnnotationValue.path;
    if (path == null) {
      return null;
    }
    return "RegExp(r\"^${path.replaceAllMapped(
          RegExp(r":([^/]+)"),
          (match) => "([^/]+)",
        ).trimString("/")}\$\")";
  }

  String toLoadParameters(List<SchemaValue> schemas, {String prefix = ""}) {
    return classValue.parameters.mapAndRemoveEmpty((param) {
      final name = param.jsonKey ?? param.name;
      if (param.reference != null) {
        return "\"$name\": value.$prefix$name?.uid != null ? ModelRefBase.fromPath(value.$prefix$name?.uid ?? \"\").toJson() : null";
      }
      return "\"$name\": value.$prefix$name";
    }).join(", ");
  }

  String toLoadReferences(List<SchemaValue> schemas,
      {String prefix = "", String querySuffix = ""}) {
    return classValue.parameters.mapAndRemoveEmpty((param) {
      if (param.reference == null) {
        return null;
      }
      final schema = schemas.firstWhereOrNull(
          (e) => e.classValue.name == param.reference?.modelType);
      if (schema == null) {
        return null;
      }

      final name = param.jsonKey ?? param.name;
      return "if (value.$prefix$name?.uid != null) { final res${prefix.toPascalCase()}${name.toPascalCase()} = { ${schema.toLoadParameters(schemas, prefix: "$prefix$name?.")} }; ${schema.toLoadReferences(schemas, prefix: "$prefix$name?.", querySuffix: querySuffix)} await localDatabase.syncDocument( query.${querySuffix}copyWith( query: query.query.${querySuffix}copyWith(path: value.$prefix$name?.uid ?? \"\")), res${prefix.toPascalCase()}${name.toPascalCase()}); }";
    }).join(" ");
  }

  String toSaveParameters(List<SchemaValue> schemas) {
    return classValue.parameters.mapAndRemoveEmpty((param) {
      if (param.reference != null) {
        return null;
      }
      if (param.type.isNullable) {
        return null;
      }
      final name = param.jsonKey ?? param.name;
      return "$name: value[\"$name\"]";
    }).join(", ");
  }

  String toSaveNullableParameters(List<SchemaValue> schemas) {
    return classValue.parameters.mapAndRemoveEmpty((param) {
      final name = param.jsonKey ?? param.name;
      if (param.reference != null) {
        return null;
      }
      if (!param.type.isNullable) {
        return null;
      }
      return "ref = ref.$name( value[\"$name\"] );";
    }).join(" ");
  }

  String toSaveReferences(List<SchemaValue> schemas) {
    return classValue.parameters.mapAndRemoveEmpty((param) {
      if (param.reference == null) {
        return null;
      }
      final schema = schemas.firstWhereOrNull(
          (e) => e.classValue.name == param.reference?.modelType);
      if (schema == null) {
        return null;
      }

      final name = param.jsonKey ?? param.name;
      return "final ${name.toCamelCase()}Uid = value.getAsMap(\"$name\").get(ModelRefBase.kRefKey, \"\").trimQuery().trimString(\"/\"); if (${name.toCamelCase()}Uid.isNotEmpty) { ref = ref.$name( Upsert${classValue.name.toPascalCase()}Variables${name.toPascalCase()}(uid: ${name.toCamelCase()}Uid), ); }";
    }).join(" ");
  }
}
