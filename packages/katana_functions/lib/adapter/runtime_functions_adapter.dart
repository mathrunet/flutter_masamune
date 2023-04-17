part of katana_functions;

/// FunctionsAdapter] that only returns a normal system without communicating with the server side.
///
/// Use as a test stub.
///
/// サーバー側と通信せずに正常系を返すだけの[FunctionsAdapter]。
///
/// テスト用のスタブとして利用してください。
class RuntimeFunctionsAdapter extends FunctionsAdapter {
  /// FunctionsAdapter] that only returns a normal system without communicating with the server side.
  ///
  /// Use as a test stub.
  ///
  /// サーバー側と通信せずに正常系を返すだけの[FunctionsAdapter]。
  ///
  /// テスト用のスタブとして利用してください。
  const RuntimeFunctionsAdapter();

  @override
  Future<void> sendNotification({
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    required String target,
  }) =>
      Future.value();

  @override
  Future<OpenAIChatGPTMessage?> openAIChatGPT(
          {required List<OpenAIChatGPTMessage> messages,
          OpenAIChatGPTModel model = OpenAIChatGPTModel.gpt35Turbo}) =>
      Future.value();

  @override
  Future<String> getAgoraToken({
    required String channelName,
    AgoraClientRole clientRole = AgoraClientRole.audience,
  }) =>
      Future.value("");
}
