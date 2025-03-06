part of '/masamune_ai_firebase.dart';

/// The model name of the AI.
///
/// AIのモデル名。
enum FirebaseAIModel {
  /// Gemini 1.5 Flash
  ///
  /// Gemini 1.5 Flash
  gemini15Flash,

  /// Gemini 1.5 Pro
  ///
  /// Gemini 1.5 Pro
  gemini15Pro,

  /// Gemini 2.0 Flash
  ///
  /// Gemini 2.0 Flash
  gemini20Flash;

  /// The default model.
  ///
  /// デフォルトのモデル。
  static const FirebaseAIModel defaultModel = gemini20Flash;

  /// The model name of the AI.
  ///
  /// AIのモデル名。
  String get model {
    switch (this) {
      case gemini15Flash:
        return "gemini-1.5-flash";
      case gemini15Pro:
        return "gemini-1.5-pro";
      case gemini20Flash:
        return "gemini-2.0-flash";
    }
  }

  /// The price per input token. (USD)
  ///
  /// 入力トークンあたりの価格。（米ドル）
  double inputPriceDollarPerToken({AIFileType fileType = AIFileType.txt}) {
    switch (this) {
      case gemini15Flash:
        switch (fileType) {
          case AIFileType.txt:
          case AIFileType.pdf:
            return 0.000075 / 1000;
          case AIFileType.webp:
          case AIFileType.png:
          case AIFileType.jpeg:
            return 0.00002;
          case AIFileType.mp3:
          case AIFileType.mp4Audio:
          case AIFileType.m4a:
          case AIFileType.wav:
            return 0.000002;
          case AIFileType.mp4Video:
          case AIFileType.mov:
            return 0.00002;
        }
      case gemini15Pro:
        switch (fileType) {
          case AIFileType.txt:
          case AIFileType.pdf:
            return 0.00125 / 1000;
          case AIFileType.webp:
          case AIFileType.png:
          case AIFileType.jpeg:
            return 0.00032875;
          case AIFileType.mp3:
          case AIFileType.mp4Audio:
          case AIFileType.m4a:
          case AIFileType.wav:
            return 0.00032875;
          case AIFileType.mp4Video:
          case AIFileType.mov:
            return 0.00032875;
        }
      case gemini20Flash:
        switch (fileType) {
          case AIFileType.txt:
          case AIFileType.pdf:
            return 0.15 / 1000000;
          case AIFileType.webp:
          case AIFileType.png:
          case AIFileType.jpeg:
            return 0.15 / 1000000;
          case AIFileType.mp3:
          case AIFileType.mp4Audio:
          case AIFileType.m4a:
          case AIFileType.wav:
            return 1.0 / 1000000;
          case AIFileType.mp4Video:
          case AIFileType.mov:
            return 0.15 / 1000000;
        }
    }
  }

  /// The price per input token. (USD)
  ///
  /// 入力トークンあたりの価格。（米ドル）
  double outputPriceDollarPerToken({AIFileType fileType = AIFileType.txt}) {
    switch (this) {
      case gemini15Flash:
        switch (fileType) {
          case AIFileType.txt:
          case AIFileType.pdf:
            return 0.000075 / 1000;
          case AIFileType.webp:
          case AIFileType.png:
          case AIFileType.jpeg:
            return 0.00002;
          case AIFileType.mp3:
          case AIFileType.mp4Audio:
          case AIFileType.m4a:
          case AIFileType.wav:
            return 0.000002;
          case AIFileType.mp4Video:
          case AIFileType.mov:
            return 0.00002;
        }
      case gemini15Pro:
        switch (fileType) {
          case AIFileType.txt:
          case AIFileType.pdf:
            return 0.00125 / 1000;
          case AIFileType.webp:
          case AIFileType.png:
          case AIFileType.jpeg:
            return 0.00032875;
          case AIFileType.mp3:
          case AIFileType.mp4Audio:
          case AIFileType.m4a:
          case AIFileType.wav:
            return 0.00032875;
          case AIFileType.mp4Video:
          case AIFileType.mov:
            return 0.00032875;
        }
      case gemini20Flash:
        return 0.6 / 1000000;
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
