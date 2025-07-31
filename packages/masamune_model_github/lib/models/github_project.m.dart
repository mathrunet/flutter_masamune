// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_project.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubProjectModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$GithubProjectModelKeys { id, name, previousName, projectUrl, url }

class _$GithubProjectModelDocument extends DocumentBase<GithubProjectModel>
    with ModelRefMixin<GithubProjectModel> {
  _$GithubProjectModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubProjectModel fromMap(DynamicMap map) =>
      GithubProjectModel.fromJson(map);

  @override
  DynamicMap toMap(GithubProjectModel value) => value.rawValue;
}

typedef _$GithubProjectModelMirrorDocument = _$GithubProjectModelDocument;

class _$GithubProjectModelCollection
    extends CollectionBase<_$GithubProjectModelDocument>
    with
        FilterableCollectionMixin<_$GithubProjectModelDocument,
            _$_GithubProjectModelCollectionQuery> {
  _$GithubProjectModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubProjectModelDocument create([String? id]) =>
      _$GithubProjectModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubProjectModelDocument>> filter(
    _$_GithubProjectModelCollectionQuery Function(
      _$_GithubProjectModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubProjectModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubProjectModelMirrorCollection = _$GithubProjectModelCollection;

@immutable
class _$GithubProjectModelRefPath extends ModelRefPath<GithubProjectModel> {
  const _$GithubProjectModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId;

  final String _organizationId;

  final String _repositoryId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/project/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubProjectModelInitialCollection
    extends ModelInitialCollection<GithubProjectModel> {
  const _$GithubProjectModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId;

  final String _organizationId;

  final String _repositoryId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/project";

  @override
  DynamicMap toMap(GithubProjectModel value) => value.rawValue;
}

@immutable
class _$GithubProjectModelDocumentQuery {
  const _$GithubProjectModelDocumentQuery();

  @useResult
  _$_GithubProjectModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubProjectModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/project/$_id",
        adapter: adapter ?? _$GithubProjectModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubProjectModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubProjectModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/project/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubProjectModelDocumentQuery
    extends ModelQueryBase<_$GithubProjectModelDocument> {
  const _$_GithubProjectModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubProjectModelDocument Function() call(Ref ref) =>
      () => _$GithubProjectModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubProjectModelCollectionQuery {
  const _$GithubProjectModelCollectionQuery();

  @useResult
  _$_GithubProjectModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubProjectModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/project",
        adapter: adapter ?? _$GithubProjectModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubProjectModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubProjectModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/project$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubProjectModelCollectionQuery
    extends ModelQueryBase<_$GithubProjectModelCollection> {
  const _$_GithubProjectModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubProjectModelCollection Function() call(Ref ref) =>
      () => _$GithubProjectModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubProjectModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubProjectModelCollectionQuery(query);

  _$_GithubProjectModelCollectionQuery collectionGroup() =>
      _$_GithubProjectModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubProjectModelCollectionQuery reset() =>
      _$_GithubProjectModelCollectionQuery(modelQuery.reset());

  _$_GithubProjectModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubProjectModelCollectionQuery(modelQuery.remove(type));

  _$_GithubProjectModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubProjectModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_GithubProjectModelCollectionQuery limitTo(int value) =>
      _$_GithubProjectModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubProjectModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubProjectModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubProjectModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubProjectModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubProjectModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_GithubProjectModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubProjectModelCollectionQuery>
      get previousName =>
          StringModelQuerySelector<_$_GithubProjectModelCollectionQuery>(
            key: "previousName",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubProjectModelCollectionQuery>
      get projectUrl =>
          ModelUriModelQuerySelector<_$_GithubProjectModelCollectionQuery>(
            key: "projectUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubProjectModelCollectionQuery> get url =>
      ModelUriModelQuerySelector<_$_GithubProjectModelCollectionQuery>(
        key: "url",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );
}

typedef _$GithubProjectModelMirrorRefPath = _$GithubProjectModelRefPath;
typedef _$GithubProjectModelMirrorInitialCollection
    = _$GithubProjectModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubProjectModelFormQuery {
  const _$GithubProjectModelFormQuery();

  @useResult
  _$_GithubProjectModelFormQuery call(GithubProjectModel value) {
    return _$_GithubProjectModelFormQuery(value);
  }
}

@immutable
class _$_GithubProjectModelFormQuery
    extends FormControllerQueryBase<GithubProjectModel> {
  const _$_GithubProjectModelFormQuery(this.value);

  final GithubProjectModel value;

  @override
  FormController<GithubProjectModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
