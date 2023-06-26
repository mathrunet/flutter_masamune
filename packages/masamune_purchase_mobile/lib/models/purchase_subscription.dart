// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import

part 'purchase_subscription.m.dart';
part 'purchase_subscription.g.dart';
part 'purchase_subscription.freezed.dart';

/// Alias for ModelRef<PurchaseSubscriptionModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @refParam PurchaseSubscriptionModelRef purchase_subscription
/// ```
typedef PurchaseSubscriptionModelRef = ModelRef<PurchaseSubscriptionModel>?;

/// Model for storing subscription data for billing purposes.
///
/// You can retrieve a collection or document by passing [collection] and [document], respectively.
///
/// 課金用のサブスクリプションデータを保存するためのモデル。
///
/// [collection]と[document]をそれぞれ渡すことによりコレクションやドキュメントを取得することができます。
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/iap/subscription")
class PurchaseSubscriptionModel with _$PurchaseSubscriptionModel {
  const factory PurchaseSubscriptionModel({
    @Default(true) bool expired,
    String? token,
    String? platform,
    String? productId,
    String? purchaseId,
    String? packageName,
    int? expiredTime,
    String? orderId,
    required String userId,
  }) = _PurchaseSubscriptionModel;
  const PurchaseSubscriptionModel._();

  factory PurchaseSubscriptionModel.fromJson(Map<String, Object?> json) =>
      _$PurchaseSubscriptionModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(PurchaseSubscriptionModel.document(id));      // Get the document.
  /// ref.model(PurchaseSubscriptionModel.document(id))..load(); // Load the document.
  /// ```
  static const document = _$PurchaseSubscriptionModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(PurchaseSubscriptionModel.collectoin());      // Get the collection.
  /// ref.model(PurchaseSubscriptionModel.collection())..load(); // Load the collection.
  /// ref.model(
  ///   PurchaseSubscriptionModel.collection().equal(
  ///     PurchaseSubscriptionModelCollectionKey.xxx,
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$PurchaseSubscriptionModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.page.controller(PurchaseSubscriptionModel.form());     // Get the form controller.
  /// ```
  static const form = _$PurchaseSubscriptionModelFormQuery();
}
