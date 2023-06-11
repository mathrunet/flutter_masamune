part of masamune_annotation;

/// When specifying a [CollectionModelPath] or [DocumentModelPath] field, you can load the referenced document together by specifying it in the field when referencing other documents.
///
/// Use with `freezed`, etc.
///
/// If this field is present, a `ModelRefMixin` is automatically assigned to the document.
///
/// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際に他のドキュメントを参照するときにフィールドに指定することでその参照ドキュメントを合わせてロードすることができます。
///
/// `freezed`などと共に利用してください。
///
/// このフィールドが存在する場合は、ドキュメントに`ModelRefMixin`が自動で付与されます。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("shop")
/// class ShopModel with _$ShopModel {
///   const factory ShopModel({
///     @Default("") String name,
///     @Default("") String description,
///     @refParam ModelRef<UserModel> user,
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
const refParam = RefParam();

/// When specifying a [CollectionModelPath] or [DocumentModelPath] field, you can load the referenced document together by specifying it in the field when referencing other documents.
///
/// Use with `freezed`, etc.
///
/// If this field is present, a `ModelRefMixin` is automatically assigned to the document.
///
/// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際に他のドキュメントを参照するときにフィールドに指定することでその参照ドキュメントを合わせてロードすることができます。
///
/// `freezed`などと共に利用してください。
///
/// このフィールドが存在する場合は、ドキュメントに`ModelRefMixin`が自動で付与されます。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("shop")
/// class ShopModel with _$ShopModel {
///   const factory ShopModel({
///     @Default("") String name,
///     @Default("") String description,
///     @refParam ModelRef<UserModel> user,
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
class RefParam {
  /// When specifying a [CollectionModelPath] or [DocumentModelPath] field, you can load the referenced document together by specifying it in the field when referencing other documents.
  ///
  /// Use with `freezed`, etc.
  ///
  /// If this field is present, a `ModelRefMixin` is automatically assigned to the document.
  ///
  /// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際に他のドキュメントを参照するときにフィールドに指定することでその参照ドキュメントを合わせてロードすることができます。
  ///
  /// `freezed`などと共に利用してください。
  ///
  /// このフィールドが存在する場合は、ドキュメントに`ModelRefMixin`が自動で付与されます。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @CollectionModelPath("shop")
  /// class ShopModel with _$ShopModel {
  ///   const factory ShopModel({
  ///     @Default("") String name,
  ///     @Default("") String description,
  ///     @refParam ModelRef<UserModel> user,
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
  const RefParam();
}
