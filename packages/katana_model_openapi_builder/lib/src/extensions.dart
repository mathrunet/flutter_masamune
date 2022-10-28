part of katana_model_openapi_builder;

extension APISchemaObjectExtensions on APISchemaObject {
  String toDartType(
    String key, {
    List<String?> required = const [],
    bool inList = false,
  }) {
    final nullable = !inList && !required.contains(key) ? "?" : "";
    if (referenceURI != null) {
      return "${referenceURI!.toString().split("/").last}$nullable";
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
      case APIType.file:
        return "file$nullable";
      default:
        return "Object$nullable";
    }
  }
}
