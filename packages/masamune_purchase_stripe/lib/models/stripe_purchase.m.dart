// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'stripe_purchase.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on StripePurchaseModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$StripePurchaseModelKeys {
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
  cancelAtPeriodEnd,
}

class _$StripePurchaseModelDocument extends DocumentBase<StripePurchaseModel>
    with ModelRefMixin<StripePurchaseModel> {
  _$StripePurchaseModelDocument(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  StripePurchaseModel fromMap(DynamicMap map) =>
      StripePurchaseModel.fromJson(map);

  @override
  DynamicMap toMap(StripePurchaseModel value) => value.rawValue;
}

typedef _$StripePurchaseModelMirrorDocument = _$StripePurchaseModelDocument;

class _$StripePurchaseModelCollection
    extends CollectionBase<_$StripePurchaseModelDocument>
    with
        FilterableCollectionMixin<_$StripePurchaseModelDocument,
            _$_StripePurchaseModelCollectionQuery> {
  _$StripePurchaseModelCollection(super.modelQuery);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$StripePurchaseModelDocument create([String? id]) =>
      _$StripePurchaseModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$StripePurchaseModelDocument>> filter(
    _$_StripePurchaseModelCollectionQuery Function(
      _$_StripePurchaseModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_StripePurchaseModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$StripePurchaseModelMirrorCollection = _$StripePurchaseModelCollection;

@immutable
class _$StripePurchaseModelRefPath extends ModelRefPath<StripePurchaseModel> {
  const _$StripePurchaseModelRefPath(super.uid, {required String userId})
      : _userId = userId;

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
class _$StripePurchaseModelInitialCollection
    extends ModelInitialCollection<StripePurchaseModel> {
  const _$StripePurchaseModelInitialCollection(
    super.value, {
    required String userId,
  }) : _userId = userId;

  final String _userId;

  @override
  String get path => "plugins/stripe/user/$_userId/purchase";

  @override
  DynamicMap toMap(StripePurchaseModel value) => value.rawValue;
}

@immutable
class _$StripePurchaseModelDocumentQuery {
  const _$StripePurchaseModelDocumentQuery();

  @useResult
  _$_StripePurchaseModelDocumentQuery call(
    Object _id, {
    required String userId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_StripePurchaseModelDocumentQuery(
      DocumentModelQuery(
        "plugins/stripe/user/$userId/purchase/$_id",
        adapter: adapter ?? _$StripePurchaseModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$StripePurchaseModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$StripePurchaseModelDocument.defaultValidationQueries,
      ),
    );
  }

  bool hasMatchPath(String path) {
    return RegExp(
      "plugins/stripe/user/[^/]+/purchase/[^/]+".trimQuery().trimString("/"),
    ).hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_StripePurchaseModelDocumentQuery
    extends ModelQueryBase<_$StripePurchaseModelDocument> {
  const _$_StripePurchaseModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$StripePurchaseModelDocument Function() call(Ref ref) =>
      () => _$StripePurchaseModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$StripePurchaseModelCollectionQuery {
  const _$StripePurchaseModelCollectionQuery();

  @useResult
  _$_StripePurchaseModelCollectionQuery call({
    required String userId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_StripePurchaseModelCollectionQuery(
      CollectionModelQuery(
        "plugins/stripe/user/$userId/purchase",
        adapter: adapter ?? _$StripePurchaseModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$StripePurchaseModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$StripePurchaseModelCollection.defaultValidationQueries,
      ),
    );
  }

  bool hasMatchPath(String path) {
    return RegExp(
      "plugins/stripe/user/[^/]+/purchase".trimQuery().trimString("/"),
    ).hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_StripePurchaseModelCollectionQuery
    extends ModelQueryBase<_$StripePurchaseModelCollection> {
  const _$_StripePurchaseModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$StripePurchaseModelCollection Function() call(Ref ref) =>
      () => _$StripePurchaseModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_StripePurchaseModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_StripePurchaseModelCollectionQuery(query);

  _$_StripePurchaseModelCollectionQuery collectionGroup() =>
      _$_StripePurchaseModelCollectionQuery(modelQuery.collectionGroup());

  _$_StripePurchaseModelCollectionQuery reset() =>
      _$_StripePurchaseModelCollectionQuery(modelQuery.reset());

  _$_StripePurchaseModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_StripePurchaseModelCollectionQuery(modelQuery.remove(type));

  _$_StripePurchaseModelCollectionQuery notifyDocumentChanges() =>
      _$_StripePurchaseModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_StripePurchaseModelCollectionQuery limitTo(int value) =>
      _$_StripePurchaseModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery> get userId =>
      StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
        key: "user",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get confirm =>
          BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "confirm",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get verified =>
          BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "verify",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get captured =>
          BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "capture",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get success =>
          BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "success",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get canceled =>
          BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "cancel",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery> get error =>
      BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
        key: "error",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery> get refund =>
      BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
        key: "refund",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery> get orderId =>
      StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
        key: "orderId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get purchaseId =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "purchaseId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get paymentMethodId =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "paymentMethodId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get customerId =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "customer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_StripePurchaseModelCollectionQuery> get amount =>
      NumModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
        key: "amount",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get application =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "application",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get applicationFeeAmount =>
          NumModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "applicationFeeAmount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get transferAmount =>
          NumModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "transferAmount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get transferDistination =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "transferDistination",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get currency =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "currency",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get clientSecret =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "clientSecret",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get createdTime => ModelTimestampModelQuerySelector<
              _$_StripePurchaseModelCollectionQuery>(
            key: "createdTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get updatedTime => ModelTimestampModelQuerySelector<
              _$_StripePurchaseModelCollectionQuery>(
            key: "updatedTime",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get emailFrom =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "emailFrom",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery> get emailTo =>
      StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
        key: "emailTo",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get emailTitle =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "emailTitle",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get emailContent =>
          StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "emailContent",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery> get locale =>
      StringModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
        key: "locale",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>
      get cancelAtPeriodEnd =>
          BooleanModelQuerySelector<_$_StripePurchaseModelCollectionQuery>(
            key: "cancel_at_period_end",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$StripePurchaseModelMirrorRefPath = _$StripePurchaseModelRefPath;
typedef _$StripePurchaseModelMirrorInitialCollection
    = _$StripePurchaseModelInitialCollection;
