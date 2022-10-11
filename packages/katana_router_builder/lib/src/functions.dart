part of katana_router_builder;

String _defaultValue(ParamaterModel param) {
  final type = param.type.toString().trimStringRight("?");
  final nullable = param.type.isNullable;
  final defaultValue = param.defaultValue;
  switch (type) {
    case "String":
      if (nullable) {
        return "null";
      }
      if (defaultValue is String) {
        return "\"${defaultValue.toString()}\"";
      }
      return "\"\"";
    case "double":
      if (nullable) {
        return "null";
      }
      if (defaultValue is double) {
        return defaultValue.toString();
      }
      return "0.0";
    case "int":
      if (nullable) {
        return "null";
      }
      if (defaultValue is int) {
        return defaultValue.toString();
      }
      return "0";
    case "bool":
      if (nullable) {
        return "null";
      }
      if (defaultValue is bool) {
        return defaultValue ? "true" : "false";
      }
      return "false";
    case "DateTime":
      if (nullable) {
        return "null";
      }
      return "DateTime.now()";
    case "TextEditingController":
      if (nullable) {
        return "null";
      }
      return "TextEditingController()";
    case "FocusNode":
      if (nullable) {
        return "null";
      }
      return "FocusNode()";
    case "ScrollController":
      if (nullable) {
        return "null";
      }
      return "ScrollController()";
    default:
      if (type.startsWith("Map")) {
        if (nullable) {
          return "null";
        }
        if (defaultValue is Map) {
          return jsonEncode(defaultValue);
        }
        return "{}";
      } else if (type.startsWith("List")) {
        if (nullable) {
          return "null";
        }
        if (defaultValue is List) {
          return jsonEncode(defaultValue);
        }
        return "[]";
      } else if (type.startsWith("Set")) {
        if (nullable) {
          return "null";
        }
        if (defaultValue is Set) {
          return jsonEncode(defaultValue);
        }
        return "{}";
      }
  }
  return "null";
}
