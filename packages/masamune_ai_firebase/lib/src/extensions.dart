part of "/masamune_ai_firebase.dart";

extension on Content {
  List<AIContentPart> _toAIContentParts() {
    final res = <AIContentPart>[];
    for (final part in parts) {
      if (part is TextPart) {
        res.add(AIContentTextPart(part.text));
      } else if (part is InlineDataPart) {
        final type = AIFileType.fromMimeType(part.mimeType);
        if (type != null) {
          res.add(AIContentBinaryPart(type, part.bytes));
        }
      } else if (part is FunctionCall) {
        res.add(AIContentFunctionCallPart(
          name: part.name,
          args: part.args,
        ));
      } else if (part is FunctionResponse) {
        res.add(AIContentFunctionResponsePart(
          name: part.name,
          response: part.response,
        ));
      }
    }
    return res;
  }
}

extension on AIContent {
  List<Content> _toContents() {
    final res = <Content>[];
    if (functions.isNotEmpty) {
      for (final function in functions) {
        res.add(
          Content(
            "function",
            [FunctionCall(function.call.name, function.call.args)],
          ),
        );
        final response = function.response;
        if (response != null) {
          res.add(
            Content.functionResponse(function.call.name, response.response),
          );
        }
      }
    }
    if (value.isNotEmpty) {
      res.add(
        Content(
          role.name,
          value.map((e) => e._toPart()).toList(),
        ),
      );
    }
    return res;
  }

  AIContent _toSystemPromptContent() {
    return where((e) => e is AIContentTextPart);
  }

  AIContent _toSystemInitialContent() {
    return AIContent(
      role: AIRole.user,
      values: value.whereType<AIContentTextPart>().toList(),
    );
  }
}

extension on AIFunctionCallingConfig {
  FunctionCallingConfig _toFunctionCallingConfig() {
    switch (mode) {
      case AIFunctionCallingMode.auto:
        return FunctionCallingConfig.auto();
      case AIFunctionCallingMode.any:
        return FunctionCallingConfig.any(allowedFunctionNames ?? {});
      case AIFunctionCallingMode.none:
        return FunctionCallingConfig.none();
      default:
        return FunctionCallingConfig.auto();
    }
  }
}

extension on AIContentPart {
  Part _toPart() {
    final part = this;
    if (part is AIContentTextPart) {
      return TextPart(part.text);
    } else if (part is AIContentBinaryPart) {
      return InlineDataPart(part.type.mimeType, part.value);
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

extension on Set<AITool> {
  Tool _toVertexAITools() {
    return Tool.functionDeclarations([
      ...mapAndRemoveEmpty((tool) {
        final optionalParameters =
            tool.parameters.where((key, value) => value.optional).keys.toList();
        return FunctionDeclaration(
          tool.name,
          tool.description,
          parameters: tool.parameters.map(
            (key, value) => MapEntry(key, value._toSchema()),
          ),
          optionalParameters: optionalParameters,
        );
      })
    ]);
  }
}
