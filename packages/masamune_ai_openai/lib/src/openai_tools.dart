part of '/masamune_ai_openai.dart';

const _kTypeKey = "type";

/// Abstract class for defining OpenAI tools.
///
/// OpenAIのツールを定義するための抽象クラス。
@immutable
abstract class OpenAITool {
  /// Abstract class for defining OpenAI tools.
  ///
  /// OpenAIのツールを定義するための抽象クラス。
  const OpenAITool();

  /// Get the type of tool.
  ///
  /// ツールのタイプを取得します。
  String get type;

  /// Convert to JSON.
  ///
  /// JSONに変換します。
  DynamicMap toJson();
}

/// Define the tools of CodeInterpreter.
///
/// CodeInterpreterのツールを定義します。
@immutable
class OpenAICodeInterpreterTool extends OpenAITool {
  /// Define the tools of CodeInterpreter.
  ///
  /// CodeInterpreterのツールを定義します。
  const OpenAICodeInterpreterTool();

  @override
  String get type => "code_interpreter";

  @override
  DynamicMap toJson() {
    return {
      _kTypeKey: type,
    };
  }
}

/// Define the tools of Retrieval.
///
/// Retrievalのツールを定義します。
@immutable
class OpenAIRetrievalTool extends OpenAITool {
  /// Define the tools of Retrieval.
  ///
  /// Retrievalのツールを定義します。
  const OpenAIRetrievalTool();

  @override
  String get type => "retrieval";

  @override
  DynamicMap toJson() {
    return {
      _kTypeKey: type,
    };
  }
}

/// Define the tools of Function.
///
/// Functionのツールを定義します。
@immutable
class OpenAIFunctionTool extends OpenAITool {
  /// Define the tools of Function.
  ///
  /// Functionのツールを定義します。
  const OpenAIFunctionTool({
    required this.name,
    required this.description,
    required this.parameters,
  });

  /// Name of the function.
  ///
  /// 関数の名前。
  final String name;

  /// Description of the function.
  ///
  /// 関数の説明。
  final String description;

  /// Parameters of the function.
  ///
  /// 関数のパラメーター。
  final DynamicMap parameters;

  static const _kNameKey = "name";
  static const _kDescriptionKey = "description";
  static const _kParametersKey = "parameters";
  static const _kFunctionKey = "function";

  @override
  String get type => "function";

  @override
  DynamicMap toJson() {
    return {
      _kTypeKey: type,
      _kFunctionKey: {
        _kNameKey: name,
        _kDescriptionKey: description,
        _kParametersKey: parameters,
      },
    };
  }
}
