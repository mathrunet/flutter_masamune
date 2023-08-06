// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'point_ecosystem_user.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on PointEcosystemUserModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$PointEcosystemUserModelKeys { lastDate, continuousCount }

class _$PointEcosystemUserModelDocument
    extends DocumentBase<PointEcosystemUserModel>
    with ModelRefMixin<PointEcosystemUserModel> {
  _$PointEcosystemUserModelDocument(super.modelQuery);

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  PointEcosystemUserModel fromMap(DynamicMap map) =>
      PointEcosystemUserModel.fromJson(map);
  @override
  DynamicMap toMap(PointEcosystemUserModel value) => value.rawValue;
}

typedef _$PointEcosystemUserModelMirrorDocument
    = _$PointEcosystemUserModelDocument;

class _$PointEcosystemUserModelCollection
    extends CollectionBase<_$PointEcosystemUserModelDocument>
    with
        FilterableCollectionMixin<_$PointEcosystemUserModelDocument,
            _$_PointEcosystemUserModelCollectionQuery> {
  _$PointEcosystemUserModelCollection(super.modelQuery);

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$PointEcosystemUserModelDocument create([String? id]) =>
      _$PointEcosystemUserModelDocument(modelQuery.create(id));
  @override
  Future<CollectionBase<_$PointEcosystemUserModelDocument>> filter(
      _$_PointEcosystemUserModelCollectionQuery Function(
              _$_PointEcosystemUserModelCollectionQuery source)
          callback) {
    final query =
        callback.call(_$_PointEcosystemUserModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$PointEcosystemUserModelMirrorCollection
    = _$PointEcosystemUserModelCollection;

@immutable
class _$PointEcosystemUserModelRefPath
    extends ModelRefPath<PointEcosystemUserModel> {
  const _$PointEcosystemUserModelRefPath(String uid) : super(uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/pes/user/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$PointEcosystemUserModelInitialCollection
    extends ModelInitialCollection<PointEcosystemUserModel> {
  const _$PointEcosystemUserModelInitialCollection(super.value);

  @override
  String get path => "plugins/pes/user";
  @override
  DynamicMap toMap(PointEcosystemUserModel value) => value.rawValue;
}

@immutable
class _$PointEcosystemUserModelDocumentQuery {
  const _$PointEcosystemUserModelDocumentQuery();

  @useResult
  _$_PointEcosystemUserModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
  }) {
    return _$_PointEcosystemUserModelDocumentQuery(DocumentModelQuery(
      "plugins/pes/user/$_id",
      adapter: adapter ?? _$PointEcosystemUserModelDocument.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_PointEcosystemUserModelDocumentQuery
    extends ModelQueryBase<_$PointEcosystemUserModelDocument> {
  const _$_PointEcosystemUserModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$PointEcosystemUserModelDocument Function() call(Ref ref) =>
      () => _$PointEcosystemUserModelDocument(modelQuery);
  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$PointEcosystemUserModelCollectionQuery {
  const _$PointEcosystemUserModelCollectionQuery();

  @useResult
  _$_PointEcosystemUserModelCollectionQuery call({ModelAdapter? adapter}) {
    return _$_PointEcosystemUserModelCollectionQuery(CollectionModelQuery(
      "plugins/pes/user",
      adapter:
          adapter ?? _$PointEcosystemUserModelCollection.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_PointEcosystemUserModelCollectionQuery
    extends ModelQueryBase<_$PointEcosystemUserModelCollection> {
  const _$_PointEcosystemUserModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$PointEcosystemUserModelCollection Function() call(Ref ref) =>
      () => _$PointEcosystemUserModelCollection(modelQuery);
  @override
  String get queryName => modelQuery.toString();
  static _$_PointEcosystemUserModelCollectionQuery _toQuery(
          CollectionModelQuery query) =>
      _$_PointEcosystemUserModelCollectionQuery(query);
  _$_PointEcosystemUserModelCollectionQuery limitTo(int value) =>
      _$_PointEcosystemUserModelCollectionQuery(modelQuery.limitTo(value));
  _$_PointEcosystemUserModelCollectionQuery reset() =>
      _$_PointEcosystemUserModelCollectionQuery(modelQuery.reset());
  ModelTimestampModelQuerySelector<_$_PointEcosystemUserModelCollectionQuery>
      get lastDate => ModelTimestampModelQuerySelector<
              _$_PointEcosystemUserModelCollectionQuery>(
          key: "lastDate", toQuery: _toQuery, modelQuery: modelQuery);
  NumModelQuerySelector<_$_PointEcosystemUserModelCollectionQuery>
      get continuousCount =>
          NumModelQuerySelector<_$_PointEcosystemUserModelCollectionQuery>(
              key: "continuousCount",
              toQuery: _toQuery,
              modelQuery: modelQuery);
}

typedef _$PointEcosystemUserModelMirrorRefPath
    = _$PointEcosystemUserModelRefPath;
typedef _$PointEcosystemUserModelMirrorInitialCollection
    = _$PointEcosystemUserModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$PointEcosystemUserModelFormQuery {
  const _$PointEcosystemUserModelFormQuery();

  @useResult
  _$_PointEcosystemUserModelFormQuery call(PointEcosystemUserModel value) {
    return _$_PointEcosystemUserModelFormQuery(value);
  }
}

@immutable
class _$_PointEcosystemUserModelFormQuery
    extends ControllerQueryBase<FormController<PointEcosystemUserModel>> {
  const _$_PointEcosystemUserModelFormQuery(this.value);

  final PointEcosystemUserModel value;

  @override
  FormController<PointEcosystemUserModel> Function() call(Ref ref) =>
      () => FormController(value);
  @override
  String get queryName => value.hashCode.toString();
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
