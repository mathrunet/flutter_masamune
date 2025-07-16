// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'github_pull_request.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubPullRequestModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "labels": labels.map((e) => e.toJson()).toList(),
      "head": head?.toJson(),
      "base": base?.toJson(),
      "milestone": milestone?.toJson(),
    };
  }
}

enum _$GithubPullRequestModelKeys {
  id,
  nodeId,
  number,
  state,
  title,
  body,
  mergeCommitSha,
  mergeableState,
  authorAssociation,
  draft,
  merged,
  mergeable,
  rebaseable,
  maintainerCanModify,
  commentsCount,
  commitsCount,
  additionsCount,
  deletionsCount,
  changedFilesCount,
  reviewCommentCount,
  repository,
  user,
  mergedBy,
  requestedReviewers,
  labels,
  head,
  base,
  milestone,
  htmlUrl,
  diffUrl,
  patchUrl,
  closedAt,
  mergedAt,
  createdAt,
  updatedAt,
  fromServer,
}

class _$GithubPullRequestModelDocument
    extends DocumentBase<GithubPullRequestModel>
    with
        ModelRefMixin<GithubPullRequestModel>,
        ModelRefLoaderMixin<GithubPullRequestModel> {
  _$GithubPullRequestModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  GithubPullRequestModel fromMap(DynamicMap map) =>
      GithubPullRequestModel.fromJson(map);

  @override
  DynamicMap toMap(GithubPullRequestModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<GithubPullRequestModel>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.repository,
          document: (modelQuery) => GithubRepositoryModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(repository: doc),
          adapter: GithubRepositoryModelDocument.defaultModelAdapter,
          accessQuery: GithubRepositoryModelDocument.defaultModelAccessQuery,
          validationQueries:
              GithubRepositoryModelDocument.defaultValidationQueries,
        ),
        ModelRefBuilder(
          modelRef: (value) => value.user,
          document: (modelQuery) => GithubUserModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(user: doc),
          adapter: GithubUserModelDocument.defaultModelAdapter,
          accessQuery: GithubUserModelDocument.defaultModelAccessQuery,
          validationQueries: GithubUserModelDocument.defaultValidationQueries,
        ),
        ModelRefBuilder(
          modelRef: (value) => value.mergedBy,
          document: (modelQuery) => GithubUserModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(mergedBy: doc),
          adapter: GithubUserModelDocument.defaultModelAdapter,
          accessQuery: GithubUserModelDocument.defaultModelAccessQuery,
          validationQueries: GithubUserModelDocument.defaultValidationQueries,
        ),
        ModelRefListBuilder(
          modelRef: (value) => value.requestedReviewers,
          document: (modelQuery) => GithubUserModelDocument(modelQuery),
          value: (value, docs) => value.copyWith(requestedReviewers: docs),
          adapter: GithubUserModelDocument.defaultModelAdapter,
          accessQuery: GithubUserModelDocument.defaultModelAccessQuery,
          validationQueries: GithubUserModelDocument.defaultValidationQueries,
        ),
      ];
}

typedef _$GithubPullRequestModelMirrorDocument
    = _$GithubPullRequestModelDocument;

class _$GithubPullRequestModelCollection
    extends CollectionBase<_$GithubPullRequestModelDocument>
    with
        FilterableCollectionMixin<_$GithubPullRequestModelDocument,
            _$_GithubPullRequestModelCollectionQuery> {
  _$GithubPullRequestModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$GithubPullRequestModelDocument create([String? id]) =>
      _$GithubPullRequestModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubPullRequestModelDocument>> filter(
    _$_GithubPullRequestModelCollectionQuery Function(
      _$_GithubPullRequestModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubPullRequestModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubPullRequestModelMirrorCollection
    = _$GithubPullRequestModelCollection;

@immutable
class _$GithubPullRequestModelRefPath
    extends ModelRefPath<GithubPullRequestModel> {
  const _$GithubPullRequestModelRefPath(
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
      "organization/$_organizationId/repository/$_repositoryId/pull_request/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubPullRequestModelInitialCollection
    extends ModelInitialCollection<GithubPullRequestModel> {
  const _$GithubPullRequestModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId;

  final String _organizationId;

  final String _repositoryId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/pull_request";

  @override
  DynamicMap toMap(GithubPullRequestModel value) => value.rawValue;
}

@immutable
class _$GithubPullRequestModelDocumentQuery {
  const _$GithubPullRequestModelDocumentQuery();

  @useResult
  _$_GithubPullRequestModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubPullRequestModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/pull_request/$_id",
        adapter:
            adapter ?? _$GithubPullRequestModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubPullRequestModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubPullRequestModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/pull_request/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubPullRequestModelDocumentQuery
    extends ModelQueryBase<_$GithubPullRequestModelDocument> {
  const _$_GithubPullRequestModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubPullRequestModelDocument Function() call(Ref ref) =>
      () => _$GithubPullRequestModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubPullRequestModelCollectionQuery {
  const _$GithubPullRequestModelCollectionQuery();

  @useResult
  _$_GithubPullRequestModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubPullRequestModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/pull_request",
        adapter:
            adapter ?? _$GithubPullRequestModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubPullRequestModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubPullRequestModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/pull_request$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubPullRequestModelCollectionQuery
    extends ModelQueryBase<_$GithubPullRequestModelCollection> {
  const _$_GithubPullRequestModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubPullRequestModelCollection Function() call(Ref ref) =>
      () => _$GithubPullRequestModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubPullRequestModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubPullRequestModelCollectionQuery(query);

  _$_GithubPullRequestModelCollectionQuery collectionGroup() =>
      _$_GithubPullRequestModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubPullRequestModelCollectionQuery reset() =>
      _$_GithubPullRequestModelCollectionQuery(modelQuery.reset());

  _$_GithubPullRequestModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubPullRequestModelCollectionQuery(modelQuery.remove(type));

  _$_GithubPullRequestModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubPullRequestModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubPullRequestModelCollectionQuery limitTo(int value) =>
      _$_GithubPullRequestModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get nodeId =>
          StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "nodeId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery> get number =>
      NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
        key: "number",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get state =>
          StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "state",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get title =>
          StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "title",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery> get body =>
      StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
        key: "body",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get mergeCommitSha =>
          StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "mergeCommitSha",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get mergeableState =>
          StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "mergeableState",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get authorAssociation =>
          StringModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "authorAssociation",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get draft =>
          BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "draft",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get merged =>
          BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "merged",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get mergeable =>
          BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "mergeable",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get rebaseable =>
          BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "rebaseable",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get maintainerCanModify =>
          BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "maintainerCanModify",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get commentsCount =>
          NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "commentsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get commitsCount =>
          NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "commitsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get additionsCount =>
          NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "additionsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get deletionsCount =>
          NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "deletionsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get changedFilesCount =>
          NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "changedFilesCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get reviewCommentCount =>
          NumModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "reviewCommentCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelRefModelQuerySelector<GithubRepositoryModel,
          _$_GithubPullRequestModelCollectionQuery>
      get repository => ModelRefModelQuerySelector<GithubRepositoryModel,
              _$_GithubPullRequestModelCollectionQuery>(
          key: "repository", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<GithubUserModel,
          _$_GithubPullRequestModelCollectionQuery>
      get user => ModelRefModelQuerySelector<GithubUserModel,
              _$_GithubPullRequestModelCollectionQuery>(
          key: "user", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<GithubUserModel,
          _$_GithubPullRequestModelCollectionQuery>
      get mergedBy => ModelRefModelQuerySelector<GithubUserModel,
              _$_GithubPullRequestModelCollectionQuery>(
          key: "mergedBy", toQuery: _toQuery, modelQuery: modelQuery);

  ListModelQuerySelector<GithubUserModelRef,
          _$_GithubPullRequestModelCollectionQuery>
      get requestedReviewers => ListModelQuerySelector<GithubUserModelRef,
              _$_GithubPullRequestModelCollectionQuery>(
          key: "requestedReviewers", toQuery: _toQuery, modelQuery: modelQuery);

  ListModelQuerySelector<GithubLabelValue,
          _$_GithubPullRequestModelCollectionQuery>
      get labels => ListModelQuerySelector<GithubLabelValue,
              _$_GithubPullRequestModelCollectionQuery>(
          key: "labels", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubPullRequestHeadValue,
          _$_GithubPullRequestModelCollectionQuery>
      get head => ValueModelQuerySelector<GithubPullRequestHeadValue,
              _$_GithubPullRequestModelCollectionQuery>(
          key: "head", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubPullRequestHeadValue,
          _$_GithubPullRequestModelCollectionQuery>
      get base => ValueModelQuerySelector<GithubPullRequestHeadValue,
              _$_GithubPullRequestModelCollectionQuery>(
          key: "base", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubMilestoneValue,
          _$_GithubPullRequestModelCollectionQuery>
      get milestone => ValueModelQuerySelector<GithubMilestoneValue,
              _$_GithubPullRequestModelCollectionQuery>(
          key: "milestone", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get htmlUrl =>
          ModelUriModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "htmlUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get diffUrl =>
          ModelUriModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "diffUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get patchUrl =>
          ModelUriModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "patchUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get closedAt => ModelTimestampModelQuerySelector<
              _$_GithubPullRequestModelCollectionQuery>(
          key: "closedAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get mergedAt => ModelTimestampModelQuerySelector<
              _$_GithubPullRequestModelCollectionQuery>(
          key: "mergedAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubPullRequestModelCollectionQuery>(
          key: "createdAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get updatedAt => ModelTimestampModelQuerySelector<
              _$_GithubPullRequestModelCollectionQuery>(
          key: "updatedAt", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubPullRequestModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubPullRequestModelMirrorRefPath = _$GithubPullRequestModelRefPath;
typedef _$GithubPullRequestModelMirrorInitialCollection
    = _$GithubPullRequestModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubPullRequestModelFormQuery {
  const _$GithubPullRequestModelFormQuery();

  @useResult
  _$_GithubPullRequestModelFormQuery call(GithubPullRequestModel value) {
    return _$_GithubPullRequestModelFormQuery(value);
  }
}

@immutable
class _$_GithubPullRequestModelFormQuery
    extends FormControllerQueryBase<GithubPullRequestModel> {
  const _$_GithubPullRequestModelFormQuery(this.value);

  final GithubPullRequestModel value;

  @override
  FormController<GithubPullRequestModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
