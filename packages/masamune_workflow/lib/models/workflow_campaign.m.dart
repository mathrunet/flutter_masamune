// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_campaign.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowCampaignModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowCampaignModelKeys {
  organization,
  limit,
  expiredTime,
  createdTime,
  updatedTime,
}

class _$WorkflowCampaignModelDocument
    extends DocumentBase<WorkflowCampaignModel>
    with
        ModelRefMixin<WorkflowCampaignModel>,
        ModelRefLoaderMixin<WorkflowCampaignModel> {
  _$WorkflowCampaignModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowCampaignModel fromMap(DynamicMap map) =>
      WorkflowCampaignModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowCampaignModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<WorkflowCampaignModel>> get builder => [
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

typedef _$WorkflowCampaignModelMirrorDocument = _$WorkflowCampaignModelDocument;

class _$WorkflowCampaignModelCollection
    extends CollectionBase<_$WorkflowCampaignModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowCampaignModelDocument,
            _$_WorkflowCampaignModelCollectionQuery> {
  _$WorkflowCampaignModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowCampaignModelDocument create([String? id]) =>
      _$WorkflowCampaignModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowCampaignModelDocument>> filter(
    _$_WorkflowCampaignModelCollectionQuery Function(
      _$_WorkflowCampaignModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowCampaignModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowCampaignModelMirrorCollection
    = _$WorkflowCampaignModelCollection;

@immutable
class _$WorkflowCampaignModelRefPath
    extends ModelRefPath<WorkflowCampaignModel> {
  const _$WorkflowCampaignModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/campaign/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowCampaignModelInitialCollection
    extends ModelInitialCollection<WorkflowCampaignModel> {
  const _$WorkflowCampaignModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/campaign";

  @override
  DynamicMap toMap(WorkflowCampaignModel value) => value.rawValue;
}

@immutable
class _$WorkflowCampaignModelDocumentQuery {
  const _$WorkflowCampaignModelDocumentQuery();

  @useResult
  _$_WorkflowCampaignModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowCampaignModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/campaign/$_id",
        adapter: adapter ?? _$WorkflowCampaignModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowCampaignModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowCampaignModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/campaign/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowCampaignModelDocumentQuery
    extends ModelQueryBase<_$WorkflowCampaignModelDocument> {
  const _$_WorkflowCampaignModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowCampaignModelDocument Function() call(Ref ref) =>
      () => _$WorkflowCampaignModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowCampaignModelCollectionQuery {
  const _$WorkflowCampaignModelCollectionQuery();

  @useResult
  _$_WorkflowCampaignModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowCampaignModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/campaign",
        adapter:
            adapter ?? _$WorkflowCampaignModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowCampaignModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowCampaignModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^plugins/workflow/campaign$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowCampaignModelCollectionQuery
    extends ModelQueryBase<_$WorkflowCampaignModelCollection> {
  const _$_WorkflowCampaignModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowCampaignModelCollection Function() call(Ref ref) =>
      () => _$WorkflowCampaignModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowCampaignModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowCampaignModelCollectionQuery(query);

  _$_WorkflowCampaignModelCollectionQuery collectionGroup() =>
      _$_WorkflowCampaignModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowCampaignModelCollectionQuery reset() =>
      _$_WorkflowCampaignModelCollectionQuery(modelQuery.reset());

  _$_WorkflowCampaignModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowCampaignModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowCampaignModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowCampaignModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_WorkflowCampaignModelCollectionQuery limitTo(int value) =>
      _$_WorkflowCampaignModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowCampaignModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowCampaignModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowCampaignModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowCampaignModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  NumModelQuerySelector<_$_WorkflowCampaignModelCollectionQuery> get limit =>
      NumModelQuerySelector<_$_WorkflowCampaignModelCollectionQuery>(
        key: "limit",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelTimestampModelQuerySelector<_$_WorkflowCampaignModelCollectionQuery>
      get expiredTime => ModelTimestampModelQuerySelector<
              _$_WorkflowCampaignModelCollectionQuery>(
            key: "expiredTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowCampaignModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_WorkflowCampaignModelCollectionQuery>(
            key: "createdTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowCampaignModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowCampaignModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$WorkflowCampaignModelMirrorRefPath = _$WorkflowCampaignModelRefPath;
typedef _$WorkflowCampaignModelMirrorInitialCollection
    = _$WorkflowCampaignModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowCampaignModelFormQuery {
  const _$WorkflowCampaignModelFormQuery();

  @useResult
  _$_WorkflowCampaignModelFormQuery call(WorkflowCampaignModel value) {
    return _$_WorkflowCampaignModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowCampaignModelFormQuery
    extends FormControllerQueryBase<WorkflowCampaignModel> {
  const _$_WorkflowCampaignModelFormQuery(this.value);

  final WorkflowCampaignModel value;

  @override
  FormController<WorkflowCampaignModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
