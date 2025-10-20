part of "/masamune_ai.dart";

/// A simple echo tool useful for local testing.
///
/// ローカルテストで利用できるシンプルなエコーツール。
@immutable
class EchoAILocalTool extends AILocalTool {
  /// A simple echo tool useful for local testing.
  ///
  /// ローカルテストで利用できるシンプルなエコーツール。
  const EchoAILocalTool({
    this.prefix = "Echo:",
  });

  /// Prefix attached to the echoed message.
  ///
  /// 出力メッセージに付与するプレフィックス。
  final String prefix;

  @override
  String get name => "echo_tool";

  @override
  String get description =>
      "Echo back the provided message. Useful for verifying function calling.";

  @override
  Map<String, AISchema> get parameters => {
        "message": AISchema.string(
          description: "Text to echo back.",
          nullable: false,
        ),
      };

  @override
  Future<void> initialize() async {}

  @override
  FutureOr<AIContent?> process(AIToolRef ref) {
    final message = ref.call.args.get("message", "");
    if (message.isEmpty) {
      return AIContent.text(
        "Echo tool received an empty message.",
        completed: true,
      );
    }
    return AIContent.text(
      "$prefix $message",
      completed: true,
    );
  }
}
