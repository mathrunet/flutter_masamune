// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_plan.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowPlanModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowPlanModelKeys { limit, burst }

class _$WorkflowPlanModelDocument extends DocumentBase<WorkflowPlanModel>
    with ModelRefMixin<WorkflowPlanModel> {
  _$WorkflowPlanModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowPlanModel fromMap(DynamicMap map) => WorkflowPlanModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowPlanModel value) => value.rawValue;
}

typedef _$WorkflowPlanModelMirrorDocument = _$WorkflowPlanModelDocument;

class _$WorkflowPlanModelCollection
    extends CollectionBase<_$WorkflowPlanModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowPlanModelDocument,
            _$_WorkflowPlanModelCollectionQuery> {
  _$WorkflowPlanModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowPlanModelDocument create([String? id]) =>
      _$WorkflowPlanModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowPlanModelDocument>> filter(
    _$_WorkflowPlanModelCollectionQuery Function(
      _$_WorkflowPlanModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowPlanModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowPlanModelMirrorCollection = _$WorkflowPlanModelCollection;

@immutable
class _$WorkflowPlanModelRefPath extends ModelRefPath<WorkflowPlanModel> {
  const _$WorkflowPlanModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/plan/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowPlanModelInitialCollection
    extends ModelInitialCollection<WorkflowPlanModel> {
  const _$WorkflowPlanModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/plan";

  @override
  DynamicMap toMap(WorkflowPlanModel value) => value.rawValue;
}

@immutable
class _$WorkflowPlanModelDocumentQuery {
  const _$WorkflowPlanModelDocumentQuery();

  @useResult
  _$_WorkflowPlanModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowPlanModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/plan/$_id",
        adapter: adapter ?? _$WorkflowPlanModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$WorkflowPlanModelDocument.defaultModelAccessQuery,
        validationQueries: _$WorkflowPlanModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/plan/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowPlanModelDocumentQuery
    extends ModelQueryBase<_$WorkflowPlanModelDocument> {
  const _$_WorkflowPlanModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowPlanModelDocument Function() call(Ref ref) =>
      () => _$WorkflowPlanModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowPlanModelCollectionQuery {
  const _$WorkflowPlanModelCollectionQuery();

  @useResult
  _$_WorkflowPlanModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowPlanModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/plan",
        adapter: adapter ?? _$WorkflowPlanModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowPlanModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowPlanModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^plugins/workflow/plan$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowPlanModelCollectionQuery
    extends ModelQueryBase<_$WorkflowPlanModelCollection> {
  const _$_WorkflowPlanModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowPlanModelCollection Function() call(Ref ref) =>
      () => _$WorkflowPlanModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowPlanModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowPlanModelCollectionQuery(query);

  _$_WorkflowPlanModelCollectionQuery collectionGroup() =>
      _$_WorkflowPlanModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowPlanModelCollectionQuery reset() =>
      _$_WorkflowPlanModelCollectionQuery(modelQuery.reset());

  _$_WorkflowPlanModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowPlanModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowPlanModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowPlanModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_WorkflowPlanModelCollectionQuery limitTo(int value) =>
      _$_WorkflowPlanModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowPlanModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowPlanModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_WorkflowPlanModelCollectionQuery> get limit =>
      NumModelQuerySelector<_$_WorkflowPlanModelCollectionQuery>(
        key: "limit",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_WorkflowPlanModelCollectionQuery> get burst =>
      NumModelQuerySelector<_$_WorkflowPlanModelCollectionQuery>(
        key: "burst",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );
}

typedef _$WorkflowPlanModelMirrorRefPath = _$WorkflowPlanModelRefPath;
typedef _$WorkflowPlanModelMirrorInitialCollection
    = _$WorkflowPlanModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowPlanModelFormQuery {
  const _$WorkflowPlanModelFormQuery();

  @useResult
  _$_WorkflowPlanModelFormQuery call(WorkflowPlanModel value) {
    return _$_WorkflowPlanModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowPlanModelFormQuery
    extends FormControllerQueryBase<WorkflowPlanModel> {
  const _$_WorkflowPlanModelFormQuery(this.value);

  final WorkflowPlanModel value;

  @override
  FormController<WorkflowPlanModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
