// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_actions_log.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubActionsLogModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$GithubActionsLogModelKeys {
  runId,
  jobId,
  chunk,
  name,
  downloadUrl,
  text,
  createdAt,
  fromServer,
}

class _$GithubActionsLogModelDocument
    extends DocumentBase<GithubActionsLogModel>
    with ModelRefMixin<GithubActionsLogModel> {
  _$GithubActionsLogModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubActionsLogModel fromMap(DynamicMap map) =>
      GithubActionsLogModel.fromJson(map);

  @override
  DynamicMap toMap(GithubActionsLogModel value) => value.rawValue;
}

typedef _$GithubActionsLogModelMirrorDocument = _$GithubActionsLogModelDocument;

class _$GithubActionsLogModelCollection
    extends CollectionBase<_$GithubActionsLogModelDocument>
    with
        FilterableCollectionMixin<_$GithubActionsLogModelDocument,
            _$_GithubActionsLogModelCollectionQuery> {
  _$GithubActionsLogModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubActionsLogModelDocument create([String? id]) =>
      _$GithubActionsLogModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubActionsLogModelDocument>> filter(
    _$_GithubActionsLogModelCollectionQuery Function(
      _$_GithubActionsLogModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubActionsLogModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubActionsLogModelMirrorCollection
    = _$GithubActionsLogModelCollection;

@immutable
class _$GithubActionsLogModelRefPath
    extends ModelRefPath<GithubActionsLogModel> {
  const _$GithubActionsLogModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
    required String actionId,
    required String jobId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _actionId = actionId,
        _jobId = jobId;

  final String _organizationId;

  final String _repositoryId;

  final String _actionId;

  final String _jobId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/actions/$_actionId/job/$_jobId/log/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubActionsLogModelInitialCollection
    extends ModelInitialCollection<GithubActionsLogModel> {
  const _$GithubActionsLogModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String actionId,
    required String jobId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _actionId = actionId,
        _jobId = jobId;

  final String _organizationId;

  final String _repositoryId;

  final String _actionId;

  final String _jobId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/actions/$_actionId/job/$_jobId/log";

  @override
  DynamicMap toMap(GithubActionsLogModel value) => value.rawValue;
}

@immutable
class _$GithubActionsLogModelDocumentQuery {
  const _$GithubActionsLogModelDocumentQuery();

  @useResult
  _$_GithubActionsLogModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    required String actionId,
    required String jobId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubActionsLogModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/actions/$actionId/job/$jobId/log/$_id",
        adapter: adapter ?? _$GithubActionsLogModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubActionsLogModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubActionsLogModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/actions/([^/]+)/job/([^/]+)/log/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubActionsLogModelDocumentQuery
    extends ModelQueryBase<_$GithubActionsLogModelDocument> {
  const _$_GithubActionsLogModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubActionsLogModelDocument Function() call(Ref ref) =>
      () => _$GithubActionsLogModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubActionsLogModelCollectionQuery {
  const _$GithubActionsLogModelCollectionQuery();

  @useResult
  _$_GithubActionsLogModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    required String actionId,
    required String jobId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubActionsLogModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/actions/$actionId/job/$jobId/log",
        adapter:
            adapter ?? _$GithubActionsLogModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubActionsLogModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubActionsLogModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/actions/([^/]+)/job/([^/]+)/log$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubActionsLogModelCollectionQuery
    extends ModelQueryBase<_$GithubActionsLogModelCollection> {
  const _$_GithubActionsLogModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubActionsLogModelCollection Function() call(Ref ref) =>
      () => _$GithubActionsLogModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubActionsLogModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubActionsLogModelCollectionQuery(query);

  _$_GithubActionsLogModelCollectionQuery collectionGroup() =>
      _$_GithubActionsLogModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubActionsLogModelCollectionQuery reset() =>
      _$_GithubActionsLogModelCollectionQuery(modelQuery.reset());

  _$_GithubActionsLogModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubActionsLogModelCollectionQuery(modelQuery.remove(type));

  _$_GithubActionsLogModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubActionsLogModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubActionsLogModelCollectionQuery limitTo(int value) =>
      _$_GithubActionsLogModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubActionsLogModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsLogModelCollectionQuery> get runId =>
      NumModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>(
        key: "runId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsLogModelCollectionQuery> get jobId =>
      NumModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>(
        key: "jobId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubActionsLogModelCollectionQuery> get chunk =>
      NumModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>(
        key: "chunk",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubActionsLogModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>
      get downloadUrl =>
          ModelUriModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>(
            key: "downloadUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubActionsLogModelCollectionQuery> get text =>
      StringModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>(
        key: "text",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelTimestampModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubActionsLogModelCollectionQuery>(
            key: "createdAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubActionsLogModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubActionsLogModelMirrorRefPath = _$GithubActionsLogModelRefPath;
typedef _$GithubActionsLogModelMirrorInitialCollection
    = _$GithubActionsLogModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubActionsLogModelFormQuery {
  const _$GithubActionsLogModelFormQuery();

  @useResult
  _$_GithubActionsLogModelFormQuery call(GithubActionsLogModel value) {
    return _$_GithubActionsLogModelFormQuery(value);
  }
}

@immutable
class _$_GithubActionsLogModelFormQuery
    extends FormControllerQueryBase<GithubActionsLogModel> {
  const _$_GithubActionsLogModelFormQuery(this.value);

  final GithubActionsLogModel value;

  @override
  FormController<GithubActionsLogModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
