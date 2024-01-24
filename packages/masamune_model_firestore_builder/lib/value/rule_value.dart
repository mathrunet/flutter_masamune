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
      buffer.writeln("      function verify$functionName(data) {");
      final paramList = <String>[];
      for (final param in classValue.parameters) {
        final key = param.jsonKey ?? param.name;
        if (param.isSearchable && !paramList.contains("isSearchable(data)")) {
          paramList.add("isSearchable(data)");
        }
        if (param.isJsonSerializable) {
          paramList.add(
            "is${param.type.isNullable ? "Nullable" : ""}Map(data, \"$key\")",
          );
        } else {
          final functionName = param.type.toRuleFunction();
          if (functionName.isNotEmpty) {
            paramList.add("$functionName(data, \"$key\")");
          }
        }
      }
      buffer.writeln("        return ${paramList.join(" && ")};");
      buffer.writeln("      }");
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
            : permission.key;
        switch (permissionType) {
          case ModelPermissionQueryType.allowRead:
          case ModelPermissionQueryType.allowReadDocument:
          case ModelPermissionQueryType.allowReadCollection:
            buffer.writeln(
              "      ${permissionType.code}: if ${userType.code(key)};",
            );
            break;
          default:
            buffer.writeln(
              "      ${permissionType.code}: if ${userType.code(key)} && verify$functionName(getResource());",
            );
            break;
        }
      }
    }
    buffer.writeln("    }");
    return buffer;
  }
}
