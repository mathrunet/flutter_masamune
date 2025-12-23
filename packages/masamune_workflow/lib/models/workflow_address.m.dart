// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'workflow_address.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on WorkflowAddressModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$WorkflowAddressModelKeys {
  appCount,
  appNames,
  appSummaries,
  collectedTime,
  updatedTime,
  developerId,
  developerName,
  email,
  privacyPolicyUrl,
  source,
  contactPageUrls,
}

class _$WorkflowAddressModelDocument extends DocumentBase<WorkflowAddressModel>
    with ModelRefMixin<WorkflowAddressModel> {
  _$WorkflowAddressModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  WorkflowAddressModel fromMap(DynamicMap map) =>
      WorkflowAddressModel.fromJson(map);

  @override
  DynamicMap toMap(WorkflowAddressModel value) => value.rawValue;
}

typedef _$WorkflowAddressModelMirrorDocument = _$WorkflowAddressModelDocument;

class _$WorkflowAddressModelCollection
    extends CollectionBase<_$WorkflowAddressModelDocument>
    with
        FilterableCollectionMixin<_$WorkflowAddressModelDocument,
            _$_WorkflowAddressModelCollectionQuery> {
  _$WorkflowAddressModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$WorkflowAddressModelDocument create([String? id]) =>
      _$WorkflowAddressModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$WorkflowAddressModelDocument>> filter(
    _$_WorkflowAddressModelCollectionQuery Function(
      _$_WorkflowAddressModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_WorkflowAddressModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$WorkflowAddressModelMirrorCollection
    = _$WorkflowAddressModelCollection;

@immutable
class _$WorkflowAddressModelRefPath extends ModelRefPath<WorkflowAddressModel> {
  const _$WorkflowAddressModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/workflow/address/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$WorkflowAddressModelInitialCollection
    extends ModelInitialCollection<WorkflowAddressModel> {
  const _$WorkflowAddressModelInitialCollection(super.value);

  @override
  String get path => "plugins/workflow/address";

  @override
  DynamicMap toMap(WorkflowAddressModel value) => value.rawValue;
}

@immutable
class _$WorkflowAddressModelDocumentQuery {
  const _$WorkflowAddressModelDocumentQuery();

  @useResult
  _$_WorkflowAddressModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowAddressModelDocumentQuery(
      DocumentModelQuery(
        "plugins/workflow/address/$_id",
        adapter: adapter ?? _$WorkflowAddressModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowAddressModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowAddressModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/workflow/address/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowAddressModelDocumentQuery
    extends ModelQueryBase<_$WorkflowAddressModelDocument> {
  const _$_WorkflowAddressModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$WorkflowAddressModelDocument Function() call(Ref ref) =>
      () => _$WorkflowAddressModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$WorkflowAddressModelCollectionQuery {
  const _$WorkflowAddressModelCollectionQuery();

  @useResult
  _$_WorkflowAddressModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_WorkflowAddressModelCollectionQuery(
      CollectionModelQuery(
        "plugins/workflow/address",
        adapter:
            adapter ?? _$WorkflowAddressModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$WorkflowAddressModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$WorkflowAddressModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^plugins/workflow/address$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_WorkflowAddressModelCollectionQuery
    extends ModelQueryBase<_$WorkflowAddressModelCollection> {
  const _$_WorkflowAddressModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$WorkflowAddressModelCollection Function() call(Ref ref) =>
      () => _$WorkflowAddressModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_WorkflowAddressModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_WorkflowAddressModelCollectionQuery(query);

  _$_WorkflowAddressModelCollectionQuery collectionGroup() =>
      _$_WorkflowAddressModelCollectionQuery(modelQuery.collectionGroup());

  _$_WorkflowAddressModelCollectionQuery reset() =>
      _$_WorkflowAddressModelCollectionQuery(modelQuery.reset());

  _$_WorkflowAddressModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_WorkflowAddressModelCollectionQuery(modelQuery.remove(type));

  _$_WorkflowAddressModelCollectionQuery notifyDocumentChanges() =>
      _$_WorkflowAddressModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_WorkflowAddressModelCollectionQuery limitTo(int value) =>
      _$_WorkflowAddressModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_WorkflowAddressModelCollectionQuery> get appCount =>
      NumModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>(
        key: "appCount",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ListModelQuerySelector<String, _$_WorkflowAddressModelCollectionQuery>
      get appNames => ListModelQuerySelector<String,
              _$_WorkflowAddressModelCollectionQuery>(
            key: "appNames",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ListModelQuerySelector<String, _$_WorkflowAddressModelCollectionQuery>
      get appSummaries => ListModelQuerySelector<String,
              _$_WorkflowAddressModelCollectionQuery>(
            key: "appSummaries",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>
      get collectedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowAddressModelCollectionQuery>(
            key: "collectedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_WorkflowAddressModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>
      get developerId =>
          StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>(
            key: "developerId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>
      get developerName =>
          StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>(
            key: "developerName",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery> get email =>
      StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>(
        key: "email",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>
      get privacyPolicyUrl =>
          StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>(
            key: "privacyPolicyUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery> get source =>
      StringModelQuerySelector<_$_WorkflowAddressModelCollectionQuery>(
        key: "source",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ListModelQuerySelector<String, _$_WorkflowAddressModelCollectionQuery>
      get contactPageUrls => ListModelQuerySelector<String,
              _$_WorkflowAddressModelCollectionQuery>(
            key: "contactPageUrls",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$WorkflowAddressModelMirrorRefPath = _$WorkflowAddressModelRefPath;
typedef _$WorkflowAddressModelMirrorInitialCollection
    = _$WorkflowAddressModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$WorkflowAddressModelFormQuery {
  const _$WorkflowAddressModelFormQuery();

  @useResult
  _$_WorkflowAddressModelFormQuery call(WorkflowAddressModel value) {
    return _$_WorkflowAddressModelFormQuery(value);
  }
}

@immutable
class _$_WorkflowAddressModelFormQuery
    extends FormControllerQueryBase<WorkflowAddressModel> {
  const _$_WorkflowAddressModelFormQuery(this.value);

  final WorkflowAddressModel value;

  @override
  FormController<WorkflowAddressModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
