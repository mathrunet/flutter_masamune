part of '/masamune_ai_openai.dart';

/// Class for starting OpenAI threads and sending messages.
///
/// Pass the corresponding [OpenAIAssistantDocument].
///
/// OpenAIのスレッドを開始したりメッセージを送信したりするためのクラス。
///
/// 対応する[OpenAIAssistantDocument]を渡します。
class OpenAIThread
    extends MasamuneControllerBase<List<OpenAIMessage>, OpenAIMasamuneAdapter> {
  /// Class for starting OpenAI threads and sending messages.
  ///
  /// Pass the corresponding [OpenAIAssistantDocument].
  ///
  /// OpenAIのスレッドを開始したりメッセージを送信したりするためのクラス。
  ///
  /// 対応する[OpenAIAssistantDocument]を渡します。
  OpenAIThread({
    required this.assistant,
    super.adapter,
  }) : super(defaultValue: []);

  @override
  OpenAIMasamuneAdapter get primaryAdapter => OpenAIMasamuneAdapter.primary;

  /// Assistant.
  ///
  /// アシスタント。
  final OpenAIAssistantDocument assistant;

  String? _threadId;
  String? _runId;
  Completer<OpenAIMessage?>? _connectingCompleter;
  Completer<OpenAIMessage?>? _sendingCompleter;
  Completer<void>? _disconnectingCompleter;

  Map<String, String> get _header {
    return {
      "Content-Type": "application/json",
      "OpenAI-Beta": "assistants=v1",
      "Authorization": "Bearer ${OpenAIMasamuneAdapter.primary.apiKey}",
    };
  }

  /// Start thread.
  ///
  /// You can pass initial messages to [initialMessages].
  ///
  /// スレッドを開始します。
  ///
  /// [initialMessages]に初期メッセージを渡すことができます。
  Future<OpenAIMessage?> connect({
    List<OpenAIMessage>? initialMessages,
    String? prompt,
  }) async {
    if (_threadId.isNotEmpty) {
      return null;
    }
    if (_connectingCompleter != null) {
      return _connectingCompleter!.future;
    }
    _connectingCompleter = Completer();
    prompt ??= assistant.value?.prompt;
    if (initialMessages.isNotEmpty) {
      final response = OpenAIMessage._();
      try {
        value?.addAll([
          ...initialMessages ?? [],
          response,
        ]);
        await assistant.load();
        notifyListeners();
        final resCreation = await Api.post(
          "https://api.openai.com/v1/threads/runs",
          headers: _header,
          body: jsonEncode({
            "assistant_id": assistant.uid,
            "thread": {
              "messages": initialMessages?.map((e) => e.toJson()).toList(),
            },
            "model": assistant.value?.model.id ?? OpenAIModel.gpt35Turbo0613.id,
            if (prompt.isNotEmpty) "instructions": prompt,
            if (assistant.value?.tools.isNotEmpty ?? false)
              "tools": assistant.value?.tools.map((e) => e.toJson()).toList(),
          }),
        );
        if (resCreation.statusCode != 200) {
          throw Exception("Failed to connect.");
        }
        final jsonCreation =
            jsonDecodeAsMap(utf8.decode(resCreation.bodyBytes));
        _threadId = jsonCreation.get("thread_id", "");
        await _run(jsonCreation);
        await _retriveMessage(response);
        notifyListeners();
        _connectingCompleter?.complete(response);
        _connectingCompleter = null;
        return response;
      } catch (e) {
        _threadId = _runId = null;
        response._applyError(e.toString());
        notifyListeners();
        _connectingCompleter?.completeError(e);
        _connectingCompleter = null;
        rethrow;
      } finally {
        _connectingCompleter?.complete(response);
        _connectingCompleter = null;
      }
    } else {
      try {
        await assistant.load();
        notifyListeners();
        final resCreation = await Api.post(
          "https://api.openai.com/v1/threads/runs",
          headers: _header,
          body: jsonEncode({
            "assistant_id": assistant.uid,
            "model": assistant.value?.model.id ?? OpenAIModel.gpt35Turbo0613.id,
            if (prompt.isNotEmpty) "instructions": prompt,
            if (assistant.value?.tools.isNotEmpty ?? false)
              "tools": assistant.value?.tools.map((e) => e.toJson()).toList(),
          }),
        );
        if (resCreation.statusCode != 200) {
          throw Exception("Failed to connect.");
        }
        final jsonCreation =
            jsonDecodeAsMap(utf8.decode(resCreation.bodyBytes));
        _threadId = jsonCreation.get("thread_id", "");
        await _run(jsonCreation);
        notifyListeners();
        _connectingCompleter?.complete(null);
        _connectingCompleter = null;
        return null;
      } catch (e) {
        _threadId = _runId = null;
        notifyListeners();
        _connectingCompleter?.completeError(e);
        _connectingCompleter = null;
        rethrow;
      } finally {
        _connectingCompleter?.complete(null);
        _connectingCompleter = null;
      }
    }
  }

  /// Send [message].
  ///
  /// You can pass additional prompts to [additionalPrompt].
  ///
  /// [message]を送信します。
  ///
  /// [additionalPrompt]に追加のプロンプトを渡すことができます。
  Future<OpenAIMessage?> send({
    required OpenAIMessage? message,
    String? additionalPrompt,
  }) async {
    if (_threadId.isEmpty) {
      return Future.error("Not connected.");
    }
    if (_sendingCompleter != null) {
      return _sendingCompleter!.future;
    }
    _sendingCompleter = Completer();
    final response = OpenAIMessage._();
    try {
      if (message != null) {
        value?.add(message);
      }
      value?.add(response);
      notifyListeners();
      if (message != null) {
        final resCreateMessage = await Api.post(
          "https://api.openai.com/v1/threads/$_threadId/messages",
          headers: _header,
          body: jsonEncode({
            "role": "user",
            "content": message.value.text,
          }),
        );
        if (resCreateMessage.statusCode != 200) {
          throw Exception("Failed to send message.");
        }
      }
      // final jsonCreateMessage =
      //     jsonDecodeAsMap(utf8.decode(resCreateMessage.bodyBytes));
      final resCreateRun = await Api.post(
        "https://api.openai.com/v1/threads/$_threadId/runs",
        headers: _header,
        body: jsonEncode({
          "assistant_id": assistant.uid,
          "model": assistant.value?.model.id ?? OpenAIModel.gpt35Turbo0613.id,
          if (assistant.value?.prompt.isNotEmpty ?? false)
            "instructions": assistant.value?.prompt,
          if (additionalPrompt?.isNotEmpty ?? false)
            "additional_instructions": additionalPrompt,
          if (assistant.value?.tools.isNotEmpty ?? false)
            "tools": assistant.value?.tools.map((e) => e.toJson()).toList(),
        }),
      );
      if (resCreateRun.statusCode != 200) {
        throw Exception("Failed to send message.");
      }
      final jsonCreationRun =
          jsonDecodeAsMap(utf8.decode(resCreateRun.bodyBytes));
      await _run(jsonCreationRun);
      await _retriveMessage(response);
      notifyListeners();
      _sendingCompleter?.complete(response);
      _sendingCompleter = null;
      return response;
    } catch (e) {
      response._applyError(e.toString());
      notifyListeners();
      _sendingCompleter?.completeError(e);
      _sendingCompleter = null;
      rethrow;
    } finally {
      _sendingCompleter?.complete(response);
      _sendingCompleter = null;
    }
  }

  /// Disconnect.
  ///
  /// 切断します。
  Future<void> disconnect() async {
    if (_threadId.isEmpty) {
      return;
    }
    await _connectingCompleter?.future;
    await _sendingCompleter?.future;
    if (_disconnectingCompleter != null) {
      return _disconnectingCompleter!.future;
    }
    _disconnectingCompleter = Completer();
    try {
      final res = await Api.delete(
        "https://api.openai.com/v1/threads/$_threadId",
        headers: _header,
      );
      if (res.statusCode != 200) {
        throw Exception("Failed to disconnect.");
      }
      _threadId = _runId = null;
      notifyListeners();
      _disconnectingCompleter?.complete();
      _disconnectingCompleter = null;
    } catch (e) {
      _threadId = _runId = null;
      notifyListeners();
      _disconnectingCompleter?.completeError(e);
      _disconnectingCompleter = null;
      rethrow;
    } finally {
      _disconnectingCompleter?.complete();
      _disconnectingCompleter = null;
    }
  }

  Future<void> _run(DynamicMap runJson) async {
    var status = runJson.get("status", "");
    _runId = runJson.get("id", "");
    if (_threadId.isEmpty || _runId.isEmpty) {
      throw Exception("Failed to connect.");
    }
    while (status == "queued" || status == "in_progress") {
      final resRetrieveRun = await Api.get(
        "https://api.openai.com/v1/threads/$_threadId/runs/$_runId",
        headers: _header,
      );
      if (resRetrieveRun.statusCode != 200) {
        throw Exception("Failed to connect.");
      }
      final jsonRetrieveRun =
          jsonDecodeAsMap(utf8.decode(resRetrieveRun.bodyBytes));
      status = jsonRetrieveRun.get("status", "");
    }
    if (status == "requires_action") {
      final resAction = await Api.post(
        "https://api.openai.com/v1/threads/$_threadId/runs/$_runId/submit_tool_outputs",
        headers: _header,
        body: jsonEncode({
          "tool_outputs": [],
        }),
      );
      if (resAction.statusCode != 200) {
        throw Exception("Failed to connect.");
      }
      final jsonAction = jsonDecodeAsMap(utf8.decode(resAction.bodyBytes));
      debugPrint(jsonAction.toString());
    }
  }

  Future<OpenAIMessage?> _retriveMessage(OpenAIMessage response) async {
    final resMessages = await Api.get(
      "https://api.openai.com/v1/threads/$_threadId/messages",
      headers: _header,
    );
    if (resMessages.statusCode != 200) {
      throw Exception("Failed to connect.");
    }
    final jsonMessage = jsonDecodeAsMap(utf8.decode(resMessages.bodyBytes));
    final newestMessage =
        jsonMessage.getAsList<DynamicMap>("data").firstWhereOrNull(
              (item) =>
                  !(value?.any((e) => e.id == item.get("id", "")) ?? false) &&
                  item.get("role", "") == "assistant",
            );
    if (newestMessage != null) {
      response._applyFromJson(newestMessage);
    }
    return response;
  }

  @override
  void dispose() {
    super.dispose();
    disconnect();
  }
}
