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
    case "ModelCounter":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelCounter(0)";
    case "ModelTimestamp":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelTimestamp()";
    case "ModelDate":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelDate()";
    case "ModelLocale":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelLocale()";
    case "ModelLocalizedValue":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelLocalizedValue()";
    case "ModelGeoValue":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelGeoValue()";
    case "ModelUri":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelUri()";
    case "ModelImageUri":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelImageUri()";
    case "ModelVideoUri":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelVideoUri()";
    case "ModelSearch":
      if (nullable) {
        return "null";
      }
      if (defaultValue != null) {
        return defaultValue.toString();
      }
      return "const ModelSearch([])";
    default:
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
