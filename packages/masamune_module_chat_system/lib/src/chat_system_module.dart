part of '/masamune_module_chat_system.dart';

/// This module is designed to build an application that allows users to interact with the chat GPT, where voice is also available.
///
/// [initialize] performs initialization.
///
/// 音声も利用可能なチャットGPTとの対話を可能にするアプリを構築するためのモジュールです。
///
/// [initialize]で初期化を行います。
class ChatSystemModule extends MasamuneControllerBase<List<ChatSystemValue>,
    ChatSystemModuleMasamuneAdapter> {
  /// This module is designed to build an application that allows users to interact with the chat GPT, where voice is also available.
  ///
  /// [initialize] performs initialization.
  ///
  /// 音声も利用可能なチャットGPTとの対話を可能にするアプリを構築するためのモジュールです。
  ///
  /// [initialize]で初期化を行います。
  ChatSystemModule({
    super.adapter,
    required this.options,
  });

  /// Query for ChatSystemModule.
  ///
  /// ```dart
  /// appRef.controller(ChatSystemModule.query(parameters));     // Get from application scope.
  /// ref.app.controller(ChatSystemModule.query(parameters));    // Watch at application scope.
  /// ref.page.controller(ChatSystemModule.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$ChatSystemModuleQuery();

  @override
  ChatSystemModuleMasamuneAdapter get primaryAdapter =>
      ChatSystemModuleMasamuneAdapter.primary;

  /// Returns `true` if initialization is complete.
  ///
  /// 初期化が完了している場合`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  /// Text-to-speech controller.
  ///
  /// テキストtoスピーチのコントローラー。
  TextToSpeechController get textToSpeechController {
    if (adapter.textToSpeechController != null) {
      return adapter.textToSpeechController!;
    }
    _textToSpeechController ??= TextToSpeechController();
    return _textToSpeechController!;
  }

  TextToSpeechController? _textToSpeechController;

  /// Text-to-speech controller.
  ///
  /// テキストtoスピーチのコントローラー。
  SpeechToTextController get speechToTextController {
    if (adapter.speechToTextController != null) {
      return adapter.speechToTextController!;
    }
    _speechToTextController ??= SpeechToTextController();
    return _speechToTextController!;
  }

  SpeechToTextController? _speechToTextController;

  /// Seed for chat.
  ///
  /// チャット用のシード。
  int get chatSeed => _chatSeed ?? 0;
  int? _chatSeed;

  /// Conversation options.
  ///
  /// 会話のオプション。
  final ChatSystemOptions options;

  bool _disposed = false;
  ChatSystemStatus status = ChatSystemStatus.idle;
  late final OpenAIAssistantDocument _assistant;
  late final OpenAIThread _thread;
  Completer<void>? _initializeCompleter;
  Completer<void>? _startingCompleter;

  @override
  List<ChatSystemValue> get value => _value;
  final List<ChatSystemValue> _value = [];

  /// Initialization.
  ///
  /// 初期化を行います。
  Future<void> initialize() async {
    if (_initializeCompleter != null) {
      return _initializeCompleter!.future;
    }
    if (initialized) {
      return;
    }
    _initializeCompleter = Completer<void>();
    try {
      _chatSeed ??= DateTime.now().millisecondsSinceEpoch;
      await wait([
        speechToTextController.initialize(),
        textToSpeechController.initialize(),
      ]);
      _initialized = true;
      notifyListeners();
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    } catch (e) {
      _initializeCompleter?.completeError(e);
      _initializeCompleter = null;
      rethrow;
    } finally {
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    }
  }

  /// Start of chat.
  ///
  /// チャットのスタート。
  Future<void> startChat() async {
    if (_startingCompleter != null) {
      return _startingCompleter!.future;
    }
    _startingCompleter = Completer<void>();
    try {
      await initialize();
      _chatSeed ??= DateTime.now().millisecondsSinceEpoch;
      await wait([
        speechToTextController.initialize(),
        textToSpeechController.initialize(),
      ]);
      if (_disposed) {
        return;
      }
      final assistantId =
          options.assistantId ?? adapter.option.defaultAssistantId;
      if (assistantId.isEmpty) {
        throw Exception("Assistant ID is not set.");
      }
      final instruction =
          options.instruction ?? adapter.option.defaultInstruction;
      if (instruction.isEmpty) {
        throw Exception("Instruction is not set.");
      }
      final now = DateTime.now();
      _assistant = OpenAIAssistantDocument(assistantId!);
      _thread = OpenAIThread(assistant: _assistant);
      final firstMessage = options.firstMessage;
      if (firstMessage.isNotEmpty) {
        final chat = ChatSystemValue(
          id: uuid(),
          role: ChatSystemRole.person,
        );
        chat._set(text: firstMessage!, time: now);
        _value.add(chat);
        final resChat = ChatSystemValue(
          id: uuid(),
          role: ChatSystemRole.ai,
        );
        status = ChatSystemStatus.aiThink;
        _value.add(resChat);
        notifyListeners();
        await _thread.connect(prompt: instruction);
        if (_disposed) {
          return;
        }
        try {
          final messageValue = firstMessage.toOpenAIUserMessage();
          final response = await _thread.send(message: messageValue);
          if (_disposed) {
            return;
          }
          if (response == null) {
            resChat._error();
          } else {
            resChat._set(text: response.value.text, time: DateTime.now());
          }
        } catch (e) {
          resChat._error(e.toString());
        }
        notifyListeners();
        _startingCompleter?.complete();
        _startingCompleter = null;
        speakAi(message: resChat);
      } else {
        await _thread.connect(prompt: instruction);
        if (_disposed) {
          return;
        }
        status = ChatSystemStatus.personWait;
        notifyListeners();
        _startingCompleter?.complete();
        _startingCompleter = null;
      }
    } catch (e) {
      _startingCompleter?.completeError(e);
      _startingCompleter = null;
      rethrow;
    } finally {
      _startingCompleter?.complete();
      _startingCompleter = null;
    }
  }

  /// AI will think of a response to a given [message].
  ///
  /// [message]を与えてその返答をAIが考えます。
  Future<void> thinkAi({
    String? message,
  }) async {
    if (_disposed) {
      return;
    }
    await initialize();
    final chat = ChatSystemValue(
      id: uuid(),
      role: ChatSystemRole.ai,
    );
    status = ChatSystemStatus.aiThink;
    _value.add(chat);
    notifyListeners();
    try {
      final messageValue = message.toOpenAIUserMessage();
      final res = await _thread.send(message: messageValue);
      if (_disposed) {
        return;
      }
      if (res == null) {
        chat._error();
      } else {
        chat._set(text: res.value.text, time: DateTime.now());
      }
    } catch (e) {
      chat._error(e.toString());
    }
    speakAi(message: chat);
  }

  /// AI's [message] is uttered.
  ///
  /// AIの[message]を発話します。
  Future<void> speakAi({required ChatSystemValue message}) async {
    if (status != ChatSystemStatus.aiThink &&
        status != ChatSystemStatus.finished &&
        status != ChatSystemStatus.personWait &&
        status != ChatSystemStatus.personSpeak) {
      return;
    }
    if (_disposed) {
      return;
    }
    await initialize();
    await wait([
      textToSpeechController.cancel(),
      speechToTextController.cancel(),
    ]);
    _value.removeWhere((e) => e.waiting);
    if (_disposed) {
      return;
    }
    if (status == ChatSystemStatus.finished) {
      notifyListeners();
      await textToSpeechController.speak(
        message.text,
        locale: options.locale ?? adapter.option.locale,
      );
      notifyListeners();
    } else {
      status = ChatSystemStatus.aiSpeak;
      notifyListeners();
      await textToSpeechController.speak(
        message.text,
        locale: options.locale ?? adapter.option.locale,
      );
      if (options.autoListenFromPerson) {
        startListenPerson();
      } else {
        status = ChatSystemStatus.personWait;
        notifyListeners();
      }
    }
  }

  /// Listens for user speech.
  ///
  /// ユーザーの発話をリッスンします。
  Future<void> startListenPerson() async {
    if (status != ChatSystemStatus.personWait &&
        status != ChatSystemStatus.aiSpeak) {
      return;
    }
    if (_disposed) {
      return;
    }
    await initialize();
    await textToSpeechController.cancel();
    status = ChatSystemStatus.personSpeak;
    final chat = ChatSystemValue(
      id: uuid(),
      role: ChatSystemRole.person,
    );
    _value.add(chat);
    notifyListeners();
    try {
      final res = await speechToTextController.listen(
        duration: 10.s,
        locale: options.locale ?? adapter.option.locale,
        onChanged: (text) {
          if (_disposed) {
            return;
          }
          chat._set(text: text.value, time: DateTime.now());
          notifyListeners();
        },
      );
      _stopListenPerson(res?.value);
    } catch (e) {
      status = ChatSystemStatus.personWait;
      _value.removeWhere((e) => e.waiting);
    }
    if (_disposed) {
      return;
    }
    notifyListeners();
  }

  /// Stops listening for user speech.
  ///
  /// ユーザーの発話のリッスンを停止します。
  Future<void> stopListenPerson() async {
    if (status != ChatSystemStatus.personSpeak) {
      return;
    }
    if (_disposed) {
      return;
    }
    await initialize();
    await speechToTextController.stop();
  }

  Future<void> _stopListenPerson([String? message]) async {
    final res = message ?? speechToTextController.value.lastOrNull?.value;
    if (res.isEmpty || !speechToTextController.updated) {
      status = ChatSystemStatus.personWait;
      _value.removeWhere((e) => e.waiting);
      if (_disposed) {
        return;
      }
      notifyListeners();
    } else {
      status = ChatSystemStatus.personSpoke;
      final chat = _value.firstWhereOrNull(
        (item) => item.waiting && item.role == ChatSystemRole.person,
      );
      if (_disposed) {
        return;
      }
      chat?._set(text: res!, time: DateTime.now());
      notifyListeners();
      thinkAi(message: res!);
    }
  }

  /// Enter the user's [message] directly.
  ///
  /// ユーザーの[message]を直接入力します。
  Future<void> inputPerson({required String message}) async {
    if (message.isEmpty) {
      return;
    }
    if (status != ChatSystemStatus.personWait &&
        status != ChatSystemStatus.aiSpeak) {
      return;
    }
    if (_disposed) {
      return;
    }
    await initialize();
    await textToSpeechController.cancel();
    status = ChatSystemStatus.personSpeak;
    final chat = ChatSystemValue(
      id: uuid(),
      role: ChatSystemRole.person,
    );
    chat._set(text: message, time: DateTime.now());
    _value.add(chat);
    status = ChatSystemStatus.personSpoke;
    notifyListeners();
    thinkAi(message: message);
  }

  /// Stops speech.
  ///
  /// 発話を停止します。
  Future<void> pause() async {
    if (status != ChatSystemStatus.personSpeak) {
      return;
    }
    if (_disposed) {
      return;
    }
    await initialize();
    await wait([
      textToSpeechController.cancel(),
      speechToTextController.cancel(),
    ]);
    _value.removeWhere((e) => e.waiting);
    status = ChatSystemStatus.personWait;
    notifyListeners();
  }

  /// Ends the chat.
  ///
  /// If [finishMessage] is specified, the user's last utterance can be specified. If [finishResponseMessage] is specified, you can specify the AI's response to the user's last utterance.
  ///
  /// チャットを終了します。
  ///
  /// [finishMessage]を指定するとユーザーの最後の発話を指定できます。[finishResponseMessage]を指定するとそれに対するAIの返答を指定できます。
  Future<void> finishChat({
    String? finishMessage,
    String? finishResponseMessage,
  }) async {
    if (_disposed) {
      return;
    }
    if (status != ChatSystemStatus.aiThink &&
        status != ChatSystemStatus.personWait &&
        status != ChatSystemStatus.personSpeak) {
      return;
    }
    await initialize();
    final now = DateTime.now();
    status = ChatSystemStatus.finished;
    if (finishMessage.isNotEmpty) {
      final chat = ChatSystemValue(
        id: uuid(),
        role: ChatSystemRole.person,
      );
      chat._set(text: finishMessage!, time: now);
      _value.add(chat);
    }
    if (finishResponseMessage.isNotEmpty) {
      final resChat = ChatSystemValue(
        id: uuid(),
        role: ChatSystemRole.ai,
      );
      resChat._set(text: finishResponseMessage!, time: now);
      _value.add(resChat);
      speakAi(message: resChat);
    } else {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    wait([
      _thread.disconnect(),
      textToSpeechController.cancel(),
      speechToTextController.cancel(),
    ]);
    super.dispose();
  }
}

@immutable
class _$ChatSystemModuleQuery {
  const _$ChatSystemModuleQuery();

  @useResult
  _$_ChatSystemModuleQuery call({
    required ChatSystemOptions options,
  }) =>
      _$_ChatSystemModuleQuery(
        (hashCode ^ options.hashCode).toString(),
        options: options,
      );
}

@immutable
class _$_ChatSystemModuleQuery extends ControllerQueryBase<ChatSystemModule> {
  const _$_ChatSystemModuleQuery(
    this._name, {
    required this.options,
  });

  final String _name;

  final ChatSystemOptions options;

  @override
  ChatSystemModule Function() call(Ref ref) {
    return () => ChatSystemModule(
          options: options,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
