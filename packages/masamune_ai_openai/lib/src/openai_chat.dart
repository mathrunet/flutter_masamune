part of masamune_ai_openai;

class OpenAIChat extends ChangeNotifier
    implements ValueListenable<List<OpenAIChatMsg>> {
  OpenAIChat({
    this.user = "user",
    this.model = OpenAIChatModel.gpt35Turbo,
    List<OpenAIChatMsg>? initialValue,
    this.maxTokens = 300,
    this.temperature,
  }) {
    _value = initialValue ?? [];
  }

  final String user;
  final OpenAIChatModel model;
  final int? maxTokens;
  final double? temperature;

  int get usageToken => _usageToken;
  int _usageToken = 0;

  @override
  List<OpenAIChatMsg> get value => _value;

  Completer<OpenAIChatMsg?>? _sendCompleter;

  Future<OpenAIChatMsg?>? get sending => _sendCompleter?.future;

  late final List<OpenAIChatMsg> _value;

  Future<OpenAIChatMsg?> send(
    String message, {
    DateTime? dateTime,
  }) async {
    if (_sendCompleter != null) {
      return sending;
    }
    _sendCompleter = Completer();
    final response = OpenAIChatMsg._(completer: Completer());
    try {
      _value.add(
        OpenAIChatMsg(
          message,
          role: user,
          dateTime: dateTime ?? DateTime.now(),
        ),
      );
      final messages = value
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
        role: res.choices.first.message.role,
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
}

class OpenAIChatMsg extends ChangeNotifier implements ValueListenable<String> {
  OpenAIChatMsg(
    String value, {
    String role = "user",
    DateTime? dateTime,
  }) : this._(
          value: value,
          role: role,
          dateTime: dateTime,
        );

  OpenAIChatMsg._({
    String? value,
    String? role,
    DateTime? dateTime,
    int? token,
    Completer? completer,
  })  : _value = value ?? "",
        _role = role ?? "",
        _dateTime = dateTime,
        _token = token,
        _completer = completer;

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

  String get role => _role;
  String _role;

  @override
  String get value => _value;
  String _value;

  DateTime? get dateTime => _dateTime;
  DateTime? _dateTime;

  int? get token => _token;
  int? _token;

  bool get error => __error;
  bool __error = false;

  Future<void>? get future => _completer?.future;
  Completer<void>? _completer;

  void _complete({
    required String text,
    required String role,
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
      role: role,
    );
  }
}

enum OpenAIChatModel {
  gpt35Turbo;

  String get name {
    switch (this) {
      case OpenAIChatModel.gpt35Turbo:
        return "gpt-3.5-turbo";
    }
  }
}
