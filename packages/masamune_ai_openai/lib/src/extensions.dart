part of "/masamune_ai_openai.dart";

extension on AIRole {
  String get _toOpenaiRoleLabel {
    switch (this) {
      case AIRole.user:
        return "user";
      case AIRole.model:
        return "assistant";
      case AIRole.system:
        return "system";
      case AIRole.function:
        return "function";
    }
  }

  OpenAIChatMessageRole _toOpenAIChatMessageRole() {
    switch (this) {
      case AIRole.user:
        return OpenAIChatMessageRole.user;
      case AIRole.model:
        return OpenAIChatMessageRole.assistant;
      case AIRole.system:
        return OpenAIChatMessageRole.system;
      case AIRole.function:
        return OpenAIChatMessageRole.function;
    }
  }
}

extension on OpenAIStreamChatCompletionChoiceDeltaModel {
  List<AIContentPart> _toAIContentParts() {
    final res = <AIContentPart>[];
    for (final part
        in content ?? <OpenAIChatCompletionChoiceMessageContentItemModel?>[]) {
      if (part?.type == "text") {
        res.add(AIContentTextPart(part?.text ?? ""));
      }
    }
    return res;
  }
}

extension on AIContent {
  List<OpenAIChatCompletionChoiceMessageModel> _toContents() {
    final res = <OpenAIChatCompletionChoiceMessageModel>[];
    if (value.isNotEmpty) {
      res.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: role._toOpenAIChatMessageRole(),
          content: value.map((e) => e._toPart()).toList(),
        ),
      );
    }
    return res;
  }

  AIContent _toSystemInitialContent() {
    return AIContent(
      role: AIRole.user,
      values: value.where((e) => e is! AIContentTextPart).toList(),
    );
  }
}

extension on AIContentPart {
  OpenAIChatCompletionChoiceMessageContentItemModel _toPart() {
    final part = this;
    if (part is AIContentTextPart) {
      return OpenAIChatCompletionChoiceMessageContentItemModel.text(part.text);
    }
    throw UnimplementedError();
  }
}
