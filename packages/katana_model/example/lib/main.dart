// Dart imports:
import "dart:math";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_model/katana_model.dart";

class ModelDocument extends DocumentBase<Map<String, dynamic>> {
  ModelDocument(super.modelQuery);

  @override
  Map<String, dynamic> fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(Map<String, dynamic> value) => value;
}

class ModelCollection extends CollectionBase<ModelDocument> {
  ModelCollection(super.modelQuery);

  @override
  ModelDocument create([String? id]) {
    return ModelDocument(modelQuery.create(id));
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ModelAdapterScope(
      adapter: const RuntimeModelAdapter(),
      child: MaterialApp(
        home: const ModelPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

class ModelPage extends StatefulWidget {
  const ModelPage({super.key});

  @override
  State<StatefulWidget> createState() => ModelPageState();
}

class ModelPageState extends State<ModelPage> {
  final collection = ModelCollection(const CollectionModelQuery("/user"));

  @override
  void initState() {
    super.initState();
    collection.addListener(_handledOnUpdate);
    collection.load();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    collection.removeListener(_handledOnUpdate);
    collection.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Demo")),
      body: FutureBuilder(
        future: collection.loading ?? Future.value(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              ...collection.mapListenable((doc) {
                return ListTile(
                  title: Text(doc.value?["count"].toString() ?? "0"),
                  trailing: IconButton(
                    onPressed: () {
                      doc.delete();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    doc.save({
                      "count": Random().nextInt(100),
                    });
                  },
                );
              }),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final doc = collection.create();
          doc.save({
            "count": Random().nextInt(100),
          });
        },
      ),
    );
  }
}
