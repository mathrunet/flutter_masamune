part of '/masamune_annotation.dart';

/// When specifying each field in [CollectionModelPath] or [DocumentModelPath], you can annotate the field to make it a search target.
///
/// If a field has this annotation, the document will be given a `SearchableDocumentMixin`.
///
/// The collection will also be given a `SearchableCollectionMixin` to allow searching from the collection using the `search` method.
///
/// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際にフィールドにアノテーションを付けることでそのフィールドを検索対象にすることが可能です。
///
/// このアノテーションが付けられたフィールドがある場合、そのドキュメントに`SearchableDocumentMixin`が付与されます。
///
/// また、コレクションには`SearchableCollectionMixin`が付与され、コレクションから`search`メソッドを使っての検索が可能となります。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("shop")
/// abstract class ShopModel with _$ShopModel {
///   const factory ShopModel({
///     @searchParam @Default("") String name,
///     @searchParam @Default("") String description,
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
const searchParam = SearchParam();

/// When specifying each field in [CollectionModelPath] or [DocumentModelPath], you can annotate the field to make it a search target.
///
/// If a field has this annotation, the document will be given a `SearchableDocumentMixin`.
///
/// The collection will also be given a `SearchableCollectionMixin` to allow searching from the collection using the `search` method.
///
/// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際にフィールドにアノテーションを付けることでそのフィールドを検索対象にすることが可能です。
///
/// このアノテーションが付けられたフィールドがある場合、そのドキュメントに`SearchableDocumentMixin`が付与されます。
///
/// また、コレクションには`SearchableCollectionMixin`が付与され、コレクションから`search`メソッドを使っての検索が可能となります。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("shop")
/// abstract class ShopModel with _$ShopModel {
///   const factory ShopModel({
///     @searchParam @Default("") String name,
///     @searchParam @Default("") String description,
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
class SearchParam {
  /// When specifying each field in [CollectionModelPath] or [DocumentModelPath], you can annotate the field to make it a search target.
  ///
  /// If a field has this annotation, the document will be given a `SearchableDocumentMixin`.
  ///
  /// The collection will also be given a `SearchableCollectionMixin` to allow searching from the collection using the `search` method.
  ///
  /// [CollectionModelPath]や[DocumentModelPath]の各フィールドを指定する際にフィールドにアノテーションを付けることでそのフィールドを検索対象にすることが可能です。
  ///
  /// このアノテーションが付けられたフィールドがある場合、そのドキュメントに`SearchableDocumentMixin`が付与されます。
  ///
  /// また、コレクションには`SearchableCollectionMixin`が付与され、コレクションから`search`メソッドを使っての検索が可能となります。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @CollectionModelPath("shop")
  /// abstract class ShopModel with _$ShopModel {
  ///   const factory ShopModel({
  ///     @searchParam @Default("") String name,
  ///     @searchParam @Default("") String description,
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
  const SearchParam();
}
