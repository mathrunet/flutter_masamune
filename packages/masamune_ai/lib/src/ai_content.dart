part of "/masamune_ai.dart";

/// The content of the AI.
///
/// Roles can be set in [role].
///
/// AIの内容。
///
/// [role]に役割を設定可能です。
class AIContent extends ChangeNotifier
    implements ValueListenable<List<AIContentPart>> {
  /// The content of the AI.
  ///
  /// Roles can be set in [role].
  ///
  /// AIの内容。
  ///
  /// [role]に役割を設定可能です。
  AIContent({
    this.role = AIRole.system,
    DateTime? time,
    List<AIContentPart> values = const [],
    String? id,
    this.userId,
    bool completed = false,
  })  : _time = time ?? Clock.now(),
        id = id ?? uuid() {
    _value.addAll(values);
    if (!completed) {
      _completer = Completer<AIContent>();
    }
  }

  /// Returns content with text prompts to be submitted by the user.
  ///
  /// ユーザーが投稿するテキストプロンプトを持つコンテンツを返します。
  factory AIContent.text(String text,
      {DateTime? time, String? id, String? userId, bool completed = false}) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentTextPart(text)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with JSON.
  ///
  /// JSONを持つコンテンツを返します。
  factory AIContent.json(Map<String, dynamic> json,
      {DateTime? time, String? id, String? userId, bool completed = false}) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentTextPart(jsonEncode(json))],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with text prompts to be submitted by the model.
  ///
  /// モデルが投稿するテキストプロンプトを持つコンテンツを返します。
  factory AIContent.model(
      {String? text,
      DateTime? time,
      String? id,
      String? userId,
      bool completed = false}) {
    return AIContent(
      role: AIRole.model,
      values: [
        if (text != null) AIContentTextPart(text),
      ],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with system prompts.
  ///
  /// システムプロンプトを持つコンテンツを返します。
  factory AIContent.system(List<AIContent> contents) {
    return AIContent(
      role: AIRole.system,
      values: [...contents.expand((e) => e._value)],
      completed: true,
    );
  }

  /// Returns content with text file.
  ///
  /// テキストファイルを持つコンテンツを返します。
  factory AIContent.textFile(Uint8List data,
      {DateTime? time, String? id, String? userId, bool completed = false}) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.txt, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with PNG image.
  ///
  /// PNG画像を持つコンテンツを返します。
  factory AIContent.png(Uint8List data,
      {DateTime? time, String? id, String? userId, bool completed = false}) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.png, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with JPEG image.
  ///
  /// JPEG画像を持つコンテンツを返します。
  factory AIContent.jpeg(
    Uint8List data, {
    DateTime? time,
    String? id,
    String? userId,
    bool completed = false,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.jpeg, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with WebP image.
  ///
  /// WebP画像を持つコンテンツを返します。
  factory AIContent.webp(
    Uint8List data, {
    DateTime? time,
    String? id,
    String? userId,
    bool completed = false,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.webp, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with MP4 video.
  ///
  /// MP4動画を持つコンテンツを返します。
  factory AIContent.mp4Video(
    Uint8List data, {
    DateTime? time,
    String? id,
    String? userId,
    bool completed = false,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.mp4Video, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with QuickTime video.
  ///
  /// QuickTime動画を持つコンテンツを返します。
  factory AIContent.movVideo(
    Uint8List data, {
    DateTime? time,
    String? id,
    String? userId,
    bool completed = false,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.mov, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with MP3 audio.
  ///
  /// MP3音声を持つコンテンツを返します。
  factory AIContent.mp3Audio(
    Uint8List data, {
    DateTime? time,
    String? id,
    String? userId,
    bool completed = false,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.mp3, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with WAV audio.
  ///
  /// WAV音声を持つコンテンツを返します。
  factory AIContent.wavAudio(
    Uint8List data, {
    DateTime? time,
    String? id,
    String? userId,
    bool completed = false,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.wav, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with MP4 audio.
  ///
  /// MP4音声を持つコンテンツを返します。
  factory AIContent.mp4Audio(
    Uint8List data, {
    DateTime? time,
    String? id,
    String? userId,
    bool completed = false,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.mp4Audio, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with M4A audio.
  ///
  /// M4A音声を持つコンテンツを返します。
  factory AIContent.m4aAudio(
    Uint8List data, {
    DateTime? time,
    String? id,
    String? userId,
    bool completed = false,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.m4a, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// Returns content with PDF file.
  ///
  /// PDFファイルを持つコンテンツを返します。
  factory AIContent.pdfFile(
    Uint8List data, {
    DateTime? time,
    String? id,
    String? userId,
    bool completed = false,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.pdf, data)],
      time: time,
      id: id,
      userId: userId,
      completed: completed,
    );
  }

  /// If the AI is in the process of responding, [Future] is returned.
  ///
  /// AIがレスポンス中の場合は[Future]を返します。
  Future<AIContent>? get loading => _completer?.future;
  Completer<AIContent>? _completer;

  /// The role of the AI.
  ///
  /// AIの役割。
  final AIRole role;

  /// The created time of the AI content.
  ///
  /// AIの内容の作成時間。
  DateTime get time => _time;
  DateTime _time;

  /// AI content ID (if applicable).
  ///
  /// AIの内容のID。（必要あれば）
  final String id;

  /// Non-AI user ID.
  ///
  /// 非AIのユーザーID。
  final String? userId;

  /// The contents of the AI.
  ///
  /// AIの内容。
  @override
  List<AIContentPart> get value => _value;
  final List<AIContentPart> _value = [];

  /// Record of function interaction with AI.
  ///
  /// AIとの関数のやりとりの記録。
  List<AIContentFunctionPair> get functions => _functions;
  final List<AIContentFunctionPair> _functions = [];

  /// Whether the function calls are completed.
  ///
  /// 関数呼び出しが完了しているかどうか。
  bool get isFunctionsCompleted => _functions.every((e) => e.completed);

  /// The prompt token count of the AI.
  ///
  /// AIのプロンプトトークン数。
  int? get promptTokenCount => _promptTokenCount;
  int? _promptTokenCount;

  /// The candidate token count of the AI.
  ///
  /// AIの候補トークン数。
  int? get candidateTokenCount => _candidateTokenCount;
  int? _candidateTokenCount;

  /// Converts the AI content to a Json-decoded Map&lt;String, dynamic&gt; object.
  ///
  /// AIの内容をJsonデコードされたMap&lt;String, dynamic&gt;オブジェクトに変換します。
  DynamicMap? toJson() {
    try {
      return (jsonDecode(toString()) as DynamicMap).cast<String, dynamic>();
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  /// Adds the AI content part.
  ///
  /// AIの内容の一部を追加します。
  void add(List<AIContentPart> values, {DateTime? time}) {
    if (_completer == null) {
      return;
    }
    if (time != null) {
      _time = time;
    }
    final merged = <AIContentPart>[];
    merged.addAll(_value);

    for (final part in values) {
      if (part is AIContentFunctionCallPart) {
        _functions.add(AIContentFunctionPair(call: part));
        continue;
      } else if (part is AIContentFunctionResponsePart) {
        final uncompleted = _functions.lastWhereOrNull((e) => !e.completed);
        if (uncompleted == null) {
          throw Exception("No function call found.");
        }
        uncompleted.set(part);
        continue;
      }
      if (merged.isEmpty) {
        merged.add(part);
      } else {
        if (part is AIContentTextPart) {
          final last = merged[merged.length - 1];
          if (last is AIContentTextPart) {
            merged[merged.length - 1] = last.mergeWith(part);
          } else {
            merged.add(part);
          }
        } else {
          merged.add(part);
        }
      }
    }
    _value.clear();
    _value.addAll(merged);
    notifyListeners();
  }

  /// Sets the usage of the AI.
  ///
  /// AIの使用量をセットします。
  void usage({
    int promptTokenCount = 0,
    int candidateTokenCount = 0,
  }) {
    _promptTokenCount = (_promptTokenCount ?? 0) + promptTokenCount;
    _candidateTokenCount = (_candidateTokenCount ?? 0) + candidateTokenCount;
    notifyListeners();
  }

  /// Sets the function response for the contents of the AI.
  ///
  /// AIの内容の関数レスポンスをセットします。
  void response(AIContentFunctionResponsePart response) {
    final uncompleted = _functions.lastWhereOrNull((e) => !e.completed);
    if (uncompleted == null) {
      throw Exception("No function call found.");
    }
    uncompleted.set(response);
  }

  /// Completes the AI content.
  ///
  /// AIの内容を完了します。
  void complete({DateTime? time}) {
    if (_completer == null) {
      return;
    }
    final uncompleted = _functions.lastWhereOrNull((e) => !e.completed);
    if (uncompleted != null) {
      throw Exception("Function call not completed.");
    }
    if (time != null) {
      _time = time;
    }
    _functions.clear();
    _completer?.complete(this);
    _completer = null;
    notifyListeners();
  }

  /// Errors the AI content.
  ///
  /// AIの内容をエラーにします。
  void error(Object error, [StackTrace? stackTrace]) {
    if (_completer == null) {
      return;
    }
    _completer?.completeError(error, stackTrace);
    _completer = null;
    notifyListeners();
  }

  /// Filters the AI content parts.
  ///
  /// AIの内容の一部をフィルターします。
  AIContent where(bool Function(AIContentPart part) test) {
    return AIContent(
      role: role,
      values: _value.where(test).toList(),
    );
  }

  /// Copies the AI content.
  ///
  /// AIの内容をコピーします。
  AIContent copyWith({
    List<AIContentPart>? values,
    DateTime? time,
    String? id,
    String? userId,
  }) {
    return AIContent(
      role: role,
      values: values ?? _value,
      time: time ?? _time,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      completed: _completer == null,
    );
  }

  @override
  String toString() {
    return _value.map((e) => e.toString()).join();
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is AIContent) {
      return toString() == other.toString();
    }
    return false;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => toString().hashCode;
}

/// The part of the AI content.
///
/// AIの内容の一部。
abstract class AIContentPart {
  /// The part of the AI content.
  ///
  /// AIの内容の一部。
  const AIContentPart();

  static AIContentPart? _fromContent(Content content) {
    if (content is mcp.TextContent) {
      return AIContentTextPart(content.text);
    } else if (content is mcp.ImageContent) {
      switch (content.mimeType) {
        case "image/jpeg":
          return AIContentBinaryPart(
              AIFileType.jpeg, base64Decode(content.data));
        case "image/png":
          return AIContentBinaryPart(
              AIFileType.png, base64Decode(content.data));
        case "image/webp":
          return AIContentBinaryPart(
              AIFileType.webp, base64Decode(content.data));
      }
    }
    return null;
  }

  /// Converts the AI content part to a MCP content.
  ///
  /// AIの内容の一部をMCPの内容に変換します。
  Content? toMcpContent();
}

/// The text part of the AI content.
///
/// AIの内容のテキストの一部。
@immutable
class AIContentTextPart extends AIContentPart {
  /// The text part of the AI content.
  ///
  /// AIの内容のテキストの一部。
  const AIContentTextPart(this.text);

  /// The text of the AI content.
  ///
  /// AIの内容のテキスト。
  final String text;

  /// Merges the AI content text part with another AI content text part.
  ///
  /// AIの内容のテキストの一部を別のAIの内容のテキストの一部とマージします。
  AIContentTextPart mergeWith(
    AIContentTextPart other, {
    String delimiter = "",
  }) {
    return AIContentTextPart(text + delimiter + other.text);
  }

  @override
  Content? toMcpContent() {
    return mcp.TextContent(text: text);
  }

  /// Copies the AI content text part.
  ///
  /// AIの内容のテキストの一部をコピーします。
  AIContentTextPart copyWith({
    String? text,
  }) {
    return AIContentTextPart(text ?? this.text);
  }

  @override
  String toString() {
    return text;
  }

  @override
  bool operator ==(Object other) {
    if (other is AIContentTextPart) {
      return text == other.text;
    }
    return false;
  }

  @override
  int get hashCode => text.hashCode;
}

/// The binary part of the AI content.
///
/// AIの内容のバイナリの一部。
@immutable
class AIContentBinaryPart extends AIContentPart {
  /// The binary part of the AI content.
  ///
  /// AIの内容のバイナリの一部。
  const AIContentBinaryPart(this.type, this.value);

  /// The mime type of the AI content.
  ///
  /// AIの内容のMIMEタイプ。
  final AIFileType type;

  /// The data of the AI content.
  ///
  /// AIの内容のバイナリ。
  final Uint8List value;

  @override
  Content? toMcpContent() {
    switch (type) {
      case AIFileType.jpeg:
      case AIFileType.png:
      case AIFileType.webp:
        return mcp.ImageContent(
            data: base64Encode(value), mimeType: type.mimeType);
      default:
        return null;
    }
  }

  /// Copies the AI content binary part.
  ///
  /// AIの内容のバイナリの一部をコピーします。
  AIContentBinaryPart copyWith({
    AIFileType? type,
    Uint8List? value,
  }) {
    return AIContentBinaryPart(type ?? this.type, value ?? this.value);
  }

  @override
  String toString() {
    return "";
  }

  @override
  bool operator ==(Object other) {
    if (other is AIContentBinaryPart) {
      return type == other.type && value.length == other.value.length;
    }
    return false;
  }

  @override
  int get hashCode => type.hashCode ^ value.length.hashCode;
}

/// The file part of the AI content.
///
/// AIの内容のファイルの一部。
@immutable
class AIContentFilePart extends AIContentPart {
  /// The file part of the AI content.
  ///
  /// AIの内容のファイルの一部。
  const AIContentFilePart(this.type, this.uri);

  /// The mime type of the AI content.
  ///
  /// AIの内容のMIMEタイプ。
  final AIFileType type;

  /// The uri of the AI content.
  ///
  /// AIの内容のURI。
  final Uri uri;

  @override
  Content? toMcpContent() {
    return null;
  }

  /// Copies the AI content file part.

  /// AIの内容のファイルの一部をコピーします。
  AIContentFilePart copyWith({
    AIFileType? type,
    Uri? uri,
  }) {
    return AIContentFilePart(type ?? this.type, uri ?? this.uri);
  }

  @override
  String toString() {
    return "";
  }

  @override
  bool operator ==(Object other) {
    if (other is AIContentFilePart) {
      return type == other.type && uri == other.uri;
    }
    return false;
  }

  @override
  int get hashCode => type.hashCode ^ uri.hashCode;
}

/// The function call part of the AI content.
///
/// AIの内容の関数呼び出しの一部。
@immutable
class AIContentFunctionCallPart extends AIContentPart {
  /// The function call part of the AI content.
  ///
  /// AIの内容の関数呼び出しの一部。
  const AIContentFunctionCallPart({
    required this.name,
    this.args = const {},
  });

  /// The name of the function to call.
  ///
  /// 呼び出す関数の名前。
  final String name;

  /// The function parameters and values.
  ///
  /// 関数のパラメータと値。
  final Map<String, dynamic> args;

  /// Converts the function call part to a function response part.
  ///
  /// 関数呼び出しの一部を関数レスポンスの一部に変換します。
  AIContentFunctionResponsePart toResponse([
    Map<String, dynamic> response = const {},
  ]) {
    return AIContentFunctionResponsePart(
      name: name,
      response: {...args, ...response},
    );
  }

  @override
  Content? toMcpContent() {
    return null;
  }

  /// Copies the AI content function call part.
  ///
  /// AIの内容の関数呼び出しの一部をコピーします。
  AIContentFunctionCallPart copyWith({
    String? name,
    Map<String, dynamic>? args,
  }) {
    return AIContentFunctionCallPart(
      name: name ?? this.name,
      args: args ?? this.args,
    );
  }

  @override
  String toString() {
    return "";
  }

  @override
  bool operator ==(Object other) {
    if (other is AIContentFunctionCallPart) {
      return name == other.name && args.equalsTo(other.args);
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode ^ args.hashCode;
}

/// The function call part of the AI content.
///
/// AIの内容の関数呼び出しの一部。
@immutable
class AIContentFunctionResponsePart extends AIContentPart {
  /// The function response part of the AI content.
  ///
  /// AIの内容の関数レスポンスの一部。
  const AIContentFunctionResponsePart({
    required this.name,
    this.response = const {},
  });

  /// Name of the function that will return the response.
  ///
  /// レスポンスを返す関数の名前。
  final String name;

  /// Response parameters and values.
  ///
  /// レスポンスのパラメータと値。
  final Map<String, dynamic> response;

  @override
  Content? toMcpContent() {
    return null;
  }

  /// Copies the AI content function response part.
  ///
  /// AIの内容の関数レスポンスの一部をコピーします。
  AIContentFunctionResponsePart copyWith({
    Map<String, dynamic>? response,
  }) {
    return AIContentFunctionResponsePart(
        name: name, response: response ?? this.response);
  }

  @override
  String toString() {
    return "";
  }

  @override
  bool operator ==(Object other) {
    if (other is AIContentFunctionResponsePart) {
      return name == other.name && response.equalsTo(other.response);
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode ^ response.hashCode;
}

/// The function pair of the AI content.
///
/// AIの内容の関数ペア。
class AIContentFunctionPair {
  /// The function pair of the AI content.
  ///
  /// AIの内容の関数ペア。
  AIContentFunctionPair({
    required this.call,
    this.response,
  });

  /// The function call part of the AI content.
  ///
  /// AIの内容の関数呼び出しの一部。
  final AIContentFunctionCallPart call;

  /// The function response part of the AI content.
  ///
  /// AIの内容の関数レスポンスの一部。
  AIContentFunctionResponsePart? response;

  /// Sets the function response for the contents of the AI.
  ///
  /// AIの内容の関数レスポンスをセットします。
  void set(AIContentFunctionResponsePart response) {
    if (this.response != null) {
      throw Exception("Response already set.");
    }
    this.response = response;
  }

  /// Whether the function response is completed.
  ///
  /// 関数レスポンスが完了しているかどうか。
  bool get completed => response != null;

  @override
  String toString() {
    return "$call/$response";
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is AIContentFunctionPair) {
      return call == other.call && response == other.response;
    }
    return false;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => call.hashCode ^ response.hashCode;
}
