// Dart imports:
import "dart:async";

// Package imports:
import "package:katana_logger/katana_logger.dart";
import "package:test/test.dart";

// Project imports:
import "package:katana_model/katana_model.dart";

class _TraceDocumentModel extends DocumentBase<DynamicMap> {
  _TraceDocumentModel(super.modelQuery, {this.fail = false, this.failure});

  final bool fail;
  final _LoadFailure? failure;

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;

  @override
  Future<DynamicMap?> loadRequest() async {
    if (failure != null) {
      await failure!.raise();
    }
    if (fail) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      throw StateError("load failed");
    }
    return super.loadRequest();
  }
}

class _TraceCollectionModel extends CollectionBase<_TraceDocumentModel> {
  _TraceCollectionModel(super.modelQuery, {this.failure});

  final _LoadFailure? failure;

  @override
  Future<Map<String, DynamicMap>?> loadRequest() async {
    if (failure != null) {
      await failure!.raise();
    }
    return super.loadRequest();
  }

  @override
  _TraceDocumentModel create([String? id]) =>
      _TraceDocumentModel(modelQuery.create(id));
}

class _LoadFailure {
  final error = StateError("load failed");
  final stackTrace = StackTrace.fromString("original adapter stack");
  final started = Completer<void>();
  final release = Completer<void>();

  Future<void> raise() async {
    started.complete();
    await release.future;
    Error.throwWithStackTrace(error, stackTrace);
  }
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

  for (final target in ["collection", "document"]) {
    for (final operation in [
      "load",
      "reload",
      if (target == "collection") "next"
    ]) {
      for (final subscribe in [false, true]) {
        test(
            "$target $operation preserves failures without unhandled duplicates "
            "(subscribe: $subscribe)", () async {
          final failure = _LoadFailure();
          final unhandled = <Object>[];
          final receivedErrors = <Object>[];
          final receivedStacks = <StackTrace>[];
          final done = Completer<void>();
          final zonedFuture = runZonedGuarded<Future<void>>(() async {
            try {
              late Future<Object?> Function() request;
              late Future<Object?>? Function() loading;
              late Future<Object?>? Function() reloading;
              late Future<Object?> Function() concurrentLoad;
              if (target == "collection") {
                final model = _TraceCollectionModel(
                  CollectionModelQuery("trace", adapter: modelAdapter),
                  failure: failure,
                );
                request = switch (operation) {
                  "load" => model.load,
                  "reload" => model.reload,
                  _ => model.next,
                };
                loading = () => model.loading;
                reloading = () => model.reloading;
                concurrentLoad = model.load;
              } else {
                final model = _TraceDocumentModel(
                  DocumentModelQuery("trace/error", adapter: modelAdapter),
                  failure: failure,
                );
                request = operation == "load" ? model.load : model.reload;
                loading = () => model.loading;
                reloading = () => model.reloading;
                concurrentLoad = model.load;
              }
              Future<void> observe(Future<Object?> future) async {
                try {
                  await future;
                } catch (error, stackTrace) {
                  receivedErrors.add(error);
                  receivedStacks.add(stackTrace);
                }
              }

              final pending = <Future<void>>[observe(request())];
              await failure.started.future;
              if (subscribe) {
                pending.add(observe(loading()!));
                if (operation == "load") {
                  pending.add(observe(concurrentLoad()));
                } else {
                  pending.add(observe(reloading()!));
                }
              }
              failure.release.complete();
              await Future.wait(pending);
              await Future<void>.delayed(Duration.zero);
              done.complete();
            } catch (error, stackTrace) {
              done.completeError(error, stackTrace);
            }
          }, (error, stackTrace) => unhandled.add(error));
          if (zonedFuture != null) {
            unawaited(zonedFuture);
          }
          await done.future;
          expect(unhandled, isEmpty);
          expect(receivedErrors, hasLength(subscribe ? 3 : 1));
          for (final error in receivedErrors) {
            expect(error, same(failure.error));
          }
          for (final stackTrace in receivedStacks) {
            expect(stackTrace.toString(), failure.stackTrace.toString());
          }
        });
      }
    }
  }
}
