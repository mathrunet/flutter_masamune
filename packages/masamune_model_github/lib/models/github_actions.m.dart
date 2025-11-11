// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_actions.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubActionsModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "actor": actor?.toJson(),
      "triggeringActor": triggeringActor?.toJson(),
    };
  }
}

enum _$GithubActionsModelKeys {
  id,
  workflowId,
  runNumber,
  runAttempt,
  name,
  displayTitle,
  event,
  status,
  conclusion,
  headBranch,
  headSha,
  path,
  actor,
  triggeringActor,
  repository,
  url,
  htmlUrl,
  jobsUrl,
  logsUrl,
  artifactsUrl,
  cancelUrl,
  rerunUrl,
  workflowUrl,
  checkSuiteUrl,
  previousAttemptUrl,
  runStartedAt,
  createdAt,
  updatedAt,
  fromServer,
}

class _$GithubActionsModelDocument extends DocumentBase<GithubActionsModel>
    with
        ModelRefMixin<GithubActionsModel>,
        ModelRefLoaderMixin<GithubActionsModel> {
  _$GithubActionsModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubActionsModel fromMap(DynamicMap map) =>
      GithubActionsModel.fromJson(map);

  @override
  DynamicMap toMap(GithubActionsModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<GithubActionsModel>> get builder => [
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

typedef _$GithubActionsModelMirrorDocument = _$GithubActionsModelDocument;

class _$GithubActionsModelCollection
    extends CollectionBase<_$GithubActionsModelDocument>
    with
        FilterableCollectionMixin<_$GithubActionsModelDocument,
            _$_GithubActionsModelCollectionQuery> {
  _$GithubActionsModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubActionsModelDocument create([String? id]) =>
      _$GithubActionsModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubActionsModelDocument>> filter(
    _$_GithubActionsModelCollectionQuery Function(
      _$_GithubActionsModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubActionsModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubActionsModelMirrorCollection = _$GithubActionsModelCollection;

@immutable
class _$GithubActionsModelRefPath extends ModelRefPath<GithubActionsModel> {
  const _$GithubActionsModelRefPath(
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
      "organization/$_organizationId/repository/$_repositoryId/actions/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubActionsModelInitialCollection
    extends ModelInitialCollection<GithubActionsModel> {
  const _$GithubActionsModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId;

  final String _organizationId;

  final String _repositoryId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/actions";

  @override
  DynamicMap toMap(GithubActionsModel value) => value.rawValue;
}

@immutable
class _$GithubActionsModelDocumentQuery {
  const _$GithubActionsModelDocumentQuery();

  @useResult
  _$_GithubActionsModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubActionsModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/actions/$_id",
        adapter: adapter ?? _$GithubActionsModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubActionsModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubActionsModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/actions/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubActionsModelDocumentQuery
    extends ModelQueryBase<_$GithubActionsModelDocument> {
  const _$_GithubActionsModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubActionsModelDocument Function() call(Ref ref) =>
      () => _$GithubActionsModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubActionsModelCollectionQuery {
  const _$GithubActionsModelCollectionQuery();

  @useResult
  _$_GithubActionsModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubActionsModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/actions",
        adapter: adapter ?? _$GithubActionsModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubActionsModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubActionsModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/actions$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubActionsModelCollectionQuery
    extends ModelQueryBase<_$GithubActionsModelCollection> {
  const _$_GithubActionsModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubActionsModelCollection Function() call(Ref ref) =>
      () => _$GithubActionsModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubActionsModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubActionsModelCollectionQuery(query);

  _$_GithubActionsModelCollectionQuery collectionGroup() =>
      _$_GithubActionsModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubActionsModelCollectionQuery reset() =>
      _$_GithubActionsModelCollectionQuery(modelQuery.reset());

  _$_GithubActionsModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubActionsModelCollectionQuery(modelQuery.remove(type));

  _$_GithubActionsModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubActionsModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_GithubActionsModelCollectionQuery limitTo(int value) =>
      _$_GithubActionsModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubActionsModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsModelCollectionQuery> get workflowId =>
      NumModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "workflowId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsModelCollectionQuery> get runNumber =>
      NumModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "runNumber",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsModelCollectionQuery> get runAttempt =>
      NumModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "runAttempt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubActionsModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get displayTitle =>
          StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "displayTitle",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubActionsModelCollectionQuery> get event =>
      StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "event",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubActionsModelCollectionQuery> get status =>
      StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "status",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get conclusion =>
          StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "conclusion",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get headBranch =>
          StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "headBranch",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubActionsModelCollectionQuery> get headSha =>
      StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "headSha",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubActionsModelCollectionQuery> get path =>
      StringModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "path",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ValueModelQuerySelector<GithubUserModel, _$_GithubActionsModelCollectionQuery>
      get actor => ValueModelQuerySelector<GithubUserModel,
              _$_GithubActionsModelCollectionQuery>(
          key: "actor", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubUserModel, _$_GithubActionsModelCollectionQuery>
      get triggeringActor => ValueModelQuerySelector<GithubUserModel,
              _$_GithubActionsModelCollectionQuery>(
          key: "triggeringActor", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<GithubRepositoryModel,
          _$_GithubActionsModelCollectionQuery>
      get repository => ModelRefModelQuerySelector<GithubRepositoryModel,
              _$_GithubActionsModelCollectionQuery>(
          key: "repository", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery> get url =>
      ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
        key: "url",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get htmlUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "htmlUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get jobsUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "jobsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get logsUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "logsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get artifactsUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "artifactsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get cancelUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "cancelUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get rerunUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "rerunUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get workflowUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "workflowUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get checkSuiteUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "checkSuiteUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get previousAttemptUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "previousAttemptUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get runStartedAt => ModelTimestampModelQuerySelector<
              _$_GithubActionsModelCollectionQuery>(
            key: "runStartedAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubActionsModelCollectionQuery>(
            key: "createdAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get updatedAt => ModelTimestampModelQuerySelector<
              _$_GithubActionsModelCollectionQuery>(
            key: "updatedAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubActionsModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubActionsModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubActionsModelMirrorRefPath = _$GithubActionsModelRefPath;
typedef _$GithubActionsModelMirrorInitialCollection
    = _$GithubActionsModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubActionsModelFormQuery {
  const _$GithubActionsModelFormQuery();

  @useResult
  _$_GithubActionsModelFormQuery call(GithubActionsModel value) {
    return _$_GithubActionsModelFormQuery(value);
  }
}

@immutable
class _$_GithubActionsModelFormQuery
    extends FormControllerQueryBase<GithubActionsModel> {
  const _$_GithubActionsModelFormQuery(this.value);

  final GithubActionsModel value;

  @override
  FormController<GithubActionsModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
