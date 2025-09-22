part of "/masamune_ai_openai.dart";

/// The model name of the AI.
///
/// AIのモデル名。
enum OpenaiAIModel {
  /// GPT-4.1
  ///
  /// GPT-4.1
  gpt41,

  /// GPT-4o
  ///
  /// GPT-4o
  gpt4o,

  /// GPT-4o Mini
  ///
  /// GPT-4o Mini
  gpt4oMini,

  /// o4Mini
  ///
  /// o4Mini
  o4Mini,

  /// o3
  ///
  /// o3
  o3,

  /// o1
  ///
  /// o1
  o1,

  /// o3 Mini
  ///
  /// o3 Mini
  o3Mini,

  /// o1 Mini
  ///
  /// o1 Mini
  o1Mini,

  /// gpt5
  ///
  /// gpt5
  gpt5,

  /// gpt5 Mini
  ///
  /// gpt5 Mini
  gpt5Mini,

  /// gpt5 Chat
  ///
  /// gpt5 Chat
  gpt5Chat;

  /// デフォルトのモデル。
  static const OpenaiAIModel defaultModel = gpt5;

  /// The model name of the AI.
  ///
  /// AIのモデル名。
  String get model {
    switch (this) {
      case gpt41:
        return "gpt-4.1";
      case gpt4o:
        return "gpt-4o";
      case gpt4oMini:
        return "gpt-4o-mini";
      case o4Mini:
        return "o4-mini";
      case o3:
        return "o3";
      case o1:
        return "o1";
      case o3Mini:
        return "o3-mini";
      case o1Mini:
        return "o1-mini";
      case gpt5:
        return "gpt-5";
      case gpt5Mini:
        return "gpt-5-mini";
      case gpt5Chat:
        return "gpt-5-chat-latest";
    }
  }

  /// The price per input token. (USD)
  ///
  /// 入力トークンあたりの価格。（米ドル）
  double inputPriceDollarPerToken({AIFileType fileType = AIFileType.txt}) {
    switch (this) {
      case gpt41:
        return 2.0 / 1000000;
      case gpt4o:
        return 2.5 / 1000000;
      case gpt4oMini:
        return 0.15 / 1000000;
      case o4Mini:
        return 1.10 / 1000000;
      case o3:
        return 10.0 / 1000000;
      case o1:
        return 15.0 / 1000000;
      case o3Mini:
        return 1.1 / 1000000;
      case o1Mini:
        return 1.1 / 1000000;
      case gpt5:
        return 1.25 / 1000000;
      case gpt5Mini:
        return 0.25 / 1000000;
      case gpt5Chat:
        return 1.25 / 1000000;
    }
  }

  /// The price per input token. (USD)
  ///
  /// 入力トークンあたりの価格。（米ドル）
  double outputPriceDollarPerToken({AIFileType fileType = AIFileType.txt}) {
    switch (this) {
      case gpt41:
        return 8.0 / 1000000;
      case gpt4o:
        return 10.0 / 1000000;
      case gpt4oMini:
        return 0.60 / 1000000;
      case o4Mini:
        return 4.40 / 1000000;
      case o3:
        return 40.0 / 1000000;
      case o1:
        return 60.0 / 1000000;
      case o3Mini:
        return 4.4 / 1000000;
      case o1Mini:
        return 4.4 / 1000000;
      case gpt5:
        return 10.0 / 1000000;
      case gpt5Mini:
        return 2.0 / 1000000;
      case gpt5Chat:
        return 10.0 / 1000000;
    }
  }

  /// Get the price of the AI.
  ///
  /// AIの価格。
  double getInputPrice(
    int tokenCount, {
    AIFileType fileType = AIFileType.txt,
  }) {
    return inputPriceDollarPerToken(fileType: fileType) * tokenCount;
  }

  /// Get the price of the AI.
  ///
  /// AIの価格。
  double getOutputPrice(
    int tokenCount, {
    AIFileType fileType = AIFileType.txt,
  }) {
    return outputPriceDollarPerToken(fileType: fileType) * tokenCount;
  }
}
