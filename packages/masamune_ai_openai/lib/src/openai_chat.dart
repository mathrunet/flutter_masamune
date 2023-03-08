part of masamune_ai_openai;

/// Class for exchanging ChatGPT.
///
/// You can set an initial value in [initialValue] and proceed with the conversation while retaining all previous conversations.
///
/// Calling [send] registers both your own conversation and OpenAI's conversation.
///
/// Registered OpenAI conversations are retrieved asynchronously within each object. By monitoring each element with [ListenableListener], you can wait for processing for each item in the list.
///
/// All previous conversations can be retrieved at [value].
///
/// With [clear], you can delete all conversations and start from the beginning.
///
/// ChatGPTのやりとりを行うためのクラス。
///
/// [initialValue]に初期値を設定し、それまでのすべての会話を保持しながら会話を進めることができます。
///
/// [send]を呼び出すと自身の会話とOpenAIの会話の両方を登録します。
///
/// 登録されたOpenAIの会話は、各オブジェクト内で非同期で取得されます。[ListenableListener]で各要素を監視することでリストの項目ごとで処理を待つことができます。
///
/// これまでのすべての会話は[value]で取得できます。
///
/// [clear]ですべての会話を削除し最初から始めることができます。
class OpenAIChat extends ChangeNotifier
    implements ValueListenable<List<OpenAIChatMsg>> {
  /// Class for exchanging ChatGPT.
  ///
  /// You can set an initial value in [initialValue] and proceed with the conversation while retaining all previous conversations.
  ///
  /// Calling [send] registers both your own conversation and OpenAI's conversation.
  ///
  /// Registered OpenAI conversations are retrieved asynchronously within each object. By monitoring each element with [ListenableListener], you can wait for processing for each item in the list.
  ///
  /// All previous conversations can be retrieved at [value].
  ///
  /// With [clear], you can delete all conversations and start from the beginning.
  ///
  /// ChatGPTのやりとりを行うためのクラス。
  ///
  /// [initialValue]に初期値を設定し、それまでのすべての会話を保持しながら会話を進めることができます。
  ///
  /// [send]を呼び出すと自身の会話とOpenAIの会話の両方を登録します。
  ///
  /// 登録されたOpenAIの会話は、各オブジェクト内で非同期で取得されます。[ListenableListener]で各要素を監視することでリストの項目ごとで処理を待つことができます。
  ///
  /// これまでのすべての会話は[value]で取得できます。
  ///
  /// [clear]ですべての会話を削除し最初から始めることができます。
  OpenAIChat({
    this.user = "user",
    this.model = OpenAIChatModel.gpt35Turbo,
    List<OpenAIChatMsg>? initialValue,
    this.maxTokens = 300,
    this.temperature,
  }) {
    _value = initialValue ?? [];
  }

  /// User Name.
  ///
  /// ユーザーの名前。
  final String user;

  /// Model to be used.
  ///
  /// 使用するモデル。
  final OpenAIChatModel model;

  /// Maximum tokens that can be obtained in a single response.
  ///
  /// １つのレスポンスで取得可能な最大トークン。
  final int? maxTokens;

  /// The temperature of the response, specified as 0-1.
  ///
  /// レスポンスの温度感。0-1で指定します。
  final double? temperature;

  /// The total number of tokens it took until then.
  ///
  /// それまでにかかった総トークン数。
  ///
  /// See also:
  ///   * https://openai.com/pricing
  int get usageToken => _usageToken;
  int _usageToken = 0;

  @override
  List<OpenAIChatMsg> get value =>
      _value.where((e) => e.role != OpenAIChatRole.system).toList();
  late final List<OpenAIChatMsg> _value;

  /// If transmission is in progress, it waits until transmission is complete.
  ///
  /// 送信中の場合は、送信完了まで待機します。
  Future<OpenAIChatMsg?>? get sending => _sendCompleter?.future;
  Completer<OpenAIChatMsg?>? _sendCompleter;

  /// Send [message] to ChatGPT.
  ///
  /// You can specify the date and time of transmission with [dateTime].
  ///
  /// The role of the sender can be specified in [role].
  ///
  /// Registered OpenAI conversations are retrieved asynchronously within each object. By monitoring each element with [ListenableListener], you can wait for processing for each item in the list.
  ///
  /// [message]をChatGPTに送信します。
  ///
  /// [dateTime]で送信日時を指定できます。
  ///
  /// [role]で送信する者のロールを指定できます。
  ///
  /// 登録されたOpenAIの会話は、各オブジェクト内で非同期で取得されます。[ListenableListener]で各要素を監視することでリストの項目ごとで処理を待つことができます。
  Future<OpenAIChatMsg?> send(
    String message, {
    DateTime? dateTime,
    OpenAIChatRole role = OpenAIChatRole.user,
  }) async {
    if (_sendCompleter != null) {
      return sending;
    }
    _sendCompleter = Completer();
    final response = OpenAIChatMsg._(completer: Completer());
    try {
      _value.removeWhere((element) => element.error);
      _value.add(
        OpenAIChatMsg(
          message,
          role: role,
          dateTime: dateTime ?? DateTime.now(),
        ),
      );
      final messages = _value
          .map((e) => e._toOpenAIChatCompletionChoiceMessageModel())
          .toList();
      _value.add(response);
      notifyListeners();
      final res = await OpenAI.instance.chat.create(
        user: user,
        model: model.name,
        messages: messages,
        temperature: temperature,
        maxTokens: maxTokens,
      );
      if (res.choices.isEmpty) {
        throw Exception("Failed to get response from openai_chat_gpt.");
      }
      response._complete(
        text: res.choices.first.message.content,
        role: OpenAIChatRole.values.firstWhereOrNull(
                (item) => item.name == res.choices.first.message.role) ??
            OpenAIChatRole.assistant,
        dateTime: res.created,
        token: res.usage.totalTokens,
      );
      _usageToken += res.usage.totalTokens;
      notifyListeners();
      _sendCompleter?.complete(response);
      _sendCompleter = null;
      return response;
    } catch (e) {
      response._error(e);
      _sendCompleter?.completeError(e);
      _sendCompleter = null;
      rethrow;
    } finally {
      response._finally();
      _sendCompleter?.complete(null);
      _sendCompleter = null;
    }
  }

  /// Clear all data.
  ///
  /// データをすべてクリアします。
  void clear() {
    if (value.isEmpty) {
      return;
    }
    value.clear();
    notifyListeners();
  }
}

/// Maintains information on chat messages sent and received by OpenAI.
///
/// This itself inherits from [ChangeNotifier] and can wait asynchronously for data sent.
///
/// See [value] for the actual text.
///
/// OpenAIで送信・受信したチャットメッセージの情報を保持します。
///
/// これ自体が[ChangeNotifier]を継承しており、送信したデータを非同期で待つことができます。
///
/// 実際のテキストは[value]を参照してください。
class OpenAIChatMsg extends ChangeNotifier implements ValueListenable<String> {
  /// Maintains information on chat messages sent and received by OpenAI.
  ///
  /// This itself inherits from [ChangeNotifier] and can wait asynchronously for data sent.
  ///
  /// See [value] for the actual text.
  ///
  /// OpenAIで送信・受信したチャットメッセージの情報を保持します。
  ///
  /// これ自体が[ChangeNotifier]を継承しており、送信したデータを非同期で待つことができます。
  ///
  /// 実際のテキストは[value]を参照してください。
  OpenAIChatMsg(
    String value, {
    OpenAIChatRole role = OpenAIChatRole.system,
    DateTime? dateTime,
  }) : this._(
          value: value,
          role: role,
          dateTime: dateTime,
        );

  OpenAIChatMsg._({
    String? value,
    OpenAIChatRole? role,
    DateTime? dateTime,
    int? token,
    Completer? completer,
  })  : _value = value ?? "",
        _role = role ?? OpenAIChatRole.user,
        _dateTime = dateTime,
        _token = token,
        _completer = completer;

  /// [OpenAIChatMsg] is generated by passing [json].
  ///
  /// [json]を渡すことで、[OpenAIChatMsg]を生成します。
  factory OpenAIChatMsg.fromJson(Map<String, dynamic> json) {
    final dateTime = json["time"];
    return OpenAIChatMsg._(
      value: json["content"] ?? "",
      role: json["role"] ?? "user",
      token: json["token"],
      dateTime: dateTime != null
          ? DateTime.fromMillisecondsSinceEpoch(dateTime)
          : null,
    );
  }

  /// Role of OpenAI messages.
  ///
  /// OpenAIのメッセージの役割。
  OpenAIChatRole get role => _role;
  OpenAIChatRole _role;

  /// The actual text. If called in a stream, it is updated each time.
  ///
  /// 実際のテキスト。ストリームで呼ばれている場合は都度更新されます。
  @override
  String get value => _value;
  String _value;

  /// Date and time the message was sent and received.
  ///
  /// メッセージの送信・受信日時。
  DateTime? get dateTime => _dateTime;
  DateTime? _dateTime;

  /// Tokens generated by sending and receiving messages.
  ///
  /// メッセージの送受信で発生したトークン。
  int? get token => _token;
  int? _token;

  /// In case of an error, `true`.
  ///
  /// エラーの場合、`true`になります。
  bool get error => __error;
  bool __error = false;

  /// If a response is awaited, [Future] is returned.
  ///
  /// This can be used to wait for a response.
  ///
  /// レスポンス待ちの場合、[Future]を返します。
  ///
  /// これを利用して、レスポンスを待つことができます。
  Future<void>? get future => _completer?.future;
  Completer<void>? _completer;

  void _complete({
    required String text,
    required OpenAIChatRole role,
    required DateTime dateTime,
    required int token,
  }) {
    _value = text;
    _role = role;
    _dateTime = dateTime;
    _token = token;
    notifyListeners();
    _finally();
  }

  void _error(Object e) {
    __error = true;
    _value = e.toString();
    notifyListeners();
    _completer?.completeError(e);
    _completer = null;
  }

  void _finally() {
    _completer?.complete();
    _completer = null;
  }

  /// Convert [OpenAIChatMsg] to [Map].
  ///
  /// [OpenAIChatMsg]を[Map]に変換します。
  Map<String, dynamic> toJson() {
    return {
      "content": value,
      "role": role,
      if (token != null) "token": token!,
      if (dateTime != null) "time": dateTime?.millisecondsSinceEpoch,
    };
  }

  OpenAIChatCompletionChoiceMessageModel
      _toOpenAIChatCompletionChoiceMessageModel() {
    return OpenAIChatCompletionChoiceMessageModel(
      content: value,
      role: role.name,
    );
  }
}

/// Available models of ChatGPT.
///
/// ChatGPTの利用可能モデル。
enum OpenAIChatModel {
  gpt35Turbo;

  /// Returns the actual name passed to Functions.
  ///
  /// Functionsに渡される実際の名前を返します。
  String get name {
    switch (this) {
      case OpenAIChatModel.gpt35Turbo:
        return "gpt-3.5-turbo";
    }
  }
}

/// Role of OpenAI messages.
///
/// OpenAIのメッセージの役割。
enum OpenAIChatRole {
  /// User.
  ///
  /// ユーザー。
  user,

  /// Assistant.ChatGPT.
  ///
  /// アシスタント。ChatGPT。
  assistant,

  /// System.
  ///
  /// システム。
  system,
}
