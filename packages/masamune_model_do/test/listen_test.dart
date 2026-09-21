import "dart:async";
import "dart:convert";
import "package:masamune/masamune.dart";
import "package:masamune_model_do/masamune_model_do.dart";
import "package:test/test.dart";
import "do_test.dart" show Recording, session;

class Socket implements DurableObjectSocket {
  final controller = StreamController<String>();
  bool closed = false;
  @override
  Stream<String> get messages => controller.stream;
  void invalidate() => controller.add(jsonEncode({"type": "invalidate"}));
  @override
  Future<void> close() async {
    if (closed) {
      return;
    }
    closed = true;
    unawaited(controller.close());
  }
}

Future<void> settle() async {
  for (var i = 0; i < 12; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  test("接続期限前に再認証し、サーバーclose待ちの空白を避ける", () async {
    var connections = 0;
    final f = Recording((_) async => {
          "data": [],
          "sequence": 0,
          "ticket": "t",
          "expires": DateTime.now().millisecondsSinceEpoch + 2200
        });
    final a = ListenableDurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: f,
        socketConnector: (_) async {
          connections++;
          return Socket();
        });
    final streams = await a.listenCollection(const ModelAdapterCollectionQuery(
        query: CollectionModelQuery("items", adapter: RuntimeModelAdapter())));
    await Future<void>.delayed(const Duration(milliseconds: 700));
    try {
      expect(connections, greaterThanOrEqualTo(2));
    } finally {
      await streams.single.cancel();
    }
  });
  test("共有topicのcacheとheaderを分離し、hub通知は同じ連番でも再取得", () async {
    DurableObjectModelSession shared(String topic) => DurableObjectModelSession(
        endpoint: "https://fixture.invalid",
        environment: "dev",
        userId: "alice",
        sharedTopic: topic);
    final room = shared("room");
    expect(room.cacheScope, isNot(shared("other").cacheScope));
    expect(room.cacheScope, isNot(session("alice").cacheScope));
    var value = 1;
    final f = Recording((a) async {
      expect((await a.headers)!["X-Masamune-Topic"], "room");
      return {
        "data": [
          {"id": "a", "value": value}
        ],
        "sequence": 1,
        "ticket": "ticket",
        "hub": {"generation": "v2", "shard": 3}
      };
    });
    final socket = Socket();
    final a = ListenableDurableObjectModelAdapter(
        prefix: null,
        session: room,
        functionsAdapter: f,
        socketConnector: (uri) async {
          expect(uri.path, "/do-connect/shared/main/room/alice/v2/3");
          return socket;
        });
    const q = ModelAdapterCollectionQuery(
        query: CollectionModelQuery("items", adapter: RuntimeModelAdapter()));
    final streams = await a.listenCollection(q);
    value = 2;
    socket.controller.add(jsonEncode({"type": "invalidate", "sequence": 1}));
    await settle();
    expect((await a.loadCollection(q))["a"]!["value"], 2);
    await streams.single.cancel();
  });
  test("共有hubの不正な接続情報ではsocketを開かない", () async {
    final f = Recording((_) async => {
          "data": [],
          "sequence": 0,
          "ticket": "t",
          "hub": {"generation": "../other", "shard": 0}
        });
    final a = ListenableDurableObjectModelAdapter(
        prefix: null,
        session: DurableObjectModelSession(
            endpoint: f.endpoint,
            environment: "dev",
            userId: "alice",
            sharedTopic: "room"),
        functionsAdapter: f,
        socketConnector: (_) {
          fail("socketを開いてはいけない");
        });
    await expectLater(
        a.listenCollection(const ModelAdapterCollectionQuery(
            query:
                CollectionModelQuery("items", adapter: RuntimeModelAdapter()))),
        throwsStateError);
  });
  test("snapshotでquery集合の削除・追加・順位変更と重複通知を反映", () async {
    var data = <DynamicMap>[
      {"id": "a", "value": 1},
      {"id": "b", "value": 2}
    ];
    var revision = 1;
    final f = Recording(
        (_) async => {"data": data, "sequence": revision, "ticket": "test"});
    final socket = Socket();
    final events = <ModelUpdateNotification>[];
    final q = ModelAdapterCollectionQuery(
        query:
            const CollectionModelQuery("items", adapter: RuntimeModelAdapter()),
        callback: events.add);
    final a = ListenableDurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: f,
        socketConnector: (_) async => socket);
    final streams = await a.listenCollection(q);
    await settle();
    expect(events.map((e) => e.id), ["a", "b"]);
    events.clear();
    data = [
      {"id": "b", "value": 0},
      {"id": "c", "value": 3}
    ];
    revision++;
    socket.invalidate();
    await settle();
    expect(events.map((e) => e.status), [
      ModelUpdateNotificationStatus.removed,
      ModelUpdateNotificationStatus.modified,
      ModelUpdateNotificationStatus.added
    ]);
    // removed通知でaが消えた後、bの旧位置は0になる。
    expect(events[1].oldIndex, 0);
    events.clear();
    socket.invalidate();
    await settle();
    expect(events, isEmpty);
    await streams.single.cancel();
    expect(socket.closed, true);
  });
  test("切断中の削除を再接続snapshotで補完", () async {
    var data = <DynamicMap>[
      {"id": "a", "name": "old"}
    ];
    var revision = 1;
    final sockets = <Socket>[];
    final events = <ModelUpdateNotification>[];
    final f = Recording(
        (_) async => {"data": data, "sequence": revision, "ticket": "test"});
    final a = ListenableDurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: f,
        socketConnector: (_) async {
          final s = Socket();
          sockets.add(s);
          return s;
        });
    final streams = await a.listenDocument(ModelAdapterDocumentQuery(
        query: const DocumentModelQuery("items/a"), callback: events.add));
    await settle();
    data = [];
    revision++;
    await sockets.single.close();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await settle();
    expect(sockets.length, 2);
    expect(events.last.status, ModelUpdateNotificationStatus.removed);
    await streams.single.cancel();
  });
  test("reset後の遅着snapshotを捨て接続を閉じる", () async {
    Completer<DynamicMap>? gate;
    final s = session();
    final socket = Socket();
    final events = <ModelUpdateNotification>[];
    final f = Recording((_) =>
        gate?.future ??
        Future.value({
          "data": [
            {"id": "a"}
          ],
          "sequence": 1,
          "ticket": "t"
        }));
    final a = ListenableDurableObjectModelAdapter(
        prefix: null,
        session: s,
        functionsAdapter: f,
        socketConnector: (_) async => socket,
        onListenError: (_, __) {});
    await a.listenDocument(ModelAdapterDocumentQuery(
        query: const DocumentModelQuery("items/a"), callback: events.add));
    await settle();
    events.clear();
    gate = Completer();
    socket.invalidate();
    await settle();
    s.reset();
    gate.complete({
      "data": [
        {"id": "a", "name": "late"}
      ],
      "sequence": 2
    });
    await settle();
    expect(events, isEmpty);
    expect(socket.closed, true);
  });
  test("認可失効で画面と永続cacheから文書を除去", () async {
    var denied = false;
    final socket = Socket();
    final events = <ModelUpdateNotification>[];
    final f = Recording((_) async {
      if (denied) {
        throw Exception("Failed to post: 403");
      }
      return {
        "data": [
          {"id": "a", "name": "private"}
        ],
        "sequence": 1,
        "ticket": "t"
      };
    });
    final a = CachedListenableDurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: f,
        cachedLocalDatabase: NoSqlDatabase(),
        socketConnector: (_) async => socket,
        onListenError: (_, __) {});
    final q = ModelAdapterDocumentQuery(
        query: const DocumentModelQuery("items/a"), callback: events.add);
    await a.listenDocument(q);
    await settle();
    expect((await a.onPreloadDocument(q))!["name"], "private");
    denied = true;
    socket.invalidate();
    await settle();
    expect(events.last.status, ModelUpdateNotificationStatus.removed);
    expect(await a.onPreloadDocument(q), isNull);
    expect(socket.closed, true);
  });
  test("query別cacheは別購読の削除で消えない", () async {
    final sockets = <Socket>[];
    var empty = false;
    final f = Recording((action) async => {
          "data": empty && action.toMap()!["table"] == "items"
              ? []
              : [
                  {"id": "a"}
                ],
          "sequence": empty ? 2 : 1,
          "ticket": "t"
        });
    final a = CachedListenableDurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: f,
        cachedLocalDatabase: NoSqlDatabase(),
        socketConnector: (_) async {
          final s = Socket();
          sockets.add(s);
          return s;
        });
    const one = ModelAdapterDocumentQuery(query: DocumentModelQuery("items/a"));
    const two = ModelAdapterDocumentQuery(query: DocumentModelQuery("other/a"));
    final first = await a.listenDocument(one);
    final second = await a.listenDocument(two);
    await settle();
    empty = true;
    sockets.first.invalidate();
    await settle();
    expect(await a.onPreloadDocument(one), isNull);
    expect((await a.onPreloadDocument(two))!["id"], "a");
    await first.single.cancel();
    await second.single.cancel();
  });

  test("同じtableの異なるwhere購読cacheを分離し空集合で置換", () async {
    var empty = false;
    final sockets = <Socket>[];
    final f = Recording((action) async {
      final value = (action.toMap()!["where"] as List).first["value"];
      return {
        "data": empty && value == 1
            ? []
            : [
                {"id": "a", "value": value}
              ],
        "sequence": empty ? 2 : 1,
        "ticket": "t"
      };
    });
    final a = CachedListenableDurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: f,
        cachedLocalDatabase: NoSqlDatabase(),
        socketConnector: (_) async {
          final socket = Socket();
          sockets.add(socket);
          return socket;
        });
    const base = CollectionModelQuery("items", adapter: RuntimeModelAdapter());
    final one = ModelAdapterCollectionQuery(query: base.equal("value", 1));
    final two = ModelAdapterCollectionQuery(query: base.equal("value", 2));
    final first = await a.listenCollection(one);
    final second = await a.listenCollection(two);
    empty = true;
    sockets.first.invalidate();
    await settle();
    expect((await a.loadCollection(one)), isEmpty);
    expect((await a.onPreloadCollection(two))!.value["a"]!["value"], 2);
    a.session.reset();
    expect(() => a.disposeCollection(one), returnsNormally);
    expect(
        () => a.disposeDocument(const ModelAdapterDocumentQuery(
            query: DocumentModelQuery("items/a"))),
        returnsNormally);
    await first.single.cancel();
    await second.single.cancel();
  });

  test("cache保存中に購読を解除した場合は遅着通知を送らない", () async {
    Completer<void>? gate;
    final saved = Completer<void>();
    var revision = 1;
    final socket = Socket();
    final events = <ModelUpdateNotification>[];
    final cache = NoSqlDatabase(onSaved: (_) async {
      if (gate != null) {
        if (!saved.isCompleted) {
          saved.complete();
        }
        await gate.future;
      }
    });
    final f = Recording((_) async => {
          "data": [
            {"id": "a", "value": revision}
          ],
          "sequence": revision,
          "ticket": "t"
        });
    final a = CachedListenableDurableObjectModelAdapter(
        prefix: null,
        session: session(),
        functionsAdapter: f,
        cachedLocalDatabase: cache,
        socketConnector: (_) async => socket);
    final streams = await a.listenDocument(ModelAdapterDocumentQuery(
        query: const DocumentModelQuery("items/a"), callback: events.add));
    events.clear();
    gate = Completer<void>();
    revision++;
    socket.invalidate();
    await saved.future;
    await streams.single.cancel();
    gate.complete();
    await settle();
    expect(events, isEmpty);
  });
}
