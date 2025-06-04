part of "/masamune_ai.dart";

/// Class for defining functions for MCP.
///
/// MCP用の関数定義用クラス。
class McpFunction {
  /// Class for defining functions for MCP.
  ///
  /// MCP用の関数定義用クラス。
  const McpFunction({
    required this.name,
    required this.description,
    required this.parameters,
    required this.serverProcess,
    required this.generateResponse,
    this.clientProcess,
    this.optionalParameters = const [],
  });

  /// Function name.
  ///
  /// 関数名。
  final String name;

  /// Function description.
  ///
  /// 関数の説明。
  final String description;

  /// Function schemas.
  ///
  /// 関数のスキーマ。
  final Map<String, AISchema> parameters;

  /// Function optional parameters.
  ///
  /// 関数のオプションのパラメーター。
  final List<String> optionalParameters;

  /// Function server process.
  ///
  /// 関数のサーバー処理。
  final FutureOr<AIContent?> Function(Map<String, dynamic> args) serverProcess;

  /// Function client process.
  ///
  /// 関数のクライアント処理。
  final FutureOr<AIContent?> Function(
    AIContentFunctionCallPart call,
  )? clientProcess;

  /// Function generate response.
  ///
  /// 関数の生成応答。
  final FutureOr<List<AIContentFunctionResponsePart>> Function(
    AIContent content,
    AIContentFunctionCallPart call,
  ) generateResponse;
}
