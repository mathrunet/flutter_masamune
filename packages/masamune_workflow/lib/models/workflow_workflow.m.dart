// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_workflow.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowWorkflowModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {...map, "actions": actions.map((e) => e.toJson()).toList()};
  }
}

enum _$WorkflowWorkflowModelKeys {
  name,
  project,
  locale,
  organization,
  repeat,
  actions,
  prompt,
  materials,
  nextTime,
  startTime,
  createdTime,
  updatedTime,
}

class _$WorkflowWorkflowModelDocument
    extends DocumentBase<WorkflowWorkflowModel>
    with
        ModelRefMixin<WorkflowWorkflowModel>,
        ModelRefLoaderMixin<WorkflowWorkflowModel> {
  _$WorkflowWorkflowModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowWorkflowModel fromMap(DynamicMap map) =>
      WorkflowWorkflowModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowWorkflowModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<WorkflowWorkflowModel>> get builder => [
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
      ];
}

typedef _$WorkflowWorkflowModelMirrorDocument = _$WorkflowWorkflowModelDocument;

class _$WorkflowWorkflowModelCollection
    extends CollectionBase<_$WorkflowWorkflowModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowWorkflowModelDocument,
            _$_WorkflowWorkflowModelCollectionQuery> {
  _$WorkflowWorkflowModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowWorkflowModelDocument create([String? id]) =>
      _$WorkflowWorkflowModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowWorkflowModelDocument>> filter(
    _$_WorkflowWorkflowModelCollectionQuery Function(
      _$_WorkflowWorkflowModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowWorkflowModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowWorkflowModelMirrorCollection
    = _$WorkflowWorkflowModelCollection;

@immutable
class _$WorkflowWorkflowModelRefPath
    extends ModelRefPath<WorkflowWorkflowModel> {
  const _$WorkflowWorkflowModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/workflow/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowWorkflowModelInitialCollection
    extends ModelInitialCollection<WorkflowWorkflowModel> {
  const _$WorkflowWorkflowModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/workflow";

  @override
  DynamicMap toMap(WorkflowWorkflowModel value) => value.rawValue;
}

@immutable
class _$WorkflowWorkflowModelDocumentQuery {
  const _$WorkflowWorkflowModelDocumentQuery();

  @useResult
  _$_WorkflowWorkflowModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowWorkflowModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/workflow/$_id",
        adapter: adapter ?? _$WorkflowWorkflowModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowWorkflowModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowWorkflowModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/workflow/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowWorkflowModelDocumentQuery
    extends ModelQueryBase<_$WorkflowWorkflowModelDocument> {
  const _$_WorkflowWorkflowModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowWorkflowModelDocument Function() call(Ref ref) =>
      () => _$WorkflowWorkflowModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowWorkflowModelCollectionQuery {
  const _$WorkflowWorkflowModelCollectionQuery();

  @useResult
  _$_WorkflowWorkflowModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowWorkflowModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/workflow",
        adapter:
            adapter ?? _$WorkflowWorkflowModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowWorkflowModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowWorkflowModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^plugins/workflow/workflow$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowWorkflowModelCollectionQuery
    extends ModelQueryBase<_$WorkflowWorkflowModelCollection> {
  const _$_WorkflowWorkflowModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowWorkflowModelCollection Function() call(Ref ref) =>
      () => _$WorkflowWorkflowModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowWorkflowModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowWorkflowModelCollectionQuery(query);

  _$_WorkflowWorkflowModelCollectionQuery collectionGroup() =>
      _$_WorkflowWorkflowModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowWorkflowModelCollectionQuery reset() =>
      _$_WorkflowWorkflowModelCollectionQuery(modelQuery.reset());

  _$_WorkflowWorkflowModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowWorkflowModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowWorkflowModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowWorkflowModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_WorkflowWorkflowModelCollectionQuery limitTo(int value) =>
      _$_WorkflowWorkflowModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelRefModelQuerySelector<WorkflowProjectModel,
          _$_WorkflowWorkflowModelCollectionQuery>
      get project => ModelRefModelQuerySelector<WorkflowProjectModel,
              _$_WorkflowWorkflowModelCollectionQuery>(
          key: "project", toQuery: _toQuery, modelQuery: modelQuery);

  ModelLocaleModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery>
      get locale => ModelLocaleModelQuerySelector<
              _$_WorkflowWorkflowModelCollectionQuery>(
            key: "locale",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowWorkflowModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowWorkflowModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<WorkflowRepeat,
          _$_WorkflowWorkflowModelCollectionQuery>
      get repeat => ValueModelQuerySelector<WorkflowRepeat,
              _$_WorkflowWorkflowModelCollectionQuery>(
          key: "repeat", toQuery: _toQuery, modelQuery: modelQuery);

  ListModelQuerySelector<WorkflowActionCommandValue,
          _$_WorkflowWorkflowModelCollectionQuery>
      get actions => ListModelQuerySelector<WorkflowActionCommandValue,
              _$_WorkflowWorkflowModelCollectionQuery>(
          key: "actions", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery>
      get prompt =>
          StringModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery>(
            key: "prompt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  MapModelQuerySelector<dynamic, _$_WorkflowWorkflowModelCollectionQuery>
      get materials => MapModelQuerySelector<dynamic,
              _$_WorkflowWorkflowModelCollectionQuery>(
            key: "materials",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery>
      get nextTime => ModelTimestampModelQuerySelector<
              _$_WorkflowWorkflowModelCollectionQuery>(
            key: "nextTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery>
      get startTime => ModelTimestampModelQuerySelector<
              _$_WorkflowWorkflowModelCollectionQuery>(
            key: "startTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_WorkflowWorkflowModelCollectionQuery>(
            key: "createdTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowWorkflowModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowWorkflowModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$WorkflowWorkflowModelMirrorRefPath = _$WorkflowWorkflowModelRefPath;
typedef _$WorkflowWorkflowModelMirrorInitialCollection
    = _$WorkflowWorkflowModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowWorkflowModelFormQuery {
  const _$WorkflowWorkflowModelFormQuery();

  @useResult
  _$_WorkflowWorkflowModelFormQuery call(WorkflowWorkflowModel value) {
    return _$_WorkflowWorkflowModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowWorkflowModelFormQuery
    extends FormControllerQueryBase<WorkflowWorkflowModel> {
  const _$_WorkflowWorkflowModelFormQuery(this.value);

  final WorkflowWorkflowModel value;

  @override
  FormController<WorkflowWorkflowModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
