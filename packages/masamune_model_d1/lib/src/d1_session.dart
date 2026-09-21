part of "/masamune_model_d1.dart";

/// DBを指定するD1 FunctionsActionの共通契約。
abstract class D1DatabaseAction<T> extends FunctionsAction<T> {
  /// 共通Action。
  const D1DatabaseAction();

  /// 論理DB名。
  String get database;
}

/// 接続先・環境・ユーザーごとのbookmark。認証切替時は新しいsessionを作る。
/// 同一DBの通信は直列化し、並行応答によるbookmarkの後退を防ぐ。
class D1ModelSession {
  /// endpointは使用するFunctionsAdapterの接続先と一致させる。
  D1ModelSession(
      {required this.endpoint,
      required this.environment,
      required this.userId});

  /// Workerの接続先。
  final String endpoint;

  /// dev/prodなどの環境識別子。
  final String environment;

  /// 認証ユーザー。匿名の場合もアプリが明示する。
  final String userId;
  final Map<String, String> _bookmarks = {};
  final Map<String, Future<void>> _pending = {};
  int _generation = 0;

  /// キャッシュの分離キー。
  String get cacheScope {
    if (_generation != 0) {
      throw StateError("破棄したD1 sessionは再利用できません。");
    }
    return jsonEncode([endpoint, environment, userId]);
  }

  /// 接続終了時に呼ぶ。進行中の応答は新しいsessionへ取り込まない。
  void reset() {
    _generation++;
    _bookmarks.clear();
  }

  /// 現在のbookmark。復元や比較ではなく診断用。
  String? bookmark(String database, {String? prefix}) =>
      _bookmarks[jsonEncode([prefix, database])];

  /// bookmarkを付加して公開FunctionsAdapterで通信する。
  Future<T> execute<T>(FunctionsAdapter adapter, D1DatabaseAction<T> action,
      {String? prefix}) {
    if (_generation != 0) {
      return Future.error(StateError("破棄したD1 sessionは再利用できません。"));
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
        throw StateError("D1 sessionは破棄されました。");
      }
      final response = await adapter
          .execute(_D1SessionAction(action, _bookmarks[key], (bookmark) {
        if (generation != _generation) {
          throw StateError("D1 sessionは破棄されました。");
        }
        if (bookmark != null) {
          _bookmarks[key] = bookmark;
        }
      }));
      if (generation != _generation) {
        throw StateError("D1 sessionは破棄されました。");
      }
      return response;
    });
    _pending[key] =
        result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return result;
  }
}

class _D1SessionAction<T> extends FunctionsAction<T> {
  _D1SessionAction(this.delegate, this.bookmark, this.received);
  final D1DatabaseAction<T> delegate;
  final String? bookmark;
  final void Function(String?) received;
  @override
  String get action => delegate.action;
  @override
  ApiMethod? get method => delegate.method;
  @override
  Duration? get timeout => delegate.timeout;
  @override
  FutureOr<Map<String, String>>? get headers => delegate.headers;
  @override
  String? get path {
    if (method != ApiMethod.get || bookmark == null) {
      return delegate.path;
    }
    final uri = Uri.parse(delegate.path!);
    return uri.replace(queryParameters: {
      ...uri.queryParameters,
      "bookmark": bookmark!
    }).toString();
  }

  @override
  DynamicMap? toMap() => method == ApiMethod.get
      ? delegate.toMap()
      : {...?delegate.toMap(), if (bookmark != null) "bookmark": bookmark};
  @override
  T toResponse(DynamicMap map) {
    final mark = map["bookmark"];
    if (mark != null && mark is! String) {
      throw const FormatException("D1 bookmarkが不正です。");
    }
    received(mark as String?);
    return delegate.toResponse(map);
  }
}
