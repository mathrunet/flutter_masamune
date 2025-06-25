// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";

part "repository.m.dart";
part "repository.g.dart";
part "repository.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("repository")
abstract class RepositoryModel with _$RepositoryModel {
  /// Value for model.
  const factory RepositoryModel({
    @Default("") String name,
    @Default("") String fullName,
    @Default("") String description,
    @Default(false) bool private,
    int? id,
    String? htmlUrl,
    String? cloneUrl,
    String? sshUrl,
    @Default(<String, dynamic>{}) Map<String, dynamic> owner,
    String? defaultBranch,
    String? language,
    @Default(0) int stargazersCount,
    @Default(0) int forksCount,
    @Default(0) int openIssuesCount,
    String? createdAt,
    String? updatedAt,
    String? pushedAt,
  }) = _RepositoryModel;
  const RepositoryModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// RepositoryModel.fromJson(json);
  /// ```
  factory RepositoryModel.fromJson(Map<String, Object?> json) => _$RepositoryModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(RepositoryModel.document(id));       // Get the document.
  /// ref.app.model(RepositoryModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$RepositoryModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(RepositoryModel.collection());       // Get the collection.
  /// ref.app.model(RepositoryModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   RepositoryModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$RepositoryModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(RepositoryModel.form(RepositoryModel()));    // Get the form controller in app scope.
  /// ref.page.form(RepositoryModel.form(RepositoryModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$RepositoryModelFormQuery();
}

/// [Enum] of the name of the value defined in RepositoryModel.
typedef RepositoryModelKeys = _$RepositoryModelKeys;

/// Alias for ModelRef&lt;RepositoryModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(RepositoryModelDocument) RepositoryModelRef repository
/// ```
typedef RepositoryModelRef = ModelRef<RepositoryModel>?;

/// It can be defined as an empty ModelRef&lt;RepositoryModel&gt;.
///
/// ```dart
/// RepositoryModelRefPath("xxx") // Define as a path.
/// ```
typedef RepositoryModelRefPath = _$RepositoryModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     RepositoryModelInitialCollection(
///       "xxx": RepositoryModel(...),
///     ),
///   ],
/// );
/// ```
typedef RepositoryModelInitialCollection = _$RepositoryModelInitialCollection;

/// Document class for storing RepositoryModel.
typedef RepositoryModelDocument = _$RepositoryModelDocument;

/// Collection class for storing RepositoryModel.
typedef RepositoryModelCollection = _$RepositoryModelCollection;

/// It can be defined as an empty ModelRef&lt;RepositoryModel&gt;.
///
/// ```dart
/// RepositoryModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef RepositoryModelMirrorRefPath = _$RepositoryModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     RepositoryModelMirrorInitialCollection(
///       "xxx": RepositoryModel(...),
///     ),
///   ],
/// );
/// ```
typedef RepositoryModelMirrorInitialCollection = _$RepositoryModelMirrorInitialCollection;

/// Document class for storing RepositoryModel.
typedef RepositoryModelMirrorDocument = _$RepositoryModelMirrorDocument;

/// Collection class for storing RepositoryModel.
typedef RepositoryModelMirrorCollection = _$RepositoryModelMirrorCollection;
