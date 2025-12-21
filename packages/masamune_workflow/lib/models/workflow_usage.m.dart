// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_usage.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowUsageModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowUsageModelKeys {
  organization,
  usage,
  latestPlan,
  bucketBalance,
  lastCheckTime,
  currentMonth,
  createdTime,
  updatedTime,
}

class _$WorkflowUsageModelDocument extends DocumentBase<WorkflowUsageModel>
    with
        ModelRefMixin<WorkflowUsageModel>,
        ModelRefLoaderMixin<WorkflowUsageModel> {
  _$WorkflowUsageModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowUsageModel fromMap(DynamicMap map) =>
      WorkflowUsageModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowUsageModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<WorkflowUsageModel>> get builder => [
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

typedef _$WorkflowUsageModelMirrorDocument = _$WorkflowUsageModelDocument;

class _$WorkflowUsageModelCollection
    extends CollectionBase<_$WorkflowUsageModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowUsageModelDocument,
            _$_WorkflowUsageModelCollectionQuery> {
  _$WorkflowUsageModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowUsageModelDocument create([String? id]) =>
      _$WorkflowUsageModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowUsageModelDocument>> filter(
    _$_WorkflowUsageModelCollectionQuery Function(
      _$_WorkflowUsageModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowUsageModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowUsageModelMirrorCollection = _$WorkflowUsageModelCollection;

@immutable
class _$WorkflowUsageModelRefPath extends ModelRefPath<WorkflowUsageModel> {
  const _$WorkflowUsageModelRefPath(super.uid, {required String organizationId})
      : _organizationId = organizationId;

  final String _organizationId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/organization/$_organizationId/usage/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowUsageModelInitialCollection
    extends ModelInitialCollection<WorkflowUsageModel> {
  const _$WorkflowUsageModelInitialCollection(
    super.value, {
    required String organizationId,
  }) : _organizationId = organizationId;

  final String _organizationId;

  @override
  String get path => "plugins/workflow/organization/$_organizationId/usage";

  @override
  DynamicMap toMap(WorkflowUsageModel value) => value.rawValue;
}

@immutable
class _$WorkflowUsageModelDocumentQuery {
  const _$WorkflowUsageModelDocumentQuery();

  @useResult
  _$_WorkflowUsageModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowUsageModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/organization/$organizationId/usage/$_id",
        adapter: adapter ?? _$WorkflowUsageModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$WorkflowUsageModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowUsageModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/organization/([^/]+)/usage/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowUsageModelDocumentQuery
    extends ModelQueryBase<_$WorkflowUsageModelDocument> {
  const _$_WorkflowUsageModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowUsageModelDocument Function() call(Ref ref) =>
      () => _$WorkflowUsageModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowUsageModelCollectionQuery {
  const _$WorkflowUsageModelCollectionQuery();

  @useResult
  _$_WorkflowUsageModelCollectionQuery call({
    required String organizationId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowUsageModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/organization/$organizationId/usage",
        adapter: adapter ?? _$WorkflowUsageModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowUsageModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowUsageModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/organization/([^/]+)/usage$".trimQuery().trimString(
            "/",
          ),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowUsageModelCollectionQuery
    extends ModelQueryBase<_$WorkflowUsageModelCollection> {
  const _$_WorkflowUsageModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowUsageModelCollection Function() call(Ref ref) =>
      () => _$WorkflowUsageModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowUsageModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowUsageModelCollectionQuery(query);

  _$_WorkflowUsageModelCollectionQuery collectionGroup() =>
      _$_WorkflowUsageModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowUsageModelCollectionQuery reset() =>
      _$_WorkflowUsageModelCollectionQuery(modelQuery.reset());

  _$_WorkflowUsageModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowUsageModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowUsageModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowUsageModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_WorkflowUsageModelCollectionQuery limitTo(int value) =>
      _$_WorkflowUsageModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowUsageModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowUsageModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowUsageModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  NumModelQuerySelector<_$_WorkflowUsageModelCollectionQuery> get usage =>
      NumModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>(
        key: "usage",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>
      get latestPlan =>
          StringModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>(
            key: "latestPlan",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>
      get bucketBalance =>
          NumModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>(
            key: "bucketBalance",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>
      get lastCheckTime => ModelTimestampModelQuerySelector<
              _$_WorkflowUsageModelCollectionQuery>(
            key: "lastCheckTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>
      get currentMonth =>
          StringModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>(
            key: "currentMonth",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_WorkflowUsageModelCollectionQuery>(
            key: "createdTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowUsageModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowUsageModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$WorkflowUsageModelMirrorRefPath = _$WorkflowUsageModelRefPath;
typedef _$WorkflowUsageModelMirrorInitialCollection
    = _$WorkflowUsageModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowUsageModelFormQuery {
  const _$WorkflowUsageModelFormQuery();

  @useResult
  _$_WorkflowUsageModelFormQuery call(WorkflowUsageModel value) {
    return _$_WorkflowUsageModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowUsageModelFormQuery
    extends FormControllerQueryBase<WorkflowUsageModel> {
  const _$_WorkflowUsageModelFormQuery(this.value);

  final WorkflowUsageModel value;

  @override
  FormController<WorkflowUsageModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
