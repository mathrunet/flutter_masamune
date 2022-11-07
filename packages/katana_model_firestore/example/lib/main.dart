import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:katana_scoped/katana_scoped.dart';
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
    return AppScoped(
      appRef: AppRef(),
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

extension ModelExtensions on RefHasApp {
  TCollection fetchCollection<TCollection extends CollectionBase>(
      CollectionModelProvider<TCollection> provider) {
    return app.watch(() => provider.build(), keys: [provider])..load();
  }

  TDodument fetchDocument<TDodument extends DocumentBase>(
      DocumentModelProvider<TDodument> provider) {
    return app.watch(() => provider.build(), keys: [provider])..load();
  }
}

abstract class DocumentModelProvider<TDocument extends DocumentBase>
    implements DocumentModelQuery {
  TDocument build();
}

abstract class CollectionModelProvider<TCollection extends CollectionBase>
    implements CollectionModelQuery {
  TCollection build();
}

class MyHomePage extends PageScopedWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final stream = ref.fetchCollection(StreamModelCollection.query());

    return Scaffold(
      appBar: AppBar(
        title: const Text("App"),
      ),
      body: ListView(
        children: stream.mapListenable((item) {
          return ListTile(
            title: Text(
              "${item.value?.name}/${item.value?.text}/${item.value?.user?.value?.name}",
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final user = stream.create();
          await user.save();
        },
        child: Text("追加"),
      ),
    );
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

enum UserModelKeys {
  name,
  text,
  image,
  age;
}

class _$UserModelDocument {
  const _$UserModelDocument();

  _$_UserModelDocument call({required String userId}) {
    return _$_UserModelDocument(userId: userId);
  }
}

class _$_UserModelDocument extends DocumentModelQuery
    implements DocumentModelProvider<UserModelDocument> {
  const _$_UserModelDocument({required String userId}) : super("user/$userId");

  @override
  UserModelDocument build() {
    return UserModelDocument(this);
  }
}

class UserModelDocument extends DocumentBase<UserModel>
    with ModelRefMixin<UserModel> {
  UserModelDocument(super.modelQuery);

  static const query = _$UserModelDocument();

  @override
  UserModel fromMap(DynamicMap map) => UserModel.fromJson(map);

  @override
  DynamicMap toMap(UserModel value) => value.toJson();
}

class _$UserModelCollection {
  const _$UserModelCollection();

  _$_UserModelCollection call({
    UserModelKeys? key,
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
    String? orderBy,
    String? search,
  }) {
    return _$_UserModelCollection(
      key: key?.name,
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
      orderBy: orderBy,
      search: search,
    );
  }
}

class _$_UserModelCollection extends CollectionModelQuery
    implements CollectionModelProvider<UserModelCollection> {
  const _$_UserModelCollection({
    String? key,
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
    String? orderBy,
    String? search,
  }) : super(
          "user",
          key: key,
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
          orderBy: orderBy,
          search: search,
        );

  @override
  UserModelCollection build() {
    return UserModelCollection(this);
  }
}

class UserModelCollection extends CollectionBase<UserModelDocument> {
  UserModelCollection(super.modelQuery);

  static const query = _$UserModelCollection();

  @override
  UserModelDocument create([String? id]) {
    return UserModelDocument(modelQuery.create(id));
  }
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

enum StreamModelKeys {
  name,
  text,
  user,
}

class _$StreamModelDocument {
  const _$StreamModelDocument();

  _$_StreamModelDocument call({required String streamId}) {
    return _$_StreamModelDocument(streamId: streamId);
  }
}

class _$_StreamModelDocument extends DocumentModelQuery
    implements DocumentModelProvider<StreamModelDocument> {
  const _$_StreamModelDocument({required String streamId})
      : super("stream/$streamId");

  @override
  StreamModelDocument build() {
    return StreamModelDocument(this);
  }
}

class StreamModelDocument extends DocumentBase<StreamModel>
    with ModelRefMixin<StreamModel> {
  StreamModelDocument(super.modelQuery, [super.value]);

  static const query = _$StreamModelDocument();

  @override
  StreamModel fromMap(DynamicMap map) => StreamModel.fromJson(map);

  @override
  DynamicMap toMap(StreamModel value) => value.toJson();

  @override
  Future<StreamModel?> filterOnDidLoad(StreamModel? value,
      [bool listenWhenPossible = true]) async {
    final modelQuery = value?.user?.modelQuery;
    if (modelQuery != null &&
        value?.user is! DocumentBase &&
        !_clientJoinCache.containsKey(modelQuery)) {
      final document = UserModelDocument(modelQuery)..load(listenWhenPossible);
      document.addListener(notifyListeners);
      _clientJoinCache[modelQuery] = document;
      return value?.copyWith(
        user: document,
      );
    }
    return value;
  }

  @override
  void dispose() {
    super.dispose();
    for (final cache in _clientJoinCache.values) {
      cache.removeListener(notifyListeners);
      cache.dispose();
    }
  }

  final _clientJoinCache = <DocumentModelQuery, ChangeNotifier>{};
}

class _$StreamModelCollection {
  const _$StreamModelCollection();

  _$_StreamModelCollection call({
    StreamModelKeys? key,
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
    String? orderBy,
    String? search,
  }) {
    return _$_StreamModelCollection(
      key: key?.name,
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
      orderBy: orderBy,
      search: search,
    );
  }
}

class _$_StreamModelCollection extends CollectionModelQuery
    implements CollectionModelProvider<StreamModelCollection> {
  const _$_StreamModelCollection({
    String? key,
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
    String? orderBy,
    String? search,
  }) : super(
          "stream",
          key: key,
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
          orderBy: orderBy,
          search: search,
        );

  @override
  StreamModelCollection build() {
    return StreamModelCollection(this);
  }
}

class StreamModelCollection extends CollectionBase<StreamModelDocument> {
  StreamModelCollection(super.modelQuery);

  static const query = _$StreamModelCollection();

  @override
  StreamModelDocument create([String? id]) {
    return StreamModelDocument(modelQuery.create(id));
  }

  @override
  Future<List<StreamModelDocument>> filterOnDidLoad(
      List<StreamModelDocument> value,
      [bool listenWhenPossible = true]) async {
    return await Future.wait(
      value.map((e) async {
        e.value = await e.filterOnDidLoad(e.value, listenWhenPossible);
        return e;
      }),
    );
  }
}
