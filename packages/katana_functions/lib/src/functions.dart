part of katana_functions;

/// An interface for executing server-side processing.
///
/// If the adapter is properly configured in [FunctionsAdapterScope], server-side communication can be performed inside the method to obtain the appropriate response.
///
/// You can also specify individual adapters by passing them to [adapter].
///
/// サーバー側の処理を実行するためのインターフェース。
///
/// [FunctionsAdapterScope]でアダプターを適切に設定しておくとメソッドの内部でサーバー側の通信を行い適切なレスポンスを得ることができます。
///
/// また[adapter]に渡すことで個別にアダプターを指定することができます。
class Functions extends ChangeNotifier {
  /// An interface for executing server-side processing.
  ///
  /// If the adapter is properly configured in [FunctionsAdapterScope], server-side communication can be performed inside the method to obtain the appropriate response.
  ///
  /// You can also specify individual adapters by passing them to [adapter].
  ///
  /// サーバー側の処理を実行するためのインターフェース。
  ///
  /// [FunctionsAdapterScope]でアダプターを適切に設定しておくとメソッドの内部でサーバー側の通信を行い適切なレスポンスを得ることができます。
  ///
  /// また[adapter]に渡すことで個別にアダプターを指定することができます。
  Functions({FunctionsAdapter? adapter}) : _adapter = adapter;

  /// An adapter that defines the platform of the server.
  ///
  /// サーバーのプラットフォームを定義するアダプター。
  FunctionsAdapter get adapter {
    return _adapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _adapter;

  /// PUSH notification.
  ///
  /// Pass the title of the notification to [title], the message to [text], and the destination to [target].
  ///
  /// If you want to plant data in the notification, use [data]. Pass the channel ID required for the specific platform to [channel].
  ///
  /// PUSH通知を行います。
  ///
  /// [title]に通知タイトル、[text]にメッセージ、[target]に宛先を渡します。
  ///
  /// 通知にデータを仕込みたい場合は[data]を利用します。[channel]に特定プラットフォームで必要なチャンネルIDを渡します。
  Future<void> sendNotification({
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    required String target,
  }) async {
    try {
      await FunctionsAdapter.primary.sendNotification(
        title: title,
        text: text,
        target: target,
        channel: channel,
        data: data,
      );
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Chat using OpenAI's Chat GPT.
  ///
  /// Pass all previous correspondence to [messages].
  ///
  /// Returns a list of [OpenAIChatGPTMessage] with new messages added to the response.
  ///
  /// Pass the model to be used to [model].
  ///
  /// OpenAIのChat GPTを利用してチャットを行います。
  ///
  /// [messages]にそれまでのやりとりのすべてを渡してください。
  ///
  /// レスポンスに新しいメッセージが追加された[OpenAIChatGPTMessage]のリストを返します。
  ///
  /// [model]には利用するモデルを渡してください。
  Future<List<OpenAIChatGPTMessage>> openAIChatGPT({
    required List<OpenAIChatGPTMessage> messages,
    OpenAIChatGPTModel model = OpenAIChatGPTModel.gpt35Turbo,
  }) async {
    try {
      final res = await FunctionsAdapter.primary.openAIChatGPT(
        messages: messages,
        model: model,
      );
      if (res == null) {
        throw Exception("Failed to get response from OpenAI Chat GPT.");
      }
      notifyListeners();
      return [
        ...messages,
        res,
      ];
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Functions for issuing tokens to be used by Agora.io.
  ///
  /// Pass the necessary values to [channelName] and [clientRole].
  ///
  /// Agora.ioで利用するトークンを発行するためのFunctions。
  ///
  /// [channelName]と[clientRole]に必要な値を渡してください。
  Future<String> getAgoraToken({
    required String channelName,
    AgoraClientRole clientRole = AgoraClientRole.audience,
  }) async {
    try {
      final res = await FunctionsAdapter.primary.getAgoraToken(
        channelName: channelName,
        clientRole: clientRole,
      );
      notifyListeners();
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
