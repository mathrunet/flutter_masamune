// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations

part of 'stripe_user.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on StripeUserModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

@immutable
class StripeUserModelPath extends ModelRefPath<StripeUserModel> {
  const StripeUserModelPath(String uid) : super(uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/stripe/user/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class StripeUserModelInitialCollection
    extends ModelInitialCollection<StripeUserModel> {
  const StripeUserModelInitialCollection(super.value);

  @override
  String get path => "plugins/stripe/user";
  @override
  DynamicMap toMap(StripeUserModel value) => value.rawValue;
}

class $StripeUserModelDocument extends DocumentBase<StripeUserModel>
    with ModelRefMixin<StripeUserModel> {
  $StripeUserModelDocument(super.modelQuery);

  static const ModelAdapter? defaultModelAdapter = null;

  @override
  StripeUserModel fromMap(DynamicMap map) => StripeUserModel.fromJson(map);
  @override
  DynamicMap toMap(StripeUserModel value) => value.rawValue;
}

class $StripeUserModelCollection
    extends CollectionBase<$StripeUserModelDocument>
    with
        FilterableCollectionMixin<$StripeUserModelDocument,
            _$_StripeUserModelCollectionQuery> {
  $StripeUserModelCollection(super.modelQuery);

  static const ModelAdapter? defaultModelAdapter = null;

  @override
  $StripeUserModelDocument create([String? id]) =>
      $StripeUserModelDocument(modelQuery.create(id));
  @override
  Future<CollectionBase<$StripeUserModelDocument>> filter(
      _$_StripeUserModelCollectionQuery Function(
              _$_StripeUserModelCollectionQuery source)
          callback) {
    final query = callback.call(_$_StripeUserModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
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
      adapter: adapter ?? $StripeUserModelDocument.defaultModelAdapter,
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
  String get queryName => modelQuery.toString();
}

@immutable
class _$StripeUserModelCollectionQuery {
  const _$StripeUserModelCollectionQuery();

  @useResult
  _$_StripeUserModelCollectionQuery call({ModelAdapter? adapter}) {
    return _$_StripeUserModelCollectionQuery(CollectionModelQuery(
      "plugins/stripe/user",
      adapter: adapter ?? $StripeUserModelCollection.defaultModelAdapter,
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
  String get queryName => modelQuery.toString();
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

  _$_StripeUserModelCollectionQuery reset() {
    return _$_StripeUserModelCollectionQuery(modelQuery.reset());
  }
}
