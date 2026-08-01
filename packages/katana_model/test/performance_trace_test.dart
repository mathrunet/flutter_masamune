// Dart imports:
import "dart:async";

// Package imports:
import "package:katana_logger/katana_logger.dart";
import "package:test/test.dart";

// Project imports:
import "package:katana_model/katana_model.dart";

class _TraceDocumentModel extends DocumentBase<DynamicMap> {
  _TraceDocumentModel(super.modelQuery, {this.fail = false});

  final bool fail;

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;

  @override
  Future<DynamicMap?> loadRequest() async {
    if (fail) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      throw StateError("load failed");
    }
    return super.loadRequest();
  }
}

class _TraceCollectionModel extends CollectionBase<_TraceDocumentModel> {
  _TraceCollectionModel(super.modelQuery);

  @override
  _TraceDocumentModel create([String? id]) =>
      _TraceDocumentModel(modelQuery.create(id));
}

void main() {
  late LoggerDatabase loggerDatabase;
  late RuntimeModelAdapter modelAdapter;

  setUp(() {
    loggerDatabase = LoggerDatabase();
    modelAdapter = RuntimeModelAdapter(database: NoSqlDatabase());
    TestLoggerAdapterScope.setTestAdapters([
      RuntimeLoggerAdapter(database: loggerDatabase),
    ]);
  });

  tearDown(() {
    TestLoggerAdapterScope.setTestAdapters(const []);
  });

  test("document load and reload emit performance traces", () async {
    final model = _TraceDocumentModel(
      DocumentModelQuery("trace/doc", adapter: modelAdapter),
    );

    await model.load();
    await model.reload();

    final names = (await loggerDatabase.read())
        .values
        .map((value) => value.get(LoggerDatabase.nameKey, ""))
        .toList();
    expect(
      names,
      containsAll([
        "$katanaModelLoadTracePrefix|document|load|_TraceDocumentModel",
        "$katanaModelLoadTracePrefix|document|reload|_TraceDocumentModel",
      ]),
    );
  });

  test("collection load emits a performance trace", () async {
    final model = _TraceCollectionModel(
      CollectionModelQuery("trace", adapter: modelAdapter),
    );

    await model.load();

    final names = (await loggerDatabase.read())
        .values
        .map((value) => value.get(LoggerDatabase.nameKey, ""))
        .toList();
    expect(
      names,
      contains(
        "$katanaModelLoadTracePrefix|collection|load|_TraceCollectionModel",
      ),
    );
  });

  test("failed loads still stop and record their trace", () async {
    final model = _TraceDocumentModel(
      DocumentModelQuery("trace/error", adapter: modelAdapter),
      fail: true,
    );

    final zoneDone = Completer<void>();
    final zonedFuture = runZonedGuarded<Future<void>>(
      () async {
        final load = model.load();
        await Future<void>.delayed(const Duration(milliseconds: 1));
        final loading = model.loading;
        expect(loading, isNotNull);
        unawaited(loading!.catchError((_) => null));
        await expectLater(load, throwsStateError);
        zoneDone.complete();
      },
      (error, stackTrace) {
        if (error is StateError && error.message == "load failed") {
          return;
        }
        if (!zoneDone.isCompleted) {
          zoneDone.completeError(error, stackTrace);
        }
      },
    );
    if (zonedFuture != null) {
      unawaited(zonedFuture);
    }
    await zoneDone.future;

    final logs = await loggerDatabase.read();
    expect(
      logs.values.map((value) => value.get(LoggerDatabase.nameKey, "")),
      contains(
        "$katanaModelLoadTracePrefix|document|load|_TraceDocumentModel",
      ),
    );
  });
}
