// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'pull_request.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on PullRequestModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$PullRequestModelKeys {
  title,
  body,
  state,
  id,
  number,
  user,
  head,
  base,
  createdAt,
  updatedAt,
  mergedAt,
}

class _$PullRequestModelDocument extends DocumentBase<PullRequestModel>
    with ModelRefMixin<PullRequestModel> {
  _$PullRequestModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  PullRequestModel fromMap(DynamicMap map) => PullRequestModel.fromJson(map);

  @override
  DynamicMap toMap(PullRequestModel value) => value.rawValue;
}

typedef _$PullRequestModelMirrorDocument = _$PullRequestModelDocument;

class _$PullRequestModelCollection
    extends CollectionBase<_$PullRequestModelDocument>
    with
        FilterableCollectionMixin<_$PullRequestModelDocument,
            _$_PullRequestModelCollectionQuery> {
  _$PullRequestModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$PullRequestModelDocument create([String? id]) =>
      _$PullRequestModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$PullRequestModelDocument>> filter(
    _$_PullRequestModelCollectionQuery Function(
      _$_PullRequestModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(_$_PullRequestModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$PullRequestModelMirrorCollection = _$PullRequestModelCollection;

@immutable
class _$PullRequestModelRefPath extends ModelRefPath<PullRequestModel> {
  const _$PullRequestModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "pull_request/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$PullRequestModelInitialCollection
    extends ModelInitialCollection<PullRequestModel> {
  const _$PullRequestModelInitialCollection(super.value);

  @override
  String get path => "pull_request";

  @override
  DynamicMap toMap(PullRequestModel value) => value.rawValue;
}

@immutable
class _$PullRequestModelDocumentQuery {
  const _$PullRequestModelDocumentQuery();

  @useResult
  _$_PullRequestModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_PullRequestModelDocumentQuery(
      DocumentModelQuery(
        "pull_request/$_id",
        adapter: adapter ?? _$PullRequestModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$PullRequestModelDocument.defaultModelAccessQuery,
        validationQueries: _$PullRequestModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^pull_request/([^/]+)$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_PullRequestModelDocumentQuery
    extends ModelQueryBase<_$PullRequestModelDocument> {
  const _$_PullRequestModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$PullRequestModelDocument Function() call(Ref ref) =>
      () => _$PullRequestModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$PullRequestModelCollectionQuery {
  const _$PullRequestModelCollectionQuery();

  @useResult
  _$_PullRequestModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_PullRequestModelCollectionQuery(
      CollectionModelQuery(
        "pull_request",
        adapter: adapter ?? _$PullRequestModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$PullRequestModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$PullRequestModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^pull_request$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_PullRequestModelCollectionQuery
    extends ModelQueryBase<_$PullRequestModelCollection> {
  const _$_PullRequestModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$PullRequestModelCollection Function() call(Ref ref) =>
      () => _$PullRequestModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_PullRequestModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_PullRequestModelCollectionQuery(query);

  _$_PullRequestModelCollectionQuery collectionGroup() =>
      _$_PullRequestModelCollectionQuery(modelQuery.collectionGroup());

  _$_PullRequestModelCollectionQuery reset() =>
      _$_PullRequestModelCollectionQuery(modelQuery.reset());

  _$_PullRequestModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_PullRequestModelCollectionQuery(modelQuery.remove(type));

  _$_PullRequestModelCollectionQuery notifyDocumentChanges() =>
      _$_PullRequestModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_PullRequestModelCollectionQuery limitTo(int value) =>
      _$_PullRequestModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_PullRequestModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_PullRequestModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_PullRequestModelCollectionQuery> get title =>
      StringModelQuerySelector<_$_PullRequestModelCollectionQuery>(
        key: "title",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_PullRequestModelCollectionQuery> get body =>
      StringModelQuerySelector<_$_PullRequestModelCollectionQuery>(
        key: "body",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_PullRequestModelCollectionQuery> get state =>
      StringModelQuerySelector<_$_PullRequestModelCollectionQuery>(
        key: "state",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_PullRequestModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_PullRequestModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_PullRequestModelCollectionQuery> get number =>
      NumModelQuerySelector<_$_PullRequestModelCollectionQuery>(
        key: "number",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  MapModelQuerySelector<dynamic, _$_PullRequestModelCollectionQuery> get user =>
      MapModelQuerySelector<dynamic, _$_PullRequestModelCollectionQuery>(
        key: "user",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  MapModelQuerySelector<dynamic, _$_PullRequestModelCollectionQuery> get head =>
      MapModelQuerySelector<dynamic, _$_PullRequestModelCollectionQuery>(
        key: "head",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  MapModelQuerySelector<dynamic, _$_PullRequestModelCollectionQuery> get base =>
      MapModelQuerySelector<dynamic, _$_PullRequestModelCollectionQuery>(
        key: "base",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_PullRequestModelCollectionQuery> get createdAt =>
      StringModelQuerySelector<_$_PullRequestModelCollectionQuery>(
        key: "createdAt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_PullRequestModelCollectionQuery> get updatedAt =>
      StringModelQuerySelector<_$_PullRequestModelCollectionQuery>(
        key: "updatedAt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_PullRequestModelCollectionQuery> get mergedAt =>
      StringModelQuerySelector<_$_PullRequestModelCollectionQuery>(
        key: "mergedAt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );
}

typedef _$PullRequestModelMirrorRefPath = _$PullRequestModelRefPath;
typedef _$PullRequestModelMirrorInitialCollection
    = _$PullRequestModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$PullRequestModelFormQuery {
  const _$PullRequestModelFormQuery();

  @useResult
  _$_PullRequestModelFormQuery call(PullRequestModel value) {
    return _$_PullRequestModelFormQuery(value);
  }
}

@immutable
class _$_PullRequestModelFormQuery
    extends FormControllerQueryBase<PullRequestModel> {
  const _$_PullRequestModelFormQuery(this.value);

  final PullRequestModel value;

  @override
  FormController<PullRequestModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
