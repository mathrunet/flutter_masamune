// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'issue.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on IssueModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$IssueModelKeys {
  title,
  body,
  state,
  id,
  number,
  user,
  labels,
  createdAt,
  updatedAt,
  closedAt,
}

class _$IssueModelDocument extends DocumentBase<IssueModel>
    with ModelRefMixin<IssueModel> {
  _$IssueModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  IssueModel fromMap(DynamicMap map) => IssueModel.fromJson(map);

  @override
  DynamicMap toMap(IssueModel value) => value.rawValue;
}

typedef _$IssueModelMirrorDocument = _$IssueModelDocument;

class _$IssueModelCollection extends CollectionBase<_$IssueModelDocument>
    with
        FilterableCollectionMixin<_$IssueModelDocument,
            _$_IssueModelCollectionQuery> {
  _$IssueModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$IssueModelDocument create([String? id]) =>
      _$IssueModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$IssueModelDocument>> filter(
    _$_IssueModelCollectionQuery Function(_$_IssueModelCollectionQuery source)
        callback,
  ) {
    final query = callback.call(_$_IssueModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$IssueModelMirrorCollection = _$IssueModelCollection;

@immutable
class _$IssueModelRefPath extends ModelRefPath<IssueModel> {
  const _$IssueModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "issue/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$IssueModelInitialCollection extends ModelInitialCollection<IssueModel> {
  const _$IssueModelInitialCollection(super.value);

  @override
  String get path => "issue";

  @override
  DynamicMap toMap(IssueModel value) => value.rawValue;
}

@immutable
class _$IssueModelDocumentQuery {
  const _$IssueModelDocumentQuery();

  @useResult
  _$_IssueModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_IssueModelDocumentQuery(
      DocumentModelQuery(
        "issue/$_id",
        adapter: adapter ?? _$IssueModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$IssueModelDocument.defaultModelAccessQuery,
        validationQueries: _$IssueModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^issue/([^/]+)$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_IssueModelDocumentQuery extends ModelQueryBase<_$IssueModelDocument> {
  const _$_IssueModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$IssueModelDocument Function() call(Ref ref) =>
      () => _$IssueModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$IssueModelCollectionQuery {
  const _$IssueModelCollectionQuery();

  @useResult
  _$_IssueModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_IssueModelCollectionQuery(
      CollectionModelQuery(
        "issue",
        adapter: adapter ?? _$IssueModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$IssueModelCollection.defaultModelAccessQuery,
        validationQueries: _$IssueModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^issue$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_IssueModelCollectionQuery
    extends ModelQueryBase<_$IssueModelCollection> {
  const _$_IssueModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$IssueModelCollection Function() call(Ref ref) =>
      () => _$IssueModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_IssueModelCollectionQuery _toQuery(CollectionModelQuery query) =>
      _$_IssueModelCollectionQuery(query);

  _$_IssueModelCollectionQuery collectionGroup() =>
      _$_IssueModelCollectionQuery(modelQuery.collectionGroup());

  _$_IssueModelCollectionQuery reset() =>
      _$_IssueModelCollectionQuery(modelQuery.reset());

  _$_IssueModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_IssueModelCollectionQuery(modelQuery.remove(type));

  _$_IssueModelCollectionQuery notifyDocumentChanges() =>
      _$_IssueModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_IssueModelCollectionQuery limitTo(int value) =>
      _$_IssueModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_IssueModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_IssueModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_IssueModelCollectionQuery> get title =>
      StringModelQuerySelector<_$_IssueModelCollectionQuery>(
        key: "title",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_IssueModelCollectionQuery> get body =>
      StringModelQuerySelector<_$_IssueModelCollectionQuery>(
        key: "body",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_IssueModelCollectionQuery> get state =>
      StringModelQuerySelector<_$_IssueModelCollectionQuery>(
        key: "state",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_IssueModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_IssueModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_IssueModelCollectionQuery> get number =>
      NumModelQuerySelector<_$_IssueModelCollectionQuery>(
        key: "number",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  MapModelQuerySelector<dynamic, _$_IssueModelCollectionQuery> get user =>
      MapModelQuerySelector<dynamic, _$_IssueModelCollectionQuery>(
        key: "user",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ListModelQuerySelector<Map<String, dynamic>, _$_IssueModelCollectionQuery>
      get labels => ListModelQuerySelector<Map<String, dynamic>,
              _$_IssueModelCollectionQuery>(
          key: "labels", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_IssueModelCollectionQuery> get createdAt =>
      StringModelQuerySelector<_$_IssueModelCollectionQuery>(
        key: "createdAt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_IssueModelCollectionQuery> get updatedAt =>
      StringModelQuerySelector<_$_IssueModelCollectionQuery>(
        key: "updatedAt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_IssueModelCollectionQuery> get closedAt =>
      StringModelQuerySelector<_$_IssueModelCollectionQuery>(
        key: "closedAt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );
}

typedef _$IssueModelMirrorRefPath = _$IssueModelRefPath;
typedef _$IssueModelMirrorInitialCollection = _$IssueModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$IssueModelFormQuery {
  const _$IssueModelFormQuery();

  @useResult
  _$_IssueModelFormQuery call(IssueModel value) {
    return _$_IssueModelFormQuery(value);
  }
}

@immutable
class _$_IssueModelFormQuery extends FormControllerQueryBase<IssueModel> {
  const _$_IssueModelFormQuery(this.value);

  final IssueModel value;

  @override
  FormController<IssueModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
