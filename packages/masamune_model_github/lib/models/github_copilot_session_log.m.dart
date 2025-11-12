// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_copilot_session_log.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubCopilotSessionLogModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$GithubCopilotSessionLogModelKeys {
  id,
  sessionId,
  message,
  level,
  metadata,
  toolName,
  toolResult,
  timestamp,
  fromServer,
}

class _$GithubCopilotSessionLogModelDocument
    extends DocumentBase<GithubCopilotSessionLogModel>
    with ModelRefMixin<GithubCopilotSessionLogModel> {
  _$GithubCopilotSessionLogModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubCopilotSessionLogModel fromMap(DynamicMap map) =>
      GithubCopilotSessionLogModel.fromJson(map);

  @override
  DynamicMap toMap(GithubCopilotSessionLogModel value) => value.rawValue;
}

typedef _$GithubCopilotSessionLogModelMirrorDocument
    = _$GithubCopilotSessionLogModelDocument;

class _$GithubCopilotSessionLogModelCollection
    extends CollectionBase<_$GithubCopilotSessionLogModelDocument>
    with
        FilterableCollectionMixin<_$GithubCopilotSessionLogModelDocument,
            _$_GithubCopilotSessionLogModelCollectionQuery> {
  _$GithubCopilotSessionLogModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubCopilotSessionLogModelDocument create([String? id]) =>
      _$GithubCopilotSessionLogModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubCopilotSessionLogModelDocument>> filter(
    _$_GithubCopilotSessionLogModelCollectionQuery Function(
      _$_GithubCopilotSessionLogModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubCopilotSessionLogModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubCopilotSessionLogModelMirrorCollection
    = _$GithubCopilotSessionLogModelCollection;

@immutable
class _$GithubCopilotSessionLogModelRefPath
    extends ModelRefPath<GithubCopilotSessionLogModel> {
  const _$GithubCopilotSessionLogModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
    required String sessionId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _sessionId = sessionId;

  final String _organizationId;

  final String _repositoryId;

  final String _sessionId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/session/$_sessionId/log/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubCopilotSessionLogModelInitialCollection
    extends ModelInitialCollection<GithubCopilotSessionLogModel> {
  const _$GithubCopilotSessionLogModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String sessionId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _sessionId = sessionId;

  final String _organizationId;

  final String _repositoryId;

  final String _sessionId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/session/$_sessionId/log";

  @override
  DynamicMap toMap(GithubCopilotSessionLogModel value) => value.rawValue;
}

@immutable
class _$GithubCopilotSessionLogModelDocumentQuery {
  const _$GithubCopilotSessionLogModelDocumentQuery();

  @useResult
  _$_GithubCopilotSessionLogModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    required String sessionId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubCopilotSessionLogModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/session/$sessionId/log/$_id",
        adapter: adapter ??
            _$GithubCopilotSessionLogModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubCopilotSessionLogModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubCopilotSessionLogModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/session/([^/]+)/log/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubCopilotSessionLogModelDocumentQuery
    extends ModelQueryBase<_$GithubCopilotSessionLogModelDocument> {
  const _$_GithubCopilotSessionLogModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubCopilotSessionLogModelDocument Function() call(Ref ref) =>
      () => _$GithubCopilotSessionLogModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubCopilotSessionLogModelCollectionQuery {
  const _$GithubCopilotSessionLogModelCollectionQuery();

  @useResult
  _$_GithubCopilotSessionLogModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    required String sessionId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubCopilotSessionLogModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/session/$sessionId/log",
        adapter: adapter ??
            _$GithubCopilotSessionLogModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubCopilotSessionLogModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubCopilotSessionLogModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/session/([^/]+)/log$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubCopilotSessionLogModelCollectionQuery
    extends ModelQueryBase<_$GithubCopilotSessionLogModelCollection> {
  const _$_GithubCopilotSessionLogModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubCopilotSessionLogModelCollection Function() call(Ref ref) =>
      () => _$GithubCopilotSessionLogModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubCopilotSessionLogModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubCopilotSessionLogModelCollectionQuery(query);

  _$_GithubCopilotSessionLogModelCollectionQuery collectionGroup() =>
      _$_GithubCopilotSessionLogModelCollectionQuery(
        modelQuery.collectionGroup(),
      );

  _$_GithubCopilotSessionLogModelCollectionQuery reset() =>
      _$_GithubCopilotSessionLogModelCollectionQuery(modelQuery.reset());

  _$_GithubCopilotSessionLogModelCollectionQuery remove(
    ModelQueryFilterType type,
  ) =>
      _$_GithubCopilotSessionLogModelCollectionQuery(modelQuery.remove(type));

  _$_GithubCopilotSessionLogModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubCopilotSessionLogModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubCopilotSessionLogModelCollectionQuery limitTo(int value) =>
      _$_GithubCopilotSessionLogModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubCopilotSessionLogModelCollectionQuery>
      get uid => StringModelQuerySelector<
              _$_GithubCopilotSessionLogModelCollectionQuery>(
            key: "@uid",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionLogModelCollectionQuery>
      get id => StringModelQuerySelector<
              _$_GithubCopilotSessionLogModelCollectionQuery>(
            key: "id",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionLogModelCollectionQuery>
      get sessionId => StringModelQuerySelector<
              _$_GithubCopilotSessionLogModelCollectionQuery>(
            key: "sessionId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionLogModelCollectionQuery>
      get message => StringModelQuerySelector<
              _$_GithubCopilotSessionLogModelCollectionQuery>(
            key: "message",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionLogModelCollectionQuery>
      get level => StringModelQuerySelector<
              _$_GithubCopilotSessionLogModelCollectionQuery>(
            key: "level",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  MapModelQuerySelector<dynamic, _$_GithubCopilotSessionLogModelCollectionQuery>
      get metadata => MapModelQuerySelector<dynamic,
              _$_GithubCopilotSessionLogModelCollectionQuery>(
          key: "metadata", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_GithubCopilotSessionLogModelCollectionQuery>
      get toolName => StringModelQuerySelector<
              _$_GithubCopilotSessionLogModelCollectionQuery>(
            key: "toolName",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubCopilotSessionLogModelCollectionQuery>
      get toolResult => StringModelQuerySelector<
              _$_GithubCopilotSessionLogModelCollectionQuery>(
            key: "toolResult",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<
          _$_GithubCopilotSessionLogModelCollectionQuery>
      get timestamp => ModelTimestampModelQuerySelector<
              _$_GithubCopilotSessionLogModelCollectionQuery>(
          key: "timestamp", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubCopilotSessionLogModelCollectionQuery>
      get fromServer => BooleanModelQuerySelector<
              _$_GithubCopilotSessionLogModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubCopilotSessionLogModelMirrorRefPath
    = _$GithubCopilotSessionLogModelRefPath;
typedef _$GithubCopilotSessionLogModelMirrorInitialCollection
    = _$GithubCopilotSessionLogModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubCopilotSessionLogModelFormQuery {
  const _$GithubCopilotSessionLogModelFormQuery();

  @useResult
  _$_GithubCopilotSessionLogModelFormQuery call(
    GithubCopilotSessionLogModel value,
  ) {
    return _$_GithubCopilotSessionLogModelFormQuery(value);
  }
}

@immutable
class _$_GithubCopilotSessionLogModelFormQuery
    extends FormControllerQueryBase<GithubCopilotSessionLogModel> {
  const _$_GithubCopilotSessionLogModelFormQuery(this.value);

  final GithubCopilotSessionLogModel value;

  @override
  FormController<GithubCopilotSessionLogModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
