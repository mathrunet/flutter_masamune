// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api

part of 'purchase_subscription.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on PurchaseSubscriptionModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

class $PurchaseSubscriptionModelDocument
    extends DocumentBase<PurchaseSubscriptionModel>
    with ModelRefMixin<PurchaseSubscriptionModel> {
  $PurchaseSubscriptionModelDocument(super.modelQuery);

  @override
  PurchaseSubscriptionModel fromMap(DynamicMap map) =>
      PurchaseSubscriptionModel.fromJson(map);
  @override
  DynamicMap toMap(PurchaseSubscriptionModel value) => value.rawValue;
}

class $PurchaseSubscriptionModelCollection
    extends CollectionBase<$PurchaseSubscriptionModelDocument>
    with
        FilterableCollectionMixin<$PurchaseSubscriptionModelDocument,
            _$_PurchaseSubscriptionModelCollectionQuery> {
  $PurchaseSubscriptionModelCollection(super.modelQuery);

  @override
  $PurchaseSubscriptionModelDocument create([String? id]) =>
      $PurchaseSubscriptionModelDocument(modelQuery.create(id));
  @override
  Future<CollectionBase<$PurchaseSubscriptionModelDocument>> filter(
      _$_PurchaseSubscriptionModelCollectionQuery Function(
              _$_PurchaseSubscriptionModelCollectionQuery source)
          callback) {
    final query =
        callback.call(_$_PurchaseSubscriptionModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

class PurchaseSubscriptionModelRawCollection
    extends ModelInitialCollection<PurchaseSubscriptionModel> {
  const PurchaseSubscriptionModelRawCollection(super.value);

  @override
  String get path => "plugins/iap/subscription";
  @override
  DynamicMap toMap(PurchaseSubscriptionModel value) => value.rawValue;
  static ModelRefBase<PurchaseSubscriptionModel> ref(String key) =>
      ModelRefBase<PurchaseSubscriptionModel>.fromPath(
          "plugins/iap/subscription/$key");
}

enum PurchaseSubscriptionModelCollectionKey {
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
      adapter: adapter,
    ));
  }
}

@immutable
class _$_PurchaseSubscriptionModelDocumentQuery
    extends ModelQueryBase<$PurchaseSubscriptionModelDocument> {
  const _$_PurchaseSubscriptionModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  $PurchaseSubscriptionModelDocument Function() call(Ref ref) =>
      () => $PurchaseSubscriptionModelDocument(modelQuery);
  @override
  String get name => modelQuery.toString();
}

@immutable
class _$PurchaseSubscriptionModelCollectionQuery {
  const _$PurchaseSubscriptionModelCollectionQuery();

  @useResult
  _$_PurchaseSubscriptionModelCollectionQuery call({ModelAdapter? adapter}) {
    return _$_PurchaseSubscriptionModelCollectionQuery(CollectionModelQuery(
      "plugins/iap/subscription",
      adapter: adapter,
    ));
  }
}

@immutable
class _$_PurchaseSubscriptionModelCollectionQuery
    extends ModelQueryBase<$PurchaseSubscriptionModelCollection> {
  const _$_PurchaseSubscriptionModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  $PurchaseSubscriptionModelCollection Function() call(Ref ref) =>
      () => $PurchaseSubscriptionModelCollection(modelQuery);
  @override
  String get name => modelQuery.toString();
  _$_PurchaseSubscriptionModelCollectionQuery equal(
    PurchaseSubscriptionModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.equal(key.name, value));
  }

  _$_PurchaseSubscriptionModelCollectionQuery notEqual(
    PurchaseSubscriptionModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.notEqual(key.name, value));
  }

  _$_PurchaseSubscriptionModelCollectionQuery lessThan(
    PurchaseSubscriptionModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.lessThan(key.name, value));
  }

  _$_PurchaseSubscriptionModelCollectionQuery greaterThan(
    PurchaseSubscriptionModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.greaterThan(key.name, value));
  }

  _$_PurchaseSubscriptionModelCollectionQuery lessThanOrEqual(
    PurchaseSubscriptionModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.lessThanOrEqual(key.name, value));
  }

  _$_PurchaseSubscriptionModelCollectionQuery greaterThanOrEqual(
    PurchaseSubscriptionModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.greaterThanOrEqual(key.name, value));
  }

  _$_PurchaseSubscriptionModelCollectionQuery contains(
    PurchaseSubscriptionModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.contains(key.name, value));
  }

  _$_PurchaseSubscriptionModelCollectionQuery containsAny(
    PurchaseSubscriptionModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.containsAny(key.name, values));
  }

  _$_PurchaseSubscriptionModelCollectionQuery where(
    PurchaseSubscriptionModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.where(key.name, values));
  }

  _$_PurchaseSubscriptionModelCollectionQuery notWhere(
    PurchaseSubscriptionModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.notWhere(key.name, values));
  }

  _$_PurchaseSubscriptionModelCollectionQuery isNull(
      PurchaseSubscriptionModelCollectionKey key) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.isNull(key.name));
  }

  _$_PurchaseSubscriptionModelCollectionQuery isNotNull(
      PurchaseSubscriptionModelCollectionKey key) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.isNotNull(key.name));
  }

  _$_PurchaseSubscriptionModelCollectionQuery geo(
    PurchaseSubscriptionModelCollectionKey key,
    List<String>? geoHash,
  ) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.geo(key.name, geoHash));
  }

  _$_PurchaseSubscriptionModelCollectionQuery orderByAsc(
      PurchaseSubscriptionModelCollectionKey key) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.orderByAsc(key.name));
  }

  _$_PurchaseSubscriptionModelCollectionQuery orderByDesc(
      PurchaseSubscriptionModelCollectionKey key) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.orderByDesc(key.name));
  }

  _$_PurchaseSubscriptionModelCollectionQuery limitTo(int value) {
    return _$_PurchaseSubscriptionModelCollectionQuery(
        modelQuery.limitTo(value));
  }

  _$_PurchaseSubscriptionModelCollectionQuery reset() {
    return _$_PurchaseSubscriptionModelCollectionQuery(modelQuery.reset());
  }
}

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
  String get name => value.hashCode.toString();
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
