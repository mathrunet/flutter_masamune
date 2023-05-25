// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check

part of 'stripe_user.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

class $StripeUserModelDocument extends DocumentBase<StripeUserModel>
    with ModelRefMixin<StripeUserModel> {
  $StripeUserModelDocument(super.modelQuery);

  @override
  StripeUserModel fromMap(DynamicMap map) => StripeUserModel.fromJson(map);
  @override
  DynamicMap toMap(StripeUserModel value) => value.toJson();
}

class $StripeUserModelCollection
    extends CollectionBase<$StripeUserModelDocument> {
  $StripeUserModelCollection(super.modelQuery);

  @override
  $StripeUserModelDocument create([String? id]) =>
      $StripeUserModelDocument(modelQuery.create(id));
}

enum StripeUserModelCollectionKey {
  userId,
  accountId,
  customerId,
  defaultPayment,
  capablity
}

@immutable
class _$StripeUserModelDocumentQuery {
  const _$StripeUserModelDocumentQuery();

  @useResult
  _$_StripeUserModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
  }) {
    return _$_StripeUserModelDocumentQuery(DocumentModelQuery(
      "plugins/stripe/user/$_id",
      adapter: adapter,
    ));
  }
}

@immutable
class _$_StripeUserModelDocumentQuery
    extends ModelQueryBase<$StripeUserModelDocument> {
  const _$_StripeUserModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  $StripeUserModelDocument Function() call(Ref ref) =>
      () => $StripeUserModelDocument(modelQuery);
  @override
  String get name => modelQuery.toString();
}

@immutable
class _$StripeUserModelCollectionQuery {
  const _$StripeUserModelCollectionQuery();

  @useResult
  _$_StripeUserModelCollectionQuery call({ModelAdapter? adapter}) {
    return _$_StripeUserModelCollectionQuery(CollectionModelQuery(
      "plugins/stripe/user",
      adapter: adapter,
    ));
  }
}

@immutable
class _$_StripeUserModelCollectionQuery
    extends ModelQueryBase<$StripeUserModelCollection> {
  const _$_StripeUserModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  $StripeUserModelCollection Function() call(Ref ref) =>
      () => $StripeUserModelCollection(modelQuery);
  @override
  String get name => modelQuery.toString();
  _$_StripeUserModelCollectionQuery equal(
    StripeUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripeUserModelCollectionQuery(modelQuery.equal(key.name, value));
  }

  _$_StripeUserModelCollectionQuery notEqual(
    StripeUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripeUserModelCollectionQuery(
        modelQuery.notEqual(key.name, value));
  }

  _$_StripeUserModelCollectionQuery lessThan(
    StripeUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripeUserModelCollectionQuery(
        modelQuery.lessThan(key.name, value));
  }

  _$_StripeUserModelCollectionQuery greaterThan(
    StripeUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripeUserModelCollectionQuery(
        modelQuery.greaterThan(key.name, value));
  }

  _$_StripeUserModelCollectionQuery lessThanOrEqual(
    StripeUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripeUserModelCollectionQuery(
        modelQuery.lessThanOrEqual(key.name, value));
  }

  _$_StripeUserModelCollectionQuery greaterThanOrEqual(
    StripeUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripeUserModelCollectionQuery(
        modelQuery.greaterThanOrEqual(key.name, value));
  }

  _$_StripeUserModelCollectionQuery contains(
    StripeUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_StripeUserModelCollectionQuery(
        modelQuery.contains(key.name, value));
  }

  _$_StripeUserModelCollectionQuery containsAny(
    StripeUserModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_StripeUserModelCollectionQuery(
        modelQuery.containsAny(key.name, values));
  }

  _$_StripeUserModelCollectionQuery where(
    StripeUserModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_StripeUserModelCollectionQuery(
        modelQuery.where(key.name, values));
  }

  _$_StripeUserModelCollectionQuery notWhere(
    StripeUserModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_StripeUserModelCollectionQuery(
        modelQuery.notWhere(key.name, values));
  }

  _$_StripeUserModelCollectionQuery isNull(StripeUserModelCollectionKey key) {
    return _$_StripeUserModelCollectionQuery(modelQuery.isNull(key.name));
  }

  _$_StripeUserModelCollectionQuery isNotNull(
      StripeUserModelCollectionKey key) {
    return _$_StripeUserModelCollectionQuery(modelQuery.isNotNull(key.name));
  }

  _$_StripeUserModelCollectionQuery geo(
    StripeUserModelCollectionKey key,
    List<String>? geoHash,
  ) {
    return _$_StripeUserModelCollectionQuery(modelQuery.geo(key.name, geoHash));
  }

  _$_StripeUserModelCollectionQuery orderByAsc(
      StripeUserModelCollectionKey key) {
    return _$_StripeUserModelCollectionQuery(modelQuery.orderByAsc(key.name));
  }

  _$_StripeUserModelCollectionQuery orderByDesc(
      StripeUserModelCollectionKey key) {
    return _$_StripeUserModelCollectionQuery(modelQuery.orderByDesc(key.name));
  }

  _$_StripeUserModelCollectionQuery limitTo(int value) {
    return _$_StripeUserModelCollectionQuery(modelQuery.limitTo(value));
  }
}
