// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check

part of 'purchase_user.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on PurchaseUserModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

class $PurchaseUserModelDocument extends DocumentBase<PurchaseUserModel>
    with ModelRefMixin<PurchaseUserModel> {
  $PurchaseUserModelDocument(super.modelQuery);

  @override
  PurchaseUserModel fromMap(DynamicMap map) => PurchaseUserModel.fromJson(map);
  @override
  DynamicMap toMap(PurchaseUserModel value) => value.rawValue;
}

class $PurchaseUserModelCollection
    extends CollectionBase<$PurchaseUserModelDocument> {
  $PurchaseUserModelCollection(super.modelQuery);

  @override
  $PurchaseUserModelDocument create([String? id]) =>
      $PurchaseUserModelDocument(modelQuery.create(id));
}

class PurchaseUserModelRawCollection
    extends ModelRawCollection<PurchaseUserModel> {
  const PurchaseUserModelRawCollection(super.value);

  @override
  String get path => "plugins/iap/user";
  @override
  DynamicMap toMap(PurchaseUserModel value) => value.rawValue;
  static PurchaseUserModelRef ref(String key) =>
      PurchaseUserModelRef.fromPath("plugins/iap/user/$key");
}

enum PurchaseUserModelCollectionKey { value }

@immutable
class _$PurchaseUserModelDocumentQuery {
  const _$PurchaseUserModelDocumentQuery();

  @useResult
  _$_PurchaseUserModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
  }) {
    return _$_PurchaseUserModelDocumentQuery(DocumentModelQuery(
      "plugins/iap/user/$_id",
      adapter: adapter,
    ));
  }
}

@immutable
class _$_PurchaseUserModelDocumentQuery
    extends ModelQueryBase<$PurchaseUserModelDocument> {
  const _$_PurchaseUserModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  $PurchaseUserModelDocument Function() call(Ref ref) =>
      () => $PurchaseUserModelDocument(modelQuery);
  @override
  String get name => modelQuery.toString();
}

@immutable
class _$PurchaseUserModelCollectionQuery {
  const _$PurchaseUserModelCollectionQuery();

  @useResult
  _$_PurchaseUserModelCollectionQuery call({ModelAdapter? adapter}) {
    return _$_PurchaseUserModelCollectionQuery(CollectionModelQuery(
      "plugins/iap/user",
      adapter: adapter,
    ));
  }
}

@immutable
class _$_PurchaseUserModelCollectionQuery
    extends ModelQueryBase<$PurchaseUserModelCollection> {
  const _$_PurchaseUserModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  $PurchaseUserModelCollection Function() call(Ref ref) =>
      () => $PurchaseUserModelCollection(modelQuery);
  @override
  String get name => modelQuery.toString();
  _$_PurchaseUserModelCollectionQuery equal(
    PurchaseUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.equal(key.name, value));
  }

  _$_PurchaseUserModelCollectionQuery notEqual(
    PurchaseUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.notEqual(key.name, value));
  }

  _$_PurchaseUserModelCollectionQuery lessThan(
    PurchaseUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.lessThan(key.name, value));
  }

  _$_PurchaseUserModelCollectionQuery greaterThan(
    PurchaseUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.greaterThan(key.name, value));
  }

  _$_PurchaseUserModelCollectionQuery lessThanOrEqual(
    PurchaseUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.lessThanOrEqual(key.name, value));
  }

  _$_PurchaseUserModelCollectionQuery greaterThanOrEqual(
    PurchaseUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.greaterThanOrEqual(key.name, value));
  }

  _$_PurchaseUserModelCollectionQuery contains(
    PurchaseUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.contains(key.name, value));
  }

  _$_PurchaseUserModelCollectionQuery containsAny(
    PurchaseUserModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.containsAny(key.name, values));
  }

  _$_PurchaseUserModelCollectionQuery where(
    PurchaseUserModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.where(key.name, values));
  }

  _$_PurchaseUserModelCollectionQuery notWhere(
    PurchaseUserModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.notWhere(key.name, values));
  }

  _$_PurchaseUserModelCollectionQuery isNull(
      PurchaseUserModelCollectionKey key) {
    return _$_PurchaseUserModelCollectionQuery(modelQuery.isNull(key.name));
  }

  _$_PurchaseUserModelCollectionQuery isNotNull(
      PurchaseUserModelCollectionKey key) {
    return _$_PurchaseUserModelCollectionQuery(modelQuery.isNotNull(key.name));
  }

  _$_PurchaseUserModelCollectionQuery geo(
    PurchaseUserModelCollectionKey key,
    List<String>? geoHash,
  ) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.geo(key.name, geoHash));
  }

  _$_PurchaseUserModelCollectionQuery orderByAsc(
      PurchaseUserModelCollectionKey key) {
    return _$_PurchaseUserModelCollectionQuery(modelQuery.orderByAsc(key.name));
  }

  _$_PurchaseUserModelCollectionQuery orderByDesc(
      PurchaseUserModelCollectionKey key) {
    return _$_PurchaseUserModelCollectionQuery(
        modelQuery.orderByDesc(key.name));
  }

  _$_PurchaseUserModelCollectionQuery limitTo(int value) {
    return _$_PurchaseUserModelCollectionQuery(modelQuery.limitTo(value));
  }
}

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
    extends ControllerQueryBase<FormController<PurchaseUserModel>> {
  const _$_PurchaseUserModelFormQuery(this.value);

  final PurchaseUserModel value;

  @override
  FormController<PurchaseUserModel> Function() call(Ref ref) =>
      () => FormController(value);
  @override
  String get name => value.hashCode.toString();
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
