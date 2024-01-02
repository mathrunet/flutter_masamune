part of '/masamune_ai_openai.dart';

/// OpenAI's model.
///
/// OpenAIのモデル。
enum OpenAIModel {
  /// gpt-3.5-turbo-0613
  ///
  /// 6月13日に公開されたモデル。
  gpt35Turbo0613,

  /// gpt-3.5-turbo-0301
  ///
  /// 3月1日に公開されたモデル。
  gpt35Turbo0301,

  /// gpt-4-0314
  ///
  /// 3月14日に公開されたモデル。
  gpt40314,

  /// gpt-4-32k-0314
  ///
  /// 3月14日に公開されたモデル。
  gpt432k0314,

  /// gpt-4-1106-preview
  ///
  /// 11月6日に公開されたモデル。
  gpt41106Preview;

  /// Get the ID of the model.
  ///
  /// モデルのIDを取得します。
  String get id {
    switch (this) {
      case OpenAIModel.gpt35Turbo0613:
        return "gpt-3.5-turbo-0613";
      case OpenAIModel.gpt35Turbo0301:
        return "gpt-3.5-turbo-0301";
      case OpenAIModel.gpt40314:
        return "gpt-4-0314";
      case OpenAIModel.gpt432k0314:
        return "gpt-4-32k-0314";
      case OpenAIModel.gpt41106Preview:
        return "gpt-4-1106-preview";
    }
  }
}
