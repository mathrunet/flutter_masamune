part of "/masamune_ai.dart";

/// The mode in which function calling should execute.
///
/// 関数呼び出しの実行モード。
enum AIFunctionCallingMode {
  /// The mode with default model behavior.
  ///
  /// The model predicts the response to a function call or natural language.
  ///
  /// デフォルトのモデルの振る舞いをするモード。
  ///
  /// モデルは、関数呼び出しまたは自然言語の応答を予測します。
  auto,

  /// Mode in which the specified function call is made.
  ///
  /// Performs the set function call.
  ///
  /// 指定した関数呼び出しを行うモード。
  ///
  /// 設定された関数呼び出しを行います。
  any,

  /// Mode in which function calling is disabled.
  ///
  /// Disables function calling.
  ///
  /// 関数呼び出しを無効にするモード。
  ///
  /// 関数呼び出しを無効にします。
  none;
}

/// Configuration specifying how the model should use the functions provided as
/// tools.
///
/// モデルが提供された関数をツールとして使用する方法を指定する設定。
class AIFunctionCallingConfig {
  /// Configuration specifying how the model should use the functions provided as
  /// tools.
  ///
  /// モデルが提供された関数をツールとして使用する方法を指定する設定。
  const AIFunctionCallingConfig._({this.mode, this.allowedFunctionNames});

  /// Returns a [AIFunctionCallingConfig] instance with mode of [AIFunctionCallingMode.auto].
  ///
  /// モードが[AIFunctionCallingMode.auto]に設定された[AIFunctionCallingConfig]インスタンスを返します。
  factory AIFunctionCallingConfig.auto() {
    return const AIFunctionCallingConfig._(mode: AIFunctionCallingMode.auto);
  }

  /// Returns a [AIFunctionCallingConfig] instance with mode of [AIFunctionCallingMode.any].
  ///
  /// モードが[AIFunctionCallingMode.any]に設定された[AIFunctionCallingConfig]インスタンスを返します。
  factory AIFunctionCallingConfig.any(Set<String> allowedFunctionNames) {
    return AIFunctionCallingConfig._(
        mode: AIFunctionCallingMode.any,
        allowedFunctionNames: allowedFunctionNames);
  }

  /// Returns a [AIFunctionCallingConfig] instance with mode of [AIFunctionCallingMode.none].
  ///
  /// モードが[AIFunctionCallingMode.none]に設定された[AIFunctionCallingConfig]インスタンスを返します。
  factory AIFunctionCallingConfig.none() {
    return const AIFunctionCallingConfig._(mode: AIFunctionCallingMode.none);
  }

  /// The mode in which function calling should execute.
  ///
  /// If null, the default behavior will match [AIFunctionCallingMode.auto].
  ///
  /// 関数呼び出しの実行モード。
  ///
  /// デフォルトの動作は[AIFunctionCallingMode.auto]に一致します。
  final AIFunctionCallingMode? mode;

  /// A set of function names that, when provided, limits the functions the
  /// model will call.
  ///
  /// This should only be set when the Mode is [AIFunctionCallingMode.any]. Function names should match [AITool.name]. With mode set to `any`, model will predict a function call from the set of function names provided.
  ///
  /// モードが[AIFunctionCallingMode.any]に設定されている場合、モデルは提供された関数名のセットから関数呼び出しを予測します。
  ///
  /// 以下は、[AIFunctionCallingMode.any]がModeに設定されている場合にのみ設定されるべきです。関数名は[AITool.name]と一致する必要があります。Modeが`any`に設定されている場合、モデルは提供された関数名のセットから関数呼び出しを予測します。
  final Set<String>? allowedFunctionNames;
}
