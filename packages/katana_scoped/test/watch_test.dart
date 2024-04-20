// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:katana_scoped/katana_scoped.dart';
import 'test_extensions.dart';

void main() {
  testWidgets("Scoped.Value.watch", (tester) async {
    final appRef = AppRef();
    await tester.pumpWidget(
      AppScoped(
        appRef: appRef,
        child: const MaterialApp(
          home: ValueWatchPage(),
        ),
      ),
    );
    await tester.pump();
    expect(text("app_text")?.data, "0");
    expect(text("page_text")?.data, "0");
    expect(text("page_text_with_double")?.data, "0.0");
    expect(text("widget_text")?.data, "0");
    await tester.tapByKey("app");
    await tester.pump();
    expect(text("app_text")?.data, "1");
    expect(text("page_text")?.data, "0");
    expect(text("page_text_with_double")?.data, "0.0");
    expect(text("widget_text")?.data, "0");
    await tester.tapByKey("page");
    await tester.pump();
    expect(text("app_text")?.data, "1");
    expect(text("page_text")?.data, "1");
    expect(text("page_text_with_double")?.data, "0.0");
    expect(text("widget_text")?.data, "0");
    await tester.tapByKey("widget");
    await tester.pump();
    expect(text("app_text")?.data, "1");
    expect(text("page_text")?.data, "1");
    expect(text("page_text_with_double")?.data, "0.0");
    expect(text("widget_text")?.data, "1");
    await tester.tapByKey("page_with_double");
    await tester.pump();
    expect(text("app_text")?.data, "1");
    expect(text("page_text")?.data, "1");
    expect(text("page_text_with_double")?.data, "1.0");
    expect(text("widget_text")?.data, "1");
  });
}

class ValueWatchPage extends PageScopedWidget {
  const ValueWatchPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          focusNode.hashCode.toString(),
          key: const ValueKey("title"),
        ),
      ),
      body: const ValueWatchContent(),
    );
  }
}

class ValueWatchContent extends ScopedWidget {
  const ValueWatchContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widget = ref.widget.watch((ref) => ValueNotifier(0));
    final page = ref.page.watch((ref) => ValueNotifier(0));
    final pageWithDouble = ref.page.watch((ref) => ValueNotifier(0.0));
    final app = ref.app.watch((ref) => ValueNotifier(0));

    return Column(children: [
      ListTile(
        key: const ValueKey("app"),
        title: Text(app.value.toString(), key: const ValueKey("app_text")),
        onTap: () {
          app.value++;
        },
      ),
      ListTile(
        key: const ValueKey("page"),
        title: Text(page.value.toString(), key: const ValueKey("page_text")),
        onTap: () {
          page.value++;
        },
      ),
      ListTile(
        key: const ValueKey("page_with_double"),
        title: Text(
          pageWithDouble.value.toString(),
          key: const ValueKey("page_text_with_double"),
        ),
        onTap: () {
          pageWithDouble.value++;
        },
      ),
      ListTile(
        key: const ValueKey("widget"),
        title:
            Text(widget.value.toString(), key: const ValueKey("widget_text")),
        onTap: () {
          widget.value++;
        },
      ),
    ]);
  }
}

extension on AppScopedValueRef {
  T watch<T extends Listenable?>(
    T Function(QueryScopedValueRef<AppScopedValueRef> ref) callback, {
    List<Object> keys = const [],
    Object? name,
    bool disposal = true,
    bool autoDisposeWhenUnreferenced = false,
  }) {
    return getScopedValue<T, _WatchValue<T, AppScopedValueRef>>(
      (ref) => _WatchValue<T, AppScopedValueRef>(
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
