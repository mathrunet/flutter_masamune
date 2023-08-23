// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import

part 'purchase_user.m.dart';
part 'purchase_user.g.dart';
part 'purchase_user.freezed.dart';

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
  const factory PurchaseUserModel({
    @Default(0.0) double value,
  }) = _PurchaseUserModel;
  const PurchaseUserModel._();

  factory PurchaseUserModel.fromJson(Map<String, Object?> json) =>
      _$PurchaseUserModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// PurchaseUserModel.document(id).read(appRef);       // Get the document.
  /// PurchaseUserModel.document(id).watch(ref)..load(); // Load the document.
  /// ```
  static const document = _$PurchaseUserModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// PurchaseUserModel.collection().read(appRef);       // Get the collection.
  /// PurchaseUserModel.collection().watch(ref)..load(); // Load the collection.
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
  /// PurchaseUserModel.form(PurchaseUserModel()).watch(ref);    // Get the form controller.
  /// ```
  static const form = _$PurchaseUserModelFormQuery();
}

/// [Enum] of the name of the value defined in PurchaseUserModel.
typedef PurchaseUserModelKeys = _$PurchaseUserModelKeys;

/// Alias for ModelRef<PurchaseUserModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(PurchaseUserModelDocument) PurchaseUserModelRef replaced_collection
/// ```
typedef PurchaseUserModelRef = ModelRef<PurchaseUserModel>?;

/// It can be defined as an empty ModelRef<PurchaseUserModel>.
///
/// ```dart
/// PurchaseUserModelRefPath("xxx") // Define as a path.
/// ```
typedef PurchaseUserModelRefPath = _$PurchaseUserModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PurchaseUserModelInitialCollection(
///       "xxx": PurchaseUserModel(...),
///     ),
///   ],
/// );
/// ```
typedef PurchaseUserModelInitialCollection
    = _$PurchaseUserModelInitialCollection;

/// Document class for storing PurchaseUserModel.
typedef PurchaseUserModelDocument = _$PurchaseUserModelDocument;

/// Collection class for storing PurchaseUserModel.
typedef PurchaseUserModelCollection = _$PurchaseUserModelCollection;

/// It can be defined as an empty ModelRef<PurchaseUserModel>.
///
/// ```dart
/// PurchaseUserModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef PurchaseUserModelMirrorRefPath = _$PurchaseUserModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PurchaseUserModelMirrorInitialCollection(
///       "xxx": PurchaseUserModel(...),
///     ),
///   ],
/// );
/// ```
typedef PurchaseUserModelMirrorInitialCollection
    = _$PurchaseUserModelMirrorInitialCollection;

/// Document class for storing PurchaseUserModel.
typedef PurchaseUserModelMirrorDocument = _$PurchaseUserModelMirrorDocument;

/// Collection class for storing PurchaseUserModel.
typedef PurchaseUserModelMirrorCollection = _$PurchaseUserModelMirrorCollection;
