part of katana_model_firestore;

/// Base class for converting [ModelFieldValue] for use in Firestore.
///
/// Firestoreで利用するための[ModelFieldValue]の変換を行うベースクラス。
@immutable
abstract class FirestoreModelFieldValueConverter {
  /// Base class for converting [ModelFieldValue] for use in Firestore.
  ///
  /// Firestoreで利用するための[ModelFieldValue]の変換を行うベースクラス。
  const FirestoreModelFieldValueConverter();

  /// The type of [ModelFieldValue] that can be converted.
  ///
  /// 変換可能な[ModelFieldValue]の型。
  String get type;

  /// Convert from Firestore manageable type to [ModelFieldValue].
  ///
  /// Generate and return a [DynamicMap] value from [key] and [value]. [original] is passed the [DynamicMap] before conversion.
  ///
  /// Return [Null] if there are no changes.
  ///
  /// [FirestoreModelAdapterBase] is passed to [adapter].
  ///
  /// Firestoreで管理可能な型から[ModelFieldValue]に変換します。
  ///
  /// [key]と[value]から[DynamicMap]の値を生成して返してください。[original]は変換前の[DynamicMap]を渡します。
  ///
  /// 変更がない場合は[Null]を返してください。
  ///
  /// [adapter]に[FirestoreModelAdapterBase]が渡されます。
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  );

  /// Convert from [ModelFieldValue] to a type that can be managed by Firestore.
  ///
  /// Generate and return a [DynamicMap] value from [key] and [value]. [original] is passed the [DynamicMap] before conversion.
  ///
  /// Return [Null] if there are no changes.
  ///
  /// [FirestoreModelAdapterBase] is passed to [adapter].
  ///
  /// [ModelFieldValue]からFirestoreで管理可能な型に変換します。
  ///
  /// [key]と[value]から[DynamicMap]の値を生成して返してください。[original]は変換前の[DynamicMap]を渡します。
  ///
  /// 変更がない場合は[Null]を返してください。
  ///
  /// [adapter]に[FirestoreModelAdapterBase]が渡されます。
  DynamicMap? convertTo(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  );

  /// When querying Firestore, [value] is converted and returned.
  ///
  /// Firestoreにクエリを出す場合、[value]を変換して返します。
  Object? convertQueryValue(
    Object? value,
    FirestoreModelAdapterBase adapter,
  );
}

/// Base class for implementing [FirestoreModelAdapter].
///
/// [FirestoreModelAdapter]を実装するためのベースクラス。
abstract class FirestoreModelAdapterBase {
  /// The Firestore database instance used in the adapter.
  ///
  /// アダプター内で利用しているFirestoreのデータベースインスタンス。
  FirebaseFirestore get database;

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  String? get prefix;

  String _path(String original);
}
