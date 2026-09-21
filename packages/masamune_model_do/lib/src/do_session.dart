part of "/masamune_model_do.dart";

/// DBを指定するDurableObject FunctionsActionの共通契約。
abstract class DurableObjectDatabaseAction<T> extends FunctionsAction<T> {
  /// 共通Action。
  const DurableObjectDatabaseAction();

  /// 論理DB名。
  String get database;
}

/// 接続先・環境・ユーザーごとの通信スコープ。認証切替時は新しいsessionを作る。
/// 同一DBの通信は直列化し、操作の順序を保持する。
class DurableObjectModelSession {
  /// endpointは使用するFunctionsAdapterの接続先と一致させる。
  DurableObjectModelSession(
      {required this.endpoint,
      required this.environment,
      required this.userId,
      this.sharedTopic}) {
    if (sharedTopic != null &&
        !RegExp(r"^[A-Za-z0-9_-]{1,128}$").hasMatch(sharedTopic!)) {
      throw ArgumentError("共有topicは英数字・ハイフン・下線の1〜128文字です。");
    }
    if (userId.isEmpty || !["dev", "prod"].contains(environment)) {
      throw ArgumentError("認証ユーザーとdev/prod環境を指定してください。");
    }
  }

  /// Workerの接続先。
  final String endpoint;

  /// dev/prodなどの環境識別子。
  final String environment;

  /// 認証ユーザー。匿名の場合もアプリが明示する。
  final String userId;

  /// 明示的に共有するトピック。参加権限はWorkerのshared.authorizeで判定する。
  final String? sharedTopic;
  final Map<String, Future<void>> _pending = {};
  int _generation = 0;
  final _resetListeners = <void Function()>{};

  /// キャッシュの分離キー。
  String get cacheScope {
    if (_generation != 0) {
      throw StateError("破棄したDurableObject sessionは再利用できません。");
    }
    return _scope;
  }

  String get _scope => jsonEncode(
      [endpoint, environment, userId, if (sharedTopic != null) sharedTopic]);

  /// 接続終了時に呼ぶ。進行中の応答は新しいsessionへ取り込まない。
  void reset() {
    _generation++;
    for (final listener in _resetListeners.toList()) {
      listener();
    }
    _resetListeners.clear();
  }

  /// 接続先とユーザーを照合してFunctionsAdapter経由で通信する。
  Future<T> execute<T>(
      FunctionsAdapter adapter, DurableObjectDatabaseAction<T> action,
      {String? prefix}) {
    if (_generation != 0) {
      return Future.error(StateError("破棄したDurableObject sessionは再利用できません。"));
    }
    if (adapter.endpoint.replaceAll(RegExp(r"/+$"), "") !=
        endpoint.replaceAll(RegExp(r"/+$"), "")) {
      return Future.error(
          ArgumentError("sessionとFunctionsAdapterの接続先が一致しません。"));
    }
    final key = jsonEncode([prefix, action.database]);
    final generation = _generation;
    final result = (_pending[key] ?? Future<void>.value()).then((_) async {
      if (generation != _generation) {
        throw StateError("DurableObject sessionは破棄されました。");
      }
      final response = await adapter.execute(_DurableObjectSessionAction(
          action, userId, environment, sharedTopic));
      if (generation != _generation) {
        throw StateError("DurableObject sessionは破棄されました。");
      }
      return response;
    });
    _pending[key] =
        result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return result;
  }
}

class _DurableObjectSessionAction<T> extends FunctionsAction<T> {
  _DurableObjectSessionAction(
      this.delegate, this.userId, this.environment, this.sharedTopic);
  final DurableObjectDatabaseAction<T> delegate;
  final String userId;
  final String environment;
  final String? sharedTopic;
  @override
  String get action => delegate.action;
  @override
  ApiMethod? get method => delegate.method;
  @override
  Duration? get timeout => delegate.timeout;
  @override
  Future<Map<String, String>> get headers async => {
        ...?await delegate.headers,
        "X-Masamune-User-Id": userId,
        "X-Masamune-Environment": environment,
        if (sharedTopic != null) "X-Masamune-Topic": sharedTopic!,
      };
  @override
  String? get path => delegate.path;
  @override
  DynamicMap? toMap() => delegate.toMap();
  @override
  T toResponse(DynamicMap map) => delegate.toResponse(map);
}
