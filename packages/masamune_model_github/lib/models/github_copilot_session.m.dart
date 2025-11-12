// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_copilot_session.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubCopilotSessionModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$GithubCopilotSessionModelKeys {
  id,
  name,
  resourceType,
  resourceId,
  userId,
  agentId,
  errorMessage,
  errorCode,
  pullRequestNumber,
  pullRequestUrl,
  pullRequestId,
  pullRequestBaseRef,
  status,
  completedAt,
  createdAt,
  updatedAt,
  fromServer,
}

class _$GithubCopilotSessionModelDocument
    extends DocumentBase<GithubCopilotSessionModel>
    with ModelRefMixin<GithubCopilotSessionModel> {
  _$GithubCopilotSessionModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubCopilotSessionModel fromMap(DynamicMap map) =>
      GithubCopilotSessionModel.fromJson(map);

  @override
  DynamicMap toMap(GithubCopilotSessionModel value) => value.rawValue;
}

typedef _$GithubCopilotSessionModelMirrorDocument
    = _$GithubCopilotSessionModelDocument;

class _$GithubCopilotSessionModelCollection
    extends CollectionBase<_$GithubCopilotSessionModelDocument>
    with
        FilterableCollectionMixin<_$GithubCopilotSessionModelDocument,
            _$_GithubCopilotSessionModelCollectionQuery> {
  _$GithubCopilotSessionModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubCopilotSessionModelDocument create([String? id]) =>
      _$GithubCopilotSessionModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubCopilotSessionModelDocument>> filter(
    _$_GithubCopilotSessionModelCollectionQuery Function(
      _$_GithubCopilotSessionModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubCopilotSessionModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubCopilotSessionModelMirrorCollection
    = _$GithubCopilotSessionModelCollection;

@immutable
class _$GithubCopilotSessionModelRefPath
    extends ModelRefPath<GithubCopilotSessionModel> {
  const _$GithubCopilotSessionModelRefPath(
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
      "organization/$_organizationId/repository/$_repositoryId/session/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubCopilotSessionModelInitialCollection
    extends ModelInitialCollection<GithubCopilotSessionModel> {
  const _$GithubCopilotSessionModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId;

  final String _organizationId;

  final String _repositoryId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/session";

  @override
  DynamicMap toMap(GithubCopilotSessionModel value) => value.rawValue;
}

@immutable
class _$GithubCopilotSessionModelDocumentQuery {
  const _$GithubCopilotSessionModelDocumentQuery();

  @useResult
  _$_GithubCopilotSessionModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubCopilotSessionModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/session/$_id",
        adapter:
            adapter ?? _$GithubCopilotSessionModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubCopilotSessionModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubCopilotSessionModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/session/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubCopilotSessionModelDocumentQuery
    extends ModelQueryBase<_$GithubCopilotSessionModelDocument> {
  const _$_GithubCopilotSessionModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubCopilotSessionModelDocument Function() call(Ref ref) =>
      () => _$GithubCopilotSessionModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubCopilotSessionModelCollectionQuery {
  const _$GithubCopilotSessionModelCollectionQuery();

  @useResult
  _$_GithubCopilotSessionModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubCopilotSessionModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/session",
        adapter: adapter ??
            _$GithubCopilotSessionModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubCopilotSessionModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubCopilotSessionModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/session$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubCopilotSessionModelCollectionQuery
    extends ModelQueryBase<_$GithubCopilotSessionModelCollection> {
  const _$_GithubCopilotSessionModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubCopilotSessionModelCollection Function() call(Ref ref) =>
      () => _$GithubCopilotSessionModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubCopilotSessionModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubCopilotSessionModelCollectionQuery(query);

  _$_GithubCopilotSessionModelCollectionQuery collectionGroup() =>
      _$_GithubCopilotSessionModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubCopilotSessionModelCollectionQuery reset() =>
      _$_GithubCopilotSessionModelCollectionQuery(modelQuery.reset());

  _$_GithubCopilotSessionModelCollectionQuery remove(
    ModelQueryFilterType type,
  ) =>
      _$_GithubCopilotSessionModelCollectionQuery(modelQuery.remove(type));

  _$_GithubCopilotSessionModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubCopilotSessionModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubCopilotSessionModelCollectionQuery limitTo(int value) =>
      _$_GithubCopilotSessionModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get uid =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "@uid",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get id =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "id",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get name =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "name",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get resourceType =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "resourceType",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get resourceId =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "resourceId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get userId =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "userId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get agentId =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "agentId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get errorMessage =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "errorMessage",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get errorCode =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "errorCode",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get pullRequestNumber =>
          NumModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "pullRequestNumber",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get pullRequestUrl =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "pullRequestUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get pullRequestId =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "pullRequestId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get pullRequestBaseRef =>
          StringModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>(
            key: "pullRequestBaseRef",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ValueModelQuerySelector<GithubCopilotSessionStatus,
          _$_GithubCopilotSessionModelCollectionQuery>
      get status => ValueModelQuerySelector<GithubCopilotSessionStatus,
              _$_GithubCopilotSessionModelCollectionQuery>(
          key: "status", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get completedAt => ModelTimestampModelQuerySelector<
              _$_GithubCopilotSessionModelCollectionQuery>(
          key: "completedAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubCopilotSessionModelCollectionQuery>(
          key: "createdAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get updatedAt => ModelTimestampModelQuerySelector<
              _$_GithubCopilotSessionModelCollectionQuery>(
          key: "updatedAt", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubCopilotSessionModelCollectionQuery>
      get fromServer => BooleanModelQuerySelector<
              _$_GithubCopilotSessionModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubCopilotSessionModelMirrorRefPath
    = _$GithubCopilotSessionModelRefPath;
typedef _$GithubCopilotSessionModelMirrorInitialCollection
    = _$GithubCopilotSessionModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubCopilotSessionModelFormQuery {
  const _$GithubCopilotSessionModelFormQuery();

  @useResult
  _$_GithubCopilotSessionModelFormQuery call(GithubCopilotSessionModel value) {
    return _$_GithubCopilotSessionModelFormQuery(value);
  }
}

@immutable
class _$_GithubCopilotSessionModelFormQuery
    extends FormControllerQueryBase<GithubCopilotSessionModel> {
  const _$_GithubCopilotSessionModelFormQuery(this.value);

  final GithubCopilotSessionModel value;

  @override
  FormController<GithubCopilotSessionModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
