// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'stripe_payment.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on StripePaymentModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$StripePaymentModelKeys {
  paymentId,
  type,
  expMonth,
  expYear,
  brand,
  numberLast,
  isDefault
}

class _$StripePaymentModelDocument extends DocumentBase<StripePaymentModel>
    with ModelRefMixin<StripePaymentModel> {
  _$StripePaymentModelDocument(super.modelQuery);

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  StripePaymentModel fromMap(DynamicMap map) =>
      StripePaymentModel.fromJson(map);
  @override
  DynamicMap toMap(StripePaymentModel value) => value.rawValue;
}

typedef _$StripePaymentModelMirrorDocument = _$StripePaymentModelDocument;

class _$StripePaymentModelCollection
    extends CollectionBase<_$StripePaymentModelDocument>
    with
        FilterableCollectionMixin<_$StripePaymentModelDocument,
            _$_StripePaymentModelCollectionQuery> {
  _$StripePaymentModelCollection(super.modelQuery);

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$StripePaymentModelDocument create([String? id]) =>
      _$StripePaymentModelDocument(modelQuery.create(id));
  @override
  Future<CollectionBase<_$StripePaymentModelDocument>> filter(
      _$_StripePaymentModelCollectionQuery Function(
              _$_StripePaymentModelCollectionQuery source)
          callback) {
    final query =
        callback.call(_$_StripePaymentModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$StripePaymentModelMirrorCollection = _$StripePaymentModelCollection;

@immutable
class _$StripePaymentModelRefPath extends ModelRefPath<StripePaymentModel> {
  const _$StripePaymentModelRefPath(
    super.uid, {
    required String userId,
  }) : _userId = userId;

  final String _userId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "plugins/stripe/user/$_userId/payment/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$StripePaymentModelInitialCollection
    extends ModelInitialCollection<StripePaymentModel> {
  const _$StripePaymentModelInitialCollection(
    super.value, {
    required String userId,
  }) : _userId = userId;

  final String _userId;

  @override
  String get path => "plugins/stripe/user/$_userId/payment";
  @override
  DynamicMap toMap(StripePaymentModel value) => value.rawValue;
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
      adapter: adapter ?? _$StripePaymentModelDocument.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_StripePaymentModelDocumentQuery
    extends ModelQueryBase<_$StripePaymentModelDocument> {
  const _$_StripePaymentModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$StripePaymentModelDocument Function() call(Ref ref) =>
      () => _$StripePaymentModelDocument(modelQuery);
  @override
  String get queryName => modelQuery.toString();
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
      adapter: adapter ?? _$StripePaymentModelCollection.defaultModelAdapter,
    ));
  }
}

@immutable
class _$_StripePaymentModelCollectionQuery
    extends ModelQueryBase<_$StripePaymentModelCollection> {
  const _$_StripePaymentModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$StripePaymentModelCollection Function() call(Ref ref) =>
      () => _$StripePaymentModelCollection(modelQuery);
  @override
  String get queryName => modelQuery.toString();
  static _$_StripePaymentModelCollectionQuery _toQuery(
          CollectionModelQuery query) =>
      _$_StripePaymentModelCollectionQuery(query);
  _$_StripePaymentModelCollectionQuery limitTo(int value) =>
      _$_StripePaymentModelCollectionQuery(modelQuery.limitTo(value));
  _$_StripePaymentModelCollectionQuery reset() =>
      _$_StripePaymentModelCollectionQuery(modelQuery.reset());
  StringModelQuerySelector<_$_StripePaymentModelCollectionQuery>
      get paymentId =>
          StringModelQuerySelector<_$_StripePaymentModelCollectionQuery>(
              key: "paymentId", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_StripePaymentModelCollectionQuery> get type =>
      StringModelQuerySelector<_$_StripePaymentModelCollectionQuery>(
          key: "type", toQuery: _toQuery, modelQuery: modelQuery);
  NumModelQuerySelector<_$_StripePaymentModelCollectionQuery> get expMonth =>
      NumModelQuerySelector<_$_StripePaymentModelCollectionQuery>(
          key: "expMonth", toQuery: _toQuery, modelQuery: modelQuery);
  NumModelQuerySelector<_$_StripePaymentModelCollectionQuery> get expYear =>
      NumModelQuerySelector<_$_StripePaymentModelCollectionQuery>(
          key: "expYear", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_StripePaymentModelCollectionQuery> get brand =>
      StringModelQuerySelector<_$_StripePaymentModelCollectionQuery>(
          key: "brand", toQuery: _toQuery, modelQuery: modelQuery);
  StringModelQuerySelector<_$_StripePaymentModelCollectionQuery>
      get numberLast =>
          StringModelQuerySelector<_$_StripePaymentModelCollectionQuery>(
              key: "numberLast", toQuery: _toQuery, modelQuery: modelQuery);
  BooleanModelQuerySelector<_$_StripePaymentModelCollectionQuery>
      get isDefault =>
          BooleanModelQuerySelector<_$_StripePaymentModelCollectionQuery>(
              key: "isDefault", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$StripePaymentModelMirrorRefPath = _$StripePaymentModelRefPath;
typedef _$StripePaymentModelMirrorInitialCollection
    = _$StripePaymentModelInitialCollection;
