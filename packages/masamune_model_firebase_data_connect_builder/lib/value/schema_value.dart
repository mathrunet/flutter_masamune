part of '/masamune_model_firebase_data_connect_builder.dart';

/// Class for storing schema values.
///
/// スキーマの値を格納するためのクラス。
class SchemaValue {
  /// Class for storing schema values.
  ///
  /// スキーマの値を格納するためのクラス。
  const SchemaValue({
    required this.classValue,
    required this.firebaseDataConnectAnnotationValue,
    required this.modelAnnotationValue,
  });

  /// Build the schema.
  ///
  /// スキーマをビルドします。
  String buildType() {
    final buffer = StringBuffer();
    buffer.writeln(
        "type ${classValue.name.toPascalCase()} @table(key: [\"uid\"]) {");
    buffer.writeln("  uid: String!");
    for (final field in classValue.parameters) {
      buffer.writeln(field.schemaCode());
    }
    buffer.writeln("}");
    return buffer.toString();
  }

  /// Build the query.
  ///
  /// クエリーをビルドします。
  String buildQuery() {
    final buffer = StringBuffer();
    final documentAuthType = modelAnnotationValue.toAuthType(permissionType: [
      ModelPermissionQueryType.allowReadDocument,
      ModelPermissionQueryType.allowRead,
    ]);
    final collectionAuthType = modelAnnotationValue.toAuthType(permissionType: [
      ModelPermissionQueryType.allowReadCollection,
      ModelPermissionQueryType.allowRead,
    ]);
    buffer.writeln("query ${classValue.name.toPascalCase()}Document(");
    buffer.writeln("  \$uid: ${classValue.name.toPascalCase()}_Key!,");
    buffer.writeln(") @auth(level: ${documentAuthType.label}) {");
    buffer.writeln("  ${classValue.name.toCamelCase()}(key: \$uid) {");
    buffer.writeln("    uid,");
    for (final field in classValue.parameters) {
      buffer.writeln(field.retrieveFieldCode());
    }
    buffer.writeln("  }");
    buffer.writeln("}");
    buffer.writeln();
    buffer.writeln("query ${classValue.name.toPascalCase()}Collection(");
    buffer.writeln("  \$limit: Int! = 100,");
    buffer.writeln(") @auth(level: ${collectionAuthType.label}) {");
    buffer.writeln("  ${classValue.name.toCamelCase()}s(limit: \$limit) {");
    buffer.writeln("    uid,");
    for (final field in classValue.parameters) {
      buffer.writeln(field.retrieveFieldCode());
    }
    buffer.writeln("  }");
    buffer.writeln("}");
    return buffer.toString();
  }

  /// Build the mutation.
  ///
  /// ミューテーションをビルドします。
  String buildMutation() {
    final buffer = StringBuffer();
    final createAuthType = modelAnnotationValue.toAuthType(permissionType: [
      ModelPermissionQueryType.allowCreate,
      ModelPermissionQueryType.allowUpdate,
      ModelPermissionQueryType.allowWrite,
    ]);
    final deleteAuthType = modelAnnotationValue.toAuthType(permissionType: [
      ModelPermissionQueryType.allowDelete,
      ModelPermissionQueryType.allowWrite,
    ]);
    buffer.writeln("mutation Upsert${classValue.name.toPascalCase()}(");
    buffer.writeln("  \$uid: String!,");
    for (final field in classValue.parameters) {
      buffer.writeln(field.upsertParameterCode());
    }
    buffer.writeln(") @auth(level: ${createAuthType.label}) {");
    buffer.writeln("  ${classValue.name.toCamelCase()}_upsert(data: {");
    buffer.writeln("    uid: \$uid,");
    for (final field in classValue.parameters) {
      buffer.writeln(field.upsertFieldCode());
    }
    buffer.writeln("  })");
    buffer.writeln("}");
    buffer.writeln();
    buffer.writeln("mutation Delete${classValue.name.toPascalCase()}(");
    buffer.writeln("  \$uid: ${classValue.name.toPascalCase()}_Key!,");
    buffer.writeln(") @auth(level: ${deleteAuthType.label}) {");
    buffer.writeln("  ${classValue.name.toCamelCase()}_delete(key: \$uid)");
    buffer.writeln("}");
    return buffer.toString();
  }

  /// The parsed value of the class.
  ///
  /// クラスのパースされた値。
  final ClassValue classValue;

  /// The parsed value of the annotation.
  ///
  /// アノテーションのパースされた値。
  final FirebaseDataConnectAnnotationValue firebaseDataConnectAnnotationValue;

  /// The parsed value of the annotation.
  ///
  /// アノテーションのパースされた値。
  final ModelAnnotationValue modelAnnotationValue;
}

/// Class for storing annotation values.
///
/// Specify the class element in [element] and the annotation type in [annotationType].
///
/// アノテーションの値を保存するためのクラス。
///
/// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
class FirebaseDataConnectAnnotationValue {
  /// Class for storing annotation values.
  ///
  /// Specify the class element in [element] and the annotation type in [annotationType].
  ///
  /// アノテーションの値を保存するためのクラス。
  ///
  /// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
  FirebaseDataConnectAnnotationValue(this.element, this.annotationType) {
    final matcher = TypeChecker.fromRuntime(annotationType);
    for (final meta in element.metadata) {
      final obj = meta.computeConstantValue()!;
      if (matcher.isExactlyType(obj.type!)) {
        schemaDirPath =
            obj.getField("schemaDirPath")?.toStringValue()?.trimString("/") ??
                "";
        dataConnectorRootDirPath = obj
                .getField("dataConnectorRootDirPath")
                ?.toStringValue()
                ?.trimString("/") ??
            "";
        dartDirPath =
            obj.getField("dartDirPath")?.toStringValue()?.trimString("/") ?? "";
        dartPackage =
            obj.getField("dartPackage")?.toStringValue()?.trimString("/") ?? "";
        connectorDirPath = "$dataConnectorRootDirPath/$dartPackage";
        return;
      }
    }
    schemaDirPath = "";
    dataConnectorRootDirPath = "";
    dartDirPath = "";
    dartPackage = "";
    connectorDirPath = "";
  }

  /// Check if the class element has
  ///
  /// クラスエレメントが指定したアノテーションを持っているか確認します。
  static bool hasMatch(ClassElement element, Type annotationType) {
    final matcher = TypeChecker.fromRuntime(annotationType);
    for (final meta in element.metadata) {
      final obj = meta.computeConstantValue()!;
      if (matcher.isExactlyType(obj.type!)) {
        return true;
      }
    }
    return false;
  }

  /// Class Element.
  ///
  /// クラスエレメント。
  final ClassElement element;

  /// Annotation Type
  ///
  /// アノテーションのタイプ
  final Type annotationType;

  /// Specify the directory where the schema files will be output.
  ///
  /// スキーマファイルを出力するディレクトリを指定します。
  late final String schemaDirPath;

  /// The root directory of DataConnect.
  ///
  /// DataConnectのルートディレクトリ。
  late final String dataConnectorRootDirPath;

  /// Specify a directory to output connector files.
  ///
  /// コネクタファイルを出力するディレクトリを指定します。
  late final String connectorDirPath;

  /// Specify the directory to output Dart files.
  ///
  /// Dart用のファイルを出力するディレクトリを指定します。
  late final String dartDirPath;

  /// Specify the Dart package name.
  ///
  /// Dartのパッケージ名を指定します。
  late final String dartPackage;
}
