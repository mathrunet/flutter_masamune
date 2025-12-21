// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_certificate.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowCertificateModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowCertificateModelKeys {
  organization,
  token,
  scope,
  expiredTime,
  createdTime,
  updatedTime,
}

class _$WorkflowCertificateModelDocument
    extends DocumentBase<WorkflowCertificateModel>
    with
        ModelRefMixin<WorkflowCertificateModel>,
        ModelRefLoaderMixin<WorkflowCertificateModel> {
  _$WorkflowCertificateModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowCertificateModel fromMap(DynamicMap map) =>
      WorkflowCertificateModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowCertificateModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<WorkflowCertificateModel>> get builder => [
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

typedef _$WorkflowCertificateModelMirrorDocument
    = _$WorkflowCertificateModelDocument;

class _$WorkflowCertificateModelCollection
    extends CollectionBase<_$WorkflowCertificateModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowCertificateModelDocument,
            _$_WorkflowCertificateModelCollectionQuery> {
  _$WorkflowCertificateModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowCertificateModelDocument create([String? id]) =>
      _$WorkflowCertificateModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowCertificateModelDocument>> filter(
    _$_WorkflowCertificateModelCollectionQuery Function(
      _$_WorkflowCertificateModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowCertificateModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowCertificateModelMirrorCollection
    = _$WorkflowCertificateModelCollection;

@immutable
class _$WorkflowCertificateModelRefPath
    extends ModelRefPath<WorkflowCertificateModel> {
  const _$WorkflowCertificateModelRefPath(
    super.uid, {
    required String organizationId,
  }) : _organizationId = organizationId;

  final String _organizationId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/organization/$_organizationId/certificate/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowCertificateModelInitialCollection
    extends ModelInitialCollection<WorkflowCertificateModel> {
  const _$WorkflowCertificateModelInitialCollection(
    super.value, {
    required String organizationId,
  }) : _organizationId = organizationId;

  final String _organizationId;

  @override
  String get path =>
      "plugins/workflow/organization/$_organizationId/certificate";

  @override
  DynamicMap toMap(WorkflowCertificateModel value) => value.rawValue;
}

@immutable
class _$WorkflowCertificateModelDocumentQuery {
  const _$WorkflowCertificateModelDocumentQuery();

  @useResult
  _$_WorkflowCertificateModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowCertificateModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/organization/$organizationId/certificate/$_id",
        adapter:
            adapter ?? _$WorkflowCertificateModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowCertificateModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowCertificateModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/organization/([^/]+)/certificate/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowCertificateModelDocumentQuery
    extends ModelQueryBase<_$WorkflowCertificateModelDocument> {
  const _$_WorkflowCertificateModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowCertificateModelDocument Function() call(Ref ref) =>
      () => _$WorkflowCertificateModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowCertificateModelCollectionQuery {
  const _$WorkflowCertificateModelCollectionQuery();

  @useResult
  _$_WorkflowCertificateModelCollectionQuery call({
    required String organizationId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowCertificateModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/organization/$organizationId/certificate",
        adapter:
            adapter ?? _$WorkflowCertificateModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowCertificateModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowCertificateModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/organization/([^/]+)/certificate$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowCertificateModelCollectionQuery
    extends ModelQueryBase<_$WorkflowCertificateModelCollection> {
  const _$_WorkflowCertificateModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowCertificateModelCollection Function() call(Ref ref) =>
      () => _$WorkflowCertificateModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowCertificateModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowCertificateModelCollectionQuery(query);

  _$_WorkflowCertificateModelCollectionQuery collectionGroup() =>
      _$_WorkflowCertificateModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowCertificateModelCollectionQuery reset() =>
      _$_WorkflowCertificateModelCollectionQuery(modelQuery.reset());

  _$_WorkflowCertificateModelCollectionQuery remove(
    ModelQueryFilterType type,
  ) =>
      _$_WorkflowCertificateModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowCertificateModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowCertificateModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_WorkflowCertificateModelCollectionQuery limitTo(int value) =>
      _$_WorkflowCertificateModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowCertificateModelCollectionQuery>
      get uid =>
          StringModelQuerySelector<_$_WorkflowCertificateModelCollectionQuery>(
            key: "@uid",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowCertificateModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowCertificateModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_WorkflowCertificateModelCollectionQuery>
      get token =>
          StringModelQuerySelector<_$_WorkflowCertificateModelCollectionQuery>(
            key: "token",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ListModelQuerySelector<String, _$_WorkflowCertificateModelCollectionQuery>
      get scope => ListModelQuerySelector<String,
              _$_WorkflowCertificateModelCollectionQuery>(
          key: "scope", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_WorkflowCertificateModelCollectionQuery>
      get expiredTime => ModelTimestampModelQuerySelector<
              _$_WorkflowCertificateModelCollectionQuery>(
          key: "expiredTime", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_WorkflowCertificateModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_WorkflowCertificateModelCollectionQuery>(
          key: "createdTime", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_WorkflowCertificateModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowCertificateModelCollectionQuery>(
          key: "updatedTime", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$WorkflowCertificateModelMirrorRefPath
    = _$WorkflowCertificateModelRefPath;
typedef _$WorkflowCertificateModelMirrorInitialCollection
    = _$WorkflowCertificateModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowCertificateModelFormQuery {
  const _$WorkflowCertificateModelFormQuery();

  @useResult
  _$_WorkflowCertificateModelFormQuery call(WorkflowCertificateModel value) {
    return _$_WorkflowCertificateModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowCertificateModelFormQuery
    extends FormControllerQueryBase<WorkflowCertificateModel> {
  const _$_WorkflowCertificateModelFormQuery(this.value);

  final WorkflowCertificateModel value;

  @override
  FormController<WorkflowCertificateModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
