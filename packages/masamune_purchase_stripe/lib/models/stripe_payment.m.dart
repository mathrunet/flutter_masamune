// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api

part of 'stripe_payment.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on StripePaymentModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

class $StripePaymentModelDocument extends DocumentBase<StripePaymentModel>
    with ModelRefMixin<StripePaymentModel> {
  $StripePaymentModelDocument(super.modelQuery);

  @override
  StripePaymentModel fromMap(DynamicMap map) =>
      StripePaymentModel.fromJson(map);
  @override
  DynamicMap toMap(StripePaymentModel value) => value.rawValue;
}

class $StripePaymentModelCollection
    extends CollectionBase<$StripePaymentModelDocument>
    with
        FilterableCollectionMixin<$StripePaymentModelDocument,
            _$_StripePaymentModelCollectionQuery> {
  $StripePaymentModelCollection(super.modelQuery);

  @override
  $StripePaymentModelDocument create([String? id]) =>
      $StripePaymentModelDocument(modelQuery.create(id));
  @override
  Future<CollectionBase<$StripePaymentModelDocument>> filter(
      _$_StripePaymentModelCollectionQuery Function(
              _$_StripePaymentModelCollectionQuery source)
          callback) {
    final query =
        callback.call(_$_StripePaymentModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

class StripePaymentModelRawCollection
    extends ModelRawCollection<StripePaymentModel> {
  const StripePaymentModelRawCollection(
    super.value, {
    required String userId,
  }) : _userId = userId;

  final String _userId;

  @override
  String get path => "plugins/stripe/user/$_userId/payment";
  @override
  DynamicMap toMap(StripePaymentModel value) => value.rawValue;
  static ModelRefBase<StripePaymentModel> ref(
    String key, {
    required String userId,
  }) =>
      ModelRefBase<StripePaymentModel>.fromPath(
          "plugins/stripe/user/$userId/payment/$key");
}

enum StripePaymentModelCollectionKey {
  paymentId,
  type,
  expMonth,
  expYear,
  brand,
  numberLast,
  isDefault
}

@immutable
class _$StripePaymentModelDocumentQuery {
  const _$StripePaymentModelDocumentQuery();

  @useResult
  _$_StripePaymentModelDocumentQuery call(
    Object _id, {
    required String userId,
    ModelAdapter? adapter,
  }) {
    return _$_StripePaymentModelDocumentQuery(DocumentModelQuery(
      "plugins/stripe/user/$userId/payment/$_id",
      adapter: adapter,
    ));
  }
}

@immutable
class _$_StripePaymentModelDocumentQuery
    extends ModelQueryBase<$StripePaymentModelDocument> {
  const _$_StripePaymentModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  $StripePaymentModelDocument Function() call(Ref ref) =>
      () => $StripePaymentModelDocument(modelQuery);
  @override
  String get name => modelQuery.toString();
}

@immutable
class _$StripePaymentModelCollectionQuery {
  const _$StripePaymentModelCollectionQuery();

  @useResult
  _$_StripePaymentModelCollectionQuery call({
    required String userId,
    ModelAdapter? adapter,
  }) {
    return _$_StripePaymentModelCollectionQuery(CollectionModelQuery(
      "plugins/stripe/user/$userId/payment",
      adapter: adapter,
    ));
  }
}

@immutable
class _$_StripePaymentModelCollectionQuery
    extends ModelQueryBase<$StripePaymentModelCollection> {
  const _$_StripePaymentModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  $StripePaymentModelCollection Function() call(Ref ref) =>
      () => $StripePaymentModelCollection(modelQuery);
  @override
  String get name => modelQuery.toString();
  _$_StripePaymentModelCollectionQuery equal(
    StripePaymentModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.equal(key.name, value));
  }

  _$_StripePaymentModelCollectionQuery notEqual(
    StripePaymentModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.notEqual(key.name, value));
  }

  _$_StripePaymentModelCollectionQuery lessThan(
    StripePaymentModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.lessThan(key.name, value));
  }

  _$_StripePaymentModelCollectionQuery greaterThan(
    StripePaymentModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.greaterThan(key.name, value));
  }

  _$_StripePaymentModelCollectionQuery lessThanOrEqual(
    StripePaymentModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.lessThanOrEqual(key.name, value));
  }

  _$_StripePaymentModelCollectionQuery greaterThanOrEqual(
    StripePaymentModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.greaterThanOrEqual(key.name, value));
  }

  _$_StripePaymentModelCollectionQuery contains(
    StripePaymentModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.contains(key.name, value));
  }

  _$_StripePaymentModelCollectionQuery containsAny(
    StripePaymentModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.containsAny(key.name, values));
  }

  _$_StripePaymentModelCollectionQuery where(
    StripePaymentModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.where(key.name, values));
  }

  _$_StripePaymentModelCollectionQuery notWhere(
    StripePaymentModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.notWhere(key.name, values));
  }

  _$_StripePaymentModelCollectionQuery isNull(
      StripePaymentModelCollectionKey key) {
    return _$_StripePaymentModelCollectionQuery(modelQuery.isNull(key.name));
  }

  _$_StripePaymentModelCollectionQuery isNotNull(
      StripePaymentModelCollectionKey key) {
    return _$_StripePaymentModelCollectionQuery(modelQuery.isNotNull(key.name));
  }

  _$_StripePaymentModelCollectionQuery geo(
    StripePaymentModelCollectionKey key,
    List<String>? geoHash,
  ) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.geo(key.name, geoHash));
  }

  _$_StripePaymentModelCollectionQuery orderByAsc(
      StripePaymentModelCollectionKey key) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.orderByAsc(key.name));
  }

  _$_StripePaymentModelCollectionQuery orderByDesc(
      StripePaymentModelCollectionKey key) {
    return _$_StripePaymentModelCollectionQuery(
        modelQuery.orderByDesc(key.name));
  }

  _$_StripePaymentModelCollectionQuery limitTo(int value) {
    return _$_StripePaymentModelCollectionQuery(modelQuery.limitTo(value));
  }

  _$_StripePaymentModelCollectionQuery reset() {
    return _$_StripePaymentModelCollectionQuery(modelQuery.reset());
  }
}
