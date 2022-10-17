part of katana;

/// Represents the type of [Map<String, dynamic>].
///
/// It is an object generated when Json is decoded, and the masamun framework provides a framework that allows this object to be treated as a document.
///
/// [Map<String, dynamic>]の型を表します。
///
/// Jsonデコードされた際に生成されるオブジェクトであり、masamunフレームワークではこのオブジェクトをドキュメントとして扱えるフレームワークを提供しています。
typedef DynamicMap = Map<String, dynamic>;

/// Represents the type of [List<dynamic>].
///
/// It is an object generated when Json is decoded, and the masamun framework provides a framework that allows this object to be treated as a collection.
///
/// [List<dynamic>]の型を表します。
///
/// Jsonデコードされた際に生成されるオブジェクトであり、masamunフレームワークではこのオブジェクトをコレクションとして扱えるフレームワークを提供しています。
typedef DynamicList = List<dynamic>;

/// A `null` object with a defined type of [String?]
///
/// [String?]の型を定義した`null`オブジェクト。
const String? nullOfString = null;

/// A `null` object with a defined type of [int?]
///
/// [int?]の型を定義した`null`オブジェクト。
const int? nullOfInt = null;

/// A `null` object with a defined type of [double?]
///
/// [double?]の型を定義した`null`オブジェクト。
const double? nullOfDouble = null;

/// A `null` object with a defined type of [num?]
///
/// [num?]の型を定義した`null`オブジェクト。
const num? nullOfNum = null;

/// A `null` object with a defined type of [bool?]
///
/// [bool?]の型を定義した`null`オブジェクト。
const bool? nullOfBool = null;

/// A `null` object with a defined type of [DynamicMap?]
///
/// [DynamicMap?]の型を定義した`null`オブジェクト。
const DynamicMap? nullOfDynamicMap = null;

/// A `null` object with a defined type of [DynamicList?]
///
/// [DynamicList?]の型を定義した`null`オブジェクト。
const DynamicList? nullOfDynamicList = null;

/// A `0` object with a defined type of [num?]
///
/// [num]の型を定義した`0`オブジェクト。
const num zeroOfNum = 0;

/// A `null` object with a defined type of [List<T>?]
///
/// [List<T>?]の型を定義した`null`オブジェクト。
List<T>? nullOfList<T>() => null;

/// A `null` object with a defined type of [Map<K, V>?]
///
/// [Map<K, V>?]の型を定義した`null`オブジェクト。
Map<K, V>? nullOfMap<K, V>() => null;

/// A `null` object with a defined type of [Set<T>?]
///
/// [Set<T>?]の型を定義した`null`オブジェクト。
Set<T>? nullOfSet<T>() => null;
