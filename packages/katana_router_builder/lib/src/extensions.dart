part of '/katana_router_builder.dart';

extension _DartObjectExtensions on DartObject {
  Object? toValue() {
    if (type == null || isNull) {
      return null;
    } else if (type!.isDartCoreString) {
      return toStringValue();
    } else if (type!.isDartCoreBool) {
      return toBoolValue();
    } else if (type!.isDartCoreInt) {
      return toIntValue();
    } else if (type!.isDartCoreDouble) {
      return toDoubleValue();
    } else if (type!.isDartCoreList) {
      return toListValue();
    } else if (type!.isDartCoreMap) {
      return toMapValue();
    } else if (type!.isDartCoreSet) {
      return toSetValue();
    }
    return null;
  }
}

extension _DartTypeExtensions on DartType {
  bool get isNullable {
    return toString().endsWith("?");
  }

  String get aliasName {
    final aliasElement = alias?.element;
    if (aliasElement != null) {
      return aliasElement.name;
    }
    return toString();
  }
}
