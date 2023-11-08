part of '/katana_router_builder.dart';

String _defaultValue(ParamaterValue param) {
  final type = param.type.toString().trimStringRight("?");
  final nullable = param.type.isNullable;
  final defaultValue = param.defaultValue;
  switch (type) {
    case "Object":
    case "String":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "\"\"";
    case "double":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "0.0";
    case "int":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "0";
    case "bool":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "false";
    case "DateTime":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "DateTime.now()";
    case "TextEditingController":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "TextEditingController()";
    case "FocusNode":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "FocusNode()";
    case "ScrollController":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "ScrollController()";
    default:
      if (type.startsWith("Map")) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "{}";
      } else if (type.startsWith("List")) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "[]";
      } else if (type.startsWith("Set")) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "{}";
      }
  }
  if (defaultValue != null) {
    return defaultValue.toString();
  } else if (nullable) {
    return "null";
  } else {
    throw Exception(
      "There is a parameter with a non-nullable value for which no initial value has been set. Please set the initial value or make it nullable.",
    );
  }
}
