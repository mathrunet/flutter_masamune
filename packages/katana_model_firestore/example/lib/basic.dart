import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:katana_model_firestore/katana_model_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseCore.initialize(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final FirestoreModelAdapter adapter;
  late final FirestoreDynamicCollection collection;

  @override
  void initState() {
    super.initState();
    adapter = const FirestoreModelAdapter();
    collection = FirestoreDynamicCollection(CollectionModelQuery("test",
        adapter: adapter,
        key: "name",
        isGreaterThanOrEqualTo: 20220929113700,
        orderBy: "name"))
      ..load();
    collection.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ModelAdapterScope(
      adapter: adapter,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: collection.mapListenable((item) {
            return ListTile(
                title: Text(item.value.get("name", 0).toString()),
                onTap: () {
                  item.save(
                      {"name": int.tryParse(DateTime.now().toDateTimeID())});
                },
                trailing: IconButton(
                  onPressed: () {
                    item.delete();
                  },
                  icon: const Icon(Icons.delete),
                ));
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final doc = collection.create();
            doc.save({"name": int.tryParse(DateTime.now().toDateTimeID())});
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class FirestoreDynamicCollection
    extends CollectionBase<FirestoreDynamicDocument> {
  FirestoreDynamicCollection(super.query);

  @override
  FirestoreDynamicDocument create([String? id]) {
    return FirestoreDynamicDocument(modelQuery.create(id), {});
  }
}

class FirestoreDynamicDocument extends DocumentBase<DynamicMap> {
  FirestoreDynamicDocument(super.query, super.value);

  @override
  DynamicMap fromMap(DynamicMap map) {
    return Map.unmodifiable(
      Map.fromEntries(
        map.entries.where((entry) => !entry.key.startsWith("@")),
      ),
    );
  }

  @override
  DynamicMap toMap(DynamicMap value) {
    return Map.unmodifiable(value);
  }
}
