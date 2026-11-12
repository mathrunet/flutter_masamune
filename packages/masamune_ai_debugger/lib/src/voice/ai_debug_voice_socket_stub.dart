import "ai_debug_voice_socket.dart";

/// Voice input is unavailable on platforms without `dart:io`.
Future<AIDebugVoiceSocket> connectAIDebugVoiceSocket(Uri url) => Future.error(
      UnsupportedError("AI Debugger voice input is not supported here."),
    );
