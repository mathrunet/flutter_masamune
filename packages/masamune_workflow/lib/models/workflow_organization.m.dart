// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_organization.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowOrganizationModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowOrganizationModelKeys {
  name,
  description,
  icon,
  ownerId,
  createdTime,
  updatedTime,
}

class _$WorkflowOrganizationModelDocument
    extends DocumentBase<WorkflowOrganizationModel>
    with ModelRefMixin<WorkflowOrganizationModel> {
  _$WorkflowOrganizationModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowOrganizationModel fromMap(DynamicMap map) =>
      WorkflowOrganizationModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowOrganizationModel value) => value.rawValue;
}

typedef _$WorkflowOrganizationModelMirrorDocument
    = _$WorkflowOrganizationModelDocument;

class _$WorkflowOrganizationModelCollection
    extends CollectionBase<_$WorkflowOrganizationModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowOrganizationModelDocument,
            _$_WorkflowOrganizationModelCollectionQuery> {
  _$WorkflowOrganizationModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowOrganizationModelDocument create([String? id]) =>
      _$WorkflowOrganizationModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowOrganizationModelDocument>> filter(
    _$_WorkflowOrganizationModelCollectionQuery Function(
      _$_WorkflowOrganizationModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowOrganizationModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowOrganizationModelMirrorCollection
    = _$WorkflowOrganizationModelCollection;

@immutable
class _$WorkflowOrganizationModelRefPath
    extends ModelRefPath<WorkflowOrganizationModel> {
  const _$WorkflowOrganizationModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/organization/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowOrganizationModelInitialCollection
    extends ModelInitialCollection<WorkflowOrganizationModel> {
  const _$WorkflowOrganizationModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/organization";

  @override
  DynamicMap toMap(WorkflowOrganizationModel value) => value.rawValue;
}

@immutable
class _$WorkflowOrganizationModelDocumentQuery {
  const _$WorkflowOrganizationModelDocumentQuery();

  @useResult
  _$_WorkflowOrganizationModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowOrganizationModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/organization/$_id",
        adapter:
            adapter ?? _$WorkflowOrganizationModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowOrganizationModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowOrganizationModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/organization/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowOrganizationModelDocumentQuery
    extends ModelQueryBase<_$WorkflowOrganizationModelDocument> {
  const _$_WorkflowOrganizationModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowOrganizationModelDocument Function() call(Ref ref) =>
      () => _$WorkflowOrganizationModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowOrganizationModelCollectionQuery {
  const _$WorkflowOrganizationModelCollectionQuery();

  @useResult
  _$_WorkflowOrganizationModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowOrganizationModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/organization",
        adapter: adapter ??
            _$WorkflowOrganizationModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowOrganizationModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowOrganizationModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/organization$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowOrganizationModelCollectionQuery
    extends ModelQueryBase<_$WorkflowOrganizationModelCollection> {
  const _$_WorkflowOrganizationModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowOrganizationModelCollection Function() call(Ref ref) =>
      () => _$WorkflowOrganizationModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowOrganizationModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowOrganizationModelCollectionQuery(query);

  _$_WorkflowOrganizationModelCollectionQuery collectionGroup() =>
      _$_WorkflowOrganizationModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowOrganizationModelCollectionQuery reset() =>
      _$_WorkflowOrganizationModelCollectionQuery(modelQuery.reset());

  _$_WorkflowOrganizationModelCollectionQuery remove(
    ModelQueryFilterType type,
  ) =>
      _$_WorkflowOrganizationModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowOrganizationModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowOrganizationModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_WorkflowOrganizationModelCollectionQuery limitTo(int value) =>
      _$_WorkflowOrganizationModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>
      get uid =>
          StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>(
            key: "@uid",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>
      get name =>
          StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>(
            key: "name",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>
      get description =>
          StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>(
            key: "description",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>
      get icon =>
          StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>(
            key: "icon",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>
      get ownerId =>
          StringModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>(
            key: "ownerId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_WorkflowOrganizationModelCollectionQuery>(
          key: "createdTime", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_WorkflowOrganizationModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowOrganizationModelCollectionQuery>(
          key: "updatedTime", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$WorkflowOrganizationModelMirrorRefPath
    = _$WorkflowOrganizationModelRefPath;
typedef _$WorkflowOrganizationModelMirrorInitialCollection
    = _$WorkflowOrganizationModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowOrganizationModelFormQuery {
  const _$WorkflowOrganizationModelFormQuery();

  @useResult
  _$_WorkflowOrganizationModelFormQuery call(WorkflowOrganizationModel value) {
    return _$_WorkflowOrganizationModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowOrganizationModelFormQuery
    extends FormControllerQueryBase<WorkflowOrganizationModel> {
  const _$_WorkflowOrganizationModelFormQuery(this.value);

  final WorkflowOrganizationModel value;

  @override
  FormController<WorkflowOrganizationModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
