// ignore: unused_import, unnecessary_import
// ignore_for_file: invalid_annotation_target

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// Project imports:
import 'package:masamune_purchase_stripe/masamune_purchase_stripe.dart';

part 'stripe_purchase.m.dart';
part 'stripe_purchase.g.dart';
part 'stripe_purchase.freezed.dart';

/// Data model for storing Stripe purchase information.
///
/// All payments to the operation, payments between users, and subscriptions are stored in this database.
///
/// Stripe購入情報を保管するためのデータモデル。
///
/// 運営への支払い、ユーザー間の支払い、サブスクリプションすべてこのデータベースに保存されます。
@freezed
@immutable
@CollectionModelPath("plugins/stripe/user/:user_id/purchase")
class StripePurchaseModel with _$StripePurchaseModel {
  /// Data model for storing Stripe purchase information.
  ///
  /// All payments to the operation, payments between users, and subscriptions are stored in this database.
  ///
  /// Stripe購入情報を保管するためのデータモデル。
  ///
  /// 運営への支払い、ユーザー間の支払い、サブスクリプションすべてこのデータベースに保存されます。
  const factory StripePurchaseModel({
    @JsonKey(name: "user")
        required String userId,
    @JsonKey(name: "confirm")
    @Default(false)
        bool confirm,
    @JsonKey(name: "verify")
    @Default(false)
        bool verified,
    @JsonKey(name: "capture")
    @Default(false)
        bool captured,
    @JsonKey(name: "success")
    @Default(false)
        bool success,
    @JsonKey(name: "cancel")
    @Default(false)
        bool canceled,
    @JsonKey(name: "error")
    @Default(false)
        bool error,
    @JsonKey(name: "refund")
    @Default(false)
        bool refund,
    @JsonKey(name: "orderId")
        required String orderId,
    @JsonKey(name: "purchaseId")
        required String purchaseId,
    @JsonKey(name: "paymentMethodId")
        required String paymentMethodId,
    @JsonKey(name: "customer")
        required String customerId,
    @JsonKey(name: "amount")
    @Default(0.0)
        double amount,
    @JsonKey(name: "application")
        String? application,
    @JsonKey(name: "applicationFeeAmount")
    @Default(0.0)
        double applicationFeeAmount,
    @JsonKey(name: "transferAmount")
    @Default(0.0)
        double transferAmount,
    @JsonKey(name: "transferDistination")
    @Default("")
        String transferDistination,
    @JsonKey(name: "currency")
    @Default("jpy")
        String currency,
    @JsonKey(name: "clientSecret")
        required String clientSecret,
    @JsonKey(name: "createdTime")
        required ModelTimestamp createdTime,
    @JsonKey(name: "updatedTime")
        required ModelTimestamp updatedTime,
    @JsonKey(name: "emailFrom")
        String? emailFrom,
    @JsonKey(name: "emailTo")
        String? emailTo,
    @JsonKey(name: "emailTitle")
        String? emailTitle,
    @JsonKey(name: "emailContent")
        String? emailContent,
    @JsonKey(name: "locale")
        String? locale,
    @JsonKey(name: "cancel_at_period_end")
    @Default(false)
        bool cancelAtPeriodEnd,
  }) = _StripePurchaseModel;
  const StripePurchaseModel._();

  factory StripePurchaseModel.fromJson(Map<String, Object?> json) =>
      _$StripePurchaseModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(StripePurchasePurchaseModel.document(id));      // Get the document.
  /// ref.model(StripePurchasePurchaseModel.document(id))..load(); // Load the document.
  /// ```
  static const document = _$$_StripePurchaseModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(StripePurchasePurchaseModel.collectoin());      // Get the collection.
  /// ref.model(StripePurchasePurchaseModel.collection())..load(); // Load the collection.
  /// ref.model(
  ///   StripePurchasePurchaseModel.collection().equal(
  ///     StripePurchasePurchaseModelCollectionKey.xxx,
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$$_StripePurchaseModelCollectionQuery();
}

/// [Enum] of the name of the value defined in StripePurchaseModel.
typedef StripePurchaseModelKeys = _$StripePurchaseModelKeys;

/// Alias for ModelRef<StripePurchaseModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(StripePurchaseModelDocument) StripePurchaseModelRef replaced_collection
/// ```
typedef StripePurchaseModelRef = ModelRef<StripePurchaseModel>?;

/// It can be defined as an empty ModelRef<StripePurchaseModel>.
///
/// ```dart
/// StripePurchaseModelRefPath("xxx") // Define as a path.
/// ```
typedef StripePurchaseModelRefPath = _$StripePurchaseModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     StripePurchaseModelInitialCollection(
///       "xxx": StripePurchaseModel(...),
///     ),
///   ],
/// );
/// ```
typedef StripePurchaseModelInitialCollection
    = _$StripePurchaseModelInitialCollection;

/// Document class for storing StripePurchaseModel.
typedef StripePurchaseModelDocument = _$StripePurchaseModelDocument;

/// Collection class for storing StripePurchaseModel.
typedef StripePurchaseModelCollection = _$StripePurchaseModelCollection;

/// It can be defined as an empty ModelRef<StripePurchaseModel>.
///
/// ```dart
/// StripePurchaseModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef StripePurchaseModelMirrorRefPath = _$StripePurchaseModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     StripePurchaseModelMirrorInitialCollection(
///       "xxx": StripePurchaseModel(...),
///     ),
///   ],
/// );
/// ```
typedef StripePurchaseModelMirrorInitialCollection
    = _$StripePurchaseModelMirrorInitialCollection;

/// Document class for storing StripePurchaseModel.
typedef StripePurchaseModelMirrorDocument = _$StripePurchaseModelMirrorDocument;

/// Collection class for storing StripePurchaseModel.
typedef StripePurchaseModelMirrorCollection
    = _$StripePurchaseModelMirrorCollection;

@immutable
class _$$_StripePurchaseModelDocumentQuery {
  const _$$_StripePurchaseModelDocumentQuery();

  @useResult
  _$_StripePurchaseModelDocumentQuery call(
    Object id, {
    required String userId,
    ModelAdapter? adapter,
  }) {
    return const _$StripePurchaseModelDocumentQuery().call(
      id,
      userId: userId,
      adapter: adapter ?? StripePurchaseMasamuneAdapter.primary.modelAdapter,
    );
  }
}

@immutable
class _$$_StripePurchaseModelCollectionQuery {
  const _$$_StripePurchaseModelCollectionQuery();

  @useResult
  _$_StripePurchaseModelCollectionQuery call({
    required String userId,
    ModelAdapter? adapter,
  }) {
    return const _$StripePurchaseModelCollectionQuery().call(
      userId: userId,
      adapter: adapter ?? StripePurchaseMasamuneAdapter.primary.modelAdapter,
    );
  }
}
