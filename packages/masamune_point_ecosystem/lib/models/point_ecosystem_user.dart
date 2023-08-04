// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import

part 'point_ecosystem_user.m.dart';
part 'point_ecosystem_user.g.dart';
part 'point_ecosystem_user.freezed.dart';

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/pes/user")
class PointEcosystemUserModel with _$PointEcosystemUserModel {
  const factory PointEcosystemUserModel({
    ModelTimestamp? lastDate,
    @Default(0) int continuousCount,
  }) = _PointEcosystemUserModel;
  const PointEcosystemUserModel._();

  factory PointEcosystemUserModel.fromJson(Map<String, Object?> json) =>
      _$PointEcosystemUserModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(PointEcosystemUserModel.document(id));      // Get the document.
  /// ref.model(PointEcosystemUserModel.document(id))..load(); // Load the document.
  /// ```
  static const document = _$PointEcosystemUserModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(PointEcosystemUserModel.collectoin());      // Get the collection.
  /// ref.model(PointEcosystemUserModel.collection())..load(); // Load the collection.
  /// ref.model(
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
  /// ref.page.controller(PointEcosystemUserModel.form());     // Get the form controller.
  /// ```
  static const form = _$PointEcosystemUserModelFormQuery();
}

/// Alias for ModelRef<PointEcosystemUserModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(PointEcosystemUserModelDocument) PointEcosystemUserModelRef point_ecosystem_user
/// ```
typedef PointEcosystemUserModelRef = ModelRef<PointEcosystemUserModel>?;

/// It can be defined as an empty ModelRef<PointEcosystemUserModel>.
///
///　```dart
/// PointEcosystemUserModelRefPath("xxx") // Define as a path.
/// ```
typedef PointEcosystemUserModelRefPath = _$PointEcosystemUserModelPath;

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

/// [Enum] of the name of the value defined in PointEcosystemUserModel.
typedef PointEcosystemUserModelKeys = _$PointEcosystemUserModelKeys;

/// Document class for storing PointEcosystemUserModel.
typedef PointEcosystemUserModelDocument = _$PointEcosystemUserModelDocument;

/// Collection class for storing PointEcosystemUserModel.
typedef PointEcosystemUserModelCollection = _$PointEcosystemUserModelCollection;
