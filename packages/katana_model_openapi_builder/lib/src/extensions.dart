part of "/katana_model_openapi_builder.dart";

/// Extension for [APISchemaObject] to convert to Dart type.
///
/// [APISchemaObject]をDartの型に変換するための拡張メソッド。
extension APISchemaObjectExtensions on APISchemaObject {
  /// Convert to Dart type.
  ///
  /// Dart型に変換します。
  String toDartType(
    String key, {
    List<String?> required = const [],
    bool inList = false,
  }) {
    final nullable = !inList && !required.contains(key) ? "?" : "";
    if (referenceURI != null && additionalPropertySchema == null) {
      return "${referenceURI!.toString().split("/").last.toPascalCase()}$nullable";
    }
    switch (type) {
      case APIType.string:
        return "String$nullable";
      case APIType.number:
        return "num$nullable";
      case APIType.integer:
        return "int$nullable";
      case APIType.boolean:
        return "bool$nullable";
      case APIType.array:
        return "List<${items?.toDartType(key, inList: true)}>";
      default:
        if (additionalPropertyPolicy != null) {
          if (!inList) {
            return "Map<String,dynamic>?";
          } else {
            return "Map<String,dynamic>";
          }
        }
        return "Object$nullable";
    }
  }
}
