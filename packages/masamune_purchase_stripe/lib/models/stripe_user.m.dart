// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'stripe_user.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on StripeUserModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$StripeUserModelKeys {
  userId,
  accountId,
  customerId,
  defaultPayment,
  capablity
}

class _$StripeUserModelDocument extends DocumentBase<StripeUserModel>
    with ModelRefMixin<StripeUserModel> {
  _$StripeUserModelDocument(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  StripeUserModel fromMap(DynamicMap map) => StripeUserModel.fromJson(map);

  @override
  DynamicMap toMap(StripeUserModel value) => value.rawValue;
}

typedef _$StripeUserModelMirrorDocument = _$StripeUserModelDocument;

class _$StripeUserModelCollection
    extends CollectionBase<_$StripeUserModelDocument>
    with
        FilterableCollectionMixin<_$StripeUserModelDocument,
            _$_StripeUserModelCollectionQuery> {
  _$StripeUserModelCollection(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$StripeUserModelDocument create([String? id]) =>
      _$StripeUserModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$StripeUserModelDocument>> filter(
      _$_StripeUserModelCollectionQuery Function(
              _$_StripeUserModelCollectionQuery source)
          callback) {
    final query = callback.call(_$_StripeUserModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$StripeUserModelMirrorCollection = _$StripeUserModelCollection;

@immutable
class _$StripeUserModelRefPath extends ModelRefPath<StripeUserModel> {
  const _$StripeUserModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/stripe/user/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$StripeUserModelInitialCollection
    extends ModelInitialCollection<StripeUserModel> {
  const _$StripeUserModelInitialCollection(super.value);

  @override
  String get path => "plugins/stripe/user";

  @override
  DynamicMap toMap(StripeUserModel value) => value.rawValue;
}

@immutable
class _$StripeUserModelDocumentQuery {
  const _$StripeUserModelDocumentQuery();

  @useResult
  _$_StripeUserModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_StripeUserModelDocumentQuery(DocumentModelQuery(
      "plugins/stripe/user/$_id",
      adapter: adapter ?? _$StripeUserModelDocument.defaultModelAdapter,
      accessQuery:
          accessQuery ?? _$StripeUserModelDocument.defaultModelAccessQuery,
      validationQueries: _$StripeUserModelDocument.defaultValidationQueries,
    ));
  }
}

@immutable
class _$_StripeUserModelDocumentQuery
    extends ModelQueryBase<_$StripeUserModelDocument> {
  const _$_StripeUserModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$StripeUserModelDocument Function() call(Ref ref) =>
      () => _$StripeUserModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$StripeUserModelCollectionQuery {
  const _$StripeUserModelCollectionQuery();

  @useResult
  _$_StripeUserModelCollectionQuery call({
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_StripeUserModelCollectionQuery(CollectionModelQuery(
      "plugins/stripe/user",
      adapter: adapter ?? _$StripeUserModelCollection.defaultModelAdapter,
      accessQuery:
          accessQuery ?? _$StripeUserModelCollection.defaultModelAccessQuery,
      validationQueries: _$StripeUserModelCollection.defaultValidationQueries,
    ));
  }
}

@immutable
class _$_StripeUserModelCollectionQuery
    extends ModelQueryBase<_$StripeUserModelCollection> {
  const _$_StripeUserModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$StripeUserModelCollection Function() call(Ref ref) =>
      () => _$StripeUserModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_StripeUserModelCollectionQuery _toQuery(
          CollectionModelQuery query) =>
      _$_StripeUserModelCollectionQuery(query);

  _$_StripeUserModelCollectionQuery limitTo(int value) =>
      _$_StripeUserModelCollectionQuery(modelQuery.limitTo(value));

  _$_StripeUserModelCollectionQuery collectionGroup() =>
      _$_StripeUserModelCollectionQuery(modelQuery.collectionGroup());

  _$_StripeUserModelCollectionQuery reset() =>
      _$_StripeUserModelCollectionQuery(modelQuery.reset());

  _$_StripeUserModelCollectionQuery notifyDocumentChanges() =>
      _$_StripeUserModelCollectionQuery(modelQuery.notifyDocumentChanges());

  StringModelQuerySelector<_$_StripeUserModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_StripeUserModelCollectionQuery>(
          key: "@uid", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_StripeUserModelCollectionQuery> get userId =>
      StringModelQuerySelector<_$_StripeUserModelCollectionQuery>(
          key: "userId", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_StripeUserModelCollectionQuery> get accountId =>
      StringModelQuerySelector<_$_StripeUserModelCollectionQuery>(
          key: "accountId", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_StripeUserModelCollectionQuery> get customerId =>
      StringModelQuerySelector<_$_StripeUserModelCollectionQuery>(
          key: "customerId", toQuery: _toQuery, modelQuery: modelQuery);

  StringModelQuerySelector<_$_StripeUserModelCollectionQuery>
      get defaultPayment =>
          StringModelQuerySelector<_$_StripeUserModelCollectionQuery>(
              key: "defaultPayment", toQuery: _toQuery, modelQuery: modelQuery);

  MapModelQuerySelector<dynamic, _$_StripeUserModelCollectionQuery>
      get capablity =>
          MapModelQuerySelector<dynamic, _$_StripeUserModelCollectionQuery>(
              key: "capablity", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$StripeUserModelMirrorRefPath = _$StripeUserModelRefPath;
typedef _$StripeUserModelMirrorInitialCollection
    = _$StripeUserModelInitialCollection;
