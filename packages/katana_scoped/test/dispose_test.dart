// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print, unused_local_variable

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:katana_scoped/katana_scoped.dart';
import 'test_extensions.dart';

void main() {
  testWidgets("Scoped.dispose", (tester) async {
    final container = TestContaner();
    await tester.pumpWidget(
      Root(container: container),
    );
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(container.value, 1);
    await tester.tapByKey("home");
    await tester.pump();
    expect(container.value, 2);
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    print("wait");
    await tester.tapByKey("next");
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));
  });
  testWidgets("Scoped.duplicate", (tester) async {
    final container = TestContaner();
    await tester.pumpWidget(
      RootParent(container: container),
    );
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.tapByKey("home");
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    print("wait");
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));
  });
}

class TestNotifier extends ChangeNotifier {
  @override
  void dispose() {
    super.dispose();
    print("disposed");
  }
}

class TestContaner {
  int value = 0;
}

class Root extends StatelessWidget {
  const Root({required this.container, super.key});

  final TestContaner container;

  @override
  Widget build(BuildContext context) {
    final appRef = AppRef();
    return AppScoped(
      appRef: appRef,
      child: MaterialApp(
        home: HomePage(
          container: container,
        ),
      ),
    );
  }
}

class HomePage extends PageScopedWidget {
  const HomePage({required this.container, super.key});
  final TestContaner container;
  @override
  Widget build(BuildContext context, PageRef ref) {
    final val = ref.app.watch((ref) => ValueNotifier(0));
    final test = ref.page.watch((ref) => TestNotifier());
    ref.page.on(
      initOrUpdate: () {
        print("init at home");
        container.value++;
      },
      disposed: () {
        print("dispose at home");
        container.value++;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: const Center(
        child: Text("HomePage"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
            builder: (_) => NextPage(
              container: container,
            ),
          ));
        },
        key: const ValueKey("home"),
        child: const Icon(Icons.skip_next),
      ),
    );
  }
}

class NextPage extends PageScopedWidget {
  const NextPage({required this.container, super.key});
  final TestContaner container;
  @override
  Widget build(BuildContext context, PageRef ref) {
    final val = ref.app.watch((ref) => ValueNotifier(0));
    final test = ref.app.watch((ref) => TestNotifier());
    ref.page.on(
      initOrUpdate: () {
        print("init at next");
        container.value++;
      },
      disposed: () {
        print("dispose at next");
        container.value++;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("NextPage"),
      ),
      body: const Center(
        child: Text("NextPage"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          val.value = 1;
        },
        key: const ValueKey("next"),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RootParent extends StatelessWidget {
  const RootParent({required this.container, super.key});

  final TestContaner container;

  @override
  Widget build(BuildContext context) {
    final appRef = AppRef();
    return AppScoped(
      appRef: appRef,
      child: MaterialApp(
        home: ParentPage(
          container: container,
        ),
      ),
    );
  }
}

class ParentPage extends PageScopedWidget {
  const ParentPage({required this.container, super.key});
  final TestContaner container;
  @override
  Widget build(BuildContext context, PageRef ref) {
    final value = ref.page.watch((ref) => ValueNotifier(false));

    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: Center(
        child: value.value
            ? const SizedBox.shrink()
            : ChildPage(
                container: container,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          value.value = true;
        },
        key: const ValueKey("home"),
        child: const Icon(Icons.skip_next),
      ),
    );
  }
}

class ChildPage extends ScopedWidget {
  const ChildPage({
    required this.container,
    super.key,
  });
  final TestContaner container;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.page.on(
      initOrUpdate: () {
        print("init at parent");
        container.value++;
      },
      disposed: () {
        print("dispose at parent");
        container.value++;
      },
    );
    ref.widget.on(
      initOrUpdate: () {
        print("init at child");
        container.value++;
      },
      disposed: () {
        print("dispose at child");
        container.value++;
      },
    );

    return const Text("child");
  }
}

extension on AppScopedValueRef {
  T watch<T extends Listenable?>(
    T Function(Ref ref) callback, {
    List<Object> keys = const [],
    Object? name,
    bool disposal = true,
    bool autoDisposeWhenUnreferenced = false,
  }) {
    return getScopedValue<T, _WatchValue<T>>(
      (ref) => _WatchValue<T>(
        callback: callback,
        keys: keys,
        ref: ref,
        disposal: disposal,
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      ),
      listen: true,
      name: name,
    );
  }
}

@immutable
class _WatchValue<T> extends ScopedValue<T> {
  const _WatchValue({
    required this.callback,
    required this.keys,
    required Ref ref,
    this.disposal = true,
    this.autoDisposeWhenUnreferenced = false,
  }) : super(ref: ref);

  final T Function(Ref ref) callback;
  final List<Object> keys;
  final bool disposal;
  final bool autoDisposeWhenUnreferenced;

  @override
  ScopedValueState<T, ScopedValue<T>> createState() => _WatchValueState<T>();
}

class _WatchValueState<T> extends ScopedValueState<T, _WatchValue<T>> {
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
  void didUpdateValue(_WatchValue<T> oldValue) {
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
