// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'purchase_subscription.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on PurchaseSubscriptionModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$PurchaseSubscriptionModelKeys {
  expired,
  token,
  platform,
  productId,
  purchaseId,
  packageName,
  expiredTime,
  orderId,
  userId
}

class _$PurchaseSubscriptionModelDocument
    extends DocumentBase<PurchaseSubscriptionModel>
    with ModelRefMixin<PurchaseSubscriptionModel> {
  _$PurchaseSubscriptionModelDocument(super.modelQuery);

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  PurchaseSubscriptionModel fromMap(DynamicMap map) =>
      PurchaseSubscriptionModel.fromJson(map);
  @override
  DynamicMap toMap(PurchaseSubscriptionModel value) => value.rawValue;
}

typedef _$PurchaseSubscriptionModelMirrorDocument
    = _$PurchaseSubscriptionModelDocument;

class _$PurchaseSubscriptionModelCollection
    extends CollectionBase<_$PurchaseSubscriptionModelDocument>
    with
        FilterableCollectionMixin<_$PurchaseSubscriptionModelDocument,
            _$_PurchaseSubscriptionModelCollectionQuery> {
  _$PurchaseSubscriptionModelCollection(super.modelQuery);

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$PurchaseSubscriptionModelDocument create([String? id]) =>
      _$PurchaseSubscriptionModelDocument(modelQuery.create(id));
  @override
  Future<CollectionBase<_$PurchaseSubscriptionModelDocument>> filter(
      _$_PurchaseSubscriptionModelCollectionQuery Function(
              _$_PurchaseSubscriptionModelCollectionQuery source)
          callback) {
    final query =
        callback.call(_$_PurchaseSubscriptionModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$PurchaseSubscriptionModelMirrorCollection
    = _$PurchaseSubscriptionModelCollection;

@immutable
class _$PurchaseSubscriptionModelRefPath
    extends ModelRefPath<PurchaseSubscriptionModel> {
  const _$PurchaseSubscriptionModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/iap/subscription/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$PurchaseSubscriptionModelInitialCollection
    extends ModelInitialCollection<PurchaseSubscriptionModel> {
  const _$PurchaseSubscriptionModelInitialCollection(super.value);

  @override
  String get path => "plugins/iap/subscription";
  @override
  DynamicMap toMap(PurchaseSubscriptionModel value) => value.rawValue;
}

@immutable
class _$PurchaseSubscriptionModelDocumentQuery {
  const _$PurchaseSubscriptionModelDocumentQuery();

  @useResult
  _$_PurchaseSubscriptionModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
  }) {
    return _$_PurchaseSubscriptionModelDocumentQuery(DocumentModelQuery(
      "plugins/iap/subscription/$_id",
      adapter:
          adapter ?? _$PurchaseSubscriptionModelDocument.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_PurchaseSubscriptionModelDocumentQuery
    extends ModelQueryBase<_$PurchaseSubscriptionModelDocument> {
  const _$_PurchaseSubscriptionModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$PurchaseSubscriptionModelDocument Function() call(Ref ref) =>
      () => _$PurchaseSubscriptionModelDocument(modelQuery);
  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$PurchaseSubscriptionModelCollectionQuery {
  const _$PurchaseSubscriptionModelCollectionQuery();

  @useResult
  _$_PurchaseSubscriptionModelCollectionQuery call({ModelAdapter? adapter}) {
    return _$_PurchaseSubscriptionModelCollectionQuery(CollectionModelQuery(
      "plugins/iap/subscription",
      adapter:
          adapter ?? _$PurchaseSubscriptionModelCollection.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_PurchaseSubscriptionModelCollectionQuery
    extends ModelQueryBase<_$PurchaseSubscriptionModelCollection> {
  const _$_PurchaseSubscriptionModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$PurchaseSubscriptionModelCollection Function() call(Ref ref) =>
      () => _$PurchaseSubscriptionModelCollection(modelQuery);
  @override
  String get queryName => modelQuery.toString();
  static _$_PurchaseSubscriptionModelCollectionQuery _toQuery(
          CollectionModelQuery query) =>
      _$_PurchaseSubscriptionModelCollectionQuery(query);
  _$_PurchaseSubscriptionModelCollectionQuery limitTo(int value) =>
      _$_PurchaseSubscriptionModelCollectionQuery(modelQuery.limitTo(value));
  _$_PurchaseSubscriptionModelCollectionQuery reset() =>
      _$_PurchaseSubscriptionModelCollectionQuery(modelQuery.reset());
  BooleanModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>
      get expired => BooleanModelQuerySelector<
              _$_PurchaseSubscriptionModelCollectionQuery>(
          key: "expired", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>
      get token =>
          StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>(
              key: "token", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>
      get platform =>
          StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>(
              key: "platform", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>
      get productId =>
          StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>(
              key: "productId", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>
      get purchaseId =>
          StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>(
              key: "purchaseId", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>
      get packageName =>
          StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>(
              key: "packageName", toQuery: _toQuery, modelQuery: modelQuery);
  NumModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>
      get expiredTime =>
          NumModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>(
              key: "expiredTime", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>
      get orderId =>
          StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>(
              key: "orderId", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>
      get userId =>
          StringModelQuerySelector<_$_PurchaseSubscriptionModelCollectionQuery>(
              key: "userId", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$PurchaseSubscriptionModelMirrorRefPath
    = _$PurchaseSubscriptionModelRefPath;
typedef _$PurchaseSubscriptionModelMirrorInitialCollection
    = _$PurchaseSubscriptionModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$PurchaseSubscriptionModelFormQuery {
  const _$PurchaseSubscriptionModelFormQuery();

  @useResult
  _$_PurchaseSubscriptionModelFormQuery call(PurchaseSubscriptionModel value) {
    return _$_PurchaseSubscriptionModelFormQuery(value);
  }
}

@immutable
class _$_PurchaseSubscriptionModelFormQuery
    extends ControllerQueryBase<FormController<PurchaseSubscriptionModel>> {
  const _$_PurchaseSubscriptionModelFormQuery(this.value);

  final PurchaseSubscriptionModel value;

  @override
  FormController<PurchaseSubscriptionModel> Function() call(Ref ref) =>
      () => FormController(value);
  @override
  String get queryName => value.hashCode.toString();
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
