part of "/masamune_annotation.dart";

/// {@template model_database_query_filter_type}
/// Define the filter type for ModelDatabaseQuery.
///
/// ModelDatabaseQueryのフィルタータイプを定義します。
/// {@endtemplate}
enum ModelDatabaseQueryFilterType {
  /// {@template model_database_query_filter_type_equal_to}
  /// A filter that checks for a match to a value in the data.
  ///
  /// データ中の値と一致するかどうかをチェックするフィルター。
  /// {@endtemplate}
  equalTo,

  /// {@template model_database_query_filter_type_not_equal_to}
  /// A filter that checks for a match to a value in the data.
  ///
  /// データ中の値と一致しないかどうかをチェックするフィルター。
  /// {@endtemplate}
  notEqualTo,

  /// {@template model_database_query_filter_type_less_than}
  /// Filter to check if the value is smaller than the value in the data.
  ///
  /// データ中の数値より小さい値かどうかをチェックするフィルター。
  /// {@endtemplate}
  lessThan,

  /// {@template model_database_query_filter_type_greater_than}
  /// Filter to check if the value is greater than the value in the data.
  ///
  /// データ中の数値より大きい値かどうかをチェックするフィルター。
  /// {@endtemplate}
  greaterThan,

  /// {@template model_database_query_filter_type_less_than_or_equal_to}
  /// A filter that checks whether a value is less than (or equal to) a number in the data.
  ///
  /// データ中の数値より小さい値（等しい値も含む）かどうかをチェックするフィルター。
  /// {@endtemplate}
  lessThanOrEqualTo,

  /// {@template model_database_query_filter_type_greater_than_or_equal_to}
  /// A filter that checks whether a value is greater than (or equal to) a number in the data.
  ///
  /// データ中の数値より大きい値（等しい値も含む）かどうかをチェックするフィルター。
  /// {@endtemplate}
  greaterThanOrEqualTo,

  /// {@template model_database_query_filter_type_array_contains}
  /// A filter that checks whether an array in the data contains a value.
  ///
  /// データ中の配列に値が含まれているかどうかをチェックするフィルター。
  /// {@endtemplate}
  arrayContains,

  /// {@template model_database_query_filter_type_array_contains_any}
  /// A filter that checks whether the array in the data contains one of the array values.
  ///
  /// データ中の配列に配列のいずれかの値が含まれているかどうかをチェックするフィルター。
  /// {@endtemplate}
  arrayContainsAny,

  /// {@template model_database_query_filter_type_where_in}
  /// A filter that checks if there is data matching one of the values in the given array.
  ///
  /// 与えた配列のいずれかの値と一致するデータがあるかどうかをチェックするフィルター。
  /// {@endtemplate}
  whereIn,

  /// {@template model_database_query_filter_type_where_not_in}
  /// A filter that checks for data that does not match any of the values in the given array.
  ///
  /// 与えた配列のいずれの値とも一致しないデータがあるかどうかをチェックするフィルター。
  /// {@endtemplate}
  whereNotIn,

  /// {@template model_database_query_filter_type_is_null}
  /// A filter that checks whether a value in the data is [Null] or not.
  ///
  /// データ中の値が[Null]かどうかをチェックするフィルター。
  /// {@endtemplate}
  isNull,

  /// {@template model_database_query_filter_type_is_not_null}
  /// A filter that checks if a value in the data is not [Null].
  ///
  /// データ中の値が[Null]でないかどうかをチェックするフィルター。
  /// {@endtemplate}
  isNotNull,

  /// {@template model_database_query_filter_type_geo_hash}
  /// A filter that checks whether a location exists within the given GeoHash.
  ///
  /// 与えたGeoHashの範囲内に位置が存在するかどうかをチェックするフィルター。
  /// {@endtemplate}
  geoHash,

  /// {@template model_database_query_filter_type_like}
  /// A filter that checks if the given text is included in the text in the data.
  ///
  /// 与えたテキストがデータ中のテキストに含まれるかどうかをチェックするフィルター。
  /// {@endtemplate}
  like,

  /// {@template model_database_query_filter_type_order_by_asc}
  /// Filter to sort data in ascending order.
  ///
  /// 昇順にデータの並び替えをするフィルター。
  /// {@endtemplate}
  orderByAsc,

  /// {@template model_database_query_filter_type_order_by_desc}
  /// Filter to sort data in descending order.
  ///
  /// 降順にデータの並び替えをするフィルター。
  /// {@endtemplate}
  orderByDesc,

  /// {@template model_database_query_filter_type_limit}
  /// A filter that limits the number of data.
  ///
  /// データの数に制限をかけるフィルター。
  /// {@endtemplate}
  limit,

  /// {@template model_database_query_filter_type_collection_group}
  /// Filter for collection groups. Available on Firestore only.
  ///
  /// コレクショングループを対象にするフィルター。Firestoreのみで利用可能。
  /// {@endtemplate}
  collectionGroup,

  /// {@template model_database_query_filter_type_and}
  /// A filter that filters when multiple conditions all match.
  ///
  /// 複数の条件がすべて一致する場合にフィルタリングするフィルター。
  /// {@endtemplate}
  and,

  /// {@template model_database_query_filter_type_or}
  /// A filter that filters when multiple conditions match at least one.
  ///
  /// 複数の条件のうち少なくとも一つが一致する場合にフィルタリングするフィルター。
  /// {@endtemplate}
  or;
}

/// {@template model_database_query}
/// Base class for creating queries to access the database.
///
/// If a list exists on [CollectionModelPath.query], only the conditions specified there are queryable.
///
/// If you use FirebaseDataConnect, this is required; if you use Firestore, RealtimeDatabase, or LocalDatabase, it is not necessary.
///
/// データベースへのアクセスを行うクエリを作成するためのベースクラスです。
///
/// [CollectionModelPath.query]上のでリストが存在している場合、そこで指定されている条件のみがクエリ可能となります。
///
/// FirebaseDataConnectを利用する場合、こちらの指定は必須となります。FirestoreやRealtimeDatabase、LocalDatabaseを利用する場合は特に必要ありません。
/// {@endtemplate}
abstract class ModelDatabaseQuery {
  /// {@macro model_database_query}
  const ModelDatabaseQuery();

  /// {@macro model_database_query_filter_type}
  ModelDatabaseQueryFilterType get type;

  /// Specify the target key.
  ///
  /// 対象のキーを指定します。
  Object? get key;

  /// Specify if there is a condition associated with this [ModelDatabaseQuery].
  ///
  /// この[ModelDatabaseQuery]に紐づく条件がある場合指定します。
  List<ModelDatabaseQuery>? get children;
}

/// A query group that summarizes [ModelDatabaseQuery].
///
/// The conditions specified here are all combined with AND conditions.
///
/// [ModelDatabaseQuery]をまとめるクエリーグループです。
///
/// ここで指定した条件はすべてAND条件で結合されます。
class ModelDatabaseQueryGroup {
  /// A query group that summarizes [ModelDatabaseQuery].
  ///
  /// The conditions specified here are all combined with AND conditions.
  ///
  /// [ModelDatabaseQuery]をまとめるクエリーグループです。
  ///
  /// ここで指定した条件はすべてAND条件で結合されます。
  const ModelDatabaseQueryGroup({
    required this.name,
    required this.conditions,
  });

  /// Name of query.
  ///
  /// クエリーの名前。
  final String name;

  /// List of queries in this query group.
  ///
  /// このクエリーグループに含まれるクエリーのリスト。
  final List<ModelDatabaseQuery> conditions;
}
