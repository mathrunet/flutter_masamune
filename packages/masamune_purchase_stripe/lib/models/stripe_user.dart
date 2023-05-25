// ignore: unused_import, unnecessary_import
// ignore_for_file: invalid_annotation_target

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

part 'stripe_user.m.dart';
part 'stripe_user.g.dart';
part 'stripe_user.freezed.dart';

/// Alias for ModelRef<StripePurchaseUserModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @refParam StripePurchaseUserModelRef stripe_purchase_user
/// ```
typedef StripeUserModelRef = ModelRef<StripeUserModel>?;

@freezed
@immutable
@CollectionModelPath("plugins/stripe/user")
class StripeUserModel with _$StripeUserModel {
  const factory StripeUserModel({
    @JsonKey(name: "user") required String userId,
    @JsonKey(name: "account") required String accountId,
    @JsonKey(name: "customer") required String customerId,
    @JsonKey(name: "defaultPayment") String? defaultPayment,
    @JsonKey(name: "capability") @Default({}) DynamicMap capablity,
  }) = _StripeUserModel;
  const StripeUserModel._();

  factory StripeUserModel.fromJson(Map<String, Object?> json) =>
      _$StripeUserModelFromJson(json);

  bool get registered {
    return capablity.containsKey("transfers");
  }

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(StripePurchaseUserModel.document(id));      // Get the document.
  /// ref.model(StripePurchaseUserModel.document(id))..load(); // Load the document.
  /// ```
  static const document = _$StripeUserModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(StripePurchaseUserModel.collectoin());      // Get the collection.
  /// ref.model(StripePurchaseUserModel.collection())..load(); // Load the collection.
  /// ref.model(
  ///   StripePurchaseUserModel.collection().equal(
  ///     StripePurchaseUserModelCollectionKey.xxx,
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$StripeUserModelCollectionQuery();
}
