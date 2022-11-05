import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'firebase_options.dart';
import 'package:katana_model_firestore/katana_model_firestore.dart';

part 'main.freezed.dart';
part 'main.g.dart';

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
    return ProviderScope(
      child: ModelAdapterScope(
        adapter: const FirestoreModelAdapter(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watchUserModelCollection();

    return Scaffold(
      appBar: AppBar(
        title: const Text("App"),
      ),
      body: ListView(
        children: users.mapListenable((item) {
          return ListTile(
            title: Text(
              "${item.value?.name}/${item.value?.text}/${item.value?.age}",
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final user = users.create();
          user.value = UserModel(
            name: uuid,
            text: uuid,
            age: Random().rangeInt(0, 100),
            image: uuid,
          );
          await user.save();
        },
        child: Text("追加"),
      ),
    );
  }
}

extension $$streamModelExtensions on WidgetRef {
  StreamModelDocument watchStreamModelDocument(String id) {
    final context = this as BuildContext;
    final adapter = ModelAdapterScope.of(context)?.adapter;
    return watch(
      _$StreamModelDocumentProvider.call(
        DocumentModelQuery(
          "stream/$id",
          adapter: adapter,
        ),
      ),
    )
      ..load()
      ..append(
        (value) {
          final userId = value?.user?.query.path.last() ?? "";
          final user = userId.isEmpty ? null : watchUserModelDocument(userId);
          return value?.copyWith(
            user: user,
          );
        },
      );
  }

  StreamModelCollection watchStreamModelCollection({
    StreamModelCollectionKeys? key,
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    List<dynamic>? arrayContainsAny,
    List<dynamic>? whereIn,
    List<dynamic>? whereNotIn,
    List<String>? geoHash,
    ModelQueryOrder order = ModelQueryOrder.asc,
    int? limit,
    StreamModelCollectionKeys? orderBy,
    String? search,
  }) {
    final context = this as BuildContext;
    final adapter = ModelAdapterScope.of(context)?.adapter;
    return watch(
      _$StreamModelCollectionProvider.call(
        CollectionModelQuery(
          "stream",
          adapter: adapter,
          key: key?._id,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          geoHash: geoHash,
          order: order,
          limit: limit,
          search: search,
          orderBy: orderBy?._id,
        ),
      ),
    )
      ..load()
      ..append((value) {
        final userId = value?.user?.route.path.last() ?? "";
        final users = userId.isEmpty ? null : watchUserModelCollection(key: );
        return value;
      });
  }
}

enum StreamModelCollectionKeys {
  name,
  text,
  user,
}

extension _StreamModelCollectionKeysExtensions on StreamModelCollectionKeys {
  String get _id {
    switch (this) {
      case StreamModelCollectionKeys.name:
        return "name";
      case StreamModelCollectionKeys.text:
        return "text";
      case StreamModelCollectionKeys.user:
        return "user";
    }
  }
}

extension $$userModelExtensions on WidgetRef {
  UserModelDocument watchUserModelDocument(String id) {
    final context = this as BuildContext;
    final adapter = ModelAdapterScope.of(context)?.adapter;
    return watch(
      _$UserModelDocumentProvider.call(
        DocumentModelQuery("user/$id", adapter: adapter),
      ),
    )..load();
  }

  UserModelCollection watchUserModelCollection({
    UserModelCollectionKeys? key,
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    List<dynamic>? arrayContainsAny,
    List<dynamic>? whereIn,
    List<dynamic>? whereNotIn,
    List<String>? geoHash,
    ModelQueryOrder order = ModelQueryOrder.asc,
    int? limit,
    UserModelCollectionKeys? orderBy,
    String? search,
  }) {
    final context = this as BuildContext;
    final adapter = ModelAdapterScope.of(context)?.adapter;
    return watch(
      _$UserModelCollectionProvider.call(
        CollectionModelQuery(
          "user",
          adapter: adapter,
          key: key?._id,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          geoHash: geoHash,
          order: order,
          limit: limit,
          search: search,
          orderBy: orderBy?._id,
        ),
      ),
    )..load();
  }
}

enum UserModelCollectionKeys {
  name,
  text,
  image,
  age,
}

extension _UserModelCollectionKeysExtensions on UserModelCollectionKeys {
  String get _id {
    switch (this) {
      case UserModelCollectionKeys.name:
        return "name";
      case UserModelCollectionKeys.text:
        return "text";
      case UserModelCollectionKeys.image:
        return "image";
      case UserModelCollectionKeys.age:
        return "age";
    }
  }
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel(
      {required String name,
      required String text,
      String? image,
      @Default(20) int age}) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}

@freezed
class StreamModel with _$StreamModel {
  const factory StreamModel({
    required String name,
    required String text,
    ModelRef<UserModel>? user,
  }) = _StreamModel;

  factory StreamModel.fromJson(Map<String, Object?> json) =>
      _$StreamModelFromJson(json);
}

final _$UserModelDocumentProvider =
    ChangeNotifierProviderFamily<UserModelDocument, DocumentModelQuery>(
        (_, query) {
  return UserModelDocument(query);
});

final _$StreamModelDocumentProvider =
    ChangeNotifierProviderFamily<StreamModelDocument, DocumentModelQuery>(
        (_, query) {
  return StreamModelDocument(query);
});

final _$UserModelCollectionProvider =
    ChangeNotifierProviderFamily<UserModelCollection, CollectionModelQuery>(
        (_, query) {
  return UserModelCollection(query);
});

final _$StreamModelCollectionProvider =
    ChangeNotifierProviderFamily<StreamModelCollection, CollectionModelQuery>(
        (_, query) {
  return StreamModelCollection(query);
});

class UserModelDocument extends DocumentBase<UserModel>
    with ModelRefMixin<UserModel>
    implements ModelRef<UserModel> {
  UserModelDocument(super.query, [super.value]);

  @override
  UserModel fromMap(DynamicMap map) => UserModel.fromJson(map);

  @override
  DynamicMap toMap(UserModel value) => value.toJson();
}

class UserModelCollection extends CollectionBase<UserModelDocument> {
  UserModelCollection(super.query);

  @override
  UserModelDocument create([String? id]) {
    return UserModelDocument(modelQuery.create(id));
  }
}

class StreamModelDocument extends DocumentBase<StreamModel>
    with ModelRefMixin<StreamModel>
    implements ModelRef<StreamModel> {
  StreamModelDocument(super.query, [super.value]);

  @override
  StreamModel fromMap(DynamicMap map) => StreamModel.fromJson(map);

  @override
  DynamicMap toMap(StreamModel value) => value.toJson();
}

class StreamModelCollection extends CollectionBase<StreamModelDocument> {
  StreamModelCollection(super.query);

  @override
  StreamModelDocument create([String? id]) {
    return StreamModelDocument(modelQuery.create(id));
  }
}
