// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_asset.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowAssetModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowAssetModelKeys {
  organization,
  source,
  content,
  path,
  mimtType,
  locale,
  createdTime,
  updatedTime,
}

class _$WorkflowAssetModelDocument extends DocumentBase<WorkflowAssetModel>
    with
        ModelRefMixin<WorkflowAssetModel>,
        ModelRefLoaderMixin<WorkflowAssetModel> {
  _$WorkflowAssetModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowAssetModel fromMap(DynamicMap map) =>
      WorkflowAssetModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowAssetModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<WorkflowAssetModel>> get builder => [
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

typedef _$WorkflowAssetModelMirrorDocument = _$WorkflowAssetModelDocument;

class _$WorkflowAssetModelCollection
    extends CollectionBase<_$WorkflowAssetModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowAssetModelDocument,
            _$_WorkflowAssetModelCollectionQuery> {
  _$WorkflowAssetModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowAssetModelDocument create([String? id]) =>
      _$WorkflowAssetModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowAssetModelDocument>> filter(
    _$_WorkflowAssetModelCollectionQuery Function(
      _$_WorkflowAssetModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowAssetModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowAssetModelMirrorCollection = _$WorkflowAssetModelCollection;

@immutable
class _$WorkflowAssetModelRefPath extends ModelRefPath<WorkflowAssetModel> {
  const _$WorkflowAssetModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/asset/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowAssetModelInitialCollection
    extends ModelInitialCollection<WorkflowAssetModel> {
  const _$WorkflowAssetModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/asset";

  @override
  DynamicMap toMap(WorkflowAssetModel value) => value.rawValue;
}

@immutable
class _$WorkflowAssetModelDocumentQuery {
  const _$WorkflowAssetModelDocumentQuery();

  @useResult
  _$_WorkflowAssetModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowAssetModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/asset/$_id",
        adapter: adapter ?? _$WorkflowAssetModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$WorkflowAssetModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowAssetModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/asset/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowAssetModelDocumentQuery
    extends ModelQueryBase<_$WorkflowAssetModelDocument> {
  const _$_WorkflowAssetModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowAssetModelDocument Function() call(Ref ref) =>
      () => _$WorkflowAssetModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowAssetModelCollectionQuery {
  const _$WorkflowAssetModelCollectionQuery();

  @useResult
  _$_WorkflowAssetModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowAssetModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/asset",
        adapter: adapter ?? _$WorkflowAssetModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowAssetModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowAssetModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^plugins/workflow/asset$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowAssetModelCollectionQuery
    extends ModelQueryBase<_$WorkflowAssetModelCollection> {
  const _$_WorkflowAssetModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowAssetModelCollection Function() call(Ref ref) =>
      () => _$WorkflowAssetModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowAssetModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowAssetModelCollectionQuery(query);

  _$_WorkflowAssetModelCollectionQuery collectionGroup() =>
      _$_WorkflowAssetModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowAssetModelCollectionQuery reset() =>
      _$_WorkflowAssetModelCollectionQuery(modelQuery.reset());

  _$_WorkflowAssetModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowAssetModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowAssetModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowAssetModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_WorkflowAssetModelCollectionQuery limitTo(int value) =>
      _$_WorkflowAssetModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowAssetModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowAssetModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery> get source =>
      StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery>(
        key: "source",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery> get content =>
      StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery>(
        key: "content",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery> get path =>
      StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery>(
        key: "path",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery> get mimtType =>
      StringModelQuerySelector<_$_WorkflowAssetModelCollectionQuery>(
        key: "mimtType",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelLocaleModelQuerySelector<_$_WorkflowAssetModelCollectionQuery>
      get locale =>
          ModelLocaleModelQuerySelector<_$_WorkflowAssetModelCollectionQuery>(
            key: "locale",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowAssetModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_WorkflowAssetModelCollectionQuery>(
            key: "createdTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowAssetModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowAssetModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$WorkflowAssetModelMirrorRefPath = _$WorkflowAssetModelRefPath;
typedef _$WorkflowAssetModelMirrorInitialCollection
    = _$WorkflowAssetModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowAssetModelFormQuery {
  const _$WorkflowAssetModelFormQuery();

  @useResult
  _$_WorkflowAssetModelFormQuery call(WorkflowAssetModel value) {
    return _$_WorkflowAssetModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowAssetModelFormQuery
    extends FormControllerQueryBase<WorkflowAssetModel> {
  const _$_WorkflowAssetModelFormQuery(this.value);

  final WorkflowAssetModel value;

  @override
  FormController<WorkflowAssetModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
