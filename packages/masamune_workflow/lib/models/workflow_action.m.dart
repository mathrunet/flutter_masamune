// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_action.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowActionModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "command": command.toJson(),
      "log": log.map((e) => e.toJson()).toList(),
    };
  }
}

enum _$WorkflowActionModelKeys {
  command,
  task,
  workflow,
  organization,
  project,
  status,
  locale,
  error,
  prompt,
  log,
  materials,
  results,
  assets,
  usage,
  search,
  token,
  tokenExpiredTime,
  startTime,
  finishedTime,
  createdTime,
  updatedTime,
}

class _$WorkflowActionModelDocument extends DocumentBase<WorkflowActionModel>
    with
        ModelRefMixin<WorkflowActionModel>,
        ModelRefLoaderMixin<WorkflowActionModel> {
  _$WorkflowActionModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowActionModel fromMap(DynamicMap map) =>
      WorkflowActionModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowActionModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<WorkflowActionModel>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.task,
          document: (modelQuery) => WorkflowTaskModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(task: doc),
          adapter: WorkflowTaskModelDocument.defaultModelAdapter,
          accessQuery: WorkflowTaskModelDocument.defaultModelAccessQuery,
          validationQueries: WorkflowTaskModelDocument.defaultValidationQueries,
        ),
        ModelRefBuilder(
          modelRef: (value) => value.workflow,
          document: (modelQuery) => WorkflowWorkflowModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(workflow: doc),
          adapter: WorkflowWorkflowModelDocument.defaultModelAdapter,
          accessQuery: WorkflowWorkflowModelDocument.defaultModelAccessQuery,
          validationQueries:
              WorkflowWorkflowModelDocument.defaultValidationQueries,
        ),
        ModelRefBuilder(
          modelRef: (value) => value.organization,
          document: (modelQuery) =>
              WorkflowOrganizationModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(organization: doc),
          adapter: WorkflowOrganizationModelDocument.defaultModelAdapter,
          accessQuery:
              WorkflowOrganizationModelDocument.defaultModelAccessQuery,
          validationQueries:
              WorkflowOrganizationModelDocument.defaultValidationQueries,
        ),
        ModelRefBuilder(
          modelRef: (value) => value.project,
          document: (modelQuery) => WorkflowProjectModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(project: doc),
          adapter: WorkflowProjectModelDocument.defaultModelAdapter,
          accessQuery: WorkflowProjectModelDocument.defaultModelAccessQuery,
          validationQueries:
              WorkflowProjectModelDocument.defaultValidationQueries,
        ),
      ];
}

typedef _$WorkflowActionModelMirrorDocument = _$WorkflowActionModelDocument;

class _$WorkflowActionModelCollection
    extends CollectionBase<_$WorkflowActionModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowActionModelDocument,
            _$_WorkflowActionModelCollectionQuery> {
  _$WorkflowActionModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowActionModelDocument create([String? id]) =>
      _$WorkflowActionModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowActionModelDocument>> filter(
    _$_WorkflowActionModelCollectionQuery Function(
      _$_WorkflowActionModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowActionModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowActionModelMirrorCollection = _$WorkflowActionModelCollection;

@immutable
class _$WorkflowActionModelRefPath extends ModelRefPath<WorkflowActionModel> {
  const _$WorkflowActionModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/action/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowActionModelInitialCollection
    extends ModelInitialCollection<WorkflowActionModel> {
  const _$WorkflowActionModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/action";

  @override
  DynamicMap toMap(WorkflowActionModel value) => value.rawValue;
}

@immutable
class _$WorkflowActionModelDocumentQuery {
  const _$WorkflowActionModelDocumentQuery();

  @useResult
  _$_WorkflowActionModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowActionModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/action/$_id",
        adapter: adapter ?? _$WorkflowActionModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowActionModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowActionModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/action/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowActionModelDocumentQuery
    extends ModelQueryBase<_$WorkflowActionModelDocument> {
  const _$_WorkflowActionModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowActionModelDocument Function() call(Ref ref) =>
      () => _$WorkflowActionModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowActionModelCollectionQuery {
  const _$WorkflowActionModelCollectionQuery();

  @useResult
  _$_WorkflowActionModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowActionModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/action",
        adapter: adapter ?? _$WorkflowActionModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowActionModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowActionModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^plugins/workflow/action$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowActionModelCollectionQuery
    extends ModelQueryBase<_$WorkflowActionModelCollection> {
  const _$_WorkflowActionModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowActionModelCollection Function() call(Ref ref) =>
      () => _$WorkflowActionModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowActionModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowActionModelCollectionQuery(query);

  _$_WorkflowActionModelCollectionQuery collectionGroup() =>
      _$_WorkflowActionModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowActionModelCollectionQuery reset() =>
      _$_WorkflowActionModelCollectionQuery(modelQuery.reset());

  _$_WorkflowActionModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowActionModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowActionModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowActionModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_WorkflowActionModelCollectionQuery limitTo(int value) =>
      _$_WorkflowActionModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowActionModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowActionModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ValueModelQuerySelector<WorkflowActionCommandValue,
          _$_WorkflowActionModelCollectionQuery>
      get command => ValueModelQuerySelector<WorkflowActionCommandValue,
              _$_WorkflowActionModelCollectionQuery>(
          key: "command", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<WorkflowTaskModel,
          _$_WorkflowActionModelCollectionQuery>
      get task => ModelRefModelQuerySelector<WorkflowTaskModel,
              _$_WorkflowActionModelCollectionQuery>(
          key: "task", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<WorkflowWorkflowModel,
          _$_WorkflowActionModelCollectionQuery>
      get workflow => ModelRefModelQuerySelector<WorkflowWorkflowModel,
              _$_WorkflowActionModelCollectionQuery>(
          key: "workflow", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowActionModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowActionModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<WorkflowProjectModel,
          _$_WorkflowActionModelCollectionQuery>
      get project => ModelRefModelQuerySelector<WorkflowProjectModel,
              _$_WorkflowActionModelCollectionQuery>(
          key: "project", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<WorkflowTaskStatus,
          _$_WorkflowActionModelCollectionQuery>
      get status => ValueModelQuerySelector<WorkflowTaskStatus,
              _$_WorkflowActionModelCollectionQuery>(
          key: "status", toQuery: _toQuery, modelQuery: modelQuery);

  ModelLocaleModelQuerySelector<_$_WorkflowActionModelCollectionQuery>
      get locale =>
          ModelLocaleModelQuerySelector<_$_WorkflowActionModelCollectionQuery>(
            key: "locale",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  MapModelQuerySelector<dynamic, _$_WorkflowActionModelCollectionQuery>
      get error =>
          MapModelQuerySelector<dynamic, _$_WorkflowActionModelCollectionQuery>(
            key: "error",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowActionModelCollectionQuery> get prompt =>
      StringModelQuerySelector<_$_WorkflowActionModelCollectionQuery>(
        key: "prompt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ListModelQuerySelector<WorkflowTaskLogValue,
      _$_WorkflowActionModelCollectionQuery> get log => ListModelQuerySelector<
          WorkflowTaskLogValue, _$_WorkflowActionModelCollectionQuery>(
      key: "log", toQuery: _toQuery, modelQuery: modelQuery);

  MapModelQuerySelector<dynamic, _$_WorkflowActionModelCollectionQuery>
      get materials =>
          MapModelQuerySelector<dynamic, _$_WorkflowActionModelCollectionQuery>(
            key: "materials",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  MapModelQuerySelector<dynamic, _$_WorkflowActionModelCollectionQuery>
      get results =>
          MapModelQuerySelector<dynamic, _$_WorkflowActionModelCollectionQuery>(
            key: "results",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  MapModelQuerySelector<dynamic, _$_WorkflowActionModelCollectionQuery>
      get assets =>
          MapModelQuerySelector<dynamic, _$_WorkflowActionModelCollectionQuery>(
            key: "assets",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_WorkflowActionModelCollectionQuery> get usage =>
      NumModelQuerySelector<_$_WorkflowActionModelCollectionQuery>(
        key: "usage",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowActionModelCollectionQuery> get search =>
      StringModelQuerySelector<_$_WorkflowActionModelCollectionQuery>(
        key: "search",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowActionModelCollectionQuery> get token =>
      StringModelQuerySelector<_$_WorkflowActionModelCollectionQuery>(
        key: "token",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelTimestampModelQuerySelector<_$_WorkflowActionModelCollectionQuery>
      get tokenExpiredTime => ModelTimestampModelQuerySelector<
              _$_WorkflowActionModelCollectionQuery>(
            key: "tokenExpiredTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowActionModelCollectionQuery>
      get startTime => ModelTimestampModelQuerySelector<
              _$_WorkflowActionModelCollectionQuery>(
            key: "startTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowActionModelCollectionQuery>
      get finishedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowActionModelCollectionQuery>(
            key: "finishedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowActionModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_WorkflowActionModelCollectionQuery>(
            key: "createdTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowActionModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowActionModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$WorkflowActionModelMirrorRefPath = _$WorkflowActionModelRefPath;
typedef _$WorkflowActionModelMirrorInitialCollection
    = _$WorkflowActionModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowActionModelFormQuery {
  const _$WorkflowActionModelFormQuery();

  @useResult
  _$_WorkflowActionModelFormQuery call(WorkflowActionModel value) {
    return _$_WorkflowActionModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowActionModelFormQuery
    extends FormControllerQueryBase<WorkflowActionModel> {
  const _$_WorkflowActionModelFormQuery(this.value);

  final WorkflowActionModel value;

  @override
  FormController<WorkflowActionModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
