// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations

part of 'point_ecosystem_user.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on PointEcosystemUserModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

@immutable
class PointEcosystemUserModelPath
    extends ModelRefPath<PointEcosystemUserModel> {
  const PointEcosystemUserModelPath(String uid) : super(uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/pes/user/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class PointEcosystemUserModelInitialCollection
    extends ModelInitialCollection<PointEcosystemUserModel> {
  const PointEcosystemUserModelInitialCollection(super.value);

  @override
  String get path => "plugins/pes/user";
  @override
  DynamicMap toMap(PointEcosystemUserModel value) => value.rawValue;
}

class $PointEcosystemUserModelDocument
    extends DocumentBase<PointEcosystemUserModel>
    with ModelRefMixin<PointEcosystemUserModel> {
  $PointEcosystemUserModelDocument(super.modelQuery);

  static const ModelAdapter? defaultModelAdapter = null;

  @override
  PointEcosystemUserModel fromMap(DynamicMap map) =>
      PointEcosystemUserModel.fromJson(map);
  @override
  DynamicMap toMap(PointEcosystemUserModel value) => value.rawValue;
}

class $PointEcosystemUserModelCollection
    extends CollectionBase<$PointEcosystemUserModelDocument>
    with
        FilterableCollectionMixin<$PointEcosystemUserModelDocument,
            _$_PointEcosystemUserModelCollectionQuery> {
  $PointEcosystemUserModelCollection(super.modelQuery);

  static const ModelAdapter? defaultModelAdapter = null;

  @override
  $PointEcosystemUserModelDocument create([String? id]) =>
      $PointEcosystemUserModelDocument(modelQuery.create(id));
  @override
  Future<CollectionBase<$PointEcosystemUserModelDocument>> filter(
      _$_PointEcosystemUserModelCollectionQuery Function(
              _$_PointEcosystemUserModelCollectionQuery source)
          callback) {
    final query =
        callback.call(_$_PointEcosystemUserModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

enum PointEcosystemUserModelCollectionKey { lastDate, continuousCount }

@immutable
class _$PointEcosystemUserModelDocumentQuery {
  const _$PointEcosystemUserModelDocumentQuery();

  @useResult
  _$_PointEcosystemUserModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
  }) {
    return _$_PointEcosystemUserModelDocumentQuery(DocumentModelQuery(
      "plugins/pes/user/$_id",
      adapter: adapter ?? $PointEcosystemUserModelDocument.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_PointEcosystemUserModelDocumentQuery
    extends ModelQueryBase<$PointEcosystemUserModelDocument> {
  const _$_PointEcosystemUserModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  $PointEcosystemUserModelDocument Function() call(Ref ref) =>
      () => $PointEcosystemUserModelDocument(modelQuery);
  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$PointEcosystemUserModelCollectionQuery {
  const _$PointEcosystemUserModelCollectionQuery();

  @useResult
  _$_PointEcosystemUserModelCollectionQuery call({ModelAdapter? adapter}) {
    return _$_PointEcosystemUserModelCollectionQuery(CollectionModelQuery(
      "plugins/pes/user",
      adapter:
          adapter ?? $PointEcosystemUserModelCollection.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_PointEcosystemUserModelCollectionQuery
    extends ModelQueryBase<$PointEcosystemUserModelCollection> {
  const _$_PointEcosystemUserModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  $PointEcosystemUserModelCollection Function() call(Ref ref) =>
      () => $PointEcosystemUserModelCollection(modelQuery);
  @override
  String get queryName => modelQuery.toString();
  _$_PointEcosystemUserModelCollectionQuery equal(
    PointEcosystemUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.equal(key.name, value));
  }

  _$_PointEcosystemUserModelCollectionQuery notEqual(
    PointEcosystemUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.notEqual(key.name, value));
  }

  _$_PointEcosystemUserModelCollectionQuery lessThan(
    PointEcosystemUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.lessThan(key.name, value));
  }

  _$_PointEcosystemUserModelCollectionQuery greaterThan(
    PointEcosystemUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.greaterThan(key.name, value));
  }

  _$_PointEcosystemUserModelCollectionQuery lessThanOrEqual(
    PointEcosystemUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.lessThanOrEqual(key.name, value));
  }

  _$_PointEcosystemUserModelCollectionQuery greaterThanOrEqual(
    PointEcosystemUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.greaterThanOrEqual(key.name, value));
  }

  _$_PointEcosystemUserModelCollectionQuery contains(
    PointEcosystemUserModelCollectionKey key,
    Object? value,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.contains(key.name, value));
  }

  _$_PointEcosystemUserModelCollectionQuery containsAny(
    PointEcosystemUserModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.containsAny(key.name, values));
  }

  _$_PointEcosystemUserModelCollectionQuery where(
    PointEcosystemUserModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.where(key.name, values));
  }

  _$_PointEcosystemUserModelCollectionQuery notWhere(
    PointEcosystemUserModelCollectionKey key,
    List<Object>? values,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.notWhere(key.name, values));
  }

  _$_PointEcosystemUserModelCollectionQuery isNull(
      PointEcosystemUserModelCollectionKey key) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.isNull(key.name));
  }

  _$_PointEcosystemUserModelCollectionQuery isNotNull(
      PointEcosystemUserModelCollectionKey key) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.isNotNull(key.name));
  }

  _$_PointEcosystemUserModelCollectionQuery geo(
    PointEcosystemUserModelCollectionKey key,
    List<String>? geoHash,
  ) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.geo(key.name, geoHash));
  }

  _$_PointEcosystemUserModelCollectionQuery orderByAsc(
      PointEcosystemUserModelCollectionKey key) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.orderByAsc(key.name));
  }

  _$_PointEcosystemUserModelCollectionQuery orderByDesc(
      PointEcosystemUserModelCollectionKey key) {
    return _$_PointEcosystemUserModelCollectionQuery(
        modelQuery.orderByDesc(key.name));
  }

  _$_PointEcosystemUserModelCollectionQuery limitTo(int value) {
    return _$_PointEcosystemUserModelCollectionQuery(modelQuery.limitTo(value));
  }

  _$_PointEcosystemUserModelCollectionQuery reset() {
    return _$_PointEcosystemUserModelCollectionQuery(modelQuery.reset());
  }
}

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$PointEcosystemUserModelFormQuery {
  const _$PointEcosystemUserModelFormQuery();

  @useResult
  _$_PointEcosystemUserModelFormQuery call(PointEcosystemUserModel value) {
    return _$_PointEcosystemUserModelFormQuery(value);
  }
}

@immutable
class _$_PointEcosystemUserModelFormQuery
    extends ControllerQueryBase<FormController<PointEcosystemUserModel>> {
  const _$_PointEcosystemUserModelFormQuery(this.value);

  final PointEcosystemUserModel value;

  @override
  FormController<PointEcosystemUserModel> Function() call(Ref ref) =>
      () => FormController(value);
  @override
  String get queryName => value.hashCode.toString();
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
