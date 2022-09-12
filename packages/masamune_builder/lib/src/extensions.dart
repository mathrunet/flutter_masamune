part of masamune_builder;

extension _ParameterElementExntensions on ParameterElement {
  String get defaultValue {
    if (defaultValueCode != null) {
      return defaultValueCode!;
    }
    if (type.isNullable) {
      return "null";
    } else if (type.isDartCoreString) {
      return "\"\"";
    } else if (type.isDartCoreBool) {
      return "false";
    } else if (type.isDartCoreInt) {
      return "0";
    } else if (type.isDartCoreDouble) {
      return "0.0";
    } else if (type.isDartCoreList) {
      return "const []";
    } else if (type.isDartCoreMap || type.isDartCoreSet) {
      return "const {}";
    }
    return "";
  }

  String get _suffixValue {
    if (type.isNullable) {
      if (defaultValueCode == null) {
        return "";
      } else {
        return "?? $defaultValue";
      }
    } else {
      return "";
    }
  }

  String get _prefixCondition {
    if (type.isNullable) {
      return "if(ref.$name != null) ";
    } else {
      return "";
    }
  }

  String get codeFromMap {
    if (type.baseName == "Widget") {
      return "";
    } else if (type.isDartCoreList) {
      if (type.genericType?.baseName == "Widget") {
        return "";
      }
      return "$name: map.get<List${type.nullablePrefix}>(\"$name\", $defaultValue)${type.codeFromMap}$_suffixValue";
    } else if (type.isDartCoreMap) {
      return "$name: map.get<Map${type.nullablePrefix}>(\"$name\", $defaultValue)${type.codeFromMap}$_suffixValue";
    } else if (type.isDartCoreSet) {
      return "$name: map.get<Set${type.nullablePrefix}>(\"$name\", $defaultValue)${type.codeFromMap}$_suffixValue";
    } else if (type.isDartCoreClass) {
      return "$name: map.get<$type>(\"$name\", $defaultValue)${type.codeFromMap}$_suffixValue";
    } else if (type.isEnum) {
      return "$name: ${type.baseName}.values.firstWhere((e) => e.index == map.get<int${type.nullablePrefix}>(\"$name\", ${defaultValueCode != null ? (defaultValueCode! + ".index") : "null"}))";
    } else if (type.isDartCoreFunction) {
      return "";
    } else {
      return "$name: map.get<DynamicMap>(\"$name\", <String, dynamic>{}).to${type.baseName}()${type.codeFromMap}${defaultValueCode == null ? "" : "?? " + defaultValue}";
    }
  }

  String get codeToMap {
    if (type.baseName == "Widget") {
      return "";
    } else if (type.isDartCoreList) {
      if (type.genericType?.baseName == "Widget") {
        return "";
      }
      return "if(ref.$name.isNotEmpty) \"$name\": ref.$name${type.nullablePrefix}.map((e) => e${type.codeToMap})";
    } else if (type.isDartCoreMap) {
      return "if(ref.$name.isNotEmpty) \"$name\": ref.$name${type.nullablePrefix}.map((k, v) => MapEntry(k, v${type.codeToMap}))";
    } else if (type.isDartCoreSet) {
      return "if(ref.$name.isNotEmpty) \"$name\": ref.$name${type.nullablePrefix}.map((e) => e${type.codeToMap})";
    } else if (type.isDartCoreString) {
      return "if(ref.$name.isNotEmpty) \"$name\": ref.$name";
    } else if (type.isEnum) {
      return "$_prefixCondition\"$name\": ref.$name${type.nullablePrefix}.index";
    } else if (type.isDartCoreFunction) {
      return "";
    } else {
      return "$_prefixCondition\"$name\": ref.$name${type.codeToMap}";
    }
  }
}

extension _DartTypeExtensions on DartType {
  String get nullablePrefix {
    if (isNullable) {
      return "?";
    } else {
      return "";
    }
  }

  String get baseName {
    final e = element;
    if (e is ClassElement && e.allSupertypes.isNotEmpty) {
      for (final superType in e.allSupertypes) {
        if (superType.toString() == "Module") {
          return "Module";
        }
        if (superType.toString() == "Widget") {
          return "Widget";
        }
        // if (superType.toString().startsWith("QueryModule")) {
        //   return "QueryModule";
        // }
      }
    }
    final name = typeName;
    switch (name) {
      case "EdgeInsetsGeometry":
        return "EdgeInsets";
      default:
        return name;
    }
  }

  String get typeName {
    return toString().replaceAll("?", "");
  }

  bool get isEnum {
    final e = element;
    if (e is! ClassElement) {
      return false;
    }
    return e.isEnum;
  }

  bool get isDartCoreClass {
    return isCollection ||
        isDartCoreBool ||
        isDartCoreDouble ||
        isDartCoreFunction ||
        isDartCoreInt ||
        isDartCoreString;
  }

  bool get isNullable {
    return toString().endsWith("?");
  }

  bool get isCollection {
    return isDartCoreIterable ||
        isDartCoreList ||
        isDartCoreMap ||
        isDartCoreSet;
  }

  DartType? get genericType {
    final type = this as ParameterizedType;
    if (isDartCoreList || isDartCoreSet) {
      if (type.typeArguments.isEmpty) {
        return null;
      }
      return type.typeArguments.first;
    } else if (isDartCoreMap) {
      if (type.typeArguments.length < 2) {
        return null;
      }
      return type.typeArguments[1];
    }
  }

  String get codeFromMap {
    if (!isCollection) {
      return "";
    }
    final type = genericType;
    if (type == null) {
      return "";
    }
    if (isDartCoreMap) {
      if (type.isDartCoreList) {
        return "$nullablePrefix.cast<String, List${type.nullablePrefix}>()$nullablePrefix.map((k,v) => MapEntry(k, v${type.codeFromMap}))";
      } else if (type.isDartCoreMap) {
        return "$nullablePrefix.cast<String, Map${type.nullablePrefix}>()$nullablePrefix.map((k,v) => MapEntry(k, v${type.codeFromMap}))";
      } else if (type.isDartCoreClass) {
        return "$nullablePrefix.cast<String, $type>()";
      } else if (type.isEnum) {
        return "$nullablePrefix.cast<String, int${type.nullablePrefix}>()$nullablePrefix.map((k,v) => MapEntry(k, ${type.baseName}.values.firstWhere((n) => n.index == v)))";
      } else if (type.baseName == "Module") {
        return "$nullablePrefix.cast<String, DynamicMap${type.nullablePrefix}>()$nullablePrefix.map((k,v) => MapEntry(k, v${type.nullablePrefix}.toModule<${type.typeName}>()))";
      } else if (type.isDynamic) {
        return "$nullablePrefix.cast<String, DynamicMap${type.nullablePrefix}>()$nullablePrefix.map((k,v) => MapEntry(k, v${type.nullablePrefix}))";
      } else {
        return "$nullablePrefix.cast<String, DynamicMap${type.nullablePrefix}>()$nullablePrefix.map((k,v) => MapEntry(k, v${type.nullablePrefix}.to${type.baseName}()))";
      }
    } else {
      if (type.isDartCoreList) {
        return "$nullablePrefix.cast<List${type.nullablePrefix}>()$nullablePrefix.map((e) => e${type.codeFromMap}).removeEmpty()";
      } else if (type.isDartCoreMap) {
        return "$nullablePrefix.cast<Map${type.nullablePrefix}>()$nullablePrefix.map((e) => e${type.codeFromMap}).removeEmpty()";
      } else if (type.isDartCoreClass) {
        return "$nullablePrefix.cast<$type>()";
      } else if (type.isEnum) {
        return "$nullablePrefix.cast<int${type.nullablePrefix}>()$nullablePrefix.map((e) => ${type.baseName}.values.firstWhere((n) => n.index == e)).removeEmpty()";
      } else if (type.baseName == "Module") {
        return "$nullablePrefix.cast<DynamicMap>()$nullablePrefix.map((e) => e${type.nullablePrefix}.toModule<${type.typeName}>()).removeEmpty()";
      } else if (type.isDynamic) {
        return "$nullablePrefix.cast<DynamicMap>()$nullablePrefix.map((e) => e${type.nullablePrefix}).removeEmpty()";
      } else {
        return "$nullablePrefix.cast<DynamicMap>()$nullablePrefix.map((e) => e${type.nullablePrefix}.to${type.baseName}()).removeEmpty()";
      }
    }
  }

  String get codeToMap {
    if (isCollection) {
      final type = genericType;
      if (type == null) {
        return "";
      }
      if (type.isDartCoreMap) {
        return "$nullablePrefix.map((k, v) => MapEntry(k, v${type.codeToMap}))";
      } else if (type.isCollection) {
        return "$nullablePrefix.map((e) => e${type.codeToMap})";
      } else if (type.isEnum) {
        return "$nullablePrefix.index";
      } else if (type.isDartCoreClass) {
        return "";
      } else if (type.isDynamic) {
        return nullablePrefix;
      } else {
        return "$nullablePrefix.toMap()";
      }
    } else if (isDartCoreMap) {
      return "$nullablePrefix.map((k, v) => MapEntry(k, v$codeToMap))";
    } else if (isDartCoreClass) {
      return "";
    } else if (isDynamic) {
      return nullablePrefix;
    } else {
      return "$nullablePrefix.toMap()";
    }
  }
}
