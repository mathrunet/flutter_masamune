// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations

part of 'stripe_purchase.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on StripePurchaseModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

@immutable
class StripePurchaseModelPath extends ModelRefPath<StripePurchaseModel> {
  const StripePurchaseModelPath(
    String uid, {
    required String userId,
  })  : _userId = userId,
        super(uid);

  final String _userId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/stripe/user/$_userId/purchase/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class StripePurchaseModelInitialCollection
    extends ModelInitialCollection<StripePurchaseModel> {
  const StripePurchaseModelInitialCollection(
    super.value, {
    required String userId,
  }) : _userId = userId;

  final String _userId;

  @override
  String get path => "plugins/stripe/user/$_userId/purchase";
  @override
  DynamicMap toMap(StripePurchaseModel value) => value.rawValue;
}

class $StripePurchaseModelDocument extends DocumentBase<StripePurchaseModel>
    with ModelRefMixin<StripePurchaseModel> {
  $StripePurchaseModelDocument(super.modelQuery);

  static const ModelAdapter? defaultModelAdapter = null;

  @override
  StripePurchaseModel fromMap(DynamicMap map) =>
      StripePurchaseModel.fromJson(map);
  @override
  DynamicMap toMap(StripePurchaseModel value) => value.rawValue;
}

class $StripePurchaseModelCollection
    extends CollectionBase<$StripePurchaseModelDocument>
    with
        FilterableCollectionMixin<$StripePurchaseModelDocument,
            _$_StripePurchaseModelCollectionQuery> {
  $StripePurchaseModelCollection(super.modelQuery);

  static const ModelAdapter? defaultModelAdapter = null;

  @override
  $StripePurchaseModelDocument create([String? id]) =>
      $StripePurchaseModelDocument(modelQuery.create(id));
  @override
  Future<CollectionBase<$StripePurchaseModelDocument>> filter(
      _$_StripePurchaseModelCollectionQuery Function(
              _$_StripePurchaseModelCollectionQuery source)
          callback) {
    final query =
        callback.call(_$_StripePurchaseModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

enum StripePurchaseModelCollectionKey {
  userId,
  confirm,
  verified,
  captured,
  success,
  canceled,
  error,
  refund,
  orderId,
  purchaseId,
  paymentMethodId,
  customerId,
  amount,
  application,
  applicationFeeAmount,
  transferAmount,
  transferDistination,
  currency,
  clientSecret,
  createdTime,
  updatedTime,
  emailFrom,
  emailTo,
  emailTitle,
  emailContent,
  locale,
  cancelAtPeriodEnd
}

@immutable
class _$StripePurchaseModelDocumentQuery {
  const _$StripePurchaseModelDocumentQuery();

  @useResult
  _$_StripePurchaseModelDocumentQuery call(
    Object _id, {
    required String userId,
    ModelAdapter? adapter,
  }) {
    return _$_StripePurchaseModelDocumentQuery(DocumentModelQuery(
      "plugins/stripe/user/$userId/purchase/$_id",
      adapter: adapter ?? $StripePurchaseModelDocument.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_StripePurchaseModelDocumentQuery
    extends ModelQueryBase<$StripePurchaseModelDocument> {
  const _$_StripePurchaseModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  $StripePurchaseModelDocument Function() call(Ref ref) =>
      () => $StripePurchaseModelDocument(modelQuery);
  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$StripePurchaseModelCollectionQuery {
  const _$StripePurchaseModelCollectionQuery();

  @useResult
  _$_StripePurchaseModelCollectionQuery call({
    required String userId,
    ModelAdapter? adapter,
  }) {
    return _$_StripePurchaseModelCollectionQuery(CollectionModelQuery(
      "plugins/stripe/user/$userId/purchase",
      adapter: adapter ?? $StripePurchaseModelCollection.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_StripePurchaseModelCollectionQuery
    extends ModelQueryBase<$StripePurchaseModelCollection> {
  const _$_StripePurchaseModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  $StripePurchaseModelCollection Function() call(Ref ref) =>
      () => $StripePurchaseModelCollection(modelQuery);
  @override
  String get queryName => modelQuery.toString();
  _$_StripePurchaseModelCollectionQuery equal(
    StripePurchaseModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.equal(key.name, value));
  }

  _$_StripePurchaseModelCollectionQuery notEqual(
    StripePurchaseModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.notEqual(key.name, value));
  }

  _$_StripePurchaseModelCollectionQuery lessThan(
    StripePurchaseModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.lessThan(key.name, value));
  }

  _$_StripePurchaseModelCollectionQuery greaterThan(
    StripePurchaseModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.greaterThan(key.name, value));
  }

  _$_StripePurchaseModelCollectionQuery lessThanOrEqual(
    StripePurchaseModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.lessThanOrEqual(key.name, value));
  }

  _$_StripePurchaseModelCollectionQuery greaterThanOrEqual(
    StripePurchaseModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.greaterThanOrEqual(key.name, value));
  }

  _$_StripePurchaseModelCollectionQuery contains(
    StripePurchaseModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.contains(key.name, value));
  }

  _$_StripePurchaseModelCollectionQuery containsAny(
    StripePurchaseModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.containsAny(key.name, values));
  }

  _$_StripePurchaseModelCollectionQuery where(
    StripePurchaseModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.where(key.name, values));
  }

  _$_StripePurchaseModelCollectionQuery notWhere(
    StripePurchaseModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.notWhere(key.name, values));
  }

  _$_StripePurchaseModelCollectionQuery isNull(
      StripePurchaseModelCollectionKey key) {
    return _$_StripePurchaseModelCollectionQuery(modelQuery.isNull(key.name));
  }

  _$_StripePurchaseModelCollectionQuery isNotNull(
      StripePurchaseModelCollectionKey key) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.isNotNull(key.name));
  }

  _$_StripePurchaseModelCollectionQuery geo(
    StripePurchaseModelCollectionKey key,
    List<String>? geoHash,
  ) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.geo(key.name, geoHash));
  }

  _$_StripePurchaseModelCollectionQuery orderByAsc(
      StripePurchaseModelCollectionKey key) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.orderByAsc(key.name));
  }

  _$_StripePurchaseModelCollectionQuery orderByDesc(
      StripePurchaseModelCollectionKey key) {
    return _$_StripePurchaseModelCollectionQuery(
        modelQuery.orderByDesc(key.name));
  }

  _$_StripePurchaseModelCollectionQuery limitTo(int value) {
    return _$_StripePurchaseModelCollectionQuery(modelQuery.limitTo(value));
  }

  _$_StripePurchaseModelCollectionQuery reset() {
    return _$_StripePurchaseModelCollectionQuery(modelQuery.reset());
  }
}
