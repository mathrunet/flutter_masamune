part of model_notifier;

/// Class for sending queries to the model.
///
/// Basically, it allows you to send the same query as Firestore.
///
/// Can be converted to a [String] by passing [value].
@immutable
class ModelQuery {
  /// Class for sending queries to the model.
  ///
  /// Basically, it allows you to send the same query as Firestore.
  ///
  /// Can be converted to a [String] by passing [value].
  const ModelQuery(
    this.path, {
    this.key,
    this.isEqualTo,
    this.isNotEqualTo,
    // this.isLessThan,
    this.isLessThanOrEqualTo,
    // this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.geoHash,
    this.order = ModelQueryOrder.asc,
    this.limit,
    this.orderBy,
  });

  /// Class for sending queries to the model.
  ///
  /// Basically, it allows you to send the same query as Firestore.
  ///
  /// Can be converted to a [String] by passing [value].
  factory ModelQuery.fromPath(String path) {
    if (path.isEmpty) {
      return ModelQuery(path);
    }
    final uri = Uri.tryParse(path);
    if (uri == null) {
      return ModelQuery(path);
    }
    final query = uri.queryParameters;

    return ModelQuery(
      uri.path,
      key: _parseQuery(query, "key"),
      isEqualTo: _parseQuery(query, "equalTo"),
      isNotEqualTo: _parseQuery(query, "notEqualTo"),
      isLessThanOrEqualTo: _parseQuery(query, "endAt"),
      isGreaterThanOrEqualTo: _parseQuery(query, "startAt"),
      arrayContains: _parseQuery(query, "contains"),
      arrayContainsAny: _parseQuery(query, "containsAny", true),
      whereIn: _parseQuery(query, "whereIn", true),
      whereNotIn: _parseQuery(query, "whereNotIn", true),
      geoHash: _parseQuery(query, "geoHash", true),
      orderBy: () {
        if (query.containsKey("orderByDesc")) {
          return query["orderByDesc"];
        } else if (query.containsKey("orderByAsc")) {
          return query["orderByAsc"];
        }
      }(),
      order: () {
        if (query.containsKey("orderByDesc")) {
          return ModelQueryOrder.desc;
        } else {
          return ModelQueryOrder.asc;
        }
      }(),
      limit: _parseQuery(query, "limitToFirst"),
    );
  }

  static dynamic _parseQuery(
    Map<String, String> query,
    String key, [
    bool isArray = false,
  ]) {
    if (!query.containsKey(key)) {
      return null;
    }
    final value = query[key];
    if (value.isEmpty) {
      return null;
    }
    if (isArray) {
      return value!.split(",").mapAndRemoveEmpty((item) => item.toAny());
    }
    return value.toAny();
  }

  /// Query path.
  final String path;

  /// Key for comparison.
  final String? key;

  /// Key to change the order.
  final String? orderBy;

  /// If the value of [key] is equal to this value, `true`.
  final dynamic isEqualTo;

  /// If the value of [key] is not equal to this value, `true`.
  final dynamic isNotEqualTo;
  // final dynamic isLessThan;
  /// If the value of [key] is less than this value, `true`.
  final dynamic isLessThanOrEqualTo;
  // final dynamic isGreaterThan;
  /// If the value of [key] is greater than this value, `true`.
  final dynamic isGreaterThanOrEqualTo;

  /// If this value is in the [key] array, `true`.
  final dynamic arrayContains;

  /// If the [key] array contains one of these values, `true`.
  final DynamicList? arrayContainsAny;

  /// If the value of [key] is equal to one of these values, `true`.
  final DynamicList? whereIn;

  /// If the value of [key] is not equal to all of these values, `true`.
  final DynamicList? whereNotIn;
  // final bool? isNull;
  /// Specify ascending or descending order.
  final ModelQueryOrder order;

  /// Check if it is geo hash the range on the position.
  final List<String>? geoHash;

  /// Limit the number to be acquired.
  final int? limit;

  String _limit([String path = ""]) {
    if (limit == null) {
      return path;
    }
    return "$path&limitToFirst=$limit";
  }

  String _order([String path = ""]) {
    if (orderBy.isEmpty) {
      return path;
    }
    if (order == ModelQueryOrder.asc) {
      return "$path&orderByAsc=$orderBy";
    } else {
      return "$path&orderByDesc=$orderBy";
    }
  }

  /// Convert all Query to [String] parameters.
  String get value {
    assert(
      (key == null &&
              (isEqualTo == null &&
                  isNotEqualTo == null &&
                  isLessThanOrEqualTo == null &&
                  isGreaterThanOrEqualTo == null &&
                  arrayContains == null &&
                  arrayContainsAny == null &&
                  whereIn == null &&
                  whereNotIn == null &&
                  geoHash == null)) ||
          (key != null &&
              (isEqualTo != null ||
                  isNotEqualTo != null ||
                  isLessThanOrEqualTo != null ||
                  isGreaterThanOrEqualTo != null ||
                  arrayContains != null ||
                  arrayContainsAny != null ||
                  whereIn != null ||
                  whereNotIn != null ||
                  geoHash != null)),
      "If you want to specify a condition, please specify [key].",
    );
    if (key.isEmpty) {
      final parameters = _limit(_order()).trimString("&");
      if (parameters.isEmpty) {
        return path;
      } else {
        return "$path?$parameters";
      }
    }
    final tmp = "key=$key";
    if (isEqualTo != null) {
      return "$path?${_limit(_order("$tmp&equalTo=$isEqualTo")).trimString("&")}";
    } else if (isNotEqualTo != null) {
      return "$path?${_limit(_order("$tmp&notEqualTo=$isNotEqualTo")).trimString("&")}";
    } else if (isLessThanOrEqualTo != null) {
      if (isGreaterThanOrEqualTo != null) {
        return "$path?${_limit(_order("$tmp&startAt=$isGreaterThanOrEqualTo&endAt=$isLessThanOrEqualTo")).trimString("&")}";
      }
      return "$path?${_limit(_order("$tmp&endAt=$isLessThanOrEqualTo")).trimString("&")}";
    } else if (isGreaterThanOrEqualTo != null) {
      if (isLessThanOrEqualTo != null) {
        return "$path?${_limit(_order("$tmp&startAt=$isGreaterThanOrEqualTo&endAt=$isLessThanOrEqualTo")).trimString("&")}";
      }
      return "$path?${_limit(_order("$tmp&startAt=$isGreaterThanOrEqualTo")).trimString("&")}";
    } else if (arrayContains != null) {
      return "$path?${_limit(_order("$tmp&contains=$arrayContains")).trimString("&")}";
    } else if (arrayContainsAny != null) {
      return "$path?" +
          _limit(
            _order(
              "$tmp&containsAny=${arrayContainsAny!.map((e) => e.toString()).join(",")}",
            ),
          ).trimString("&");
    } else if (whereIn != null) {
      return "$path?" +
          _limit(
            _order(
              "$tmp&whereIn=${whereIn!.map((e) => e.toString()).join(",")}",
            ),
          ).trimString("&");
    } else if (whereNotIn != null) {
      return "$path?" +
          _limit(
            _order(
              "$tmp&whereNotIn=${whereNotIn!.map((e) => e.toString()).join(",")}",
            ),
          ).trimString("&");
    } else if (geoHash != null) {
      return "$path?" +
          _limit(
            _order(
              "$tmp&geoHash=${geoHash!.map((e) => e.toString()).join(",")}",
            ),
          ).trimString("&");
    }
    return "$path?${tmp.trimString("&")}";
  }

  /// Check if the condition is satisfied by passing [data].
  ///
  /// When [DynamicMap] is passed, the value for [key] is checked.
  ///
  /// If `[List]' is passed,
  /// it checks whether or not the elements of the list satisfy the condition,
  /// and returns `true` if one of them satisfies the condition.
  ///
  /// All other values are checked to see if they satisfy the condition themselves, regardless of [key].
  bool check(Object? data) {
    if (data == null) {
      return false;
    }
    if (data is DynamicMap) {
      if (key.isEmpty) {
        return false;
      }
      if (!data.containsKey(key)) {
        return false;
      }
      return _check(data[key]);
    } else if (data is List) {
      return data.any((element) => check(element));
    } else {
      return _check(data);
    }
  }

  bool _check(dynamic value) {
    if (isEqualTo != null) {
      return value == isEqualTo;
    }
    if (isNotEqualTo != null) {
      return value != isNotEqualTo;
    }
    if (isGreaterThanOrEqualTo != null) {
      return value >= isGreaterThanOrEqualTo;
    }
    if (isLessThanOrEqualTo != null) {
      return value <= isLessThanOrEqualTo;
    }
    if (arrayContains != null) {
      final list = value;
      if (list is! List) {
        return false;
      }
      return list.contains(arrayContains);
    }
    if (arrayContainsAny != null) {
      if (arrayContainsAny.isEmpty) {
        return false;
      }
      final list = value;
      if (list is! List) {
        return false;
      }
      final any = arrayContainsAny!.mapAndRemoveEmpty((item) => item.toAny());
      return list.any((e) => e == any);
    }
    if (whereIn != null) {
      if (whereIn.isEmpty) {
        return false;
      }
      final val = value;
      final any = whereIn!.mapAndRemoveEmpty((item) => item.toAny());
      return any.contains(val);
    }
    if (whereNotIn != null) {
      if (whereNotIn.isEmpty) {
        return false;
      }
      final val = value;
      final any = whereNotIn!.mapAndRemoveEmpty((item) => item.toAny());
      return !any.contains(val);
    }
    if (geoHash != null) {
      if (geoHash.isEmpty) {
        return false;
      }
      final val = value.toString();
      final any = geoHash!.mapAndRemoveEmpty((item) => item.toString());
      return any.any((item) => val.startsWith(item));
    }
    return true;
  }

  static bool _filter(
    Map<String, String> parameters,
    DynamicMap? data,
  ) {
    if (data.isEmpty) {
      return false;
    }
    if (!parameters.containsKey("key") || parameters["key"].isEmpty) {
      return true;
    }
    final key = parameters["key"]!;
    if (!data.containsKey(key)) {
      return false;
    }
    if (parameters.containsKey("equalTo")) {
      return data![key] == parameters["equalTo"].toAny();
    }
    if (parameters.containsKey("notEqualTo")) {
      return data![key] != parameters["noteEqualTo"].toAny();
    }
    if (parameters.containsKey("startAt")) {
      if (parameters.containsKey("endAt")) {
        return data![key] >= parameters["startAt"].toAny() &&
            data[key] <= parameters["endAt"].toAny();
      }
      return data![key] >= parameters["startAt"].toAny();
    }
    if (parameters.containsKey("endAt")) {
      if (parameters.containsKey("startAt")) {
        return data![key] >= parameters["startAt"].toAny() &&
            data[key] <= parameters["endAt"].toAny();
      }
      return data![key] <= parameters["endAt"].toAny();
    }
    if (parameters.containsKey("contains")) {
      final list = data![key];
      if (list is! List) {
        return false;
      }
      return list.contains(parameters["contains"].toAny());
    }
    if (parameters.containsKey("containsAny")) {
      if (parameters["containsAny"].isEmpty) {
        return false;
      }
      final list = data![key];
      if (list is! List) {
        return false;
      }
      final any = parameters["containsAny"]
          .toString()
          .split(",")
          .mapAndRemoveEmpty((item) => item.toAny());
      return list.any((e) => e == any);
    }
    if (parameters.containsKey("whereIn")) {
      if (parameters["whereIn"].isEmpty) {
        return false;
      }
      final val = data![key];
      final any = parameters["whereIn"]
          .toString()
          .split(",")
          .mapAndRemoveEmpty((item) => item.toAny());
      return any.contains(val);
    }
    if (parameters.containsKey("whereNotIn")) {
      if (parameters["whereNotIn"].isEmpty) {
        return false;
      }
      final val = data![key];
      final any = parameters["whereNotIn"]
          .toString()
          .split(",")
          .mapAndRemoveEmpty((item) => item.toAny());
      return !any.contains(val);
    }
    if (parameters.containsKey("geoHash")) {
      if (parameters["geoHash"].isEmpty) {
        return false;
      }
      final val = data![key].toString();
      final any = parameters["geoHash"]
          .toString()
          .split(",")
          .mapAndRemoveEmpty((item) => item.toString());
      return any.any((item) => val.startsWith(item));
    }
    return true;
  }

  static List<MapEntry<String, DynamicMap>> _sort(
    Map<String, String> parameters,
    List<MapEntry<String, DynamicMap>> data,
  ) {
    if (parameters.containsKey("orderByAsc") &&
        parameters["orderByAsc"].isNotEmpty) {
      final key = parameters["orderByAsc"];
      data.sort((a, b) => _compare(a.value[key], b.value[key]));
    } else if (parameters.containsKey("orderByDesc") &&
        parameters["orderByDesc"].isNotEmpty) {
      final key = parameters["orderByDesc"];
      data.sort((a, b) => _compare(b.value[key], a.value[key]));
    }
    return data;
  }

  static int? _seek(
    Map<String, String> parameters,
    List<MapEntry<String, DynamicMap>> list,
    DynamicMap data,
  ) {
    if (parameters.containsKey("orderByAsc") &&
        parameters["orderByAsc"].isNotEmpty) {
      final key = parameters["orderByAsc"];
      final value = data[key];
      if (value == null) {
        return list.length;
      }
      for (var i = 0; i < list.length; i++) {
        final p = i - 1;
        if (i == 0) {
          if (list[i].value[key] == null) {
            continue;
          }
          final a = _compare(value, list[i].value[key]);
          if (a <= 0) {
            return i;
          }
        } else {
          if (list[i].value[key] == null || list[p].value[key] == null) {
            continue;
          }
          final a = _compare(value, list[i].value[key]);
          final b = _compare(value, list[p].value[key]);
          if (a <= 0 && b > 0) {
            return i;
          }
        }
      }
      return list.length;
    } else if (parameters.containsKey("orderByDesc") &&
        parameters["orderByDesc"].isNotEmpty) {
      final key = parameters["orderByDesc"];
      final value = data[key];
      if (value == null) {
        return list.length;
      }
      for (var i = 0; i < list.length; i++) {
        final p = i - 1;
        if (i == 0) {
          if (list[i].value[key] == null) {
            continue;
          }
          final a = _compare(value, list[i].value[key]);
          if (a >= 0) {
            return i;
          }
        } else {
          if (list[i].value[key] == null || list[p].value[key] == null) {
            continue;
          }
          final a = _compare(value, list[i].value[key]);
          final b = _compare(value, list[p].value[key]);
          if (a >= 0 && b < 0) {
            return i;
          }
        }
      }
      return list.length;
    }
    return null;
  }

  static int _compare(dynamic a, dynamic b) {
    if (a == null) {
      return -1;
    }
    if (b == null) {
      return 1;
    }
    if (a is num && b is num) {
      return a.compareTo(b);
    }
    return a.toString().compareTo(b);
  }

  /// Get limitCount from [parameters].
  ///
  /// If not set, null is returned.
  static int? limitCountFrom(Map<String, String> parameters) {
    if (parameters.containsKey("limitToFirst") &&
        parameters["limitToFirst"].isNotEmpty) {
      final limit = int.tryParse(parameters["limitToFirst"]!);
      if (limit != null) {
        return limit;
      }
    }
    return null;
  }

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      path.hashCode ^
      key.hashCode ^
      isEqualTo.hashCode ^
      isNotEqualTo.hashCode ^
      isLessThanOrEqualTo.hashCode ^
      isGreaterThanOrEqualTo.hashCode ^
      arrayContains.hashCode ^
      arrayContainsAny.hashCode ^
      whereIn.hashCode ^
      whereNotIn.hashCode ^
      geoHash.hashCode ^
      order.hashCode ^
      limit.hashCode ^
      orderBy.hashCode;
}

/// Specifies the order in which queries are ordered.
enum ModelQueryOrder {
  /// Ascending order.
  asc,

  /// Descending order.
  desc,
}
