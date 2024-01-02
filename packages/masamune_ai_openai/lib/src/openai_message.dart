part of '/masamune_ai_openai.dart';

/// Define messages to be exchanged in OpenAI threads.
///
/// If [status] is [OpenAIMessageStatus.queued], the message is being read and the UI for it should be displayed.
///
/// The content of the message is contained in [value].
///
/// OpenAIのスレッドでやりとりするためのメッセージを定義します。
///
/// [status]が[OpenAIMessageStatus.queued]の場合は、読み込み中なのでそれ用のUIを表示してください。
///
/// [value]にメッセージの内容が入っています。
class OpenAIMessage extends ChangeNotifier
    implements ValueListenable<List<OpenAIMessageValue>> {
  OpenAIMessage._();

  /// Define messages to be exchanged in OpenAI threads.
  ///
  /// If [status] is [OpenAIMessageStatus.queued], the message is being read and the UI for it should be displayed.
  ///
  /// The content of the message is contained in [value].
  ///
  /// OpenAIのスレッドでやりとりするためのメッセージを定義します。
  ///
  /// [status]が[OpenAIMessageStatus.queued]の場合は、読み込み中なのでそれ用のUIを表示してください。
  ///
  /// [value]にメッセージの内容が入っています。
  OpenAIMessage.fromUser({required String content}) {
    _id = uuid();
    _role = OpenAIMessageRole.user;
    _value = [
      OpenAIMessageValue(
        type: OpenAIMessageValueType.text,
        value: content,
      ),
    ];
    _status = OpenAIMessageStatus.complete;
  }

  void _applyError([String? errorMessage]) {
    if (status != OpenAIMessageStatus.queued || id.isNotEmpty || role != null) {
      return;
    }
    _status = OpenAIMessageStatus.error;
    if (errorMessage.isNotEmpty) {
      _value = [
        OpenAIMessageValue(
          type: OpenAIMessageValueType.text,
          value: errorMessage ?? "",
        ),
      ];
    }
    notifyListeners();
  }

  void _applyFromJson(DynamicMap? json) {
    if (json.isEmpty || id.isNotEmpty || role != null) {
      return;
    }
    _status = OpenAIMessageStatus.complete;
    _time = DateTime.fromMillisecondsSinceEpoch(
        json.get("time", DateTime.now().millisecondsSinceEpoch ~/ 1000));
    _id = json.get("id", "");
    _threadId = json.get("thread_id", "");
    _assistantId = json.get("assistant_id", "");
    _runId = json.get("run_id", "");
    _role = OpenAIMessageRole.values
        .firstWhereOrNull((item) => item.name == json.get("role", ""));
    _value = json.getAsList<DynamicMap>("content").map((e) {
      String value = "";
      final type = OpenAIMessageValueType.values
              .firstWhereOrNull((item) => item.name == e.get("type", "")) ??
          OpenAIMessageValueType.text;
      switch (type) {
        case OpenAIMessageValueType.text:
          value = e.getAsMap("text").get("value", "");
          break;
        case OpenAIMessageValueType.image:
          value = e.getAsMap("image_file").get("file_id", "");
          break;
      }
      return OpenAIMessageValue(
        type: type,
        value: value,
      );
    }).toList();
    _status = OpenAIMessageStatus.complete;
    notifyListeners();
  }

  /// The status of the message.
  ///
  /// メッセージのステータスです。
  OpenAIMessageStatus get status => _status;
  OpenAIMessageStatus _status = OpenAIMessageStatus.queued;

  /// Message ID.
  ///
  /// メッセージのID。
  String? get id => _id;
  String? _id;

  /// Thread ID.
  ///
  /// スレッドのID。
  String? get threadId => _threadId;
  String? _threadId;

  /// Assistant ID.
  ///
  /// アシスタントのID。
  String? get assistantId => _assistantId;
  String? _assistantId;

  /// Run ID.
  ///
  /// ランのID。
  String? get runId => _runId;
  String? _runId;

  /// Role of the speaker of the message.s
  ///
  /// メッセージの発話者の役割。
  OpenAIMessageRole? get role => _role;
  OpenAIMessageRole? _role;

  /// Time of the message.
  ///
  /// メッセージの時間。
  DateTime get time => _time ?? DateTime.now();
  DateTime? _time;

  /// The content of the message.
  ///
  /// メッセージの内容。
  @override
  List<OpenAIMessageValue> get value => _value;
  List<OpenAIMessageValue> _value = [];

  /// Convert to JSON.
  ///
  /// JSONに変換します。
  DynamicMap toJson() {
    return {
      "role": role?.name ?? OpenAIMessageRole.user.name,
      "content": value.text,
    };
  }
}

/// The status of the message.
///
/// メッセージのステータス。
enum OpenAIMessageStatus {
  /// Waiting state.
  ///
  /// 待ち状態。
  queued,

  /// Completed.
  ///
  /// 完了。
  complete,

  /// Error.
  ///
  /// エラー。
  error;
}

/// Role of the speaker of the message.
///
/// メッセージの発話者の役割。
enum OpenAIMessageRole {
  /// System.
  ///
  /// システム。
  system,

  /// User.
  ///
  /// ユーザー。
  user,

  /// Assistant.
  ///
  /// アシスタント。
  assistant;
}

/// The type of message content.
///
/// メッセージの内容のタイプ。
enum OpenAIMessageValueType {
  /// Text.
  ///
  /// テキスト。
  text,

  /// Image.
  ///
  /// 画像。
  image;
}

/// The content of the message.
///
/// メッセージの内容。
@immutable
class OpenAIMessageValue {
  /// The content of the message.
  ///
  /// メッセージの内容。
  const OpenAIMessageValue({
    required this.type,
    required this.value,
  });

  /// The type of message content.
  ///
  /// メッセージの内容のタイプ。
  final OpenAIMessageValueType type;

  /// The content of the message.
  ///
  /// メッセージの内容。
  final String value;
}

/// Extension methods for [Iterable<OpenAIMessageValue>].
///
/// [Iterable<OpenAIMessageValue>]の拡張メソッドを提供します。
extension OpenAIMessageValueIterableExtensions on Iterable<OpenAIMessageValue> {
  /// Get the text of the message.
  ///
  /// メッセージのテキストを取得します。
  String get text {
    return where((element) => element.type == OpenAIMessageValueType.text)
        .map((e) => e.value)
        .join("\n");
  }
}
