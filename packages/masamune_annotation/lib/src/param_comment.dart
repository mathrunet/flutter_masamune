part of "/masamune_annotation.dart";

/// When specifying each field in [CollectionModelPath] or [DocumentModelPath], it is possible to annotate the field with a comment.
///
/// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際にフィールドにアノテーションを付けることでそのフィールドにコメントを付与することが可能です。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("shop")
/// abstract class ShopModel with _$ShopModel {
///   const factory ShopModel({
///     @ParamComment("This is name.") @Default("") String name,
///     @ParamComment("This is description.") @Default("") String description,
///   }) = _ShopModel;
///   const ShopModel._();
///
///   factory ShopModel.fromJson(Map<String, Object?> json) => _$ShopModelFromJson(json);
///
///   static const document = _$ShopModelDocumentQuery();
///
///   static const collection = _$ShopModelCollectionQuery();
/// }
/// ```
class ParamComment {
  /// When specifying each field in [CollectionModelPath] or [DocumentModelPath], it is possible to annotate the field with a comment.
  ///
  /// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際にフィールドにアノテーションを付けることでそのフィールドにコメントを付与することが可能です。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @CollectionModelPath("shop")
  /// abstract class ShopModel with _$ShopModel {
  ///   const factory ShopModel({
  ///     @ParamComment("This is name.") @Default("") String name,
  ///     @ParamComment("This is description.") @Default("") String description,
  ///   }) = _ShopModel;
  ///   const ShopModel._();
  ///
  ///   factory ShopModel.fromJson(Map<String, Object?> json) => _$ShopModelFromJson(json);
  ///
  ///   static const document = _$ShopModelDocumentQuery();
  ///
  ///   static const collection = _$ShopModelCollectionQuery();
  /// }
  /// ```
  const ParamComment(this.comment);

  /// Comments for parameters.
  ///
  /// パラメーター用のコメント。
  final String comment;
}
