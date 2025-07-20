// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable

part of 'github_repository.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubRepositoryModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "license": license?.toJson(),
      "permissions": permissions?.toJson(),
    };
  }
}

enum _$GithubRepositoryModelKeys {
  id,
  name,
  fullName,
  owner,
  organization,
  language,
  license,
  permissions,
  isPrivate,
  isFork,
  isTemplate,
  description,
  masterBranch,
  mergeCommitMessage,
  mergeCommitTitle,
  squashMergeCommitMessage,
  squashMergeCommitTitle,
  nodeId,
  tempCloneToken,
  visibility,
  topics,
  archived,
  disabled,
  hasIssues,
  hasWiki,
  hasDownloads,
  hasPages,
  hasDiscussions,
  hasProjects,
  allowAutoMerge,
  allowForking,
  allowMergeCommit,
  allowRebaseMerge,
  allowSquashMerge,
  allowUpdateBranch,
  anonymousAccessEnabled,
  deleteBranchOnMerge,
  webCommitSignoffRequired,
  size,
  stargazersCount,
  watchersCount,
  forksCount,
  openIssuesCount,
  subscribersCount,
  networkCount,
  htmlUrl,
  cloneUrl,
  sshUrl,
  svnUrl,
  gitUrl,
  homepageUrl,
  archiveUrl,
  assigneesUrl,
  blobsUrl,
  branchesUrl,
  collaboratorsUrl,
  commentsUrl,
  commitsUrl,
  compareUrl,
  contentsUrl,
  contributorsUrl,
  deploymentsUrl,
  downloadsUrl,
  eventsUrl,
  forksUrl,
  gitCommitsUrl,
  gitRefsUrl,
  gitTagsUrl,
  hooksUrl,
  issueCommentUrl,
  issueEventsUrl,
  issuesUrl,
  keysUrl,
  labelsUrl,
  languagesUrl,
  mergesUrl,
  milestonesUrl,
  mirrorUrl,
  notificationsUrl,
  pullsUrl,
  releasesUrl,
  stargazersUrl,
  statusesUrl,
  subscribersUrl,
  subscriptionUrl,
  tagsUrl,
  teamsUrl,
  treesUrl,
  templateRepository,
  starredAt,
  pushedAt,
  createdAt,
  updatedAt,
  fromServer,
}

class _$GithubRepositoryModelDocument
    extends DocumentBase<GithubRepositoryModel>
    with
        ModelRefMixin<GithubRepositoryModel>,
        ModelRefLoaderMixin<GithubRepositoryModel> {
  _$GithubRepositoryModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  GithubRepositoryModel fromMap(DynamicMap map) =>
      GithubRepositoryModel.fromJson(map);

  @override
  DynamicMap toMap(GithubRepositoryModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<GithubRepositoryModel>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.owner,
          document: (modelQuery) => GithubUserModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(owner: doc),
          adapter: GithubUserModelDocument.defaultModelAdapter,
          accessQuery: GithubUserModelDocument.defaultModelAccessQuery,
          validationQueries: GithubUserModelDocument.defaultValidationQueries,
        ),
        ModelRefBuilder(
          modelRef: (value) => value.organization,
          document: (modelQuery) => GithubOrganizationModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(organization: doc),
          adapter: GithubOrganizationModelDocument.defaultModelAdapter,
          accessQuery: GithubOrganizationModelDocument.defaultModelAccessQuery,
          validationQueries:
              GithubOrganizationModelDocument.defaultValidationQueries,
        ),
        ModelRefBuilder(
          modelRef: (value) => value.templateRepository,
          document: (modelQuery) => GithubRepositoryModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(templateRepository: doc),
          adapter: GithubRepositoryModelDocument.defaultModelAdapter,
          accessQuery: GithubRepositoryModelDocument.defaultModelAccessQuery,
          validationQueries:
              GithubRepositoryModelDocument.defaultValidationQueries,
        ),
      ];
}

typedef _$GithubRepositoryModelMirrorDocument = _$GithubRepositoryModelDocument;

class _$GithubRepositoryModelCollection
    extends CollectionBase<_$GithubRepositoryModelDocument>
    with
        FilterableCollectionMixin<_$GithubRepositoryModelDocument,
            _$_GithubRepositoryModelCollectionQuery> {
  _$GithubRepositoryModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$GithubRepositoryModelDocument create([String? id]) =>
      _$GithubRepositoryModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubRepositoryModelDocument>> filter(
    _$_GithubRepositoryModelCollectionQuery Function(
      _$_GithubRepositoryModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubRepositoryModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubRepositoryModelMirrorCollection
    = _$GithubRepositoryModelCollection;

@immutable
class _$GithubRepositoryModelRefPath
    extends ModelRefPath<GithubRepositoryModel> {
  const _$GithubRepositoryModelRefPath(
    super.uid, {
    required String organizationId,
  }) : _organizationId = organizationId;

  final String _organizationId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubRepositoryModelInitialCollection
    extends ModelInitialCollection<GithubRepositoryModel> {
  const _$GithubRepositoryModelInitialCollection(
    super.value, {
    required String organizationId,
  }) : _organizationId = organizationId;

  final String _organizationId;

  @override
  String get path => "organization/$_organizationId/repository";

  @override
  DynamicMap toMap(GithubRepositoryModel value) => value.rawValue;
}

@immutable
class _$GithubRepositoryModelDocumentQuery {
  const _$GithubRepositoryModelDocumentQuery();

  @useResult
  _$_GithubRepositoryModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubRepositoryModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$_id",
        adapter: adapter ?? _$GithubRepositoryModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubRepositoryModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubRepositoryModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubRepositoryModelDocumentQuery
    extends ModelQueryBase<_$GithubRepositoryModelDocument> {
  const _$_GithubRepositoryModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubRepositoryModelDocument Function() call(Ref ref) =>
      () => _$GithubRepositoryModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubRepositoryModelCollectionQuery {
  const _$GithubRepositoryModelCollectionQuery();

  @useResult
  _$_GithubRepositoryModelCollectionQuery call({
    required String organizationId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubRepositoryModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository",
        adapter:
            adapter ?? _$GithubRepositoryModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubRepositoryModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubRepositoryModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubRepositoryModelCollectionQuery
    extends ModelQueryBase<_$GithubRepositoryModelCollection> {
  const _$_GithubRepositoryModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubRepositoryModelCollection Function() call(Ref ref) =>
      () => _$GithubRepositoryModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubRepositoryModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubRepositoryModelCollectionQuery(query);

  _$_GithubRepositoryModelCollectionQuery collectionGroup() =>
      _$_GithubRepositoryModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubRepositoryModelCollectionQuery reset() =>
      _$_GithubRepositoryModelCollectionQuery(modelQuery.reset());

  _$_GithubRepositoryModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubRepositoryModelCollectionQuery(modelQuery.remove(type));

  _$_GithubRepositoryModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubRepositoryModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubRepositoryModelCollectionQuery limitTo(int value) =>
      _$_GithubRepositoryModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get fullName =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "fullName",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelRefModelQuerySelector<GithubUserModel,
          _$_GithubRepositoryModelCollectionQuery>
      get owner => ModelRefModelQuerySelector<GithubUserModel,
              _$_GithubRepositoryModelCollectionQuery>(
          key: "owner", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<GithubOrganizationModel,
          _$_GithubRepositoryModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<GithubOrganizationModel,
              _$_GithubRepositoryModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  ModelLocaleModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get language => ModelLocaleModelQuerySelector<
              _$_GithubRepositoryModelCollectionQuery>(
            key: "language",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ValueModelQuerySelector<GithubLicenseValue,
          _$_GithubRepositoryModelCollectionQuery>
      get license => ValueModelQuerySelector<GithubLicenseValue,
              _$_GithubRepositoryModelCollectionQuery>(
          key: "license", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubRepositoryPermissionValue,
          _$_GithubRepositoryModelCollectionQuery>
      get permissions => ValueModelQuerySelector<
              GithubRepositoryPermissionValue,
              _$_GithubRepositoryModelCollectionQuery>(
          key: "permissions", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get isPrivate =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "isPrivate",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get isFork =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "isFork",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get isTemplate =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "isTemplate",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get description =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "description",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get masterBranch =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "masterBranch",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get mergeCommitMessage =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "mergeCommitMessage",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get mergeCommitTitle =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "mergeCommitTitle",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get squashMergeCommitMessage =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "squashMergeCommitMessage",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get squashMergeCommitTitle =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "squashMergeCommitTitle",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get nodeId =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "nodeId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get tempCloneToken =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "tempCloneToken",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get visibility =>
          StringModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "visibility",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ListModelQuerySelector<String, _$_GithubRepositoryModelCollectionQuery>
      get topics => ListModelQuerySelector<String,
              _$_GithubRepositoryModelCollectionQuery>(
            key: "topics",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get archived =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "archived",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get disabled =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "disabled",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get hasIssues =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "hasIssues",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get hasWiki =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "hasWiki",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get hasDownloads =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "hasDownloads",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get hasPages =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "hasPages",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get hasDiscussions =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "hasDiscussions",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get hasProjects =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "hasProjects",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get allowAutoMerge =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "allowAutoMerge",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get allowForking =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "allowForking",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get allowMergeCommit =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "allowMergeCommit",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get allowRebaseMerge =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "allowRebaseMerge",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get allowSquashMerge =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "allowSquashMerge",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get allowUpdateBranch =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "allowUpdateBranch",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get anonymousAccessEnabled =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "anonymousAccessEnabled",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get deleteBranchOnMerge =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "deleteBranchOnMerge",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get webCommitSignoffRequired =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "webCommitSignoffRequired",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery> get size =>
      NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
        key: "size",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get stargazersCount =>
          NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "stargazersCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get watchersCount =>
          NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "watchersCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get forksCount =>
          NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "forksCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get openIssuesCount =>
          NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "openIssuesCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get subscribersCount =>
          NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "subscribersCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get networkCount =>
          NumModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "networkCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get htmlUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "htmlUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get cloneUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "cloneUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get sshUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "sshUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get svnUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "svnUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get gitUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "gitUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get homepageUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "homepageUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get archiveUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "archiveUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get assigneesUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "assigneesUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get blobsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "blobsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get branchesUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "branchesUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get collaboratorsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "collaboratorsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get commentsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "commentsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get commitsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "commitsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get compareUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "compareUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get contentsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "contentsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get contributorsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "contributorsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get deploymentsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "deploymentsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get downloadsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "downloadsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get eventsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "eventsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get forksUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "forksUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get gitCommitsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "gitCommitsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get gitRefsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "gitRefsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get gitTagsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "gitTagsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get hooksUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "hooksUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get issueCommentUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "issueCommentUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get issueEventsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "issueEventsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get issuesUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "issuesUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get keysUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "keysUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get labelsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "labelsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get languagesUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "languagesUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get mergesUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "mergesUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get milestonesUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "milestonesUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get mirrorUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "mirrorUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get notificationsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "notificationsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get pullsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "pullsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get releasesUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "releasesUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get stargazersUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "stargazersUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get statusesUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "statusesUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get subscribersUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "subscribersUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get subscriptionUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "subscriptionUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get tagsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "tagsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get teamsUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "teamsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get treesUrl =>
          ModelUriModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "treesUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelRefModelQuerySelector<GithubRepositoryModel,
          _$_GithubRepositoryModelCollectionQuery>
      get templateRepository => ModelRefModelQuerySelector<
              GithubRepositoryModel, _$_GithubRepositoryModelCollectionQuery>(
          key: "templateRepository", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get starredAt => ModelTimestampModelQuerySelector<
              _$_GithubRepositoryModelCollectionQuery>(
            key: "starredAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get pushedAt => ModelTimestampModelQuerySelector<
              _$_GithubRepositoryModelCollectionQuery>(
            key: "pushedAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubRepositoryModelCollectionQuery>(
            key: "createdAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get updatedAt => ModelTimestampModelQuerySelector<
              _$_GithubRepositoryModelCollectionQuery>(
            key: "updatedAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubRepositoryModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubRepositoryModelMirrorRefPath = _$GithubRepositoryModelRefPath;
typedef _$GithubRepositoryModelMirrorInitialCollection
    = _$GithubRepositoryModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubRepositoryModelFormQuery {
  const _$GithubRepositoryModelFormQuery();

  @useResult
  _$_GithubRepositoryModelFormQuery call(GithubRepositoryModel value) {
    return _$_GithubRepositoryModelFormQuery(value);
  }
}

@immutable
class _$_GithubRepositoryModelFormQuery
    extends FormControllerQueryBase<GithubRepositoryModel> {
  const _$_GithubRepositoryModelFormQuery(this.value);

  final GithubRepositoryModel value;

  @override
  FormController<GithubRepositoryModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
