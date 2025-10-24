part of "/masamune_ai_firebase.dart";

/// The model name of the AI.
///
/// AIのモデル名。
enum FirebaseAIModel {
  /// Gemini 2.5 Flash
  ///
  /// Gemini 2.5 Flash
  gemini25Flash,

  /// Gemini 2.5 Flash Lite
  ///
  /// Gemini 2.5 Flash Lite
  gemini25FlashLite,

  /// Gemini 2.5 Pro
  ///
  /// Gemini 2.5 Pro
  gemini25Pro;

  /// デフォルトのモデル。
  static const FirebaseAIModel defaultModel = gemini25Flash;

  /// The model name of the AI.
  ///
  /// AIのモデル名。
  String get model {
    switch (this) {
      case gemini25Flash:
        return "gemini-2.5-flash";
      case gemini25FlashLite:
        return "gemini-2.5-flash-lite";
      case gemini25Pro:
        return "gemini-2.5-pro";
    }
  }

  /// The price per input token. (USD)
  ///
  /// 入力トークンあたりの価格。（米ドル）
  double inputPriceDollarPerToken({AIFileType fileType = AIFileType.txt}) {
    switch (this) {
      case gemini25Flash:
        switch (fileType) {
          case AIFileType.txt:
          case AIFileType.pdf:
          case AIFileType.webp:
          case AIFileType.png:
          case AIFileType.jpeg:
          case AIFileType.mp4Video:
          case AIFileType.mov:
            return 0.3 / 1000000;
          case AIFileType.mp3:
          case AIFileType.wav:
          case AIFileType.mp4Audio:
          case AIFileType.m4a:
            return 1.0 / 1000000;
        }
      case FirebaseAIModel.gemini25FlashLite:
        switch (fileType) {
          case AIFileType.txt:
          case AIFileType.pdf:
          case AIFileType.webp:
          case AIFileType.png:
          case AIFileType.jpeg:
          case AIFileType.mp4Video:
          case AIFileType.mov:
            return 0.1 / 1000000;
          case AIFileType.mp3:
          case AIFileType.wav:
          case AIFileType.mp4Audio:
          case AIFileType.m4a:
            return 0.3 / 1000000;
        }
      case FirebaseAIModel.gemini25Pro:
        switch (fileType) {
          case AIFileType.txt:
          case AIFileType.pdf:
          case AIFileType.webp:
          case AIFileType.png:
          case AIFileType.jpeg:
          case AIFileType.mp3:
          case AIFileType.mp4Audio:
          case AIFileType.m4a:
          case AIFileType.wav:
          case AIFileType.mp4Video:
          case AIFileType.mov:
            return 2.5 / 1000000;
        }
    }
  }

  /// The price per input token. (USD)
  ///
  /// 入力トークンあたりの価格。（米ドル）
  double outputPriceDollarPerToken({AIFileType fileType = AIFileType.txt}) {
    switch (this) {
      case gemini25Flash:
        return 2.5 / 1000000;
      case gemini25FlashLite:
        return 0.4 / 1000000;
      case gemini25Pro:
        return 15.0 / 1000000;
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
