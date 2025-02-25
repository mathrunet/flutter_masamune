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
  gemini15Pro;

  /// The model name of the AI.
  ///
  /// AIのモデル名。
  String get model {
    switch (this) {
      case gemini15Flash:
        return "gemini-1.5-flash";
      case gemini15Pro:
        return "gemini-1.5-pro";
    }
  }
}
