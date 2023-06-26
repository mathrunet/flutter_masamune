// ignore: unused_import, unnecessary_import
// ignore_for_file: invalid_annotation_target

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// Project imports:
import 'package:masamune_purchase_stripe/masamune_purchase_stripe.dart';

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

/// Data model for storing stripe user data.
///
/// Both the payer (customer) and the revenue receiver (account) are stored in this data.
///
/// ストライプのユーザーデータを保管するためのデータモデル。
///
/// 支払う側（カスタマー）や収益を受け取る側（アカウント）両方がこのデータに保存されます。
@freezed
@immutable
@CollectionModelPath("plugins/stripe/user")
class StripeUserModel with _$StripeUserModel {
  /// Data model for storing stripe user data.
  ///
  /// Both the payer (customer) and the revenue receiver (account) are stored in this data.
  ///
  /// ストライプのユーザーデータを保管するためのデータモデル。
  ///
  /// 支払う側（カスタマー）や収益を受け取る側（アカウント）両方がこのデータに保存されます。
  const factory StripeUserModel({
    @JsonKey(name: "user") required String userId,
    @JsonKey(name: "account") String? accountId,
    @JsonKey(name: "customer") String? customerId,
    @JsonKey(name: "defaultPayment") String? defaultPayment,
    @JsonKey(name: "capability") @Default({}) DynamicMap capablity,
  }) = _StripeUserModel;
  const StripeUserModel._();

  factory StripeUserModel.fromJson(Map<String, Object?> json) =>
      _$StripeUserModelFromJson(json);

  /// Returns `true` if the account is already registered.
  ///
  /// アカウントとしてすでに登録されている場合`true`を返します。
  bool get registered {
    return capablity.containsKey("transfers");
  }

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(StripePurchaseUserModel.document(id));      // Get the document.
  /// ref.model(StripePurchaseUserModel.document(id))..load(); // Load the document.
  /// ```
  static const document = _$$_StripeUserModelDocumentQuery();

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
  static const collection = _$$_StripeUserModelCollectionQuery();
}

@immutable
class _$$_StripeUserModelDocumentQuery {
  const _$$_StripeUserModelDocumentQuery();

  @useResult
  _$_StripeUserModelDocumentQuery call(
    Object id, {
    ModelAdapter? adapter,
  }) {
    return const _$StripeUserModelDocumentQuery().call(
      id,
      adapter: adapter ?? StripePurchaseMasamuneAdapter.primary.modelAdapter,
    );
  }
}

@immutable
class _$$_StripeUserModelCollectionQuery {
  const _$$_StripeUserModelCollectionQuery();

  @useResult
  _$_StripeUserModelCollectionQuery call({ModelAdapter? adapter}) {
    return const _$StripeUserModelCollectionQuery().call(
      adapter: adapter ?? StripePurchaseMasamuneAdapter.primary.modelAdapter,
    );
  }
}
