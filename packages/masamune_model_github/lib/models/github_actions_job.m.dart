// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_actions_job.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubActionsJobModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "runner": runner?.toJson(),
      "steps": steps.map((e) => e.toJson()).toList(),
    };
  }
}

enum _$GithubActionsJobModelKeys {
  id,
  runId,
  runAttempt,
  name,
  runnerName,
  runnerId,
  runnerGroupId,
  status,
  conclusion,
  labels,
  runner,
  steps,
  url,
  htmlUrl,
  logsUrl,
  startedAt,
  completedAt,
  fromServer,
}

class _$GithubActionsJobModelDocument
    extends DocumentBase<GithubActionsJobModel>
    with ModelRefMixin<GithubActionsJobModel> {
  _$GithubActionsJobModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubActionsJobModel fromMap(DynamicMap map) =>
      GithubActionsJobModel.fromJson(map);

  @override
  DynamicMap toMap(GithubActionsJobModel value) => value.rawValue;
}

typedef _$GithubActionsJobModelMirrorDocument = _$GithubActionsJobModelDocument;

class _$GithubActionsJobModelCollection
    extends CollectionBase<_$GithubActionsJobModelDocument>
    with
        FilterableCollectionMixin<_$GithubActionsJobModelDocument,
            _$_GithubActionsJobModelCollectionQuery> {
  _$GithubActionsJobModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubActionsJobModelDocument create([String? id]) =>
      _$GithubActionsJobModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubActionsJobModelDocument>> filter(
    _$_GithubActionsJobModelCollectionQuery Function(
      _$_GithubActionsJobModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubActionsJobModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubActionsJobModelMirrorCollection
    = _$GithubActionsJobModelCollection;

@immutable
class _$GithubActionsJobModelRefPath
    extends ModelRefPath<GithubActionsJobModel> {
  const _$GithubActionsJobModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
    required String actionId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _actionId = actionId;

  final String _organizationId;

  final String _repositoryId;

  final String _actionId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/actions/$_actionId/job/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubActionsJobModelInitialCollection
    extends ModelInitialCollection<GithubActionsJobModel> {
  const _$GithubActionsJobModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String actionId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _actionId = actionId;

  final String _organizationId;

  final String _repositoryId;

  final String _actionId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/actions/$_actionId/job";

  @override
  DynamicMap toMap(GithubActionsJobModel value) => value.rawValue;
}

@immutable
class _$GithubActionsJobModelDocumentQuery {
  const _$GithubActionsJobModelDocumentQuery();

  @useResult
  _$_GithubActionsJobModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    required String actionId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubActionsJobModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/actions/$actionId/job/$_id",
        adapter: adapter ?? _$GithubActionsJobModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubActionsJobModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubActionsJobModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/actions/([^/]+)/job/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubActionsJobModelDocumentQuery
    extends ModelQueryBase<_$GithubActionsJobModelDocument> {
  const _$_GithubActionsJobModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubActionsJobModelDocument Function() call(Ref ref) =>
      () => _$GithubActionsJobModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubActionsJobModelCollectionQuery {
  const _$GithubActionsJobModelCollectionQuery();

  @useResult
  _$_GithubActionsJobModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    required String actionId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubActionsJobModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/actions/$actionId/job",
        adapter:
            adapter ?? _$GithubActionsJobModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubActionsJobModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubActionsJobModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/actions/([^/]+)/job$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubActionsJobModelCollectionQuery
    extends ModelQueryBase<_$GithubActionsJobModelCollection> {
  const _$_GithubActionsJobModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubActionsJobModelCollection Function() call(Ref ref) =>
      () => _$GithubActionsJobModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubActionsJobModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubActionsJobModelCollectionQuery(query);

  _$_GithubActionsJobModelCollectionQuery collectionGroup() =>
      _$_GithubActionsJobModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubActionsJobModelCollectionQuery reset() =>
      _$_GithubActionsJobModelCollectionQuery(modelQuery.reset());

  _$_GithubActionsJobModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubActionsJobModelCollectionQuery(modelQuery.remove(type));

  _$_GithubActionsJobModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubActionsJobModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubActionsJobModelCollectionQuery limitTo(int value) =>
      _$_GithubActionsJobModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery> get runId =>
      NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
        key: "runId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get runAttempt =>
          NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
            key: "runAttempt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get runnerName =>
          StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
            key: "runnerName",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery> get runnerId =>
      NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
        key: "runnerId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get runnerGroupId =>
          NumModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
            key: "runnerGroupId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get status =>
          StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
            key: "status",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get conclusion =>
          StringModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
            key: "conclusion",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ListModelQuerySelector<String, _$_GithubActionsJobModelCollectionQuery>
      get labels => ListModelQuerySelector<String,
              _$_GithubActionsJobModelCollectionQuery>(
            key: "labels",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ValueModelQuerySelector<GithubUserModel,
          _$_GithubActionsJobModelCollectionQuery>
      get runner => ValueModelQuerySelector<GithubUserModel,
              _$_GithubActionsJobModelCollectionQuery>(
          key: "runner", toQuery: _toQuery, modelQuery: modelQuery);

  ListModelQuerySelector<GithubActionsStepValue,
          _$_GithubActionsJobModelCollectionQuery>
      get steps => ListModelQuerySelector<GithubActionsStepValue,
              _$_GithubActionsJobModelCollectionQuery>(
          key: "steps", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubActionsJobModelCollectionQuery> get url =>
      ModelUriModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
        key: "url",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get htmlUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
            key: "htmlUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get logsUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
            key: "logsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get startedAt => ModelTimestampModelQuerySelector<
              _$_GithubActionsJobModelCollectionQuery>(
            key: "startedAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get completedAt => ModelTimestampModelQuerySelector<
              _$_GithubActionsJobModelCollectionQuery>(
            key: "completedAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubActionsJobModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubActionsJobModelMirrorRefPath = _$GithubActionsJobModelRefPath;
typedef _$GithubActionsJobModelMirrorInitialCollection
    = _$GithubActionsJobModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubActionsJobModelFormQuery {
  const _$GithubActionsJobModelFormQuery();

  @useResult
  _$_GithubActionsJobModelFormQuery call(GithubActionsJobModel value) {
    return _$_GithubActionsJobModelFormQuery(value);
  }
}

@immutable
class _$_GithubActionsJobModelFormQuery
    extends FormControllerQueryBase<GithubActionsJobModel> {
  const _$_GithubActionsJobModelFormQuery(this.value);

  final GithubActionsJobModel value;

  @override
  FormController<GithubActionsJobModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}

@immutable
class _$GithubActionsStepValueFormQuery {
  const _$GithubActionsStepValueFormQuery();

  @useResult
  _$_GithubActionsStepValueFormQuery call(GithubActionsStepValue value) {
    return _$_GithubActionsStepValueFormQuery(value);
  }
}

@immutable
class _$_GithubActionsStepValueFormQuery
    extends FormControllerQueryBase<GithubActionsStepValue> {
  const _$_GithubActionsStepValueFormQuery(this.value);

  final GithubActionsStepValue value;

  @override
  FormController<GithubActionsStepValue> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
