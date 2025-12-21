// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_organization_member.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowOrganizationMemberModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowOrganizationMemberModelKeys {
  role,
  userId,
  organization,
  createdTime,
  updatedTime,
}

class _$WorkflowOrganizationMemberModelDocument
    extends DocumentBase<WorkflowOrganizationMemberModel>
    with
        ModelRefMixin<WorkflowOrganizationMemberModel>,
        ModelRefLoaderMixin<WorkflowOrganizationMemberModel> {
  _$WorkflowOrganizationMemberModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowOrganizationMemberModel fromMap(DynamicMap map) =>
      WorkflowOrganizationMemberModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowOrganizationMemberModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<WorkflowOrganizationMemberModel>> get builder => [
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

typedef _$WorkflowOrganizationMemberModelMirrorDocument
    = _$WorkflowOrganizationMemberModelDocument;

class _$WorkflowOrganizationMemberModelCollection
    extends CollectionBase<_$WorkflowOrganizationMemberModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowOrganizationMemberModelDocument,
            _$_WorkflowOrganizationMemberModelCollectionQuery> {
  _$WorkflowOrganizationMemberModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowOrganizationMemberModelDocument create([String? id]) =>
      _$WorkflowOrganizationMemberModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowOrganizationMemberModelDocument>> filter(
    _$_WorkflowOrganizationMemberModelCollectionQuery Function(
      _$_WorkflowOrganizationMemberModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowOrganizationMemberModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowOrganizationMemberModelMirrorCollection
    = _$WorkflowOrganizationMemberModelCollection;

@immutable
class _$WorkflowOrganizationMemberModelRefPath
    extends ModelRefPath<WorkflowOrganizationMemberModel> {
  const _$WorkflowOrganizationMemberModelRefPath(
    super.uid, {
    required String organizationId,
  }) : _organizationId = organizationId;

  final String _organizationId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/organization/$_organizationId/member/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowOrganizationMemberModelInitialCollection
    extends ModelInitialCollection<WorkflowOrganizationMemberModel> {
  const _$WorkflowOrganizationMemberModelInitialCollection(
    super.value, {
    required String organizationId,
  }) : _organizationId = organizationId;

  final String _organizationId;

  @override
  String get path => "plugins/workflow/organization/$_organizationId/member";

  @override
  DynamicMap toMap(WorkflowOrganizationMemberModel value) => value.rawValue;
}

@immutable
class _$WorkflowOrganizationMemberModelDocumentQuery {
  const _$WorkflowOrganizationMemberModelDocumentQuery();

  @useResult
  _$_WorkflowOrganizationMemberModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowOrganizationMemberModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/organization/$organizationId/member/$_id",
        adapter: adapter ??
            _$WorkflowOrganizationMemberModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowOrganizationMemberModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowOrganizationMemberModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/organization/([^/]+)/member/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowOrganizationMemberModelDocumentQuery
    extends ModelQueryBase<_$WorkflowOrganizationMemberModelDocument> {
  const _$_WorkflowOrganizationMemberModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowOrganizationMemberModelDocument Function() call(Ref ref) =>
      () => _$WorkflowOrganizationMemberModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowOrganizationMemberModelCollectionQuery {
  const _$WorkflowOrganizationMemberModelCollectionQuery();

  @useResult
  _$_WorkflowOrganizationMemberModelCollectionQuery call({
    required String organizationId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowOrganizationMemberModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/organization/$organizationId/member",
        adapter: adapter ??
            _$WorkflowOrganizationMemberModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowOrganizationMemberModelCollection.defaultModelAccessQuery,
        validationQueries: _$WorkflowOrganizationMemberModelCollection
            .defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/organization/([^/]+)/member$".trimQuery().trimString(
            "/",
          ),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowOrganizationMemberModelCollectionQuery
    extends ModelQueryBase<_$WorkflowOrganizationMemberModelCollection> {
  const _$_WorkflowOrganizationMemberModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowOrganizationMemberModelCollection Function() call(Ref ref) =>
      () => _$WorkflowOrganizationMemberModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowOrganizationMemberModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowOrganizationMemberModelCollectionQuery(query);

  _$_WorkflowOrganizationMemberModelCollectionQuery collectionGroup() =>
      _$_WorkflowOrganizationMemberModelCollectionQuery(
        modelQuery.collectionGroup(),
      );

  _$_WorkflowOrganizationMemberModelCollectionQuery reset() =>
      _$_WorkflowOrganizationMemberModelCollectionQuery(modelQuery.reset());

  _$_WorkflowOrganizationMemberModelCollectionQuery remove(
    ModelQueryFilterType type,
  ) =>
      _$_WorkflowOrganizationMemberModelCollectionQuery(
        modelQuery.remove(type),
      );

  _$_WorkflowOrganizationMemberModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowOrganizationMemberModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_WorkflowOrganizationMemberModelCollectionQuery limitTo(int value) =>
      _$_WorkflowOrganizationMemberModelCollectionQuery(
        modelQuery.limitTo(value),
      );

  StringModelQuerySelector<_$_WorkflowOrganizationMemberModelCollectionQuery>
      get uid => StringModelQuerySelector<
              _$_WorkflowOrganizationMemberModelCollectionQuery>(
          key: "@uid", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<WorkflowRole,
          _$_WorkflowOrganizationMemberModelCollectionQuery>
      get role => ValueModelQuerySelector<WorkflowRole,
              _$_WorkflowOrganizationMemberModelCollectionQuery>(
          key: "role", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_WorkflowOrganizationMemberModelCollectionQuery>
      get userId => StringModelQuerySelector<
              _$_WorkflowOrganizationMemberModelCollectionQuery>(
          key: "userId", toQuery: _toQuery, modelQuery: modelQuery);

  ModelRefModelQuerySelector<WorkflowOrganizationModel,
          _$_WorkflowOrganizationMemberModelCollectionQuery>
      get organization => ModelRefModelQuerySelector<WorkflowOrganizationModel,
              _$_WorkflowOrganizationMemberModelCollectionQuery>(
          key: "organization", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<
          _$_WorkflowOrganizationMemberModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_WorkflowOrganizationMemberModelCollectionQuery>(
          key: "createdTime", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<
          _$_WorkflowOrganizationMemberModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowOrganizationMemberModelCollectionQuery>(
          key: "updatedTime", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$WorkflowOrganizationMemberModelMirrorRefPath
    = _$WorkflowOrganizationMemberModelRefPath;
typedef _$WorkflowOrganizationMemberModelMirrorInitialCollection
    = _$WorkflowOrganizationMemberModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowOrganizationMemberModelFormQuery {
  const _$WorkflowOrganizationMemberModelFormQuery();

  @useResult
  _$_WorkflowOrganizationMemberModelFormQuery call(
    WorkflowOrganizationMemberModel value,
  ) {
    return _$_WorkflowOrganizationMemberModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowOrganizationMemberModelFormQuery
    extends FormControllerQueryBase<WorkflowOrganizationMemberModel> {
  const _$_WorkflowOrganizationMemberModelFormQuery(this.value);

  final WorkflowOrganizationMemberModel value;

  @override
  FormController<WorkflowOrganizationMemberModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
