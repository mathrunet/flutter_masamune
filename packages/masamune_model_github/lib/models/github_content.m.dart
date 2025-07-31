// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_content.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubContentModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {...map, "children": children?.map((e) => e.toJson()).toList()};
  }
}

enum _$GithubContentModelKeys {
  name,
  path,
  content,
  sha,
  type,
  encoding,
  patch,
  status,
  committer,
  size,
  additionsCount,
  deletionsCount,
  changesCount,
  rawUrl,
  blobUrl,
  htmlUrl,
  gitUrl,
  downloadUrl,
  children,
  fromServer,
}

class _$GithubContentModelDocument extends DocumentBase<GithubContentModel>
    with
        ModelRefMixin<GithubContentModel>,
        ModelRefLoaderMixin<GithubContentModel> {
  _$GithubContentModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubContentModel fromMap(DynamicMap map) =>
      GithubContentModel.fromJson(map);

  @override
  DynamicMap toMap(GithubContentModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<GithubContentModel>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.committer,
          document: (modelQuery) => GithubUserModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(committer: doc),
          adapter: GithubUserModelDocument.defaultModelAdapter,
          accessQuery: GithubUserModelDocument.defaultModelAccessQuery,
          validationQueries: GithubUserModelDocument.defaultValidationQueries,
        ),
      ];
}

typedef _$GithubContentModelMirrorDocument = _$GithubContentModelDocument;

class _$GithubContentModelCollection
    extends CollectionBase<_$GithubContentModelDocument>
    with
        FilterableCollectionMixin<_$GithubContentModelDocument,
            _$_GithubContentModelCollectionQuery> {
  _$GithubContentModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubContentModelDocument create([String? id]) =>
      _$GithubContentModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubContentModelDocument>> filter(
    _$_GithubContentModelCollectionQuery Function(
      _$_GithubContentModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubContentModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubContentModelMirrorCollection = _$GithubContentModelCollection;

@immutable
class _$GithubContentModelRefPath extends ModelRefPath<GithubContentModel> {
  const _$GithubContentModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
    required String branchId,
    required String commitId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _branchId = branchId,
        _commitId = commitId;

  final String _organizationId;

  final String _repositoryId;

  final String _branchId;

  final String _commitId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/branch/$_branchId/commit/$_commitId/content/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubContentModelInitialCollection
    extends ModelInitialCollection<GithubContentModel> {
  const _$GithubContentModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String branchId,
    required String commitId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _branchId = branchId,
        _commitId = commitId;

  final String _organizationId;

  final String _repositoryId;

  final String _branchId;

  final String _commitId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/branch/$_branchId/commit/$_commitId/content";

  @override
  DynamicMap toMap(GithubContentModel value) => value.rawValue;
}

@immutable
class _$GithubContentModelDocumentQuery {
  const _$GithubContentModelDocumentQuery();

  @useResult
  _$_GithubContentModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    required String branchId,
    required String commitId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubContentModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/branch/$branchId/commit/$commitId/content/$_id",
        adapter: adapter ?? _$GithubContentModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubContentModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubContentModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/branch/([^/]+)/commit/([^/]+)/content/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubContentModelDocumentQuery
    extends ModelQueryBase<_$GithubContentModelDocument> {
  const _$_GithubContentModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubContentModelDocument Function() call(Ref ref) =>
      () => _$GithubContentModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubContentModelCollectionQuery {
  const _$GithubContentModelCollectionQuery();

  @useResult
  _$_GithubContentModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    required String branchId,
    required String commitId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubContentModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/branch/$branchId/commit/$commitId/content",
        adapter: adapter ?? _$GithubContentModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubContentModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubContentModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/branch/([^/]+)/commit/([^/]+)/content$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubContentModelCollectionQuery
    extends ModelQueryBase<_$GithubContentModelCollection> {
  const _$_GithubContentModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubContentModelCollection Function() call(Ref ref) =>
      () => _$GithubContentModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubContentModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubContentModelCollectionQuery(query);

  _$_GithubContentModelCollectionQuery collectionGroup() =>
      _$_GithubContentModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubContentModelCollectionQuery reset() =>
      _$_GithubContentModelCollectionQuery(modelQuery.reset());

  _$_GithubContentModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubContentModelCollectionQuery(modelQuery.remove(type));

  _$_GithubContentModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubContentModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_GithubContentModelCollectionQuery limitTo(int value) =>
      _$_GithubContentModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubContentModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubContentModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubContentModelCollectionQuery> get path =>
      StringModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "path",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubContentModelCollectionQuery> get content =>
      StringModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "content",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubContentModelCollectionQuery> get sha =>
      StringModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "sha",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubContentModelCollectionQuery> get type =>
      StringModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "type",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubContentModelCollectionQuery> get encoding =>
      StringModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "encoding",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubContentModelCollectionQuery> get patch =>
      StringModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "patch",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubContentModelCollectionQuery> get status =>
      StringModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "status",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelRefModelQuerySelector<GithubUserModel,
          _$_GithubContentModelCollectionQuery>
      get committer => ModelRefModelQuerySelector<GithubUserModel,
              _$_GithubContentModelCollectionQuery>(
          key: "committer", toQuery: _toQuery, modelQuery: modelQuery);

  NumModelQuerySelector<_$_GithubContentModelCollectionQuery> get size =>
      NumModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "size",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubContentModelCollectionQuery>
      get additionsCount =>
          NumModelQuerySelector<_$_GithubContentModelCollectionQuery>(
            key: "additionsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubContentModelCollectionQuery>
      get deletionsCount =>
          NumModelQuerySelector<_$_GithubContentModelCollectionQuery>(
            key: "deletionsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubContentModelCollectionQuery>
      get changesCount =>
          NumModelQuerySelector<_$_GithubContentModelCollectionQuery>(
            key: "changesCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery> get rawUrl =>
      ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "rawUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery>
      get blobUrl =>
          ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery>(
            key: "blobUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery>
      get htmlUrl =>
          ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery>(
            key: "htmlUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery> get gitUrl =>
      ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery>(
        key: "gitUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery>
      get downloadUrl =>
          ModelUriModelQuerySelector<_$_GithubContentModelCollectionQuery>(
            key: "downloadUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ListModelQuerySelector<GithubContentModel,
          _$_GithubContentModelCollectionQuery>
      get children => ListModelQuerySelector<GithubContentModel,
              _$_GithubContentModelCollectionQuery>(
          key: "children", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubContentModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubContentModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubContentModelMirrorRefPath = _$GithubContentModelRefPath;
typedef _$GithubContentModelMirrorInitialCollection
    = _$GithubContentModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubContentModelFormQuery {
  const _$GithubContentModelFormQuery();

  @useResult
  _$_GithubContentModelFormQuery call(GithubContentModel value) {
    return _$_GithubContentModelFormQuery(value);
  }
}

@immutable
class _$_GithubContentModelFormQuery
    extends FormControllerQueryBase<GithubContentModel> {
  const _$_GithubContentModelFormQuery(this.value);

  final GithubContentModel value;

  @override
  FormController<GithubContentModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
