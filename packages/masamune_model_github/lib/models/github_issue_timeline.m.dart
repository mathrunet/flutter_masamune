// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_issue_timeline.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubIssueTimelineModel {
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

enum _$GithubIssueTimelineModelKeys {
  id,
  body,
  previousBody,
  authorAssociation,
  commitId,
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
  commitUrl,
  htmlUrl,
  issueUrl,
  links,
  pullRequestUrl,
  createdAt,
  updatedAt,
  fromServer,
}

class _$GithubIssueTimelineModelDocument
    extends DocumentBase<GithubIssueTimelineModel>
    with ModelRefMixin<GithubIssueTimelineModel> {
  _$GithubIssueTimelineModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubIssueTimelineModel fromMap(DynamicMap map) =>
      GithubIssueTimelineModel.fromJson(map);

  @override
  DynamicMap toMap(GithubIssueTimelineModel value) => value.rawValue;
}

typedef _$GithubIssueTimelineModelMirrorDocument
    = _$GithubIssueTimelineModelDocument;

class _$GithubIssueTimelineModelCollection
    extends CollectionBase<_$GithubIssueTimelineModelDocument>
    with
        FilterableCollectionMixin<_$GithubIssueTimelineModelDocument,
            _$_GithubIssueTimelineModelCollectionQuery> {
  _$GithubIssueTimelineModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubIssueTimelineModelDocument create([String? id]) =>
      _$GithubIssueTimelineModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubIssueTimelineModelDocument>> filter(
    _$_GithubIssueTimelineModelCollectionQuery Function(
      _$_GithubIssueTimelineModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubIssueTimelineModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubIssueTimelineModelMirrorCollection
    = _$GithubIssueTimelineModelCollection;

@immutable
class _$GithubIssueTimelineModelRefPath
    extends ModelRefPath<GithubIssueTimelineModel> {
  const _$GithubIssueTimelineModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
    required String issueId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _issueId = issueId;

  final String _organizationId;

  final String _repositoryId;

  final String _issueId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/issue/$_issueId/timeline/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubIssueTimelineModelInitialCollection
    extends ModelInitialCollection<GithubIssueTimelineModel> {
  const _$GithubIssueTimelineModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String issueId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _issueId = issueId;

  final String _organizationId;

  final String _repositoryId;

  final String _issueId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/issue/$_issueId/timeline";

  @override
  DynamicMap toMap(GithubIssueTimelineModel value) => value.rawValue;
}

@immutable
class _$GithubIssueTimelineModelDocumentQuery {
  const _$GithubIssueTimelineModelDocumentQuery();

  @useResult
  _$_GithubIssueTimelineModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    required String issueId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubIssueTimelineModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/issue/$issueId/timeline/$_id",
        adapter:
            adapter ?? _$GithubIssueTimelineModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubIssueTimelineModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubIssueTimelineModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/issue/([^/]+)/timeline/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubIssueTimelineModelDocumentQuery
    extends ModelQueryBase<_$GithubIssueTimelineModelDocument> {
  const _$_GithubIssueTimelineModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubIssueTimelineModelDocument Function() call(Ref ref) =>
      () => _$GithubIssueTimelineModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubIssueTimelineModelCollectionQuery {
  const _$GithubIssueTimelineModelCollectionQuery();

  @useResult
  _$_GithubIssueTimelineModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    required String issueId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubIssueTimelineModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/issue/$issueId/timeline",
        adapter:
            adapter ?? _$GithubIssueTimelineModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubIssueTimelineModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubIssueTimelineModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/issue/([^/]+)/timeline$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubIssueTimelineModelCollectionQuery
    extends ModelQueryBase<_$GithubIssueTimelineModelCollection> {
  const _$_GithubIssueTimelineModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubIssueTimelineModelCollection Function() call(Ref ref) =>
      () => _$GithubIssueTimelineModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubIssueTimelineModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubIssueTimelineModelCollectionQuery(query);

  _$_GithubIssueTimelineModelCollectionQuery collectionGroup() =>
      _$_GithubIssueTimelineModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubIssueTimelineModelCollectionQuery reset() =>
      _$_GithubIssueTimelineModelCollectionQuery(modelQuery.reset());

  _$_GithubIssueTimelineModelCollectionQuery remove(
    ModelQueryFilterType type,
  ) =>
      _$_GithubIssueTimelineModelCollectionQuery(modelQuery.remove(type));

  _$_GithubIssueTimelineModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubIssueTimelineModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubIssueTimelineModelCollectionQuery limitTo(int value) =>
      _$_GithubIssueTimelineModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get uid =>
          StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
            key: "@uid",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get body =>
          StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
            key: "body",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get previousBody =>
          StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
            key: "previousBody",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get authorAssociation =>
          StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
            key: "authorAssociation",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get commitId =>
          StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
            key: "commitId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get sha =>
          StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
            key: "sha",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get state =>
          StringModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
            key: "state",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get reviewId =>
          NumModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
            key: "reviewId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ValueModelQuerySelector<GithubTimelineEvent,
          _$_GithubIssueTimelineModelCollectionQuery>
      get event => ValueModelQuerySelector<GithubTimelineEvent,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "event", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel,
          _$_GithubIssueTimelineModelCollectionQuery>
      get user => ValueModelQuerySelector<GithubUserModel,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "user", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel,
          _$_GithubIssueTimelineModelCollectionQuery>
      get from => ValueModelQuerySelector<GithubUserModel,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "from", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel,
          _$_GithubIssueTimelineModelCollectionQuery>
      get to => ValueModelQuerySelector<GithubUserModel,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "to", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubProjectModel,
          _$_GithubIssueTimelineModelCollectionQuery>
      get project => ValueModelQuerySelector<GithubProjectModel,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "project", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubMilestoneValue,
          _$_GithubIssueTimelineModelCollectionQuery>
      get milestone => ValueModelQuerySelector<GithubMilestoneValue,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "milestone", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubReactionValue,
          _$_GithubIssueTimelineModelCollectionQuery>
      get reaction => ValueModelQuerySelector<GithubReactionValue,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "reaction", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubIssueModel,
          _$_GithubIssueTimelineModelCollectionQuery>
      get issue => ValueModelQuerySelector<GithubIssueModel,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "issue", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubPullRequestModel,
          _$_GithubIssueTimelineModelCollectionQuery>
      get pullRequest => ValueModelQuerySelector<GithubPullRequestModel,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "pullRequest", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubLabelValue,
          _$_GithubIssueTimelineModelCollectionQuery>
      get label => ValueModelQuerySelector<GithubLabelValue,
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "label", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get url => ModelUriModelQuerySelector<
              _$_GithubIssueTimelineModelCollectionQuery>(
            key: "url",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get commitUrl => ModelUriModelQuerySelector<
              _$_GithubIssueTimelineModelCollectionQuery>(
            key: "commitUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get htmlUrl => ModelUriModelQuerySelector<
              _$_GithubIssueTimelineModelCollectionQuery>(
            key: "htmlUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get issueUrl => ModelUriModelQuerySelector<
              _$_GithubIssueTimelineModelCollectionQuery>(
            key: "issueUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get links => ModelUriModelQuerySelector<
              _$_GithubIssueTimelineModelCollectionQuery>(
            key: "links",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get pullRequestUrl => ModelUriModelQuerySelector<
              _$_GithubIssueTimelineModelCollectionQuery>(
            key: "pullRequestUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "createdAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get updatedAt => ModelTimestampModelQuerySelector<
              _$_GithubIssueTimelineModelCollectionQuery>(
          key: "updatedAt", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubIssueTimelineModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubIssueTimelineModelMirrorRefPath
    = _$GithubIssueTimelineModelRefPath;
typedef _$GithubIssueTimelineModelMirrorInitialCollection
    = _$GithubIssueTimelineModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubIssueTimelineModelFormQuery {
  const _$GithubIssueTimelineModelFormQuery();

  @useResult
  _$_GithubIssueTimelineModelFormQuery call(GithubIssueTimelineModel value) {
    return _$_GithubIssueTimelineModelFormQuery(value);
  }
}

@immutable
class _$_GithubIssueTimelineModelFormQuery
    extends FormControllerQueryBase<GithubIssueTimelineModel> {
  const _$_GithubIssueTimelineModelFormQuery(this.value);

  final GithubIssueTimelineModel value;

  @override
  FormController<GithubIssueTimelineModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
