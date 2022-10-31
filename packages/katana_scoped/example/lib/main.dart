import 'package:flutter/material.dart';
import 'package:katana_scoped/katana_scoped.dart';

void main() {
  runApp(const MyApp());
}

final appRef = AppRef();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScoped(
      appRef: appRef,
      child: MaterialApp(
        home: const ScopedTestPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

class CounterPage extends PageScopedWidget {
  const CounterPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, PageRef ref) {
    final counter = ref.app.watch(() => ValueNotifier(0));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text("${counter.value}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ScopedTestPage extends PageScopedWidget {
  const ScopedTestPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test App"),
      ),
      body: ScopedTestContent(
        page: this,
      ),
    );
  }
}

class ScopedTestContent extends ScopedWidget<ScopedTestPage> {
  const ScopedTestContent({
    super.key,
    required super.page,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widget = ref.widget.watch(() => ValueNotifier(0));
    final page = ref.page.watch(() => ValueNotifier(0));
    final app = ref.app.watch(() => ValueNotifier(0));

    return Column(
      children: [
        ListTile(
          title: Text(app.value.toString()),
          onTap: () {
            app.value++;
          },
        ),
        ListTile(
          title: Text(page.value.toString()),
          onTap: () {
            page.value++;
          },
        ),
        ListTile(
          title: Text(widget.value.toString()),
          onTap: () {
            widget.value++;
          },
        ),
      ],
    );
  }
}

class Repository with ChangeNotifier {}

class RepositoryValue extends ScopedValue<Repository> {
  @override
  ScopedValueState<Repository, RepositoryValue> createState() =>
      RepositoryValueState();
}

class RepositoryValueState
    extends ScopedValueState<Repository, RepositoryValue> {
  late Repository repository;

  @override
  void initValue() {
    super.initValue();
    repository = Repository();
    repository.addListener(_handeldOnUpdate);
  }

  void _handeldOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    repository.removeListener(_handeldOnUpdate);
    repository.dispose();
  }

  @override
  Repository build() => repository;
}

extension UserRepositoryAppRef on RefHasApp {
  TRepository repository<TRepository extends Repository>(
    TRepository source,
  ) {
    return app.watch(() => source);
  }
}
