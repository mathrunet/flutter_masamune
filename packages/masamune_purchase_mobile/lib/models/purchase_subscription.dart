// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import

part 'purchase_subscription.m.dart';
part 'purchase_subscription.g.dart';
part 'purchase_subscription.freezed.dart';

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
  /// Model for storing subscription data for billing purposes.
  ///
  /// You can retrieve a collection or document by passing [collection] and [document], respectively.
  ///
  /// 課金用のサブスクリプションデータを保存するためのモデル。
  ///
  /// [collection]と[document]をそれぞれ渡すことによりコレクションやドキュメントを取得することができます。
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
  /// PurchaseSubscriptionModel.document(id).read(appRef);       // Get the document.
  /// PurchaseSubscriptionModel.document(id).watch(ref)..load(); // Load the document.
  /// ```
  static const document = _$PurchaseSubscriptionModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// PurchaseSubscriptionModel.collection().read(appRef);       // Get the collection.
  /// PurchaseSubscriptionModel.collection().watch(ref)..load(); // Load the collection.
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
  /// PurchaseSubscriptionModel.form(PurchaseSubscriptionModel()).watch(ref);    // Get the form controller.
  /// ```
  static const form = _$PurchaseSubscriptionModelFormQuery();
}

/// [Enum] of the name of the value defined in PurchaseSubscriptionModel.
typedef PurchaseSubscriptionModelKeys = _$PurchaseSubscriptionModelKeys;

/// Alias for ModelRef<PurchaseSubscriptionModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(PurchaseSubscriptionModelDocument) PurchaseSubscriptionModelRef replaced_collection
/// ```
typedef PurchaseSubscriptionModelRef = ModelRef<PurchaseSubscriptionModel>?;

/// It can be defined as an empty ModelRef<PurchaseSubscriptionModel>.
///
/// ```dart
/// PurchaseSubscriptionModelRefPath("xxx") // Define as a path.
/// ```
typedef PurchaseSubscriptionModelRefPath = _$PurchaseSubscriptionModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PurchaseSubscriptionModelInitialCollection(
///       "xxx": PurchaseSubscriptionModel(...),
///     ),
///   ],
/// );
/// ```
typedef PurchaseSubscriptionModelInitialCollection
    = _$PurchaseSubscriptionModelInitialCollection;

/// Document class for storing PurchaseSubscriptionModel.
typedef PurchaseSubscriptionModelDocument = _$PurchaseSubscriptionModelDocument;

/// Collection class for storing PurchaseSubscriptionModel.
typedef PurchaseSubscriptionModelCollection
    = _$PurchaseSubscriptionModelCollection;

/// It can be defined as an empty ModelRef<PurchaseSubscriptionModel>.
///
/// ```dart
/// PurchaseSubscriptionModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef PurchaseSubscriptionModelMirrorRefPath
    = _$PurchaseSubscriptionModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PurchaseSubscriptionModelMirrorInitialCollection(
///       "xxx": PurchaseSubscriptionModel(...),
///     ),
///   ],
/// );
/// ```
typedef PurchaseSubscriptionModelMirrorInitialCollection
    = _$PurchaseSubscriptionModelMirrorInitialCollection;

/// Document class for storing PurchaseSubscriptionModel.
typedef PurchaseSubscriptionModelMirrorDocument
    = _$PurchaseSubscriptionModelMirrorDocument;

/// Collection class for storing PurchaseSubscriptionModel.
typedef PurchaseSubscriptionModelMirrorCollection
    = _$PurchaseSubscriptionModelMirrorCollection;
