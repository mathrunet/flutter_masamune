// ignore_for_file: invalid_annotation_target

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

part 'stripe_payment.m.dart';
part 'stripe_payment.g.dart';
part 'stripe_payment.freezed.dart';

/// Alias for ModelRef<StripePurchasePaymentModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @refParam StripePurchasePaymentModelRef stripe_purchase_payment
/// ```
typedef StripePaymentModelRef = ModelRef<StripePaymentModel>?;

@freezed
@immutable
@CollectionModelPath("plugins/stripe/user/:user_id/payment")
class StripePaymentModel with _$StripePaymentModel {
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
  static const document = _$StripePaymentModelDocumentQuery();

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
  static const collection = _$StripePaymentModelCollectionQuery();
}