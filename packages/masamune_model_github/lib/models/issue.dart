// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";


import "package:freezed_annotation/freezed_annotation.dart";

part "issue.m.dart";
part "issue.g.dart";
part "issue.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("issue")
abstract class IssueModel with _$IssueModel {
  /// Value for model.
  const factory IssueModel({
    @Default("") String title,
    @Default("") String body,
    @Default("open") String state,
    int? id,
    int? number,
    @Default(<String, dynamic>{}) Map<String, dynamic> user,
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> labels,
    String? createdAt,
    String? updatedAt,
    String? closedAt,
  }) = _IssueModel;
  const IssueModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// IssueModel.fromJson(json);
  /// ```
  factory IssueModel.fromJson(Map<String, Object?> json) => _$IssueModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(IssueModel.document(id));       // Get the document.
  /// ref.app.model(IssueModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$IssueModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(IssueModel.collection());       // Get the collection.
  /// ref.app.model(IssueModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   IssueModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$IssueModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(IssueModel.form(IssueModel()));    // Get the form controller in app scope.
  /// ref.page.form(IssueModel.form(IssueModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$IssueModelFormQuery();
}

/// [Enum] of the name of the value defined in IssueModel.
typedef IssueModelKeys = _$IssueModelKeys;

/// Alias for ModelRef&lt;IssueModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(IssueModelDocument) IssueModelRef issue
/// ```
typedef IssueModelRef = ModelRef<IssueModel>?;

/// It can be defined as an empty ModelRef&lt;IssueModel&gt;.
///
/// ```dart
/// IssueModelRefPath("xxx") // Define as a path.
/// ```
typedef IssueModelRefPath = _$IssueModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     IssueModelInitialCollection(
///       "xxx": IssueModel(...),
///     ),
///   ],
/// );
/// ```
typedef IssueModelInitialCollection = _$IssueModelInitialCollection;

/// Document class for storing IssueModel.
typedef IssueModelDocument = _$IssueModelDocument;

/// Collection class for storing IssueModel.
typedef IssueModelCollection = _$IssueModelCollection;

/// It can be defined as an empty ModelRef&lt;IssueModel&gt;.
///
/// ```dart
/// IssueModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef IssueModelMirrorRefPath = _$IssueModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     IssueModelMirrorInitialCollection(
///       "xxx": IssueModel(...),
///     ),
///   ],
/// );
/// ```
typedef IssueModelMirrorInitialCollection = _$IssueModelMirrorInitialCollection;

/// Document class for storing IssueModel.
typedef IssueModelMirrorDocument = _$IssueModelMirrorDocument;

/// Collection class for storing IssueModel.
typedef IssueModelMirrorCollection = _$IssueModelMirrorCollection;
