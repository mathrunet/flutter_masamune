// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_page.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowPageModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowPageModelKeys {
  organization,
  project,
  content,
  path,
  locale,
  createdTime,
  updatedTime,
}

class _$WorkflowPageModelDocument extends DocumentBase<WorkflowPageModel>
    with
        ModelRefMixin<WorkflowPageModel>,
        ModelRefLoaderMixin<WorkflowPageModel> {
  _$WorkflowPageModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowPageModel fromMap(DynamicMap map) => WorkflowPageModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowPageModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<WorkflowPageModel>> get builder => [
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

typedef _$WorkflowPageModelMirrorDocument = _$WorkflowPageModelDocument;

class _$WorkflowPageModelCollection
    extends CollectionBase<_$WorkflowPageModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowPageModelDocument,
            _$_WorkflowPageModelCollectionQuery> {
  _$WorkflowPageModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowPageModelDocument create([String? id]) =>
      _$WorkflowPageModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowPageModelDocument>> filter(
    _$_WorkflowPageModelCollectionQuery Function(
      _$_WorkflowPageModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowPageModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowPageModelMirrorCollection = _$WorkflowPageModelCollection;

@immutable
class _$WorkflowPageModelRefPath extends ModelRefPath<WorkflowPageModel> {
  const _$WorkflowPageModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/page/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowPageModelInitialCollection
    extends ModelInitialCollection<WorkflowPageModel> {
  const _$WorkflowPageModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/page";

  @override
  DynamicMap toMap(WorkflowPageModel value) => value.rawValue;
}

@immutable
class _$WorkflowPageModelDocumentQuery {
  const _$WorkflowPageModelDocumentQuery();

  @useResult
  _$_WorkflowPageModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowPageModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/page/$_id",
        adapter: adapter ?? _$WorkflowPageModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$WorkflowPageModelDocument.defaultModelAccessQuery,
        validationQueries: _$WorkflowPageModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/page/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowPageModelDocumentQuery
    extends ModelQueryBase<_$WorkflowPageModelDocument> {
  const _$_WorkflowPageModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowPageModelDocument Function() call(Ref ref) =>
      () => _$WorkflowPageModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowPageModelCollectionQuery {
  const _$WorkflowPageModelCollectionQuery();

  @useResult
  _$_WorkflowPageModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowPageModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/page",
        adapter: adapter ?? _$WorkflowPageModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowPageModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowPageModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^plugins/workflow/page$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowPageModelCollectionQuery
    extends ModelQueryBase<_$WorkflowPageModelCollection> {
  const _$_WorkflowPageModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowPageModelCollection Function() call(Ref ref) =>
      () => _$WorkflowPageModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowPageModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowPageModelCollectionQuery(query);

  _$_WorkflowPageModelCollectionQuery collectionGroup() =>
      _$_WorkflowPageModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowPageModelCollectionQuery reset() =>
      _$_WorkflowPageModelCollectionQuery(modelQuery.reset());

  _$_WorkflowPageModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowPageModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowPageModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowPageModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_WorkflowPageModelCollectionQuery limitTo(int value) =>
      _$_WorkflowPageModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowPageModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowPageModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowPageModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowPageModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<WorkflowProjectModel,
          _$_WorkflowPageModelCollectionQuery>
      get project => ModelRefModelQuerySelector<WorkflowProjectModel,
              _$_WorkflowPageModelCollectionQuery>(
          key: "project", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_WorkflowPageModelCollectionQuery> get content =>
      StringModelQuerySelector<_$_WorkflowPageModelCollectionQuery>(
        key: "content",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowPageModelCollectionQuery> get path =>
      StringModelQuerySelector<_$_WorkflowPageModelCollectionQuery>(
        key: "path",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelLocaleModelQuerySelector<_$_WorkflowPageModelCollectionQuery>
      get locale =>
          ModelLocaleModelQuerySelector<_$_WorkflowPageModelCollectionQuery>(
            key: "locale",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowPageModelCollectionQuery>
      get createdTime =>
          ModelTimestampModelQuerySelector<_$_WorkflowPageModelCollectionQuery>(
            key: "createdTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowPageModelCollectionQuery>
      get updatedTime =>
          ModelTimestampModelQuerySelector<_$_WorkflowPageModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$WorkflowPageModelMirrorRefPath = _$WorkflowPageModelRefPath;
typedef _$WorkflowPageModelMirrorInitialCollection
    = _$WorkflowPageModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowPageModelFormQuery {
  const _$WorkflowPageModelFormQuery();

  @useResult
  _$_WorkflowPageModelFormQuery call(WorkflowPageModel value) {
    return _$_WorkflowPageModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowPageModelFormQuery
    extends FormControllerQueryBase<WorkflowPageModel> {
  const _$_WorkflowPageModelFormQuery(this.value);

  final WorkflowPageModel value;

  @override
  FormController<WorkflowPageModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
