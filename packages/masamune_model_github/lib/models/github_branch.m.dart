// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_branch.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubBranchModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {...map, "commit": commit?.toJson()};
  }
}

enum _$GithubBranchModelKeys { name, commit, baseRef, fromServer }

class _$GithubBranchModelDocument extends DocumentBase<GithubBranchModel>
    with
        ModelRefMixin<GithubBranchModel>,
        ModelRefLoaderMixin<GithubBranchModel> {
  _$GithubBranchModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubBranchModel fromMap(DynamicMap map) => GithubBranchModel.fromJson(map);

  @override
  DynamicMap toMap(GithubBranchModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<GithubBranchModel>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.baseRef,
          document: (modelQuery) => GithubBranchModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(baseRef: doc),
          adapter: GithubBranchModelDocument.defaultModelAdapter,
          accessQuery: GithubBranchModelDocument.defaultModelAccessQuery,
          validationQueries: GithubBranchModelDocument.defaultValidationQueries,
        ),
      ];
}

typedef _$GithubBranchModelMirrorDocument = _$GithubBranchModelDocument;

class _$GithubBranchModelCollection
    extends CollectionBase<_$GithubBranchModelDocument>
    with
        FilterableCollectionMixin<_$GithubBranchModelDocument,
            _$_GithubBranchModelCollectionQuery> {
  _$GithubBranchModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubBranchModelDocument create([String? id]) =>
      _$GithubBranchModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubBranchModelDocument>> filter(
    _$_GithubBranchModelCollectionQuery Function(
      _$_GithubBranchModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubBranchModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubBranchModelMirrorCollection = _$GithubBranchModelCollection;

@immutable
class _$GithubBranchModelRefPath extends ModelRefPath<GithubBranchModel> {
  const _$GithubBranchModelRefPath(
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
      "organization/$_organizationId/repository/$_repositoryId/branch/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubBranchModelInitialCollection
    extends ModelInitialCollection<GithubBranchModel> {
  const _$GithubBranchModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId;

  final String _organizationId;

  final String _repositoryId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/branch";

  @override
  DynamicMap toMap(GithubBranchModel value) => value.rawValue;
}

@immutable
class _$GithubBranchModelDocumentQuery {
  const _$GithubBranchModelDocumentQuery();

  @useResult
  _$_GithubBranchModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubBranchModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/branch/$_id",
        adapter: adapter ?? _$GithubBranchModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubBranchModelDocument.defaultModelAccessQuery,
        validationQueries: _$GithubBranchModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/branch/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubBranchModelDocumentQuery
    extends ModelQueryBase<_$GithubBranchModelDocument> {
  const _$_GithubBranchModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubBranchModelDocument Function() call(Ref ref) =>
      () => _$GithubBranchModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubBranchModelCollectionQuery {
  const _$GithubBranchModelCollectionQuery();

  @useResult
  _$_GithubBranchModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubBranchModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/branch",
        adapter: adapter ?? _$GithubBranchModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubBranchModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubBranchModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/branch$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubBranchModelCollectionQuery
    extends ModelQueryBase<_$GithubBranchModelCollection> {
  const _$_GithubBranchModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubBranchModelCollection Function() call(Ref ref) =>
      () => _$GithubBranchModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubBranchModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubBranchModelCollectionQuery(query);

  _$_GithubBranchModelCollectionQuery collectionGroup() =>
      _$_GithubBranchModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubBranchModelCollectionQuery reset() =>
      _$_GithubBranchModelCollectionQuery(modelQuery.reset());

  _$_GithubBranchModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubBranchModelCollectionQuery(modelQuery.remove(type));

  _$_GithubBranchModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubBranchModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_GithubBranchModelCollectionQuery limitTo(int value) =>
      _$_GithubBranchModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubBranchModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubBranchModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubBranchModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_GithubBranchModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ValueModelQuerySelector<GithubCommitModel,
          _$_GithubBranchModelCollectionQuery>
      get commit => ValueModelQuerySelector<GithubCommitModel,
              _$_GithubBranchModelCollectionQuery>(
          key: "commit", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<GithubBranchModel,
          _$_GithubBranchModelCollectionQuery>
      get baseRef => ModelRefModelQuerySelector<GithubBranchModel,
              _$_GithubBranchModelCollectionQuery>(
          key: "baseRef", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubBranchModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubBranchModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubBranchModelMirrorRefPath = _$GithubBranchModelRefPath;
typedef _$GithubBranchModelMirrorInitialCollection
    = _$GithubBranchModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubBranchModelFormQuery {
  const _$GithubBranchModelFormQuery();

  @useResult
  _$_GithubBranchModelFormQuery call(GithubBranchModel value) {
    return _$_GithubBranchModelFormQuery(value);
  }
}

@immutable
class _$_GithubBranchModelFormQuery
    extends FormControllerQueryBase<GithubBranchModel> {
  const _$_GithubBranchModelFormQuery(this.value);

  final GithubBranchModel value;

  @override
  FormController<GithubBranchModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
