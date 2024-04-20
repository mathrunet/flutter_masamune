// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana_scoped/katana_scoped.dart';

final scopedQuery = ChangeNotifierScopedQuery((ref) => ValueNotifier(0));

void main() {
  test("ScopedQuery", () async {
    final container = ScopedValueContainer();
    final logger = RuntimeLoggerAdapter(database: LoggerDatabase());
    final appRef = AppRef(
      scopedValueContainer: container,
      loggerAdapters: [logger],
    );
    final value = appRef.query(scopedQuery);
    expect(value.value, 0);
    value.value = 1;
    expect(value.value, 1);
    final value2 = appRef.query(scopedQuery);
    expect(value.value, 1);
    value.value = 2;
    expect(value2.value, 2);
  });
  test("Logger Test", () async {
    WidgetsFlutterBinding.ensureInitialized();
    final container = ScopedValueContainer();
    final logger = RuntimeLoggerAdapter(database: LoggerDatabase());
    final appRef = AppRef(
      scopedValueContainer: container,
      loggerAdapters: [logger],
    );
    appRef.watch((ref) => ValueNotifier(0), name: "1");
    appRef.watch((ref) => ValueNotifier(0), name: "2");
    appRef.watch((ref) => ValueNotifier(2), name: "3");
    appRef.watch((ref) => ValueNotifier(2), name: "4");
    appRef.clear();
    expect(
        (await logger.logList())
            .map((e) => "${e.name}: ${e.parameters.get("name", "")}"),
        [
          for (var i = 1; i <= 4; i++) "ScopedLoggerEvent.init: $i",
          for (var i = 1; i <= 4; i++) "ScopedLoggerEvent.dispose: $i"
        ]);
  });
  test("Reset Test", () async {
    WidgetsFlutterBinding.ensureInitialized();
    final container = ScopedValueContainer();
    final appRef = AppRef(scopedValueContainer: container);
    final n1 = appRef.watch((ref) => ValueNotifier(0));
    expect(n1.value, 0);
    n1.value = 1;
    final n2 = appRef.watch((ref) => ValueNotifier(0));
    expect(n2.value, 1);
    expect(n1 == n2, true);
    appRef.clear();
    final n3 = appRef.watch((ref) => ValueNotifier(2));
    expect(n3.value, 2);
    expect(n1 != n3, true);
    n3.value = 4;
    final n4 = appRef.watch((ref) => ValueNotifier(2));
    expect(n4.value, 4);
    expect(n3 == n4, true);
  });
}

extension on AppRef {
  T watch<T extends Listenable?>(
    T Function(QueryScopedValueRef<AppRef> ref) callback, {
    List<Object> keys = const [],
    Object? name,
    bool disposal = true,
    bool autoDisposeWhenUnreferenced = false,
  }) {
    return getScopedValue<T, _WatchValue<T, AppRef>>(
      (ref) => _WatchValue<T, AppRef>(
        callback: callback,
        keys: keys,
        ref: this,
        disposal: disposal,
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      ),
      listen: true,
      name: name,
    );
  }
}

@immutable
class _WatchValue<T, TRef extends Ref> extends QueryScopedValue<T, TRef> {
  const _WatchValue({
    required this.callback,
    required this.keys,
    required TRef ref,
    this.disposal = true,
    this.autoDisposeWhenUnreferenced = false,
  }) : super(ref: ref);

  final T Function(QueryScopedValueRef<TRef> ref) callback;
  final List<Object> keys;
  final bool disposal;
  final bool autoDisposeWhenUnreferenced;

  @override
  QueryScopedValueState<T, TRef, QueryScopedValue<T, TRef>> createState() =>
      _WatchValueState<T, TRef>();
}

class _WatchValueState<T, TRef extends Ref>
    extends QueryScopedValueState<T, TRef, _WatchValue<T, TRef>> {
  _WatchValueState();

  late T _value;

  @override
  bool get autoDisposeWhenUnreferenced => value.autoDisposeWhenUnreferenced;

  @override
  void initValue() {
    super.initValue();
    _value = value.callback(ref);
    final val = _value;
    if (val is Listenable) {
      val.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void didUpdateValue(_WatchValue<T, TRef> oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      final oldVal = _value;
      if (oldVal is Listenable) {
        oldVal.removeListener(_handledOnUpdate);
      }
      _value = value.callback(ref);
      final newVal = _value;
      if (newVal is Listenable) {
        newVal.addListener(_handledOnUpdate);
      }
    }
  }

  @override
  void didUpdateDescendant() {
    super.didUpdateDescendant();
    final oldVal = _value;
    if (oldVal is Listenable) {
      oldVal.removeListener(_handledOnUpdate);
    }
    _value = value.callback(ref);
    final newVal = _value;
    if (newVal is Listenable) {
      newVal.addListener(_handledOnUpdate);
    }
  }

  @override
  void dispose() {
    super.dispose();
    final val = _value;
    if (val is Listenable) {
      val.removeListener(_handledOnUpdate);
      if (value.disposal && val is ChangeNotifier) {
        val.dispose();
      }
    }
  }

  @override
  T build() => _value;
}
