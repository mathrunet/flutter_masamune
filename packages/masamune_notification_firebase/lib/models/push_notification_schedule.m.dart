// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'push_notification_schedule.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on PushNotificationScheduleModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$PushNotificationScheduleModelKeys {
  time,
  title,
  text,
  channelId,
  data,
  token,
  topic
}

class _$PushNotificationScheduleModelDocument
    extends DocumentBase<PushNotificationScheduleModel>
    with ModelRefMixin<PushNotificationScheduleModel> {
  _$PushNotificationScheduleModelDocument(super.modelQuery);

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  PushNotificationScheduleModel fromMap(DynamicMap map) =>
      PushNotificationScheduleModel.fromJson(map);
  @override
  DynamicMap toMap(PushNotificationScheduleModel value) => value.rawValue;
}

typedef _$PushNotificationScheduleModelMirrorDocument
    = _$PushNotificationScheduleModelDocument;

class _$PushNotificationScheduleModelCollection
    extends CollectionBase<_$PushNotificationScheduleModelDocument>
    with
        FilterableCollectionMixin<_$PushNotificationScheduleModelDocument,
            _$_PushNotificationScheduleModelCollectionQuery> {
  _$PushNotificationScheduleModelCollection(super.modelQuery);

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$PushNotificationScheduleModelDocument create([String? id]) =>
      _$PushNotificationScheduleModelDocument(modelQuery.create(id));
  @override
  Future<CollectionBase<_$PushNotificationScheduleModelDocument>> filter(
      _$_PushNotificationScheduleModelCollectionQuery Function(
              _$_PushNotificationScheduleModelCollectionQuery source)
          callback) {
    final query = callback
        .call(_$_PushNotificationScheduleModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$PushNotificationScheduleModelMirrorCollection
    = _$PushNotificationScheduleModelCollection;

@immutable
class _$PushNotificationScheduleModelRefPath
    extends ModelRefPath<PushNotificationScheduleModel> {
  const _$PushNotificationScheduleModelRefPath(String uid) : super(uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/notification/schedule/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$PushNotificationScheduleModelInitialCollection
    extends ModelInitialCollection<PushNotificationScheduleModel> {
  const _$PushNotificationScheduleModelInitialCollection(super.value);

  @override
  String get path => "plugins/notification/schedule";
  @override
  DynamicMap toMap(PushNotificationScheduleModel value) => value.rawValue;
}

@immutable
class _$PushNotificationScheduleModelDocumentQuery {
  const _$PushNotificationScheduleModelDocumentQuery();

  @useResult
  _$_PushNotificationScheduleModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
  }) {
    return _$_PushNotificationScheduleModelDocumentQuery(DocumentModelQuery(
      "plugins/notification/schedule/$_id",
      adapter: adapter ??
          _$PushNotificationScheduleModelDocument.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_PushNotificationScheduleModelDocumentQuery
    extends ModelQueryBase<_$PushNotificationScheduleModelDocument> {
  const _$_PushNotificationScheduleModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$PushNotificationScheduleModelDocument Function() call(Ref ref) =>
      () => _$PushNotificationScheduleModelDocument(modelQuery);
  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$PushNotificationScheduleModelCollectionQuery {
  const _$PushNotificationScheduleModelCollectionQuery();

  @useResult
  _$_PushNotificationScheduleModelCollectionQuery call(
      {ModelAdapter? adapter}) {
    return _$_PushNotificationScheduleModelCollectionQuery(CollectionModelQuery(
      "plugins/notification/schedule",
      adapter: adapter ??
          _$PushNotificationScheduleModelCollection.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_PushNotificationScheduleModelCollectionQuery
    extends ModelQueryBase<_$PushNotificationScheduleModelCollection> {
  const _$_PushNotificationScheduleModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$PushNotificationScheduleModelCollection Function() call(Ref ref) =>
      () => _$PushNotificationScheduleModelCollection(modelQuery);
  @override
  String get queryName => modelQuery.toString();
  static _$_PushNotificationScheduleModelCollectionQuery _toQuery(
          CollectionModelQuery query) =>
      _$_PushNotificationScheduleModelCollectionQuery(query);
  _$_PushNotificationScheduleModelCollectionQuery limitTo(int value) =>
      _$_PushNotificationScheduleModelCollectionQuery(
          modelQuery.limitTo(value));
  _$_PushNotificationScheduleModelCollectionQuery reset() =>
      _$_PushNotificationScheduleModelCollectionQuery(modelQuery.reset());
  ModelTimestampModelQuerySelector<
          _$_PushNotificationScheduleModelCollectionQuery>
      get time => ModelTimestampModelQuerySelector<
              _$_PushNotificationScheduleModelCollectionQuery>(
          key: "time", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PushNotificationScheduleModelCollectionQuery>
      get title => StringModelQuerySelector<
              _$_PushNotificationScheduleModelCollectionQuery>(
          key: "title", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PushNotificationScheduleModelCollectionQuery>
      get text => StringModelQuerySelector<
              _$_PushNotificationScheduleModelCollectionQuery>(
          key: "text", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PushNotificationScheduleModelCollectionQuery>
      get channelId => StringModelQuerySelector<
              _$_PushNotificationScheduleModelCollectionQuery>(
          key: "channelId", toQuery: _toQuery, modelQuery: modelQuery);
  MapModelQuerySelector<dynamic,
          _$_PushNotificationScheduleModelCollectionQuery>
      get data => MapModelQuerySelector<dynamic,
              _$_PushNotificationScheduleModelCollectionQuery>(
          key: "data", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PushNotificationScheduleModelCollectionQuery>
      get token => StringModelQuerySelector<
              _$_PushNotificationScheduleModelCollectionQuery>(
          key: "token", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PushNotificationScheduleModelCollectionQuery>
      get topic => StringModelQuerySelector<
              _$_PushNotificationScheduleModelCollectionQuery>(
          key: "topic", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$PushNotificationScheduleModelMirrorRefPath
    = _$PushNotificationScheduleModelRefPath;
typedef _$PushNotificationScheduleModelMirrorInitialCollection
    = _$PushNotificationScheduleModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$PushNotificationScheduleModelFormQuery {
  const _$PushNotificationScheduleModelFormQuery();

  @useResult
  _$_PushNotificationScheduleModelFormQuery call(
      PushNotificationScheduleModel value) {
    return _$_PushNotificationScheduleModelFormQuery(value);
  }
}

@immutable
class _$_PushNotificationScheduleModelFormQuery
    extends ControllerQueryBase<FormController<PushNotificationScheduleModel>> {
  const _$_PushNotificationScheduleModelFormQuery(this.value);

  final PushNotificationScheduleModel value;

  @override
  FormController<PushNotificationScheduleModel> Function() call(Ref ref) =>
      () => FormController(value);
  @override
  String get queryName => value.hashCode.toString();
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
