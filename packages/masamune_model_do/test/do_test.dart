import "dart:async";
import "dart:convert";
import "package:masamune/masamune.dart";
import "package:masamune_model_do/masamune_model_do.dart";
import "package:test/test.dart";

class Recording extends FunctionsAdapter {
  Recording(this.reply);
  @override
  String get endpoint => "https://fixture.invalid";
  final Future<DynamicMap> Function(FunctionsAction<dynamic>) reply;
  final List<FunctionsAction<dynamic>> actions = [];
  @override
  Future<T> execute<T>(FunctionsAction<T> action) async {
    actions.add(action);
    return action.toResponse(await reply(action));
  }
}

DurableObjectModelSession session([String user = "a"]) =>
    DurableObjectModelSession(
        endpoint: "https://fixture.invalid", environment: "dev", userId: user);
const query = ModelAdapterDocumentQuery(
    query: DocumentModelQuery("database/main/items/a"));

class FixtureConverter extends PassVectorConverter {
  const FixtureConverter();
  @override
  List<double> toVector(String value) => [1, 0, 0];
}

void main() {
  test("近傍検索文字列をvectorへ変換して送信する", () async {
    final functions = Recording((_) async => {
          "data": [
            {"id": "a", "name": "近傍"}
          ]
        });
    final adapter = DurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: functions,
        vectorConverter: const FixtureConverter());
    final collection = ModelAdapterCollectionQuery(
        query: CollectionModelQuery("items", adapter: adapter)
            .nearest("embedding", "猫"));
    expect((await adapter.loadCollection(collection)).keys, ["a"]);
    final parameters =
        Uri.parse(functions.actions.single.path!).queryParameters;
    expect(jsonDecode(parameters["nearest"]!), {
      "key": "embedding",
      "value": [1.0, 0.0, 0.0]
    });
  });
  test("生成モデルの標準flat pathはmain DBへ解決する", () {
    final p = DurableObjectModelPath.fromDocumentQuery(
        const ModelAdapterDocumentQuery(query: DocumentModelQuery("item/one")));
    expect(p.database, "main");
    expect(p.table, "item");
    expect(p.indexKey, "one");
  });
  test("ユーザー照合headerを付け、通信を直列化する", () async {
    final gate = Completer<void>();
    var n = 0;
    final f = Recording((a) async {
      n++;
      if (n == 1) {
        await gate.future;
      }
      return {"data": [], "bookmark": "mark$n"};
    });
    final s = session();
    final adapter = DurableObjectModelAdapter(
        prefix: null, session: s, functionsAdapter: f);
    final write = adapter.saveDocument(query, {"name": "日本語"});
    final read = adapter.loadDocument(query);
    await Future<void>.delayed(Duration.zero);
    expect(f.actions.length, 1);
    gate.complete();
    await write;
    await read;
    expect((await f.actions.last.headers)!["X-Masamune-User-Id"], "a");
    expect(
        Uri.parse(f.actions.last.path!).queryParameters.containsKey("bookmark"),
        false);
  });
  test("認証切替・resetでcacheを分離する", () async {
    final f = Recording((a) async => {
          "data": [
            {"id": "a", "name": "A"}
          ],
          "bookmark": "one"
        });
    final cache = NoSqlDatabase();
    final a = CachedDurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: f,
        cachedLocalDatabase: cache);
    await a.loadDocument(query);
    await a.loadDocument(query);
    expect(f.actions.length, 1);
    final b = CachedDurableObjectModelAdapter(
        prefix: null,
        session: session("b"),
        functionsAdapter: f,
        cachedLocalDatabase: cache);
    await b.loadDocument(query);
    expect(f.actions.length, 2);
    expect(
        Uri.parse(f.actions.last.path!).queryParameters.containsKey("bookmark"),
        false);
    a.session.reset();
    await expectLater(a.loadDocument(query), throwsStateError);
    expect(f.actions.length, 2);
  });
  test("進行中にresetした応答を取り込まない", () async {
    final gate = Completer<DynamicMap>();
    final f = Recording((_) => gate.future);
    final s = session();
    final future = s.execute(f,
        DurableObjectGetModelFunctionsAction(database: "main", table: "items"));
    await Future<void>.delayed(Duration.zero);
    s.reset();
    final check = expectLater(future, throwsStateError);
    gate.complete({"data": [], "bookmark": "old"});
    await check;
  });
  test("batchは1HTTP要求で送信し、別DBとtransactionを拒否する", () async {
    final f = Recording((_) async => {"data": [], "bookmark": "x"});
    final adapter = DurableObjectModelAdapter(
        prefix: null, session: session(), functionsAdapter: f);
    await adapter.runBatch((ref) {
      adapter.saveOnBatch(ref, query, {"name": "a"});
      adapter.deleteOnBatch(ref, query);
    }, 100);
    expect(f.actions.length, 1);
    expect(f.actions.single.path, "do/batch/main");
    expect(f.actions.single.toMap()!["operations"], hasLength(2));
    expect(() => adapter.runTransaction((_) {}), throwsUnsupportedError);
    await expectLater(
        adapter.runBatch((ref) {
          adapter.deleteOnBatch(ref, query);
          adapter.deleteOnBatch(
              ref,
              const ModelAdapterDocumentQuery(
                  query: DocumentModelQuery("database/other/items/b")));
        }, 100),
        throwsArgumentError);
    expect(f.actions.length, 1);
  });
  test("変更失敗は再送せずcacheを更新しない", () async {
    var fail = false;
    final f = Recording((_) async {
      if (fail) {
        throw Exception("status=502");
      }
      return {
        "data": [
          {"id": "a", "name": "before"}
        ],
        "bookmark": "one"
      };
    });
    final adapter = CachedDurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: f,
        cachedLocalDatabase: NoSqlDatabase());
    await adapter.loadDocument(query);
    fail = true;
    await expectLater(
        adapter.saveDocument(query, {"name": "after"}), throwsException);
    expect(f.actions.length, 2);
    expect((await adapter.loadDocument(query))["name"], "before");
  });
  test("Workerで確定したJSON・boolean・TEXTを再解釈しない", () async {
    final value = {
      "id": "a",
      "flag": true,
      "name": "1",
      "tags": ["猫", null],
      "big": "9007199254740993"
    };
    final f = Recording((_) async => jsonDecode(jsonEncode({
          "data": [value],
          "bookmark": "m"
        })) as DynamicMap);
    final a = DurableObjectModelAdapter(
        prefix: null, session: session(), functionsAdapter: f);
    final loaded = await a.loadDocument(query);
    for (final entry in value.entries) {
      expect(loaded[entry.key], entry.value);
    }
  });
}
