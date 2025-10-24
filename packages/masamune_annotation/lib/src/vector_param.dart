part of "/masamune_annotation.dart";

/// It is possible to make a field eligible for similarity search by annotating it when specifying each field of [CollectionModelPath] or [DocumentModelPath].
///
/// If a document contains a field with this annotation, `VectorDocumentMixin` will be applied to that document.
///
/// Furthermore, `VectorCollectionMixin` will be applied to the collection, enabling searches from the collection using the `nearest` method.
///
/// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際にフィールドにアノテーションを付けることでそのフィールドを類似検索対象にすることが可能です。
///
/// このアノテーションが付けられたフィールドがある場合、そのドキュメントに`VectorDocumentMixin`が付与されます。
///
/// また、コレクションには`VectorCollectionMixin`が付与され、コレクションから`nearest`メソッドを使っての検索が可能となります。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("shop")
/// abstract class ShopModel with _$ShopModel {
///   const factory ShopModel({
///     @vectorParam @Default("") String name,
///     @vectorParam @Default("") String description,
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
const vectorParam = VectorParam();

/// It is possible to make a field eligible for similarity search by annotating it when specifying each field of [CollectionModelPath] or [DocumentModelPath].
///
/// If a document contains a field with this annotation, `VectorDocumentMixin` will be applied to that document.
///
/// Furthermore, `VectorCollectionMixin` will be applied to the collection, enabling searches from the collection using the `nearest` method.
///
/// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際にフィールドにアノテーションを付けることでそのフィールドを類似検索対象にすることが可能です。
///
/// このアノテーションが付けられたフィールドがある場合、そのドキュメントに`VectorDocumentMixin`が付与されます。
///
/// また、コレクションには`VectorCollectionMixin`が付与され、コレクションから`nearest`メソッドを使っての検索が可能となります。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("shop")
/// abstract class ShopModel with _$ShopModel {
///   const factory ShopModel({
///     @vectorParam @Default("") String name,
///     @vectorParam @Default("") String description,
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
class VectorParam {
  /// It is possible to make a field eligible for similarity search by annotating it when specifying each field of [CollectionModelPath] or [DocumentModelPath].
  ///
  /// If a document contains a field with this annotation, `VectorDocumentMixin` will be applied to that document.
  ///
  /// Furthermore, `VectorCollectionMixin` will be applied to the collection, enabling searches from the collection using the `nearest` method.
  ///
  /// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際にフィールドにアノテーションを付けることでそのフィールドを類似検索対象にすることが可能です。
  ///
  /// このアノテーションが付けられたフィールドがある場合、そのドキュメントに`VectorDocumentMixin`が付与されます。
  ///
  /// また、コレクションには`VectorCollectionMixin`が付与され、コレクションから`nearest`メソッドを使っての検索が可能となります。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @CollectionModelPath("shop")
  /// abstract class ShopModel with _$ShopModel {
  ///   const factory ShopModel({
  ///     @vectorParam @Default("") String name,
  ///     @vectorParam @Default("") String description,
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
  const VectorParam();
}
