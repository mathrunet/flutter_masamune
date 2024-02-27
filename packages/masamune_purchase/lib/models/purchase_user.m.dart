// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'purchase_user.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on PurchaseUserModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$PurchaseUserModelKeys { value }

class _$PurchaseUserModelDocument extends DocumentBase<PurchaseUserModel>
    with ModelRefMixin<PurchaseUserModel> {
  _$PurchaseUserModelDocument(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  PurchaseUserModel fromMap(DynamicMap map) => PurchaseUserModel.fromJson(map);

  @override
  DynamicMap toMap(PurchaseUserModel value) => value.rawValue;
}

typedef _$PurchaseUserModelMirrorDocument = _$PurchaseUserModelDocument;

class _$PurchaseUserModelCollection
    extends CollectionBase<_$PurchaseUserModelDocument>
    with
        FilterableCollectionMixin<_$PurchaseUserModelDocument,
            _$_PurchaseUserModelCollectionQuery> {
  _$PurchaseUserModelCollection(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$PurchaseUserModelDocument create([String? id]) =>
      _$PurchaseUserModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$PurchaseUserModelDocument>> filter(
      _$_PurchaseUserModelCollectionQuery Function(
              _$_PurchaseUserModelCollectionQuery source)
          callback) {
    final query =
        callback.call(_$_PurchaseUserModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$PurchaseUserModelMirrorCollection = _$PurchaseUserModelCollection;

@immutable
class _$PurchaseUserModelRefPath extends ModelRefPath<PurchaseUserModel> {
  const _$PurchaseUserModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/iap/user/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$PurchaseUserModelInitialCollection
    extends ModelInitialCollection<PurchaseUserModel> {
  const _$PurchaseUserModelInitialCollection(super.value);

  @override
  String get path => "plugins/iap/user";

  @override
  DynamicMap toMap(PurchaseUserModel value) => value.rawValue;
}

@immutable
class _$PurchaseUserModelDocumentQuery {
  const _$PurchaseUserModelDocumentQuery();

  @useResult
  _$_PurchaseUserModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_PurchaseUserModelDocumentQuery(DocumentModelQuery(
      "plugins/iap/user/$_id",
      adapter: adapter ?? _$PurchaseUserModelDocument.defaultModelAdapter,
      accessQuery:
          accessQuery ?? _$PurchaseUserModelDocument.defaultModelAccessQuery,
      validationQueries: _$PurchaseUserModelDocument.defaultValidationQueries,
    ));
  }
}

@immutable
class _$_PurchaseUserModelDocumentQuery
    extends ModelQueryBase<_$PurchaseUserModelDocument> {
  const _$_PurchaseUserModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$PurchaseUserModelDocument Function() call(Ref ref) =>
      () => _$PurchaseUserModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$PurchaseUserModelCollectionQuery {
  const _$PurchaseUserModelCollectionQuery();

  @useResult
  _$_PurchaseUserModelCollectionQuery call({
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_PurchaseUserModelCollectionQuery(CollectionModelQuery(
      "plugins/iap/user",
      adapter: adapter ?? _$PurchaseUserModelCollection.defaultModelAdapter,
      accessQuery:
          accessQuery ?? _$PurchaseUserModelCollection.defaultModelAccessQuery,
      validationQueries: _$PurchaseUserModelCollection.defaultValidationQueries,
    ));
  }
}

@immutable
class _$_PurchaseUserModelCollectionQuery
    extends ModelQueryBase<_$PurchaseUserModelCollection> {
  const _$_PurchaseUserModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$PurchaseUserModelCollection Function() call(Ref ref) =>
      () => _$PurchaseUserModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_PurchaseUserModelCollectionQuery _toQuery(
          CollectionModelQuery query) =>
      _$_PurchaseUserModelCollectionQuery(query);

  _$_PurchaseUserModelCollectionQuery limitTo(int value) =>
      _$_PurchaseUserModelCollectionQuery(modelQuery.limitTo(value));

  _$_PurchaseUserModelCollectionQuery collectionGroup() =>
      _$_PurchaseUserModelCollectionQuery(modelQuery.collectionGroup());

  _$_PurchaseUserModelCollectionQuery reset() =>
      _$_PurchaseUserModelCollectionQuery(modelQuery.reset());

  StringModelQuerySelector<_$_PurchaseUserModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_PurchaseUserModelCollectionQuery>(
          key: "@uid", toQuery: _toQuery, modelQuery: modelQuery);

  NumModelQuerySelector<_$_PurchaseUserModelCollectionQuery> get value =>
      NumModelQuerySelector<_$_PurchaseUserModelCollectionQuery>(
          key: "value", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$PurchaseUserModelMirrorRefPath = _$PurchaseUserModelRefPath;
typedef _$PurchaseUserModelMirrorInitialCollection
    = _$PurchaseUserModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$PurchaseUserModelFormQuery {
  const _$PurchaseUserModelFormQuery();

  @useResult
  _$_PurchaseUserModelFormQuery call(PurchaseUserModel value) {
    return _$_PurchaseUserModelFormQuery(value);
  }
}

@immutable
class _$_PurchaseUserModelFormQuery
    extends FormControllerQueryBase<PurchaseUserModel> {
  const _$_PurchaseUserModelFormQuery(this.value);

  final PurchaseUserModel value;

  @override
  FormController<PurchaseUserModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
