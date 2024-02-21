part of '/masamune_model_firestore_builder.dart';

/// Class for storing rule values.
///
/// ルールの値を格納するためのクラス。
class RuleValue {
  /// Class for storing rule values.
  ///
  /// ルールの値を格納するためのクラス。
  const RuleValue({
    required this.classValue,
    required this.pathValue,
    required this.annotationValue,
    this.mirrorPathValue,
  });

  /// The parsed value of the class.
  ///
  /// クラスのパースされた値。
  final ClassValue classValue;

  /// The parsed value of the path.
  ///
  /// パスのパースされた値。
  final PathValue pathValue;

  /// The parsed value of the mirror path.
  ///
  /// ミラーパスのパースされた値。
  final PathValue? mirrorPathValue;

  /// The parsed value of the annotation.
  ///
  /// アノテーションのパースされた値。
  final ModelAnnotationValue annotationValue;

  ///　Generate a rule.
  ///
  /// ルールを生成する。
  StringBuffer apply(StringBuffer buffer) {
    buffer = _applyAtPath(buffer, pathValue);
    if (mirrorPathValue == null) {
      return buffer;
    }
    buffer = _applyAtPath(buffer, mirrorPathValue!);
    return buffer;
  }

  StringBuffer _applyAtPath(StringBuffer buffer, PathValue pathValue) {
    final path = pathValue.rulePath;
    final functionName = classValue.name.toPascalCase();
    buffer.writeln("    match /$path {");
    if (annotationValue.permission == null) {
      buffer.writeln("      allow read, write: if true;");
    } else if (annotationValue.permission.isEmpty) {
      buffer.writeln("      allow read, write: if false;");
    } else {
      bool useFunction = false;
      for (final permission in annotationValue.permission!) {
        final permissionType = ModelPermissionQueryType.values.firstWhereOrNull(
          (item) => item.className == permission.type,
        );
        final userType = ModelPermissionQueryUserType.values.firstWhereOrNull(
          (item) => item.methodName == permission.user,
        );
        if (permissionType == null || userType == null) {
          continue;
        }
        final key = userType == ModelPermissionQueryUserType.userFromPath
            ? pathValue.keyFromRulePath(permission.key)
            : permission.key?.trimString("'").trimString('"');
        final isReference = classValue.parameters.any((e) {
          if (e.jsonKey != key && e.name != key) {
            return false;
          }
          return e.reference != null;
        });
        switch (permissionType) {
          case ModelPermissionQueryType.allowRead:
          case ModelPermissionQueryType.allowReadDocument:
          case ModelPermissionQueryType.allowReadCollection:
            buffer.writeln(
              "      ${permissionType.code}: if ${userType.code(key, isReference)};",
            );
            break;
          default:
            useFunction = true;
            buffer.writeln(
              "      ${permissionType.code}: if ${userType.code(key, isReference)} && verify$functionName(getResource());",
            );
            break;
        }
      }
      if (useFunction) {
        buffer.writeln("      function verify$functionName(data) {");
        final paramList = <String>[];
        for (final param in classValue.parameters) {
          final key = param.jsonKey ?? param.name;
          if (param.isSearchable && !paramList.contains("isSearchable(data)")) {
            paramList.add("isSearchable(data)");
          }
          if (param.isJsonSerializable) {
            if (param.type.isDartCoreList || param.type.isDartCoreSet) {
              paramList.add(
                "is${param.type.isNullable ? "Nullable" : ""}List(data, \"$key\")",
              );
            } else if (param.type.isDartCoreMap) {
              paramList.add(
                "is${param.type.isNullable ? "Nullable" : ""}Map(data, \"$key\")",
              );
            } else if (param.type.isDartCoreIterable) {
              paramList.add(
                "is${param.type.isNullable ? "Nullable" : ""}List(data, \"$key\")",
              );
            } else {
              paramList.add(
                "is${param.type.isNullable ? "Nullable" : ""}Map(data, \"$key\")",
              );
            }
          } else {
            final functionName = param.type.toRuleFunction();
            if (functionName.isNotEmpty) {
              paramList.add("$functionName(data, \"$key\")");
            }
          }
        }
        buffer.writeln(
            "        return isDocument(data) && ${paramList.join(" && ")};");
        buffer.writeln("      }");
      }
    }
    buffer.writeln("    }");
    return buffer;
  }
}
