// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'remote_notification_schedule.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on RemoteNotificationScheduleModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$RemoteNotificationScheduleModelKeys { command }

class _$RemoteNotificationScheduleModelDocument
    extends DocumentBase<RemoteNotificationScheduleModel>
    with ModelRefMixin<RemoteNotificationScheduleModel> {
  _$RemoteNotificationScheduleModelDocument(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  RemoteNotificationScheduleModel fromMap(DynamicMap map) =>
      RemoteNotificationScheduleModel.fromJson(map);

  @override
  DynamicMap toMap(RemoteNotificationScheduleModel value) => value.rawValue;
}

typedef _$RemoteNotificationScheduleModelMirrorDocument
    = _$RemoteNotificationScheduleModelDocument;

class _$RemoteNotificationScheduleModelCollection
    extends CollectionBase<_$RemoteNotificationScheduleModelDocument>
    with
        FilterableCollectionMixin<_$RemoteNotificationScheduleModelDocument,
            _$_RemoteNotificationScheduleModelCollectionQuery> {
  _$RemoteNotificationScheduleModelCollection(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$RemoteNotificationScheduleModelDocument create([String? id]) =>
      _$RemoteNotificationScheduleModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$RemoteNotificationScheduleModelDocument>> filter(
      _$_RemoteNotificationScheduleModelCollectionQuery Function(
              _$_RemoteNotificationScheduleModelCollectionQuery source)
          callback) {
    final query = callback
        .call(_$_RemoteNotificationScheduleModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$RemoteNotificationScheduleModelMirrorCollection
    = _$RemoteNotificationScheduleModelCollection;

@immutable
class _$RemoteNotificationScheduleModelRefPath
    extends ModelRefPath<RemoteNotificationScheduleModel> {
  const _$RemoteNotificationScheduleModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/scheduler/schedule/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$RemoteNotificationScheduleModelInitialCollection
    extends ModelInitialCollection<RemoteNotificationScheduleModel> {
  const _$RemoteNotificationScheduleModelInitialCollection(super.value);

  @override
  String get path => "plugins/scheduler/schedule";

  @override
  DynamicMap toMap(RemoteNotificationScheduleModel value) => value.rawValue;
}

@immutable
class _$RemoteNotificationScheduleModelDocumentQuery {
  const _$RemoteNotificationScheduleModelDocumentQuery();

  @useResult
  _$_RemoteNotificationScheduleModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_RemoteNotificationScheduleModelDocumentQuery(DocumentModelQuery(
      "plugins/scheduler/schedule/$_id",
      adapter: adapter ??
          _$RemoteNotificationScheduleModelDocument.defaultModelAdapter,
      accessQuery: accessQuery ??
          _$RemoteNotificationScheduleModelDocument.defaultModelAccessQuery,
      validationQueries:
          _$RemoteNotificationScheduleModelDocument.defaultValidationQueries,
    ));
  }
}

@immutable
class _$_RemoteNotificationScheduleModelDocumentQuery
    extends ModelQueryBase<_$RemoteNotificationScheduleModelDocument> {
  const _$_RemoteNotificationScheduleModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$RemoteNotificationScheduleModelDocument Function() call(Ref ref) =>
      () => _$RemoteNotificationScheduleModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$RemoteNotificationScheduleModelCollectionQuery {
  const _$RemoteNotificationScheduleModelCollectionQuery();

  @useResult
  _$_RemoteNotificationScheduleModelCollectionQuery call({
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_RemoteNotificationScheduleModelCollectionQuery(
        CollectionModelQuery(
      "plugins/scheduler/schedule",
      adapter: adapter ??
          _$RemoteNotificationScheduleModelCollection.defaultModelAdapter,
      accessQuery: accessQuery ??
          _$RemoteNotificationScheduleModelCollection.defaultModelAccessQuery,
      validationQueries:
          _$RemoteNotificationScheduleModelCollection.defaultValidationQueries,
    ));
  }
}

@immutable
class _$_RemoteNotificationScheduleModelCollectionQuery
    extends ModelQueryBase<_$RemoteNotificationScheduleModelCollection> {
  const _$_RemoteNotificationScheduleModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$RemoteNotificationScheduleModelCollection Function() call(Ref ref) =>
      () => _$RemoteNotificationScheduleModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_RemoteNotificationScheduleModelCollectionQuery _toQuery(
          CollectionModelQuery query) =>
      _$_RemoteNotificationScheduleModelCollectionQuery(query);

  _$_RemoteNotificationScheduleModelCollectionQuery limitTo(int value) =>
      _$_RemoteNotificationScheduleModelCollectionQuery(
          modelQuery.limitTo(value));

  _$_RemoteNotificationScheduleModelCollectionQuery collectionGroup() =>
      _$_RemoteNotificationScheduleModelCollectionQuery(
          modelQuery.collectionGroup());

  _$_RemoteNotificationScheduleModelCollectionQuery reset() =>
      _$_RemoteNotificationScheduleModelCollectionQuery(modelQuery.reset());

  _$_RemoteNotificationScheduleModelCollectionQuery notifyDocumentChanges() =>
      _$_RemoteNotificationScheduleModelCollectionQuery(
          modelQuery.notifyDocumentChanges());

  StringModelQuerySelector<_$_RemoteNotificationScheduleModelCollectionQuery>
      get uid => StringModelQuerySelector<
              _$_RemoteNotificationScheduleModelCollectionQuery>(
          key: "@uid", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<ModelServerCommandRemoteNotificationSchedule,
          _$_RemoteNotificationScheduleModelCollectionQuery>
      get command => ValueModelQuerySelector<
              ModelServerCommandRemoteNotificationSchedule,
              _$_RemoteNotificationScheduleModelCollectionQuery>(
          key: "command", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$RemoteNotificationScheduleModelMirrorRefPath
    = _$RemoteNotificationScheduleModelRefPath;
typedef _$RemoteNotificationScheduleModelMirrorInitialCollection
    = _$RemoteNotificationScheduleModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$RemoteNotificationScheduleModelFormQuery {
  const _$RemoteNotificationScheduleModelFormQuery();

  @useResult
  _$_RemoteNotificationScheduleModelFormQuery call(
      RemoteNotificationScheduleModel value) {
    return _$_RemoteNotificationScheduleModelFormQuery(value);
  }
}

@immutable
class _$_RemoteNotificationScheduleModelFormQuery
    extends FormControllerQueryBase<RemoteNotificationScheduleModel> {
  const _$_RemoteNotificationScheduleModelFormQuery(this.value);

  final RemoteNotificationScheduleModel value;

  @override
  FormController<RemoteNotificationScheduleModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
