// Dart imports:
import "dart:math";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_model/katana_model.dart";

/// Document class for managing model data.
///
/// モデルデータを管理するDocumentクラス。
class ModelDocument extends DocumentBase<Map<String, dynamic>> {
  /// Creates a ModelDocument instance.
  ///
  /// ModelDocumentインスタンスを作成します。
  ModelDocument(super.modelQuery);

  @override
  Map<String, dynamic> fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(Map<String, dynamic> value) => value;
}

/// Collection class for managing model documents.
///
/// モデルドキュメントを管理するCollectionクラス。
class ModelCollection extends CollectionBase<ModelDocument> {
  /// Creates a ModelCollection instance.
  ///
  /// ModelCollectionインスタンスを作成します。
  ModelCollection(super.modelQuery);

  @override
  ModelDocument create([String? id]) {
    return ModelDocument(modelQuery.create(id));
  }
}

void main() {
  runApp(const MyApp());
}

/// Main application widget for model demo.
///
/// Model デモ用のメインアプリケーションWidget。
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  ///
  /// MyAppウィジェットを作成します。
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

/// Page widget to demonstrate model functionality.
///
/// Model機能を実演するページWidget。
class ModelPage extends StatefulWidget {
  /// Creates a ModelPage widget.
  ///
  /// ModelPageウィジェットを作成します。
  const ModelPage({super.key});

  @override
  State<StatefulWidget> createState() => ModelPageState();
}

/// State for ModelPage widget.
///
/// ModelPageウィジェットのState。
class ModelPageState extends State<ModelPage> {
  /// Model collection instance for managing user data.
  ///
  /// ユーザーデータを管理するModelCollectionインスタンス。
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
