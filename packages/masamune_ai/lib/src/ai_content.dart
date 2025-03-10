part of '/masamune_ai.dart';

/// The content of the AI.
///
/// Roles can be set in [role].
///
/// AIの内容。
///
/// [role]に役割を設定可能です。
class AIContent extends ChangeNotifier
    implements ValueListenable<List<AIContentPart>> {
  AIContent({
    this.role = AIRole.system,
    DateTime? time,
    List<AIContentPart> values = const [],
  }) : _time = time ?? DateTime.now() {
    _value.addAll(values);
    _completer = Completer<AIContent>();
  }

  /// Returns content with text prompts to be submitted by the user.
  ///
  /// ユーザーが投稿するテキストプロンプトを持つコンテンツを返します。
  static AIContent text(String text, {DateTime? time}) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentTextPart(text)],
      time: time,
    );
  }

  /// Returns content with text prompts to be submitted by the model.
  ///
  /// モデルが投稿するテキストプロンプトを持つコンテンツを返します。
  static AIContent model({String? text, DateTime? time}) {
    return AIContent(
      role: AIRole.model,
      values: [
        if (text != null) AIContentTextPart(text),
      ],
      time: time,
    );
  }

  /// Returns content with system prompts.
  ///
  /// システムプロンプトを持つコンテンツを返します。
  static AIContent system(List<AIContent> contents) {
    return AIContent(
      role: AIRole.system,
      values: [...contents.expand((e) => e._value)],
    );
  }

  /// Returns content with text file.
  ///
  /// テキストファイルを持つコンテンツを返します。
  static AIContent textFile(Uint8List data, {DateTime? time}) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.txt, data)],
      time: time,
    );
  }

  /// Returns content with PNG image.
  ///
  /// PNG画像を持つコンテンツを返します。
  static AIContent png(Uint8List data, {DateTime? time}) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.png, data)],
      time: time,
    );
  }

  /// Returns content with JPEG image.
  ///
  /// JPEG画像を持つコンテンツを返します。
  static AIContent jpeg(
    Uint8List data, {
    DateTime? time,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.jpeg, data)],
      time: time,
    );
  }

  /// Returns content with WebP image.
  ///
  /// WebP画像を持つコンテンツを返します。
  static AIContent webp(
    Uint8List data, {
    DateTime? time,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.webp, data)],
      time: time,
    );
  }

  /// Returns content with MP4 video.
  ///
  /// MP4動画を持つコンテンツを返します。
  static AIContent mp4Video(
    Uint8List data, {
    DateTime? time,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.mp4Video, data)],
      time: time,
    );
  }

  /// Returns content with QuickTime video.
  ///
  /// QuickTime動画を持つコンテンツを返します。
  static AIContent movVideo(
    Uint8List data, {
    DateTime? time,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.mov, data)],
      time: time,
    );
  }

  /// Returns content with MP3 audio.
  ///
  /// MP3音声を持つコンテンツを返します。
  static AIContent mp3Audio(
    Uint8List data, {
    DateTime? time,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.mp3, data)],
      time: time,
    );
  }

  /// Returns content with WAV audio.
  ///
  /// WAV音声を持つコンテンツを返します。
  static AIContent wavAudio(
    Uint8List data, {
    DateTime? time,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.wav, data)],
      time: time,
    );
  }

  /// Returns content with MP4 audio.
  ///
  /// MP4音声を持つコンテンツを返します。
  static AIContent mp4Audio(
    Uint8List data, {
    DateTime? time,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.mp4Audio, data)],
      time: time,
    );
  }

  /// Returns content with M4A audio.
  ///
  /// M4A音声を持つコンテンツを返します。
  static AIContent m4aAudio(
    Uint8List data, {
    DateTime? time,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.m4a, data)],
      time: time,
    );
  }

  /// Returns content with PDF file.
  ///
  /// PDFファイルを持つコンテンツを返します。
  static AIContent pdfFile(
    Uint8List data, {
    DateTime? time,
  }) {
    return AIContent(
      role: AIRole.user,
      values: [AIContentBinaryPart(AIFileType.pdf, data)],
      time: time,
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

  /// The contents of the AI.
  ///
  /// AIの内容。
  @override
  List<AIContentPart> get value => _value;
  final List<AIContentPart> _value = [];

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

  /// Converts the AI content to a Json-decoded Map<String, dynamic> object.
  ///
  /// AIの内容をJsonデコードされたMap<String, dynamic>オブジェクトに変換します。
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

  /// Completes the AI content.
  ///
  /// AIの内容を完了します。
  void complete({
    DateTime? time,
    int promptTokenCount = 0,
    int candidateTokenCount = 0,
  }) {
    if (_completer == null) {
      return;
    }
    if (time != null) {
      _time = time;
    }
    _promptTokenCount = promptTokenCount;
    _candidateTokenCount = candidateTokenCount;
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

  @override
  String toString() {
    return _value.map((e) => e.toString()).join();
  }

  @override
  bool operator ==(Object other) {
    if (other is AIContent) {
      return toString() == other.toString();
    }
    return false;
  }

  @override
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
}

/// The text part of the AI content.
///
/// AIの内容のテキストの一部。
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
