// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of "local_notification_schedule.dart";

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on LocalNotificationScheduleModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$LocalNotificationScheduleModelKeys {
  id,
  time,
  repeat,
  title,
  text,
  data,
}

class _$LocalNotificationScheduleModelDocument
    extends DocumentBase<LocalNotificationScheduleModel>
    with ModelRefMixin<LocalNotificationScheduleModel> {
  _$LocalNotificationScheduleModelDocument(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      LocalNotificationMasamuneAdapter.primary.modelAdapter;

  @override
  LocalNotificationScheduleModel fromMap(DynamicMap map) =>
      LocalNotificationScheduleModel.fromJson(map);

  @override
  DynamicMap toMap(LocalNotificationScheduleModel value) => value.rawValue;
}

typedef _$LocalNotificationScheduleModelMirrorDocument
    = _$LocalNotificationScheduleModelDocument;

class _$LocalNotificationScheduleModelCollection
    extends CollectionBase<_$LocalNotificationScheduleModelDocument>
    with
        FilterableCollectionMixin<_$LocalNotificationScheduleModelDocument,
            _$_LocalNotificationScheduleModelCollectionQuery> {
  _$LocalNotificationScheduleModelCollection(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      LocalNotificationMasamuneAdapter.primary.modelAdapter;

  @override
  _$LocalNotificationScheduleModelDocument create([String? id]) =>
      _$LocalNotificationScheduleModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$LocalNotificationScheduleModelDocument>> filter(
    _$_LocalNotificationScheduleModelCollectionQuery Function(
      _$_LocalNotificationScheduleModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_LocalNotificationScheduleModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$LocalNotificationScheduleModelMirrorCollection
    = _$LocalNotificationScheduleModelCollection;

@immutable
class _$LocalNotificationScheduleModelRefPath
    extends ModelRefPath<LocalNotificationScheduleModel> {
  const _$LocalNotificationScheduleModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/scheduler/schedule/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$LocalNotificationScheduleModelInitialCollection
    extends ModelInitialCollection<LocalNotificationScheduleModel> {
  const _$LocalNotificationScheduleModelInitialCollection(super.value);

  @override
  String get path => "plugins/scheduler/schedule";

  @override
  DynamicMap toMap(LocalNotificationScheduleModel value) => value.rawValue;
}

@immutable
class _$LocalNotificationScheduleModelDocumentQuery {
  const _$LocalNotificationScheduleModelDocumentQuery();

  @useResult
  _$_LocalNotificationScheduleModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_LocalNotificationScheduleModelDocumentQuery(
      DocumentModelQuery(
        "plugins/scheduler/schedule/$_id",
        adapter: adapter ??
            _$LocalNotificationScheduleModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$LocalNotificationScheduleModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$LocalNotificationScheduleModelDocument.defaultValidationQueries,
      ),
    );
  }

  bool hasMatchPath(String path) {
    return RegExp(
      "plugins/scheduler/schedule/[^/]+".trimQuery().trimString("/"),
    ).hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_LocalNotificationScheduleModelDocumentQuery
    extends ModelQueryBase<_$LocalNotificationScheduleModelDocument> {
  const _$_LocalNotificationScheduleModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$LocalNotificationScheduleModelDocument Function() call(Ref ref) =>
      () => _$LocalNotificationScheduleModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$LocalNotificationScheduleModelCollectionQuery {
  const _$LocalNotificationScheduleModelCollectionQuery();

  @useResult
  _$_LocalNotificationScheduleModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_LocalNotificationScheduleModelCollectionQuery(
      CollectionModelQuery(
        "plugins/scheduler/schedule",
        adapter: adapter ??
            _$LocalNotificationScheduleModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$LocalNotificationScheduleModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$LocalNotificationScheduleModelCollection.defaultValidationQueries,
      ),
    );
  }

  bool hasMatchPath(String path) {
    return RegExp(
      "plugins/scheduler/schedule".trimQuery().trimString("/"),
    ).hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_LocalNotificationScheduleModelCollectionQuery
    extends ModelQueryBase<_$LocalNotificationScheduleModelCollection> {
  const _$_LocalNotificationScheduleModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$LocalNotificationScheduleModelCollection Function() call(Ref ref) =>
      () => _$LocalNotificationScheduleModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_LocalNotificationScheduleModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_LocalNotificationScheduleModelCollectionQuery(query);

  _$_LocalNotificationScheduleModelCollectionQuery collectionGroup() =>
      _$_LocalNotificationScheduleModelCollectionQuery(
        modelQuery.collectionGroup(),
      );

  _$_LocalNotificationScheduleModelCollectionQuery reset() =>
      _$_LocalNotificationScheduleModelCollectionQuery(modelQuery.reset());

  _$_LocalNotificationScheduleModelCollectionQuery remove(
    ModelQueryFilterType type,
  ) =>
      _$_LocalNotificationScheduleModelCollectionQuery(modelQuery.remove(type));

  _$_LocalNotificationScheduleModelCollectionQuery notifyDocumentChanges() =>
      _$_LocalNotificationScheduleModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_LocalNotificationScheduleModelCollectionQuery limitTo(int value) =>
      _$_LocalNotificationScheduleModelCollectionQuery(
        modelQuery.limitTo(value),
      );

  StringModelQuerySelector<_$_LocalNotificationScheduleModelCollectionQuery>
      get uid => StringModelQuerySelector<
              _$_LocalNotificationScheduleModelCollectionQuery>(
          key: "@uid", toQuery: _toQuery, modelQuery: modelQuery);

  NumModelQuerySelector<_$_LocalNotificationScheduleModelCollectionQuery>
      get id => NumModelQuerySelector<
              _$_LocalNotificationScheduleModelCollectionQuery>(
            key: "id",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<
          _$_LocalNotificationScheduleModelCollectionQuery>
      get time => ModelTimestampModelQuerySelector<
              _$_LocalNotificationScheduleModelCollectionQuery>(
          key: "time", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<LocalNotificationRepeatSettings,
          _$_LocalNotificationScheduleModelCollectionQuery>
      get repeat => ValueModelQuerySelector<LocalNotificationRepeatSettings,
              _$_LocalNotificationScheduleModelCollectionQuery>(
          key: "repeat", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_LocalNotificationScheduleModelCollectionQuery>
      get title => StringModelQuerySelector<
              _$_LocalNotificationScheduleModelCollectionQuery>(
          key: "title", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_LocalNotificationScheduleModelCollectionQuery>
      get text => StringModelQuerySelector<
              _$_LocalNotificationScheduleModelCollectionQuery>(
          key: "text", toQuery: _toQuery, modelQuery: modelQuery);

  MapModelQuerySelector<dynamic,
          _$_LocalNotificationScheduleModelCollectionQuery>
      get data => MapModelQuerySelector<dynamic,
              _$_LocalNotificationScheduleModelCollectionQuery>(
          key: "data", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$LocalNotificationScheduleModelMirrorRefPath
    = _$LocalNotificationScheduleModelRefPath;
typedef _$LocalNotificationScheduleModelMirrorInitialCollection
    = _$LocalNotificationScheduleModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$LocalNotificationScheduleModelFormQuery {
  const _$LocalNotificationScheduleModelFormQuery();

  @useResult
  _$_LocalNotificationScheduleModelFormQuery call(
    LocalNotificationScheduleModel value,
  ) {
    return _$_LocalNotificationScheduleModelFormQuery(value);
  }
}

@immutable
class _$_LocalNotificationScheduleModelFormQuery
    extends FormControllerQueryBase<LocalNotificationScheduleModel> {
  const _$_LocalNotificationScheduleModelFormQuery(this.value);

  final LocalNotificationScheduleModel value;

  @override
  FormController<LocalNotificationScheduleModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
