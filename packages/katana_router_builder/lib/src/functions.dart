part of '/katana_router_builder.dart';

String _defaultValue(ParamaterValue param) {
  final dartType = param.type;
  final type = dartType.toString().trimStringRight("?");
  final nullable = dartType.isNullable;
  final isRequired = param.element.isRequired;
  final defaultValue = param.defaultValue;
  switch (type) {
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
      for (final tmp in MasamuneType.values) {
        if (tmp.className != type) {
          continue;
        }
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return tmp.instansiateString;
      }
      if (dartType.isDartCoreObject || dartType.isDartCoreString) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "\"\"";
      } else if (dartType.isDartCoreDouble) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "0.0";
      } else if (dartType.isDartCoreInt || dartType.isDartCoreNum) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "0";
      } else if (dartType.isDartCoreBool) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "false";
      } else if (dartType.isDartCoreMap) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "{}";
      } else if (dartType.isDartCoreSet) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "{}";
      } else if (dartType.isDartCoreIterable) {
        if (nullable) {
          return "null";
        }
        if (defaultValue != null) {
          return defaultValue.toString();
        }
        return "[]";
      }
  }
  if (defaultValue != null) {
    return defaultValue.toString();
  } else if (nullable) {
    return "null";
  } else if (isRequired) {
    return "(){ throw Exception(\"There is a parameter with a non-nullable value for which no initial value has been set. Please set the initial value or make it nullable.\"); }()";
  } else {
    throw Exception(
      "There is a parameter with a non-nullable value for which no initial value has been set. Please set the initial value or make it nullable.",
    );
  }
}
