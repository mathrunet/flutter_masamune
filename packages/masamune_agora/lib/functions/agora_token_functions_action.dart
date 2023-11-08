part of '/masamune_agora.dart';

/// Client role used by Agora.io.
///
/// Agora.ioで用いるClientの役割。
enum AgoraClientRole {
  /// Distributor.
  ///
  /// 配信者。
  broadcaster,

  /// Viewer.
  ///
  /// 視聴者。
  audience,
}

/// [FunctionsAction] to obtain a token for Agora room creation from the server side.
///
/// Agoraのルーム作成用トークンをサーバー側から取得するための[FunctionsAction]。
///
/// {@macro functions_action}
class AgoraTokenFunctionsAction
    extends FunctionsAction<AgoraTokenFunctionsActionResponse> {
  /// [FunctionsAction] to obtain a token for Agora room creation from the server side.
  ///
  /// Agoraのルーム作成用トークンをサーバー側から取得するための[FunctionsAction]。
  ///
  /// {@macro functions_action}
  const AgoraTokenFunctionsAction({
    required this.channelName,
    this.clientRole = AgoraClientRole.audience,
  });

  /// Name of the channel to be created.
  ///
  /// 作成するチャンネル名。
  final String channelName;

  /// Role of the channel creator.
  ///
  /// チャンネルの作成者の役割。
  final AgoraClientRole clientRole;

  @override
  String get action => "agora_token";

  @override
  DynamicMap? toMap() {
    return {
      "role":
          clientRole == AgoraClientRole.audience ? "audience" : "broadcaster",
      "name": channelName,
    };
  }

  @override
  AgoraTokenFunctionsActionResponse toResponse(DynamicMap map) {
    try {
      if (map.isEmpty) {
        throw Exception("Failed to get response from agora_token.");
      }

      final token = map.get("token", "");
      if (token.isEmpty) {
        throw Exception("Failed to get response from agora_token.");
      }
      return AgoraTokenFunctionsActionResponse(
        token: token,
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

/// Response to [FunctionsAction] to obtain a token for Agora room creation from the server side.
///
/// Agoraのルーム作成用トークンをサーバー側から取得するための[FunctionsAction]のレスポンス。
class AgoraTokenFunctionsActionResponse extends FunctionsActionResponse {
  /// Response to [FunctionsAction] to obtain a token for Agora room creation from the server side.
  ///
  /// Agoraのルーム作成用トークンをサーバー側から取得するための[FunctionsAction]のレスポンス。
  const AgoraTokenFunctionsActionResponse({
    required this.token,
  });

  /// Token of the room created.
  ///
  /// 作成されたルームのトークン。
  final String token;
}
