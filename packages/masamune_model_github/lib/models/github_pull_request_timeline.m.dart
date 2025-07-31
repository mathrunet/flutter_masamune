// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_pull_request_timeline.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubPullRequestTimelineModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "user": user?.toJson(),
      "from": from?.toJson(),
      "to": to?.toJson(),
      "project": project?.toJson(),
      "milestone": milestone?.toJson(),
      "reaction": reaction?.toJson(),
      "issue": issue?.toJson(),
      "pullRequest": pullRequest?.toJson(),
      "label": label?.toJson(),
    };
  }
}

enum _$GithubPullRequestTimelineModelKeys {
  id,
  body,
  previousBody,
  diffHunk,
  path,
  position,
  originalPosition,
  commitId,
  originalCommitId,
  sha,
  state,
  reviewId,
  event,
  user,
  from,
  to,
  project,
  milestone,
  reaction,
  issue,
  pullRequest,
  label,
  url,
  pullRequestUrl,
  commitUrl,
  links,
  issueUrl,
  createdAt,
  updatedAt,
  fromServer,
}

class _$GithubPullRequestTimelineModelDocument
    extends DocumentBase<GithubPullRequestTimelineModel>
    with ModelRefMixin<GithubPullRequestTimelineModel> {
  _$GithubPullRequestTimelineModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubPullRequestTimelineModel fromMap(DynamicMap map) =>
      GithubPullRequestTimelineModel.fromJson(map);

  @override
  DynamicMap toMap(GithubPullRequestTimelineModel value) => value.rawValue;
}

typedef _$GithubPullRequestTimelineModelMirrorDocument
    = _$GithubPullRequestTimelineModelDocument;

class _$GithubPullRequestTimelineModelCollection
    extends CollectionBase<_$GithubPullRequestTimelineModelDocument>
    with
        FilterableCollectionMixin<_$GithubPullRequestTimelineModelDocument,
            _$_GithubPullRequestTimelineModelCollectionQuery> {
  _$GithubPullRequestTimelineModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubPullRequestTimelineModelDocument create([String? id]) =>
      _$GithubPullRequestTimelineModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubPullRequestTimelineModelDocument>> filter(
    _$_GithubPullRequestTimelineModelCollectionQuery Function(
      _$_GithubPullRequestTimelineModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubPullRequestTimelineModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubPullRequestTimelineModelMirrorCollection
    = _$GithubPullRequestTimelineModelCollection;

@immutable
class _$GithubPullRequestTimelineModelRefPath
    extends ModelRefPath<GithubPullRequestTimelineModel> {
  const _$GithubPullRequestTimelineModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
    required String pullRequestId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _pullRequestId = pullRequestId;

  final String _organizationId;

  final String _repositoryId;

  final String _pullRequestId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/pull_request/$_pullRequestId/timeline/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubPullRequestTimelineModelInitialCollection
    extends ModelInitialCollection<GithubPullRequestTimelineModel> {
  const _$GithubPullRequestTimelineModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String pullRequestId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _pullRequestId = pullRequestId;

  final String _organizationId;

  final String _repositoryId;

  final String _pullRequestId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/pull_request/$_pullRequestId/timeline";

  @override
  DynamicMap toMap(GithubPullRequestTimelineModel value) => value.rawValue;
}

@immutable
class _$GithubPullRequestTimelineModelDocumentQuery {
  const _$GithubPullRequestTimelineModelDocumentQuery();

  @useResult
  _$_GithubPullRequestTimelineModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    required String pullRequestId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubPullRequestTimelineModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/pull_request/$pullRequestId/timeline/$_id",
        adapter: adapter ??
            _$GithubPullRequestTimelineModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubPullRequestTimelineModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubPullRequestTimelineModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/pull_request/([^/]+)/timeline/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubPullRequestTimelineModelDocumentQuery
    extends ModelQueryBase<_$GithubPullRequestTimelineModelDocument> {
  const _$_GithubPullRequestTimelineModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubPullRequestTimelineModelDocument Function() call(Ref ref) =>
      () => _$GithubPullRequestTimelineModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubPullRequestTimelineModelCollectionQuery {
  const _$GithubPullRequestTimelineModelCollectionQuery();

  @useResult
  _$_GithubPullRequestTimelineModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    required String pullRequestId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubPullRequestTimelineModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/pull_request/$pullRequestId/timeline",
        adapter: adapter ??
            _$GithubPullRequestTimelineModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubPullRequestTimelineModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubPullRequestTimelineModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/pull_request/([^/]+)/timeline$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubPullRequestTimelineModelCollectionQuery
    extends ModelQueryBase<_$GithubPullRequestTimelineModelCollection> {
  const _$_GithubPullRequestTimelineModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubPullRequestTimelineModelCollection Function() call(Ref ref) =>
      () => _$GithubPullRequestTimelineModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubPullRequestTimelineModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubPullRequestTimelineModelCollectionQuery(query);

  _$_GithubPullRequestTimelineModelCollectionQuery collectionGroup() =>
      _$_GithubPullRequestTimelineModelCollectionQuery(
        modelQuery.collectionGroup(),
      );

  _$_GithubPullRequestTimelineModelCollectionQuery reset() =>
      _$_GithubPullRequestTimelineModelCollectionQuery(modelQuery.reset());

  _$_GithubPullRequestTimelineModelCollectionQuery remove(
    ModelQueryFilterType type,
  ) =>
      _$_GithubPullRequestTimelineModelCollectionQuery(modelQuery.remove(type));

  _$_GithubPullRequestTimelineModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubPullRequestTimelineModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubPullRequestTimelineModelCollectionQuery limitTo(int value) =>
      _$_GithubPullRequestTimelineModelCollectionQuery(
        modelQuery.limitTo(value),
      );

  StringModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get uid => StringModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "@uid", toQuery: _toQuery, modelQuery: modelQuery);

  NumModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get id => NumModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
            key: "id",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get body => StringModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "body", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get previousBody => StringModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "previousBody", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get diffHunk => StringModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "diffHunk", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get path => StringModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "path", toQuery: _toQuery, modelQuery: modelQuery);

  NumModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get position => NumModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
            key: "position",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get originalPosition => NumModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
            key: "originalPosition",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get commitId => StringModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "commitId", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get originalCommitId => StringModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "originalCommitId", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get sha => StringModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "sha", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get state => StringModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "state", toQuery: _toQuery, modelQuery: modelQuery);

  NumModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get reviewId => NumModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
            key: "reviewId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ValueModelQuerySelector<GithubTimelineEvent,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get event => ValueModelQuerySelector<GithubTimelineEvent,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "event", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get user => ValueModelQuerySelector<GithubUserModel,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "user", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get from => ValueModelQuerySelector<GithubUserModel,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "from", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get to => ValueModelQuerySelector<GithubUserModel,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "to", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubProjectModel,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get project => ValueModelQuerySelector<GithubProjectModel,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "project", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubMilestoneValue,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get milestone => ValueModelQuerySelector<GithubMilestoneValue,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "milestone", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubReactionValue,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get reaction => ValueModelQuerySelector<GithubReactionValue,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "reaction", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubIssueModel,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get issue => ValueModelQuerySelector<GithubIssueModel,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "issue", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubPullRequestModel,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get pullRequest => ValueModelQuerySelector<GithubPullRequestModel,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "pullRequest", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubLabelValue,
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get label => ValueModelQuerySelector<GithubLabelValue,
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "label", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get url => ModelUriModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "url", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get pullRequestUrl => ModelUriModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "pullRequestUrl", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get commitUrl => ModelUriModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "commitUrl", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get links => ModelUriModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "links", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get issueUrl => ModelUriModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "issueUrl", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "createdAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<
          _$_GithubPullRequestTimelineModelCollectionQuery>
      get updatedAt => ModelTimestampModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "updatedAt", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubPullRequestTimelineModelCollectionQuery>
      get fromServer => BooleanModelQuerySelector<
              _$_GithubPullRequestTimelineModelCollectionQuery>(
          key: "fromServer", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$GithubPullRequestTimelineModelMirrorRefPath
    = _$GithubPullRequestTimelineModelRefPath;
typedef _$GithubPullRequestTimelineModelMirrorInitialCollection
    = _$GithubPullRequestTimelineModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubPullRequestTimelineModelFormQuery {
  const _$GithubPullRequestTimelineModelFormQuery();

  @useResult
  _$_GithubPullRequestTimelineModelFormQuery call(
    GithubPullRequestTimelineModel value,
  ) {
    return _$_GithubPullRequestTimelineModelFormQuery(value);
  }
}

@immutable
class _$_GithubPullRequestTimelineModelFormQuery
    extends FormControllerQueryBase<GithubPullRequestTimelineModel> {
  const _$_GithubPullRequestTimelineModelFormQuery(this.value);

  final GithubPullRequestTimelineModel value;

  @override
  FormController<GithubPullRequestTimelineModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
