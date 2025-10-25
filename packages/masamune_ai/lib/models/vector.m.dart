// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'vector.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on VectorModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$VectorModelKeys { agentId, content, createdAt }

class _$VectorModelDocument extends DocumentBase<VectorModel>
    with ModelRefMixin<VectorModel>, VectorDocumentMixin<VectorModel> {
  _$VectorModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      AIMasamuneAdapter.primary.vectorModelAdapter;

  @override
  VectorModel fromMap(DynamicMap map) => VectorModel.fromJson(map);

  @override
  DynamicMap toMap(VectorModel value) => value.rawValue;

  @override
  String buildVectorText(VectorModel value) => value.content.toString();
}

typedef _$VectorModelMirrorDocument = _$VectorModelDocument;

class _$VectorModelCollection extends CollectionBase<_$VectorModelDocument>
    with
        FilterableCollectionMixin<_$VectorModelDocument,
            _$_VectorModelCollectionQuery>,
        VectorCollectionMixin<_$VectorModelDocument> {
  _$VectorModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      AIMasamuneAdapter.primary.vectorModelAdapter;

  @override
  _$VectorModelDocument create([String? id]) =>
      _$VectorModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$VectorModelDocument>> filter(
    _$_VectorModelCollectionQuery Function(_$_VectorModelCollectionQuery source)
        callback,
  ) {
    final query = callback.call(_$_VectorModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$VectorModelMirrorCollection = _$VectorModelCollection;

@immutable
class _$VectorModelRefPath extends ModelRefPath<VectorModel> {
  const _$VectorModelRefPath(super.uid, {required String agentId})
      : _agentId = agentId;

  final String _agentId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/ai/agent/$_agentId/vector/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$VectorModelInitialCollection extends ModelInitialCollection<VectorModel>
    with VectorInitialCollectionMixin<VectorModel> {
  const _$VectorModelInitialCollection(super.value, {required String agentId})
      : _agentId = agentId;

  final String _agentId;

  @override
  String get path => "plugins/ai/agent/$_agentId/vector";

  @override
  DynamicMap toMap(VectorModel value) => value.rawValue;

  @override
  String buildVectorText(VectorModel value) => value.content.toString();
}

@immutable
class _$VectorModelDocumentQuery {
  const _$VectorModelDocumentQuery();

  @useResult
  _$_VectorModelDocumentQuery call(
    Object _id, {
    required String agentId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_VectorModelDocumentQuery(
      DocumentModelQuery(
        "plugins/ai/agent/$agentId/vector/$_id",
        adapter: adapter ?? _$VectorModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$VectorModelDocument.defaultModelAccessQuery,
        validationQueries: _$VectorModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/ai/agent/([^/]+)/vector/([^/]+)$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_VectorModelDocumentQuery
    extends ModelQueryBase<_$VectorModelDocument> {
  const _$_VectorModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$VectorModelDocument Function() call(Ref ref) =>
      () => _$VectorModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$VectorModelCollectionQuery {
  const _$VectorModelCollectionQuery();

  @useResult
  _$_VectorModelCollectionQuery call({
    required String agentId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_VectorModelCollectionQuery(
      CollectionModelQuery(
        "plugins/ai/agent/$agentId/vector",
        adapter: adapter ?? _$VectorModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$VectorModelCollection.defaultModelAccessQuery,
        validationQueries: _$VectorModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^plugins/ai/agent/([^/]+)/vector$".trimQuery().trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_VectorModelCollectionQuery
    extends ModelQueryBase<_$VectorModelCollection> {
  const _$_VectorModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$VectorModelCollection Function() call(Ref ref) =>
      () => _$VectorModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_VectorModelCollectionQuery _toQuery(CollectionModelQuery query) =>
      _$_VectorModelCollectionQuery(query);

  _$_VectorModelCollectionQuery collectionGroup() =>
      _$_VectorModelCollectionQuery(modelQuery.collectionGroup());

  _$_VectorModelCollectionQuery reset() =>
      _$_VectorModelCollectionQuery(modelQuery.reset());

  _$_VectorModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_VectorModelCollectionQuery(modelQuery.remove(type));

  _$_VectorModelCollectionQuery notifyDocumentChanges() =>
      _$_VectorModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_VectorModelCollectionQuery limitTo(int value) =>
      _$_VectorModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_VectorModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_VectorModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_VectorModelCollectionQuery> get agentId =>
      StringModelQuerySelector<_$_VectorModelCollectionQuery>(
        key: "agentId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_VectorModelCollectionQuery> get content =>
      StringModelQuerySelector<_$_VectorModelCollectionQuery>(
        key: "content",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelTimestampModelQuerySelector<_$_VectorModelCollectionQuery>
      get createdAt =>
          ModelTimestampModelQuerySelector<_$_VectorModelCollectionQuery>(
            key: "createdAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$VectorModelMirrorRefPath = _$VectorModelRefPath;
typedef _$VectorModelMirrorInitialCollection = _$VectorModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$VectorModelFormQuery {
  const _$VectorModelFormQuery();

  @useResult
  _$_VectorModelFormQuery call(VectorModel value) {
    return _$_VectorModelFormQuery(value);
  }
}

@immutable
class _$_VectorModelFormQuery extends FormControllerQueryBase<VectorModel> {
  const _$_VectorModelFormQuery(this.value);

  final VectorModel value;

  @override
  FormController<VectorModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
