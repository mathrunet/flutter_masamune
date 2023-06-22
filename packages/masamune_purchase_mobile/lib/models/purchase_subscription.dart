// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

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

/// Value for model.
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
