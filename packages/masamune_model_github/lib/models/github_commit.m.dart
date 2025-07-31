// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_commit.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubCommitModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "parents": parents.map((e) => e.toJson()).toList(),
      "contents": contents.map((e) => e.toJson()).toList(),
    };
  }
}

enum _$GithubCommitModelKeys {
  sha,
  message,
  commentCount,
  additionsCount,
  deletionsCount,
  totalCount,
  url,
  htmlUrl,
  commentsUrl,
  author,
  committer,
  authorDate,
  committerDate,
  parents,
  contents,
  fromServer,
}

class _$GithubCommitModelDocument extends DocumentBase<GithubCommitModel>
    with
        ModelRefMixin<GithubCommitModel>,
        ModelRefLoaderMixin<GithubCommitModel> {
  _$GithubCommitModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubCommitModel fromMap(DynamicMap map) => GithubCommitModel.fromJson(map);

  @override
  DynamicMap toMap(GithubCommitModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<GithubCommitModel>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.author,
          document: (modelQuery) => GithubUserModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(author: doc),
          adapter: GithubUserModelDocument.defaultModelAdapter,
          accessQuery: GithubUserModelDocument.defaultModelAccessQuery,
          validationQueries: GithubUserModelDocument.defaultValidationQueries,
        ),
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

typedef _$GithubCommitModelMirrorDocument = _$GithubCommitModelDocument;

class _$GithubCommitModelCollection
    extends CollectionBase<_$GithubCommitModelDocument>
    with
        FilterableCollectionMixin<_$GithubCommitModelDocument,
            _$_GithubCommitModelCollectionQuery> {
  _$GithubCommitModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubCommitModelDocument create([String? id]) =>
      _$GithubCommitModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubCommitModelDocument>> filter(
    _$_GithubCommitModelCollectionQuery Function(
      _$_GithubCommitModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubCommitModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubCommitModelMirrorCollection = _$GithubCommitModelCollection;

@immutable
class _$GithubCommitModelRefPath extends ModelRefPath<GithubCommitModel> {
  const _$GithubCommitModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
    required String branchId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _branchId = branchId;

  final String _organizationId;

  final String _repositoryId;

  final String _branchId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/branch/$_branchId/commit/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubCommitModelInitialCollection
    extends ModelInitialCollection<GithubCommitModel> {
  const _$GithubCommitModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String branchId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _branchId = branchId;

  final String _organizationId;

  final String _repositoryId;

  final String _branchId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/branch/$_branchId/commit";

  @override
  DynamicMap toMap(GithubCommitModel value) => value.rawValue;
}

@immutable
class _$GithubCommitModelDocumentQuery {
  const _$GithubCommitModelDocumentQuery();

  @useResult
  _$_GithubCommitModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    required String branchId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubCommitModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/branch/$branchId/commit/$_id",
        adapter: adapter ?? _$GithubCommitModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubCommitModelDocument.defaultModelAccessQuery,
        validationQueries: _$GithubCommitModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/branch/([^/]+)/commit/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubCommitModelDocumentQuery
    extends ModelQueryBase<_$GithubCommitModelDocument> {
  const _$_GithubCommitModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubCommitModelDocument Function() call(Ref ref) =>
      () => _$GithubCommitModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubCommitModelCollectionQuery {
  const _$GithubCommitModelCollectionQuery();

  @useResult
  _$_GithubCommitModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    required String branchId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubCommitModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/branch/$branchId/commit",
        adapter: adapter ?? _$GithubCommitModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubCommitModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubCommitModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/branch/([^/]+)/commit$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubCommitModelCollectionQuery
    extends ModelQueryBase<_$GithubCommitModelCollection> {
  const _$_GithubCommitModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubCommitModelCollection Function() call(Ref ref) =>
      () => _$GithubCommitModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubCommitModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubCommitModelCollectionQuery(query);

  _$_GithubCommitModelCollectionQuery collectionGroup() =>
      _$_GithubCommitModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubCommitModelCollectionQuery reset() =>
      _$_GithubCommitModelCollectionQuery(modelQuery.reset());

  _$_GithubCommitModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubCommitModelCollectionQuery(modelQuery.remove(type));

  _$_GithubCommitModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubCommitModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_GithubCommitModelCollectionQuery limitTo(int value) =>
      _$_GithubCommitModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubCommitModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubCommitModelCollectionQuery> get sha =>
      StringModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
        key: "sha",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubCommitModelCollectionQuery> get message =>
      StringModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
        key: "message",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubCommitModelCollectionQuery> get commentCount =>
      NumModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
        key: "commentCount",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubCommitModelCollectionQuery>
      get additionsCount =>
          NumModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
            key: "additionsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubCommitModelCollectionQuery>
      get deletionsCount =>
          NumModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
            key: "deletionsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubCommitModelCollectionQuery> get totalCount =>
      NumModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
        key: "totalCount",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubCommitModelCollectionQuery> get url =>
      ModelUriModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
        key: "url",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubCommitModelCollectionQuery> get htmlUrl =>
      ModelUriModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
        key: "htmlUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubCommitModelCollectionQuery>
      get commentsUrl =>
          ModelUriModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
            key: "commentsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelRefModelQuerySelector<GithubUserModel,
          _$_GithubCommitModelCollectionQuery>
      get author => ModelRefModelQuerySelector<GithubUserModel,
              _$_GithubCommitModelCollectionQuery>(
          key: "author", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<GithubUserModel,
          _$_GithubCommitModelCollectionQuery>
      get committer => ModelRefModelQuerySelector<GithubUserModel,
              _$_GithubCommitModelCollectionQuery>(
          key: "committer", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubCommitModelCollectionQuery>
      get authorDate =>
          ModelTimestampModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
            key: "authorDate",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubCommitModelCollectionQuery>
      get committerDate =>
          ModelTimestampModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
            key: "committerDate",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ListModelQuerySelector<GithubCommitModel, _$_GithubCommitModelCollectionQuery>
      get parents => ListModelQuerySelector<GithubCommitModel,
              _$_GithubCommitModelCollectionQuery>(
          key: "parents", toQuery: _toQuery, modelQuery: modelQuery);

  ListModelQuerySelector<GithubContentModel,
          _$_GithubCommitModelCollectionQuery>
      get contents => ListModelQuerySelector<GithubContentModel,
              _$_GithubCommitModelCollectionQuery>(
          key: "contents", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubCommitModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubCommitModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubCommitModelMirrorRefPath = _$GithubCommitModelRefPath;
typedef _$GithubCommitModelMirrorInitialCollection
    = _$GithubCommitModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubCommitModelFormQuery {
  const _$GithubCommitModelFormQuery();

  @useResult
  _$_GithubCommitModelFormQuery call(GithubCommitModel value) {
    return _$_GithubCommitModelFormQuery(value);
  }
}

@immutable
class _$_GithubCommitModelFormQuery
    extends FormControllerQueryBase<GithubCommitModel> {
  const _$_GithubCommitModelFormQuery(this.value);

  final GithubCommitModel value;

  @override
  FormController<GithubCommitModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
