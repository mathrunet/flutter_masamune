part of '/masamune_ai_firebase.dart';

extension on Content {
  List<AIContentPart> _toAIContentParts() {
    final res = <AIContentPart>[];
    for (final part in parts) {
      if (part is TextPart) {
        res.add(AIContentTextPart(part.text));
      } else if (part is InlineDataPart) {
        res.add(AIContentBinaryPart(part.mimeType, part.bytes));
      }
    }
    return res;
  }
}

extension on AIContent {
  Content _toContent() {
    return Content(
      role.name,
      value.map((e) => e._toPart()).toList(),
    );
  }
}

extension on AIContentPart {
  Part _toPart() {
    final part = this;
    if (part is AIContentTextPart) {
      return TextPart(part.text);
    } else if (part is AIContentBinaryPart) {
      return InlineDataPart(part.mimeType, part.data);
    }
    throw UnimplementedError();
  }
}

extension on AISchema {
  Schema _toSchema() {
    final items = this.items?._toSchema();
    final properties =
        this.properties?.map((key, value) => MapEntry(key, value._toSchema()));
    return Schema(
      type._toSchemaType(),
      properties: properties,
      optionalProperties: optionalProperties,
      nullable: nullable,
      enumValues: enumValues,
      format: format,
      description: description,
      items: items,
    );
  }
}

extension on AISchemaType {
  SchemaType _toSchemaType() {
    switch (this) {
      case AISchemaType.string:
        return SchemaType.string;
      case AISchemaType.double:
        return SchemaType.number;
      case AISchemaType.int:
        return SchemaType.integer;
      case AISchemaType.boolean:
        return SchemaType.boolean;
      case AISchemaType.list:
        return SchemaType.array;
      case AISchemaType.map:
        return SchemaType.object;
    }
  }
}
