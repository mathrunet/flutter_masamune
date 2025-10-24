part of "/masamune_ai.dart";

/// A tool for AI.
///
/// AIのツール。
@immutable
abstract class AITool {
  /// A tool for AI.
  ///
  /// AIのツール。
  const AITool();

  /// The name of the tool.
  ///
  /// ツールの名前。
  String get name;

  /// The description of the tool.
  ///
  /// ツールの説明。
  String get description;

  /// The parameters of the tool.
  ///
  /// ツールのパラメーター。
  Map<String, AISchema> get parameters;

  @override
  String toString() {
    return "Tool(name: $name, description: $description, parameters: $parameters)";
  }

  @override
  bool operator ==(Object other) {
    if (other is AITool) {
      return name == other.name;
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode;
}

/// A function tool for AI.
///
/// AIの関数ツール。
@immutable
abstract class AIFunctionTool extends AITool {
  /// A function tool for AI.
  ///
  /// AIの関数ツール。
  const AIFunctionTool();

  /// Initialize the tool.
  ///
  /// ツールを初期化します。
  Future<void> initialize();

  /// Function client process.
  ///
  /// 関数のクライアント処理。
  FutureOr<AIContent?> process(AIToolRef ref);

  /// Function generate response.
  ///
  /// 関数の生成応答。
  FutureOr<List<AIContentFunctionResponsePart>> generateResponse(
    AIContent? content,
    AIToolRef ref,
  ) {
    return [
      ref.call.toResponse(
        response: content?.toJson() ?? const {},
        source: content,
      )
    ];
  }
}

/// A local tool for AI.
///
/// AIのローカルツール。
@immutable
abstract class AILocalTool extends AIFunctionTool {
  /// A local tool for AI.
  ///
  /// AIのローカルツール。
  const AILocalTool();
}

/// A remote tool for AI.
///
/// AIのリモートツール。
@immutable
abstract class AIRemoteTool extends AIFunctionTool {
  /// A remote tool for AI.
  ///
  /// AIのリモートツール。
  const AIRemoteTool();

  /// The URL of the remote tool.
  ///
  /// リモートツールのURL。
  Uri get endpoint;

  /// The method of the remote tool.
  ///
  /// リモートツールのメソッド。
  ApiMethod get method => ApiMethod.post;

  /// Generate the headers for the remote tool.
  ///
  /// リモートツールのヘッダーを生成します。
  FutureOr<Map<String, String>> headers(AIContentFunctionCallPart call) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  /// Convert the response from the remote tool to an AI content.
  ///
  /// リモートツールからの応答をAIコンテンツに変換します。
  FutureOr<AIContent?> convertFromResponse(DynamicMap json);

  @override
  FutureOr<AIContent?> process(AIToolRef ref) async {
    try {
      final headers = await this.headers(ref.call);
      switch (method) {
        case ApiMethod.get:
          final endpoint =
              this.endpoint.replace(queryParameters: ref.call.args);
          final response = await Api.get(
            endpoint.toString(),
            headers: headers,
          );
          final json = jsonDecodeAsMap(response.body);
          return await convertFromResponse(json);
        case ApiMethod.post:
          final response = await Api.post(
            endpoint.toString(),
            headers: headers,
            body: jsonEncode(ref.call.args),
          );
          final json = jsonDecodeAsMap(response.body);
          return await convertFromResponse(json);
        case ApiMethod.put:
          final response = await Api.put(
            endpoint.toString(),
            headers: headers,
            body: jsonEncode(ref.call.args),
          );
          final json = jsonDecodeAsMap(response.body);
          return await convertFromResponse(json);
        case ApiMethod.patch:
          final response = await Api.patch(
            endpoint.toString(),
            headers: headers,
            body: jsonEncode(ref.call.args),
          );
          final json = jsonDecodeAsMap(response.body);
          return await convertFromResponse(json);
        case ApiMethod.delete:
          final response = await Api.delete(
            endpoint.toString(),
            headers: headers,
          );
          final json = jsonDecodeAsMap(response.body);
          return await convertFromResponse(json);
        case ApiMethod.head:
          return null;
      }
    } catch (e, stackTrace) {
      return AIContent.error(e, stackTrace);
    }
  }
}

/// A reference to the AI.
///
/// AIの参照。
class AIToolRef {
  const AIToolRef._({
    required this.tools,
    required this.call,
    required this.adapter,
  });

  /// The tools of the AI.
  ///
  /// AIのツール。
  final Set<AITool> tools;

  /// The call of the AI.
  ///
  /// AIの呼び出し。
  final AIContentFunctionCallPart call;

  /// The adapter of the AI.
  ///
  /// AIのアダプター。
  final AIMasamuneAdapter adapter;
}
