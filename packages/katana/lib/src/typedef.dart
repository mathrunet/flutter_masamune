part of katana;

/// Define a map for Json.
typedef DynamicMap = Map<String, dynamic>;

/// Define a list for Json.
typedef DynamicList = List<dynamic>;

/// Null of string.
const String? nullOfString = null;

/// Null of int.
const int? nullOfInt = null;

/// Null of double.
const double? nullOfDouble = null;

/// Null of num.
const num? nullOfNum = null;

/// Null of bool.
const bool? nullOfBool = null;

/// Null of dynamic map.
const DynamicMap? nullOfDynamicMap = null;

/// Null of dynamic list.
const DynamicList? nullOfDynamicList = null;

/// Zero of num.
const num zeroOfNum = 0;

/// Null of List.
List<T>? nullOfList<T>() => null;

/// Null of Map.
Map<K, V>? nullOfMap<K, V>() => null;

/// Null of Set.
Set<T>? nullOfSet<T>() => null;
