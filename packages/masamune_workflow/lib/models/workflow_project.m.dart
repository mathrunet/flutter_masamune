// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_project.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowProjectModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowProjectModelKeys {
  name,
  description,
  concept,
  goal,
  target,
  locale,
  kpi,
  organization,
  icon,
  googleAccessToken,
  googleRefreshToken,
  googleServiceAccount,
  githubPersonalAccessToken,
  appstoreIssuerId,
  appstoreAuthKeyId,
  appstoreAuthKey,
  createdTime,
  updatedTime,
}

class _$WorkflowProjectModelDocument extends DocumentBase<WorkflowProjectModel>
    with
        ModelRefMixin<WorkflowProjectModel>,
        ModelRefLoaderMixin<WorkflowProjectModel> {
  _$WorkflowProjectModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowProjectModel fromMap(DynamicMap map) =>
      WorkflowProjectModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowProjectModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<WorkflowProjectModel>> get builder => [
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

typedef _$WorkflowProjectModelMirrorDocument = _$WorkflowProjectModelDocument;

class _$WorkflowProjectModelCollection
    extends CollectionBase<_$WorkflowProjectModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowProjectModelDocument,
            _$_WorkflowProjectModelCollectionQuery> {
  _$WorkflowProjectModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowProjectModelDocument create([String? id]) =>
      _$WorkflowProjectModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowProjectModelDocument>> filter(
    _$_WorkflowProjectModelCollectionQuery Function(
      _$_WorkflowProjectModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowProjectModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowProjectModelMirrorCollection
    = _$WorkflowProjectModelCollection;

@immutable
class _$WorkflowProjectModelRefPath extends ModelRefPath<WorkflowProjectModel> {
  const _$WorkflowProjectModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/project/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowProjectModelInitialCollection
    extends ModelInitialCollection<WorkflowProjectModel> {
  const _$WorkflowProjectModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/project";

  @override
  DynamicMap toMap(WorkflowProjectModel value) => value.rawValue;
}

@immutable
class _$WorkflowProjectModelDocumentQuery {
  const _$WorkflowProjectModelDocumentQuery();

  @useResult
  _$_WorkflowProjectModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowProjectModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/project/$_id",
        adapter: adapter ?? _$WorkflowProjectModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowProjectModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowProjectModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/project/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowProjectModelDocumentQuery
    extends ModelQueryBase<_$WorkflowProjectModelDocument> {
  const _$_WorkflowProjectModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowProjectModelDocument Function() call(Ref ref) =>
      () => _$WorkflowProjectModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowProjectModelCollectionQuery {
  const _$WorkflowProjectModelCollectionQuery();

  @useResult
  _$_WorkflowProjectModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowProjectModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/project",
        adapter:
            adapter ?? _$WorkflowProjectModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowProjectModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowProjectModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^plugins/workflow/project$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowProjectModelCollectionQuery
    extends ModelQueryBase<_$WorkflowProjectModelCollection> {
  const _$_WorkflowProjectModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowProjectModelCollection Function() call(Ref ref) =>
      () => _$WorkflowProjectModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowProjectModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowProjectModelCollectionQuery(query);

  _$_WorkflowProjectModelCollectionQuery collectionGroup() =>
      _$_WorkflowProjectModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowProjectModelCollectionQuery reset() =>
      _$_WorkflowProjectModelCollectionQuery(modelQuery.reset());

  _$_WorkflowProjectModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowProjectModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowProjectModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowProjectModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_WorkflowProjectModelCollectionQuery limitTo(int value) =>
      _$_WorkflowProjectModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get description =>
          StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "description",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get concept =>
          StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "concept",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery> get goal =>
      StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
        key: "goal",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery> get target =>
      StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
        key: "target",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelLocaleModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get locale =>
          ModelLocaleModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "locale",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  MapModelQuerySelector<dynamic, _$_WorkflowProjectModelCollectionQuery>
      get kpi => MapModelQuerySelector<dynamic,
              _$_WorkflowProjectModelCollectionQuery>(
            key: "kpi",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowProjectModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowProjectModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery> get icon =>
      StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
        key: "icon",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get googleAccessToken =>
          StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "googleAccessToken",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get googleRefreshToken =>
          StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "googleRefreshToken",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get googleServiceAccount =>
          StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "googleServiceAccount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get githubPersonalAccessToken =>
          StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "githubPersonalAccessToken",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get appstoreIssuerId =>
          StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "appstoreIssuerId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get appstoreAuthKeyId =>
          StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "appstoreAuthKeyId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get appstoreAuthKey =>
          StringModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>(
            key: "appstoreAuthKey",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_WorkflowProjectModelCollectionQuery>(
            key: "createdTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowProjectModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowProjectModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$WorkflowProjectModelMirrorRefPath = _$WorkflowProjectModelRefPath;
typedef _$WorkflowProjectModelMirrorInitialCollection
    = _$WorkflowProjectModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowProjectModelFormQuery {
  const _$WorkflowProjectModelFormQuery();

  @useResult
  _$_WorkflowProjectModelFormQuery call(WorkflowProjectModel value) {
    return _$_WorkflowProjectModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowProjectModelFormQuery
    extends FormControllerQueryBase<WorkflowProjectModel> {
  const _$_WorkflowProjectModelFormQuery(this.value);

  final WorkflowProjectModel value;

  @override
  FormController<WorkflowProjectModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
