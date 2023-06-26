// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import

part 'purchase_user.m.dart';
part 'purchase_user.g.dart';
part 'purchase_user.freezed.dart';

/// Alias for ModelRef<PurchaseUserModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @refParam PurchaseUserModelRef purchase_user
/// ```
typedef PurchaseUserModelRef = ModelRef<PurchaseUserModel>?;

/// Model for storing user data for billing purposes.
///
/// Here you can retrieve information about the user wallet.
///
/// You can retrieve a collection or document by passing [collection] and [document], respectively.
///
/// 課金用のユーザーデータを保存するためのモデル。
///
/// ここでユーザーウォレットの情報を取得することができます。
///
/// [collection]と[document]をそれぞれ渡すことによりコレクションやドキュメントを取得することができます。
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/iap/user")
class PurchaseUserModel with _$PurchaseUserModel {
  const factory PurchaseUserModel({
    @Default(0.0) double value,
  }) = _PurchaseUserModel;
  const PurchaseUserModel._();

  factory PurchaseUserModel.fromJson(Map<String, Object?> json) =>
      _$PurchaseUserModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(PurchaseUserModel.document(id));      // Get the document.
  /// ref.model(PurchaseUserModel.document(id))..load(); // Load the document.
  /// ```
  static const document = _$PurchaseUserModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(PurchaseUserModel.collectoin());      // Get the collection.
  /// ref.model(PurchaseUserModel.collection())..load(); // Load the collection.
  /// ref.model(
  ///   PurchaseUserModel.collection().equal(
  ///     PurchaseUserModelCollectionKey.xxx,
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$PurchaseUserModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.page.controller(PurchaseUserModel.form());     // Get the form controller.
  /// ```
  static const form = _$PurchaseUserModelFormQuery();
}
