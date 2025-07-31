// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_issue.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubIssueModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "user": user?.toJson(),
      "assignee": assignee?.toJson(),
      "assignees": assignees.map((e) => e.toJson()).toList(),
      "closedBy": closedBy?.toJson(),
      "labels": labels.map((e) => e.toJson()).toList(),
      "reactions": reactions?.toJson(),
    };
  }
}

enum _$GithubIssueModelKeys {
  id,
  number,
  title,
  body,
  bodyHtml,
  bodyText,
  state,
  stateReason,
  activeLockReason,
  authorAssociation,
  nodeId,
  draft,
  locked,
  commentsCount,
  repository,
  user,
  assignee,
  assignees,
  closedBy,
  labels,
  url,
  htmlUrl,
  commentsUrl,
  eventsUrl,
  labelsUrl,
  repositoryUrl,
  timelineUrl,
  reactions,
  closedAt,
  createdAt,
  updatedAt,
  fromServer,
}

class _$GithubIssueModelDocument extends DocumentBase<GithubIssueModel>
    with
        ModelRefMixin<GithubIssueModel>,
        ModelRefLoaderMixin<GithubIssueModel> {
  _$GithubIssueModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubIssueModel fromMap(DynamicMap map) => GithubIssueModel.fromJson(map);

  @override
  DynamicMap toMap(GithubIssueModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<GithubIssueModel>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.repository,
          document: (modelQuery) => GithubRepositoryModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(repository: doc),
          adapter: GithubRepositoryModelDocument.defaultModelAdapter,
          accessQuery: GithubRepositoryModelDocument.defaultModelAccessQuery,
          validationQueries:
              GithubRepositoryModelDocument.defaultValidationQueries,
        ),
      ];
}

typedef _$GithubIssueModelMirrorDocument = _$GithubIssueModelDocument;

class _$GithubIssueModelCollection
    extends CollectionBase<_$GithubIssueModelDocument>
    with
        FilterableCollectionMixin<_$GithubIssueModelDocument,
            _$_GithubIssueModelCollectionQuery> {
  _$GithubIssueModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubIssueModelDocument create([String? id]) =>
      _$GithubIssueModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubIssueModelDocument>> filter(
    _$_GithubIssueModelCollectionQuery Function(
      _$_GithubIssueModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(_$_GithubIssueModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubIssueModelMirrorCollection = _$GithubIssueModelCollection;

@immutable
class _$GithubIssueModelRefPath extends ModelRefPath<GithubIssueModel> {
  const _$GithubIssueModelRefPath(
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
      "organization/$_organizationId/repository/$_repositoryId/issue/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubIssueModelInitialCollection
    extends ModelInitialCollection<GithubIssueModel> {
  const _$GithubIssueModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId;

  final String _organizationId;

  final String _repositoryId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/issue";

  @override
  DynamicMap toMap(GithubIssueModel value) => value.rawValue;
}

@immutable
class _$GithubIssueModelDocumentQuery {
  const _$GithubIssueModelDocumentQuery();

  @useResult
  _$_GithubIssueModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubIssueModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/issue/$_id",
        adapter: adapter ?? _$GithubIssueModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubIssueModelDocument.defaultModelAccessQuery,
        validationQueries: _$GithubIssueModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/issue/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubIssueModelDocumentQuery
    extends ModelQueryBase<_$GithubIssueModelDocument> {
  const _$_GithubIssueModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubIssueModelDocument Function() call(Ref ref) =>
      () => _$GithubIssueModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubIssueModelCollectionQuery {
  const _$GithubIssueModelCollectionQuery();

  @useResult
  _$_GithubIssueModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubIssueModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/issue",
        adapter: adapter ?? _$GithubIssueModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubIssueModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubIssueModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/issue$".trimQuery().trimString(
            "/",
          ),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubIssueModelCollectionQuery
    extends ModelQueryBase<_$GithubIssueModelCollection> {
  const _$_GithubIssueModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubIssueModelCollection Function() call(Ref ref) =>
      () => _$GithubIssueModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubIssueModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubIssueModelCollectionQuery(query);

  _$_GithubIssueModelCollectionQuery collectionGroup() =>
      _$_GithubIssueModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubIssueModelCollectionQuery reset() =>
      _$_GithubIssueModelCollectionQuery(modelQuery.reset());

  _$_GithubIssueModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubIssueModelCollectionQuery(modelQuery.remove(type));

  _$_GithubIssueModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubIssueModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_GithubIssueModelCollectionQuery limitTo(int value) =>
      _$_GithubIssueModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubIssueModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubIssueModelCollectionQuery> get number =>
      NumModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "number",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery> get title =>
      StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "title",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery> get body =>
      StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "body",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery> get bodyHtml =>
      StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "bodyHtml",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery> get bodyText =>
      StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "bodyText",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery> get state =>
      StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "state",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get stateReason =>
          StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "stateReason",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get activeLockReason =>
          StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "activeLockReason",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get authorAssociation =>
          StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "authorAssociation",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubIssueModelCollectionQuery> get nodeId =>
      StringModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "nodeId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  BooleanModelQuerySelector<_$_GithubIssueModelCollectionQuery> get draft =>
      BooleanModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "draft",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  BooleanModelQuerySelector<_$_GithubIssueModelCollectionQuery> get locked =>
      BooleanModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "locked",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubIssueModelCollectionQuery> get commentsCount =>
      NumModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "commentsCount",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelRefModelQuerySelector<GithubRepositoryModel,
          _$_GithubIssueModelCollectionQuery>
      get repository => ModelRefModelQuerySelector<GithubRepositoryModel,
              _$_GithubIssueModelCollectionQuery>(
          key: "repository", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel, _$_GithubIssueModelCollectionQuery>
      get user => ValueModelQuerySelector<GithubUserModel,
              _$_GithubIssueModelCollectionQuery>(
          key: "user", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel, _$_GithubIssueModelCollectionQuery>
      get assignee => ValueModelQuerySelector<GithubUserModel,
              _$_GithubIssueModelCollectionQuery>(
          key: "assignee", toQuery: _toQuery, modelQuery: modelQuery);

  ListModelQuerySelector<GithubUserModel, _$_GithubIssueModelCollectionQuery>
      get assignees => ListModelQuerySelector<GithubUserModel,
              _$_GithubIssueModelCollectionQuery>(
          key: "assignees", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel, _$_GithubIssueModelCollectionQuery>
      get closedBy => ValueModelQuerySelector<GithubUserModel,
              _$_GithubIssueModelCollectionQuery>(
          key: "closedBy", toQuery: _toQuery, modelQuery: modelQuery);

  ListModelQuerySelector<GithubLabelValue, _$_GithubIssueModelCollectionQuery>
      get labels => ListModelQuerySelector<GithubLabelValue,
              _$_GithubIssueModelCollectionQuery>(
          key: "labels", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery> get url =>
      ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "url",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery> get htmlUrl =>
      ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
        key: "htmlUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get commentsUrl =>
          ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "commentsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get eventsUrl =>
          ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "eventsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get labelsUrl =>
          ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "labelsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get repositoryUrl =>
          ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "repositoryUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get timelineUrl =>
          ModelUriModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "timelineUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ValueModelQuerySelector<GithubReactionValue,
          _$_GithubIssueModelCollectionQuery>
      get reactions => ValueModelQuerySelector<GithubReactionValue,
              _$_GithubIssueModelCollectionQuery>(
          key: "reactions", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get closedAt =>
          ModelTimestampModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "closedAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get createdAt =>
          ModelTimestampModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "createdAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get updatedAt =>
          ModelTimestampModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "updatedAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubIssueModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubIssueModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubIssueModelMirrorRefPath = _$GithubIssueModelRefPath;
typedef _$GithubIssueModelMirrorInitialCollection
    = _$GithubIssueModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubIssueModelFormQuery {
  const _$GithubIssueModelFormQuery();

  @useResult
  _$_GithubIssueModelFormQuery call(GithubIssueModel value) {
    return _$_GithubIssueModelFormQuery(value);
  }
}

@immutable
class _$_GithubIssueModelFormQuery
    extends FormControllerQueryBase<GithubIssueModel> {
  const _$_GithubIssueModelFormQuery(this.value);

  final GithubIssueModel value;

  @override
  FormController<GithubIssueModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
