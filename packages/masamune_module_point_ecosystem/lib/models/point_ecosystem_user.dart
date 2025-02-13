// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import

part 'point_ecosystem_user.m.dart';
part 'point_ecosystem_user.g.dart';
part 'point_ecosystem_user.freezed.dart';

/// User model for managing point login bonuses, etc.
///
/// ポイントのログインボーナスなどを管理するためのユーザーモデル。
@freezed
@formValue
@immutable
@CollectionModelPath(PointEcosystemUserModel.path)
class PointEcosystemUserModel with _$PointEcosystemUserModel {
  /// User model for managing point login bonuses, etc.
  ///
  /// ポイントのログインボーナスなどを管理するためのユーザーモデル。
  const factory PointEcosystemUserModel({
    ModelTimestamp? lastDate,
    @Default(0) int continuousCount,
  }) = _PointEcosystemUserModel;
  const PointEcosystemUserModel._();

  factory PointEcosystemUserModel.fromJson(Map<String, Object?> json) =>
      _$PointEcosystemUserModelFromJson(json);

  /// Model path.
  ///
  /// モデルのパス。
  static const String path = "plugins/pes/user";

  /// Query for document.
  ///
  /// ```dart
  /// appref.app.model(PointEcosystemUserModel.document(id));       // Get the document.
  /// ref.app.model(PointEcosystemUserModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$PointEcosystemUserModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(PointEcosystemUserModel.collection());       // Get the collection.
  /// ref.app.model(PointEcosystemUserModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   PointEcosystemUserModel.collection().equal(
  ///     PointEcosystemUserModelCollectionKey.xxx,
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$PointEcosystemUserModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(PointEcosystemUserModel.form(PointEcosystemUserModel()));    // Get the form controller in app scope.
  /// ref.page.form(PointEcosystemUserModel.form(PointEcosystemUserModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$PointEcosystemUserModelFormQuery();
}

/// [Enum] of the name of the value defined in PointEcosystemUserModel.
typedef PointEcosystemUserModelKeys = _$PointEcosystemUserModelKeys;

/// Alias for ModelRef&lt;PointEcosystemUserModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(PointEcosystemUserModelDocument) PointEcosystemUserModelRef replaced_collection
/// ```
typedef PointEcosystemUserModelRef = ModelRef<PointEcosystemUserModel>?;

/// It can be defined as an empty ModelRef&lt;PointEcosystemUserModel&gt;.
///
/// ```dart
/// PointEcosystemUserModelRefPath("xxx") // Define as a path.
/// ```
typedef PointEcosystemUserModelRefPath = _$PointEcosystemUserModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PointEcosystemUserModelInitialCollection(
///       "xxx": PointEcosystemUserModel(...),
///     ),
///   ],
/// );
/// ```
typedef PointEcosystemUserModelInitialCollection
    = _$PointEcosystemUserModelInitialCollection;

/// Document class for storing PointEcosystemUserModel.
typedef PointEcosystemUserModelDocument = _$PointEcosystemUserModelDocument;

/// Collection class for storing PointEcosystemUserModel.
typedef PointEcosystemUserModelCollection = _$PointEcosystemUserModelCollection;

/// It can be defined as an empty ModelRef&lt;PointEcosystemUserModel&gt;.
///
/// ```dart
/// PointEcosystemUserModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef PointEcosystemUserModelMirrorRefPath
    = _$PointEcosystemUserModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PointEcosystemUserModelMirrorInitialCollection(
///       "xxx": PointEcosystemUserModel(...),
///     ),
///   ],
/// );
/// ```
typedef PointEcosystemUserModelMirrorInitialCollection
    = _$PointEcosystemUserModelMirrorInitialCollection;

/// Document class for storing PointEcosystemUserModel.
typedef PointEcosystemUserModelMirrorDocument
    = _$PointEcosystemUserModelMirrorDocument;

/// Collection class for storing PointEcosystemUserModel.
typedef PointEcosystemUserModelMirrorCollection
    = _$PointEcosystemUserModelMirrorCollection;
