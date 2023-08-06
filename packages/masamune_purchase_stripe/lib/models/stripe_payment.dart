// ignore_for_file: invalid_annotation_target

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// Project imports:
import 'package:masamune_purchase_stripe/masamune_purchase_stripe.dart';

part 'stripe_payment.m.dart';
part 'stripe_payment.g.dart';
part 'stripe_payment.freezed.dart';

/// A model for storing data on payment methods for stripes.
///
/// ストライプの支払い方法のデータを保管するためのモデル。
@freezed
@immutable
@CollectionModelPath("plugins/stripe/user/:user_id/payment")
class StripePaymentModel with _$StripePaymentModel {
  /// A model for storing data on payment methods for stripes.
  ///
  /// ストライプの支払い方法のデータを保管するためのモデル。
  const factory StripePaymentModel({
    @JsonKey(name: "id") required String paymentId,
    @JsonKey(name: "type") required String type,
    @JsonKey(name: "expMonth") @Default(1) int expMonth,
    @JsonKey(name: "expYear") @Default(2000) int expYear,
    @JsonKey(name: "brand") required String brand,
    @JsonKey(name: "numberLast") required String numberLast,
    @JsonKey(name: "default") @Default(false) bool isDefault,
  }) = _StripePaymentModel;
  const StripePaymentModel._();

  factory StripePaymentModel.fromJson(Map<String, Object?> json) =>
      _$StripePaymentModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(StripePurchasePaymentModel.document(id));      // Get the document.
  /// ref.model(StripePurchasePaymentModel.document(id))..load(); // Load the document.
  /// ```
  static const document = _$$_StripePaymentModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(StripePurchasePaymentModel.collectoin());      // Get the collection.
  /// ref.model(StripePurchasePaymentModel.collection())..load(); // Load the collection.
  /// ref.model(
  ///   StripePurchasePaymentModel.collection().equal(
  ///     StripePurchasePaymentModelCollectionKey.xxx,
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$$_StripePaymentModelCollectionQuery();
}

@immutable
class _$$_StripePaymentModelDocumentQuery {
  const _$$_StripePaymentModelDocumentQuery();

  @useResult
  _$_StripePaymentModelDocumentQuery call(
    Object id, {
    required String userId,
    ModelAdapter? adapter,
  }) {
    return const _$StripePaymentModelDocumentQuery().call(
      id,
      userId: userId,
      adapter: adapter ?? StripePurchaseMasamuneAdapter.primary.modelAdapter,
    );
  }
}

@immutable
class _$$_StripePaymentModelCollectionQuery {
  const _$$_StripePaymentModelCollectionQuery();

  @useResult
  _$_StripePaymentModelCollectionQuery call({
    required String userId,
    ModelAdapter? adapter,
  }) {
    return const _$StripePaymentModelCollectionQuery().call(
      userId: userId,
      adapter: adapter ?? StripePurchaseMasamuneAdapter.primary.modelAdapter,
    );
  }
}

/// [Enum] of the name of the value defined in StripePaymentModel.
typedef StripePaymentModelKeys = _$StripePaymentModelKeys;

/// Alias for ModelRef<StripePaymentModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(StripePaymentModelDocument) StripePaymentModelRef replaced_collection
/// ```
typedef StripePaymentModelRef = ModelRef<StripePaymentModel>?;

/// It can be defined as an empty ModelRef<StripePaymentModel>.
///
/// ```dart
/// StripePaymentModelRefPath("xxx") // Define as a path.
/// ```
typedef StripePaymentModelRefPath = _$StripePaymentModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     StripePaymentModelInitialCollection(
///       "xxx": StripePaymentModel(...),
///     ),
///   ],
/// );
/// ```
typedef StripePaymentModelInitialCollection
    = _$StripePaymentModelInitialCollection;

/// Document class for storing StripePaymentModel.
typedef StripePaymentModelDocument = _$StripePaymentModelDocument;

/// Collection class for storing StripePaymentModel.
typedef StripePaymentModelCollection = _$StripePaymentModelCollection;

/// It can be defined as an empty ModelRef<StripePaymentModel>.
///
/// ```dart
/// StripePaymentModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef StripePaymentModelMirrorRefPath
    = _$StripePaymentModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     StripePaymentModelMirrorInitialCollection(
///       "xxx": StripePaymentModel(...),
///     ),
///   ],
/// );
/// ```
typedef StripePaymentModelMirrorInitialCollection
    = _$StripePaymentModelMirrorInitialCollection;

/// Document class for storing StripePaymentModel.
typedef StripePaymentModelMirrorDocument
    = _$StripePaymentModelMirrorDocument;

/// Collection class for storing StripePaymentModel.
typedef StripePaymentModelMirrorCollection
    = _$StripePaymentModelMirrorCollection;
