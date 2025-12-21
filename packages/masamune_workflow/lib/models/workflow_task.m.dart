// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_task.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowTaskModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "actions": actions.map((e) => e.toJson()).toList(),
      "nextAction": nextAction?.toJson(),
      "log": log.map((e) => e.toJson()).toList(),
    };
  }
}

enum _$WorkflowTaskModelKeys {
  workflow,
  organization,
  project,
  locale,
  status,
  actions,
  currentAction,
  nextAction,
  error,
  log,
  prompt,
  materials,
  results,
  assets,
  search,
  usage,
  startTime,
  finishedTime,
  createdTime,
  updatedTime,
}

class _$WorkflowTaskModelDocument extends DocumentBase<WorkflowTaskModel>
    with
        ModelRefMixin<WorkflowTaskModel>,
        SearchableDocumentMixin<WorkflowTaskModel>,
        ModelRefLoaderMixin<WorkflowTaskModel> {
  _$WorkflowTaskModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowTaskModel fromMap(DynamicMap map) => WorkflowTaskModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowTaskModel value) => value.rawValue;

  @override
  String buildSearchText(WorkflowTaskModel value) =>
      (value.search?.toString() ?? "");

  @override
  List<ModelRefBuilderBase<WorkflowTaskModel>> get builder => [
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
        ModelRefBuilder(
          modelRef: (value) => value.currentAction,
          document: (modelQuery) => WorkflowActionModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(currentAction: doc),
          adapter: WorkflowActionModelDocument.defaultModelAdapter,
          accessQuery: WorkflowActionModelDocument.defaultModelAccessQuery,
          validationQueries:
              WorkflowActionModelDocument.defaultValidationQueries,
        ),
      ];
}

typedef _$WorkflowTaskModelMirrorDocument = _$WorkflowTaskModelDocument;

class _$WorkflowTaskModelCollection
    extends CollectionBase<_$WorkflowTaskModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowTaskModelDocument,
            _$_WorkflowTaskModelCollectionQuery>,
        SearchableCollectionMixin<_$WorkflowTaskModelDocument> {
  _$WorkflowTaskModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowTaskModelDocument create([String? id]) =>
      _$WorkflowTaskModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowTaskModelDocument>> filter(
    _$_WorkflowTaskModelCollectionQuery Function(
      _$_WorkflowTaskModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowTaskModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowTaskModelMirrorCollection = _$WorkflowTaskModelCollection;

@immutable
class _$WorkflowTaskModelRefPath extends ModelRefPath<WorkflowTaskModel> {
  const _$WorkflowTaskModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/task/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowTaskModelInitialCollection
    extends ModelInitialCollection<WorkflowTaskModel>
    with SearchableInitialCollectionMixin<WorkflowTaskModel> {
  const _$WorkflowTaskModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/task";

  @override
  DynamicMap toMap(WorkflowTaskModel value) => value.rawValue;

  @override
  String buildSearchText(WorkflowTaskModel value) =>
      (value.search?.toString() ?? "");
}

@immutable
class _$WorkflowTaskModelDocumentQuery {
  const _$WorkflowTaskModelDocumentQuery();

  @useResult
  _$_WorkflowTaskModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowTaskModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/task/$_id",
        adapter: adapter ?? _$WorkflowTaskModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$WorkflowTaskModelDocument.defaultModelAccessQuery,
        validationQueries: _$WorkflowTaskModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/task/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowTaskModelDocumentQuery
    extends ModelQueryBase<_$WorkflowTaskModelDocument> {
  const _$_WorkflowTaskModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowTaskModelDocument Function() call(Ref ref) =>
      () => _$WorkflowTaskModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowTaskModelCollectionQuery {
  const _$WorkflowTaskModelCollectionQuery();

  @useResult
  _$_WorkflowTaskModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowTaskModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/task",
        adapter: adapter ?? _$WorkflowTaskModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowTaskModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowTaskModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^plugins/workflow/task$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowTaskModelCollectionQuery
    extends ModelQueryBase<_$WorkflowTaskModelCollection> {
  const _$_WorkflowTaskModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowTaskModelCollection Function() call(Ref ref) =>
      () => _$WorkflowTaskModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowTaskModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowTaskModelCollectionQuery(query);

  _$_WorkflowTaskModelCollectionQuery collectionGroup() =>
      _$_WorkflowTaskModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowTaskModelCollectionQuery reset() =>
      _$_WorkflowTaskModelCollectionQuery(modelQuery.reset());

  _$_WorkflowTaskModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowTaskModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowTaskModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowTaskModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_WorkflowTaskModelCollectionQuery limitTo(int value) =>
      _$_WorkflowTaskModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowTaskModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelRefModelQuerySelector<WorkflowWorkflowModel,
          _$_WorkflowTaskModelCollectionQuery>
      get workflow => ModelRefModelQuerySelector<WorkflowWorkflowModel,
              _$_WorkflowTaskModelCollectionQuery>(
          key: "workflow", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowTaskModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowTaskModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<WorkflowProjectModel,
          _$_WorkflowTaskModelCollectionQuery>
      get project => ModelRefModelQuerySelector<WorkflowProjectModel,
              _$_WorkflowTaskModelCollectionQuery>(
          key: "project", toQuery: _toQuery, modelQuery: modelQuery);

  ModelLocaleModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>
      get locale =>
          ModelLocaleModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>(
            key: "locale",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ValueModelQuerySelector<WorkflowTaskStatus,
          _$_WorkflowTaskModelCollectionQuery>
      get status => ValueModelQuerySelector<WorkflowTaskStatus,
              _$_WorkflowTaskModelCollectionQuery>(
          key: "status", toQuery: _toQuery, modelQuery: modelQuery);

  ListModelQuerySelector<WorkflowActionCommandValue,
          _$_WorkflowTaskModelCollectionQuery>
      get actions => ListModelQuerySelector<WorkflowActionCommandValue,
              _$_WorkflowTaskModelCollectionQuery>(
          key: "actions", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<WorkflowActionModel,
          _$_WorkflowTaskModelCollectionQuery>
      get currentAction => ModelRefModelQuerySelector<WorkflowActionModel,
              _$_WorkflowTaskModelCollectionQuery>(
          key: "currentAction", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<WorkflowActionCommandValue,
          _$_WorkflowTaskModelCollectionQuery>
      get nextAction => ValueModelQuerySelector<WorkflowActionCommandValue,
              _$_WorkflowTaskModelCollectionQuery>(
          key: "nextAction", toQuery: _toQuery, modelQuery: modelQuery);

  MapModelQuerySelector<dynamic, _$_WorkflowTaskModelCollectionQuery>
      get error =>
          MapModelQuerySelector<dynamic, _$_WorkflowTaskModelCollectionQuery>(
            key: "error",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ListModelQuerySelector<WorkflowTaskLogValue,
      _$_WorkflowTaskModelCollectionQuery> get log => ListModelQuerySelector<
          WorkflowTaskLogValue, _$_WorkflowTaskModelCollectionQuery>(
      key: "log", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_WorkflowTaskModelCollectionQuery> get prompt =>
      StringModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>(
        key: "prompt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  MapModelQuerySelector<dynamic, _$_WorkflowTaskModelCollectionQuery>
      get materials =>
          MapModelQuerySelector<dynamic, _$_WorkflowTaskModelCollectionQuery>(
            key: "materials",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  MapModelQuerySelector<dynamic, _$_WorkflowTaskModelCollectionQuery>
      get results =>
          MapModelQuerySelector<dynamic, _$_WorkflowTaskModelCollectionQuery>(
            key: "results",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  MapModelQuerySelector<dynamic, _$_WorkflowTaskModelCollectionQuery>
      get assets =>
          MapModelQuerySelector<dynamic, _$_WorkflowTaskModelCollectionQuery>(
            key: "assets",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowTaskModelCollectionQuery> get search =>
      StringModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>(
        key: "search",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_WorkflowTaskModelCollectionQuery> get usage =>
      NumModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>(
        key: "usage",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelTimestampModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>
      get startTime =>
          ModelTimestampModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>(
            key: "startTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>
      get finishedTime =>
          ModelTimestampModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>(
            key: "finishedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>
      get createdTime =>
          ModelTimestampModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>(
            key: "createdTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>
      get updatedTime =>
          ModelTimestampModelQuerySelector<_$_WorkflowTaskModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$WorkflowTaskModelMirrorRefPath = _$WorkflowTaskModelRefPath;
typedef _$WorkflowTaskModelMirrorInitialCollection
    = _$WorkflowTaskModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowTaskModelFormQuery {
  const _$WorkflowTaskModelFormQuery();

  @useResult
  _$_WorkflowTaskModelFormQuery call(WorkflowTaskModel value) {
    return _$_WorkflowTaskModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowTaskModelFormQuery
    extends FormControllerQueryBase<WorkflowTaskModel> {
  const _$_WorkflowTaskModelFormQuery(this.value);

  final WorkflowTaskModel value;

  @override
  FormController<WorkflowTaskModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
