// ignore: unused_import, unnecessary_import

// Dart imports:
import "dart:convert";

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

// ignore: unused_import, unnecessary_import

part "github_content.m.dart";
part "github_content.g.dart";
part "github_content.freezed.dart";

/// Model for managing Github contents.
///
/// Githubのコンテンツを管理するためのモデル。
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/branch/:branch_id/commit/:commit_id/path/:path_id/content",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubContentModel with _$GithubContentModel {
  /// Model for managing Github contents.
  ///
  /// Githubのコンテンツを管理するためのモデル。
  const factory GithubContentModel({
    String? name,
    String? path,
    String? content,
    String? sha,
    String? type,
    String? encoding,
    String? patch,
    String? status,
    @refParam GithubUserModelRef committer,
    @Default(0) int size,
    @Default(0) int additionsCount,
    @Default(0) int deletionsCount,
    @Default(0) int changesCount,
    ModelUri? rawUrl,
    ModelUri? blobUrl,
    ModelUri? htmlUrl,
    ModelUri? gitUrl,
    ModelUri? downloadUrl,
    @jsonParam List<GithubContentModel>? children,
    @Default(false) bool fromServer,
  }) = _GithubContentModel;
  const GithubContentModel._();

  /// The value in [content] Base-64 decoded.
  String? get text {
    final content = this.content;
    if (content == null) {
      return null;
    }
    return utf8.decode(base64Decode(LineSplitter.split(content).join()));
  }

  /// Get the path id from the path.
  ///
  /// ```dart
  /// GithubContentModel.getPathId("path/to/file");
  /// ```
  static String getPathId([String? path]) {
    return Uri.encodeFull("/${path?.trimString("/") ?? ""}");
  }

  /// Whether the content is a directory.
  bool get isDirectory => type == "dir";

  /// Whether the content is base64 encoded.
  bool get isBase64 => encoding == "base64";

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubContentModel.fromJson(json);
  /// ```
  factory GithubContentModel.fromJson(Map<String, Object?> json) =>
      _$GithubContentModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubContentModel.document(id));       // Get the document.
  /// ref.app.model(GithubContentModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubContentModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubContentModel.collection());       // Get the collection.
  /// ref.app.model(GithubContentModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubContentModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubContentModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubContentModel.form(GithubContentModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubContentModel.form(GithubContentModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubContentModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubContentModel.
typedef GithubContentModelKeys = _$GithubContentModelKeys;

/// Alias for ModelRef&lt;GithubContentModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubContentModelDocument) GithubContentModelRef github_content
/// ```
typedef GithubContentModelRef = ModelRef<GithubContentModel>?;

/// It can be defined as an empty ModelRef&lt;GithubContentModel&gt;.
///
/// ```dart
/// GithubContentModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubContentModelRefPath = _$GithubContentModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubContentModelInitialCollection(
///       "xxx": GithubContentModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubContentModelInitialCollection
    = _$GithubContentModelInitialCollection;

/// Document class for storing GithubContentModel.
typedef GithubContentModelDocument = _$GithubContentModelDocument;

/// Collection class for storing GithubContentModel.
typedef GithubContentModelCollection = _$GithubContentModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubContentModel&gt;.
///
/// ```dart
/// GithubContentModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubContentModelMirrorRefPath = _$GithubContentModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubContentModelMirrorInitialCollection(
///       "xxx": GithubContentModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubContentModelMirrorInitialCollection
    = _$GithubContentModelMirrorInitialCollection;

/// Document class for storing GithubContentModel.
typedef GithubContentModelMirrorDocument = _$GithubContentModelMirrorDocument;

/// Collection class for storing GithubContentModel.
typedef GithubContentModelMirrorCollection
    = _$GithubContentModelMirrorCollection;
