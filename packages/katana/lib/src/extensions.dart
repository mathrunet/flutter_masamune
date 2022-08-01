part of katana;

/// Provides general extensions to [String].
extension StringExtensions on String {
  static final RegExp _tail = RegExp(r"[^/]+$");

  /// Divides a path, etc., with [separator] and returns its length.
  int splitLength({String separator = "/"}) {
    if (isEmpty) {
      return 0;
    }
    final paths = split(separator);
    final length = paths.length;
    return length;
  }

  /// The path, for example, is divided by [separator] and returns the path one level up.
  String parentPath({String separator = "/"}) {
    if (isEmpty) {
      return this;
    }
    final path = trimString(separator);
    return path.replaceAll(_tail, "").trimStringRight(separator);
  }

  /// Splits the text by character.
  ///
  /// It is used for searching.
  List<String> splitByCharacter() {
    if (isEmpty) {
      return <String>[];
    }
    if (length <= 1) {
      return [this];
    }
    final tmp = <String>[];
    for (int i = 0; i < length - 1; i++) {
      tmp.add(substring(i, min(i + 1, length)));
    }
    return tmp;
  }

  /// Splits the text using the bigram algorithm.
  ///
  /// It is used for searching.
  List<String> splitByBigram() {
    if (isEmpty) {
      return <String>[];
    }
    if (length <= 2) {
      return [this];
    }
    final tmp = <String>[];
    for (int i = 0; i < length - 1; i++) {
      tmp.add(substring(i, min(i + 2, length)));
    }
    return tmp;
  }

  /// Splits the text using the trigram algorithm.
  ///
  /// It is used for searching.
  List<String> splitByTrigram() {
    if (isEmpty) {
      return [];
    }
    if (length <= 3) {
      return [this];
    }
    final tmp = <String>[];
    for (int i = 0; i < length - 2; i++) {
      tmp.add(substring(i, min(i + 3, length)));
    }
    return tmp;
  }

  /// Removes a query from a URL string.
  String trimQuery() {
    if (!contains("?")) {
      return this;
    }
    return split("?").first;
  }

  /// Trim with specific characters.
  ///
  /// Specify the character string to be trimmed in [chars].
  String trimString(String chars) {
    final pattern = chars.isNotEmpty
        ? RegExp("^[$chars]+|[$chars]+\$")
        : RegExp(r"^\s+|\s+$");
    return replaceAll(pattern, "");
  }

  /// Trim only the left side with a specific string.
  ///
  /// Specify the character string to be trimmed in [chars].
  String trimStringLeft(String chars) {
    final pattern = chars.isNotEmpty ? RegExp("^[$chars]+") : RegExp(r"^\s+");
    return replaceAll(pattern, "");
  }

  /// Trim only the right side with a specific string.
  ///
  /// Specify the character string to be trimmed in [chars].
  String trimStringRight(String chars) {
    final pattern = chars.isNotEmpty ? RegExp("[$chars]+\$") : RegExp(r"\s+$");
    return replaceAll(pattern, "");
  }

  /// Converts a String to an int.
  ///
  /// Normally it parses, but if it cannot parse it, it creates a random string.
  int toInt() {
    if (isEmpty) {
      return 0;
    }
    final i = int.tryParse(this);
    if (i != null) {
      return i;
    }
    int val = 0;
    for (final rune in runes) {
      val += (val + 1) * rune;
    }
    return val;
  }

  /// Converts a String to an int.
  ///
  /// Normally it parses, but if it cannot parse it, it creates a random string.
  double toDouble() {
    if (isEmpty) {
      return 0.0;
    }
    final d = double.tryParse(this);
    if (d != null) {
      return d;
    }
    double val = 0.0;
    for (final rune in runes) {
      val += (val + 1.0) * rune;
    }
    return val;
  }

  /// Parses a String into a bool.
  bool toBool() {
    if (toLowerCase() == "true") {
      return true;
    }
    return false;
  }

  /// Convert to Double or Int or Bool.
  dynamic toAny() {
    if (isEmpty) {
      return null;
    }
    final b = toLowerCase();
    if (b == "true") {
      return true;
    } else if (b == "false") {
      return false;
    }
    final n = num.tryParse(this);
    if (n != null) {
      return n;
    }
    return this;
  }

  /// Parses a String into a DateTime.
  DateTime toDateTime() {
    if (isEmpty) {
      return DateTime.now();
    }
    final dateTime = DateTime.tryParse(this);
    if (dateTime != null) {
      return dateTime;
    }
    final year = int.tryParse(substring(0, 4));
    final month = int.tryParse(substring(4, 6));
    final day = int.tryParse(substring(6, 8));
    final hour = int.tryParse(substring(8, 10));
    final minute = int.tryParse(substring(10, 12));
    final second = int.tryParse(substring(12, 14));
    if (year == null) {
      return DateTime.now();
    }
    if (month == null) {
      return DateTime(year);
    }
    if (day == null) {
      return DateTime(year, month);
    }
    if (hour == null) {
      return DateTime(year, month, day);
    }
    if (minute == null) {
      return DateTime(year, month, day, hour);
    }
    if (second == null) {
      return DateTime(year, month, day, hour, minute);
    }
    return DateTime(
      year,
      month,
      day,
      hour,
      minute,
      second,
    );
  }

  /// Encoded in Base64.
  String toBase64() => utf8.fuse(base64).encode(this);

  /// Encode in url safe base64.
  String toBase64Url() => utf8.fuse(base64Url).encode(this);

  /// Decoded in Base64.
  String fromBase64() => utf8.fuse(base64).decode(this);

  /// Decoded in url safe base64.
  String fromBase64Url() => utf8.fuse(base64Url).decode(this);

  /// Convert to SHA1 hash.
  String toSHA1() => sha1.convert(utf8.encode(this)).toString();

  /// Convert to SHA256 hash.
  ///
  /// Set the password for encoding to [password].
  String toSHA256(String password) {
    final hmacSha256 = Hmac(sha256, utf8.encode(password));
    return hmacSha256.convert(utf8.encode(this)).toString();
  }

  /// Converts a string into a Base64-encoded AES cipher.
  ///
  /// You can specify an AES encryption key by giving [key].
  String toAES(String key) {
    final encodedKey = Key.fromUtf8(key.substring(0, 32));
    final iv = IV.fromUtf8(key.substring(max(0, key.length - 16), key.length));
    return Encrypter(AES(encodedKey)).encrypt(this, iv: iv).base64;
  }

  /// Decrypts Base64 AES-encrypted strings.
  ///
  /// You can specify an AES encryption key by giving [key].
  String fromAES(String key) {
    final encodedKey = Key.fromUtf8(key.substring(0, 32));
    final iv = IV.fromUtf8(key.substring(max(0, key.length - 16), key.length));
    return Encrypter(AES(encodedKey)).decrypt64(this, iv: iv);
  }

  /// Format for text.
  ///
  /// You can assign a value to it by specifying [%s].
  String format(List<Object> arg) {
    return sprintf(this, arg);
  }

  /// Get the first string which is separated by [separator].
  String first({String separator = "/"}) {
    return split(separator).firstOrNull ?? "";
  }

  /// Get the last string which is separated by [separator].
  String last({String separator = "/"}) {
    return split(separator).lastOrNull ?? "";
  }

  /// Limits the string to [length],
  /// followed by [suffix] if it is limited.
  String limit(int length, {String suffix = "..."}) {
    if (this.length <= length) {
      return this;
    }
    return "${substring(0, length)}$suffix";
  }

  /// Capitalize only the first letter.
  String capitalize() {
    if (isEmpty) {
      return "";
    }
    if (length <= 1) {
      return this[0].toUpperCase();
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  /// Converts from JSON string to any object.
  dynamic toJsonObject([Object? object]) {
    return jsonDecode(this) ?? object;
  }

  /// Converts from JSON string to Map.
  Map<String, T> toJsonMap<T extends Object>([
    Map<String, T> defaultValue = const {},
  ]) {
    return jsonDecodeAsMap<T>(this, defaultValue);
  }

  /// Converts from JSON string to List.
  List<T> toJsonList<T extends Object>([
    List<T> defaultValue = const [],
  ]) {
    return jsonDecodeAsList<T>(this, defaultValue);
  }
}

/// Provides general extensions to [String?].
extension NullableStringExtensions on String? {
  /// Whether this string is empty.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// Whether this string is not empty
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.isNotEmpty;
  }

  /// The length of the string.
  ///
  /// Returns the number of UTF-16 code units in this string.
  /// The number of runes might be fewer,
  /// if the string contains characters outside the Basic Multilingual Plane (plane 0):
  ///
  /// 'Dart'.length;          // 4
  /// 'Dart'.runes.length;    // 4
  ///
  /// var clef = '\u{1D11E}';
  /// clef.length;            // 2
  /// clef.runes.length;      // 1
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Get the first string which is separated by [separator].
  String first({String separator = "/"}) {
    return this?.split(separator).firstOrNull ?? "";
  }

  /// Get the last string which is separated by [separator].
  String last({String separator = "/"}) {
    return this?.split(separator).lastOrNull ?? "";
  }

  /// Convert to Double or Int or Bool.
  dynamic toAny() {
    if (isEmpty) {
      return null;
    }
    final b = this!.toLowerCase();
    if (b == "true") {
      return true;
    } else if (b == "false") {
      return false;
    }
    final n = num.tryParse(this!);
    if (n != null) {
      return n;
    }
    return this;
  }

  /// Limits the string to [length],
  /// followed by [suffix] if it is limited.
  String? limit(int length, {String suffix = "..."}) {
    if (this == null) {
      return null;
    }
    if (this.length <= length) {
      return this;
    }
    return "${this!.substring(0, length)}$suffix";
  }

  /// Converts from JSON string to any object.
  dynamic toJsonObject([Object? object]) {
    if (this == null) {
      return object;
    }
    return jsonDecode(this!) ?? object;
  }

  /// Converts from JSON string to Map.
  Map<String, T> toJsonMap<T extends Object>([
    Map<String, T> defaultValue = const {},
  ]) {
    if (this == null) {
      return defaultValue;
    }
    return jsonDecodeAsMap<T>(this!, defaultValue);
  }

  /// Converts from JSON string to List.
  List<T> toJsonList<T extends Object>([
    List<T> defaultValue = const [],
  ]) {
    if (this == null) {
      return defaultValue;
    }
    return jsonDecodeAsList<T>(this!, defaultValue);
  }
}

/// Provides general extensions to [Iterable<T>?].
extension NullableIterableExtensions<T> on Iterable<T>? {
  /// Returns true if there are no elements in this collection.
  ///
  /// May be computed by checking if iterator.moveNext() returns false.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// Returns true if there is at least one element in this collection.
  ///
  /// May be computed by checking if iterator.moveNext() returns true.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.isNotEmpty;
  }

  /// Returns the number of elements in [this].
  ///
  /// Counting all elements may involve iterating through all elements and can therefore be slow.
  /// Some iterables have a more efficient way to find the number of elements.
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Returns the first element.
  ///
  /// Return `null` if the list has no element.
  T? get firstOrNull {
    if (this == null || isEmpty) {
      return null;
    }
    return this?.first;
  }

  /// Returns the last element.
  ///
  /// Return `null` if the list has no element.
  T? get lastOrNull {
    if (this == null || isEmpty) {
      return null;
    }
    return this?.last;
  }

  /// Returns the first value found by searching based on the condition specified in [test].
  ///
  /// If the value is not found, [Null] is returned.
  T? firstWhereOrNull(bool Function(T item) test) {
    if (this == null || isEmpty) {
      return null;
    }
    for (final element in this!) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// Whether the collection contains an element equal to [element].
  ///
  /// This operation will check each element in order for being equal to [element],
  /// unless it has a more efficient way to find an element equal to [element].
  ///
  /// The equality used to determine whether [element] is equal to an element of the iterable defaults to the [Object.==] of the element.
  ///
  /// Some types of iterable may have a different equality used for its elements.
  /// For example, a [Set] may have a custom equality (see [Set.identity]) that its contains uses.
  /// Likewise the Iterable returned by a [Map.keys] call should use the same equality that the Map uses for keys.
  bool contains(Object? element) {
    if (this == null) {
      return false;
    }
    return this!.contains(element);
  }

  /// Returns `true` if any of the given [elements] is in the list.
  bool containsAny(Iterable<Object?> elements) {
    if (this == null) {
      return false;
    }
    return elements.any((element) => this!.contains(element));
  }

  /// Returns `true` if all of the given [elements] is in the list.
  bool containsAll(Iterable<Object?> elements) {
    if (this == null) {
      return false;
    }
    return elements.every((element) => this!.contains(element));
  }

  /// The data in the list of [others] is conditionally given to the current list.
  ///
  /// If [test] is `true`, [apply] will be executed.
  ///
  /// Otherwise, [orElse] will be executed.
  Iterable<K> setWhere<K extends Object>(
    Iterable<T> others, {
    required bool Function(T original, T other) test,
    required K? Function(T original, T other) apply,
    K? Function(T original)? orElse,
  }) {
    final tmp = <K>[];
    if (this == null) {
      return tmp;
    }
    for (final original in this!) {
      final res = others.firstWhereOrNull((item) => test.call(original, item));
      if (res != null) {
        final applied = apply.call(original, res);
        if (applied != null) {
          tmp.add(applied);
        }
      } else {
        final applied = orElse?.call(original);
        if (applied != null) {
          tmp.add(applied);
        }
      }
    }
    return tmp;
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Iterable<T>? others) {
    if (this == null && others != null) {
      return false;
    }
    if (this != null && others == null) {
      return false;
    }
    if (this == null && others == null) {
      return true;
    }
    return this!.equalsTo(others!);
  }
}

/// Provides general extensions to [Object?].
extension NullableObjectExtensions on Object? {
  /// Specifies the initial value when the value is [Null].
  ///
  /// If the value is [Null],
  /// the value specified by [defaultValue] will be returned.
  ///
  /// All returned values will be of type non-null.
  T def<T>(T defaultValue) {
    if (this == null) {
      return defaultValue;
    }
    return this as T;
  }
}

/// Provides general extensions to [Map<K,V>].
extension MapExtensions<K, V> on Map<K, V> {
  /// Convert it to a list through [callback].
  Iterable<T> toList<T>(T Function(K key, V value) callback) sync* {
    for (final tmp in entries) {
      yield callback(tmp.key, tmp.value);
    }
  }

  /// Set only the value of the key specified
  /// by [keys] in the map specified by [other].
  ///
  /// ```
  /// final main = {"c": 3, "d": 4};
  /// final other = {"a": 1, "b": 2};
  /// main.addWith(other, ["a"]);     // {"a": 1, "c": 3, "d": 4}
  /// ```
  Map<K, V> addWith(Map<K, V> other, Iterable<K> keys) {
    for (final key in keys) {
      if (!other.containsKey(key)) {
        continue;
      }
      // ignore: null_check_on_nullable_type_parameter
      this[key] = other[key]!;
    }
    return this;
  }

  /// Get the value corresponding to [key] in the map.
  ///
  /// If [key] is not found, the value of [orElse] is returned.
  T get<T>(K key, T orElse) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse;
    }
    return (this[key] as T?) ?? orElse;
  }

  /// Get the list corresponding to [key] in the map.
  ///
  /// If [key] is not found, the list of [orElse] is returned.
  List<T> getAsList<T>(K key, [List<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse ?? [];
    }
    return (this[key] as List?)?.cast<T>() ?? orElse ?? [];
  }

  /// Get the map corresponding to [key] in the map.
  ///
  /// If [key] is not found, the map of [orElse] is returned.
  Map<String, T> getAsMap<T>(K key, [Map<String, T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse ?? {};
    }
    return (this[key] as Map?)?.cast<String, T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the map.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  Set<T> getAsSets<T>(K key, [Set<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse ?? {};
    }
    return (this[key] as Set?)?.cast<T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the DateTime.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  DateTime getAsDateTime(K key, [DateTime? orElse]) {
    if (!containsKey(key)) {
      return orElse ?? DateTime.now();
    }
    final millisecondsSinceEpoch = this[key] as int?;
    if (millisecondsSinceEpoch == null) {
      return orElse ?? DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  /// Merges the map in [others] with the current map.
  ///
  /// If the same key is found, the value of [others] has priority.
  Map<K, V> merge(
    Map<K, V>? others, {
    K Function(K key)? convertKeys,
    V Function(V value)? convertValues,
  }) {
    others ??= const {};
    final res = <K, V>{};
    for (final tmp in entries) {
      res[tmp.key] = tmp.value;
    }
    for (final tmp in others.entries) {
      final key = convertKeys?.call(tmp.key) ?? tmp.key;
      final value = convertValues?.call(tmp.value) ?? tmp.value;
      res[key] = value;
    }
    return res;
  }

  /// Add the values of the keys in [others]
  /// that do not exist in the current Map.
  void addAllIfEmpty(Map<K, V>? others) {
    if (others.isEmpty) {
      return;
    }
    for (final tmp in others!.entries) {
      if (containsKey(tmp.key)) {
        continue;
      }
      this[tmp.key] = tmp.value;
    }
  }

  /// Returns `true` if any of the given [keys] is in the map.
  bool containsKeyAny(Iterable<Object?> keys) {
    return keys.any((element) => containsKey(element));
  }

  /// Returns `true` if all of the given [keys] is in the map.
  bool containsKeyAll(Iterable<Object?> keys) {
    return keys.every((element) => containsKey(element));
  }

  /// Returns `true` if any of the given [values] is in the map.
  bool containsValueAny(Iterable<Object?> values) {
    return values.any((element) => containsValue(element));
  }

  /// Returns `true` if all of the given [values] is in the map.
  bool containsValueAll(Iterable<Object?> values) {
    return values.every((element) => containsValue(element));
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Map<K, V> others) {
    for (final tmp in entries) {
      if (!others.containsKey(tmp.key)) {
        return false;
      }
      final t = tmp.value;
      final o = others[tmp.key];
      if (t is Iterable?) {
        if (o is! Iterable?) {
          return false;
        }
        return t.equalsTo(o);
      } else if (t is Map?) {
        if (o is! Map?) {
          return false;
        }
        return t.equalsTo(o);
      } else if (t is Set?) {
        if (o is! Set?) {
          return false;
        }
        return t.equalsTo(o);
      } else if (t != o) {
        return false;
      }
    }
    for (final tmp in others.entries) {
      if (!containsKey(tmp.key)) {
        return false;
      }
    }
    return true;
  }
}

/// Provides general extensions to [Map<K,V>?].
extension NullableMapExtensions<K, V> on Map<K, V>? {
  /// Whether there is no key/value pair in the map.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// Whether there is at least one key/value pair in the map.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.isNotEmpty;
  }

  /// The number of key/value pairs in the map.
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Whether this map contains the given key.
  ///
  /// Returns true if any of the keys in the map are equal to key according to the equality used by the map.
  bool containsKey(Object? element) {
    if (this == null) {
      return false;
    }
    return this!.containsKey(element);
  }

  /// Whether this map contains the given value.
  ///
  /// Returns true if any of the values in the map are equal to value according to the == operator.
  bool containsValue(Object? element) {
    if (this == null) {
      return false;
    }
    return this!.containsValue(element);
  }

  /// Get the value corresponding to [key] in the map.
  ///
  /// If [key] is not found, the value of [orElse] is returned.
  T get<T>(K key, T orElse) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse;
    }
    return (this![key] as T?) ?? orElse;
  }

  /// Get the list corresponding to [key] in the map.
  ///
  /// If [key] is not found, the list of [orElse] is returned.
  List<T> getAsList<T>(K key, [List<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse ?? [];
    }
    return (this![key] as List?)?.cast<T>() ?? orElse ?? [];
  }

  /// Get the map corresponding to [key] in the map.
  ///
  /// If [key] is not found, the map of [orElse] is returned.
  Map<String, T> getAsMap<T>(K key, [Map<String, T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse ?? {};
    }
    return (this![key] as Map?)?.cast<String, T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the map.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  Set<T> getAsSets<T>(K key, [Set<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse ?? {};
    }
    return (this![key] as Set?)?.cast<T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the DateTime.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  DateTime getAsDateTime(K key, [DateTime? orElse]) {
    if (this == null || !containsKey(key)) {
      return orElse ?? DateTime.now();
    }
    final millisecondsSinceEpoch = this![key] as int?;
    if (millisecondsSinceEpoch == null) {
      return orElse ?? DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  /// Merges the map in [others] with the current map.
  ///
  /// If the same key is found, the value of [others] has priority.
  Map<K, V> merge(Map<K, V>? others) {
    others ??= const {};
    final res = <K, V>{};
    if (this != null) {
      for (final tmp in this!.entries) {
        res[tmp.key] = tmp.value;
      }
    }
    for (final tmp in others.entries) {
      res[tmp.key] = tmp.value;
    }
    return res;
  }

  /// Add the values of the keys in [others]
  /// that do not exist in the current Map.
  void addAllIfEmpty(Map<K, V>? others) {
    if (this == null || others.isEmpty) {
      return;
    }
    for (final tmp in others!.entries) {
      if (containsKey(tmp.key)) {
        continue;
      }
      this![tmp.key] = tmp.value;
    }
  }

  /// Returns `true` if any of the given [keys] is in the map.
  bool containsKeyAny(Iterable<Object?> keys) {
    if (this == null) {
      return false;
    }
    return keys.any((element) => this!.containsKey(element));
  }

  /// Returns `true` if all of the given [keys] is in the map.
  bool containsKeyAll(Iterable<Object?> keys) {
    if (this == null) {
      return false;
    }
    return keys.every((element) => this!.containsKey(element));
  }

  /// Returns `true` if any of the given [values] is in the map.
  bool containsValueAny(Iterable<Object?> values) {
    if (this == null) {
      return false;
    }
    return values.any((element) => this!.containsValue(element));
  }

  /// Returns `true` if all of the given [values] is in the map.
  bool containsValueAll(Iterable<Object?> values) {
    if (this == null) {
      return false;
    }
    return values.every((element) => this!.containsValue(element));
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Map<K, V>? others) {
    if (this == null && others != null) {
      return false;
    }
    if (this != null && others == null) {
      return false;
    }
    if (this == null && others == null) {
      return true;
    }
    return this!.equalsTo(others!);
  }
}

/// Provides general extensions to [Set<T>].
extension SetExtensions<T> on Set<T> {
  /// Returns `true` if any of the given [others] is in the list.
  bool containsAny(Iterable<Object?> others) {
    return others.any((element) => contains(element));
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Set<T> others) {
    for (final t in this) {
      if (!others.any((o) {
        if (t is Iterable?) {
          if (o is! Iterable?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Map?) {
          if (o is! Map?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Set?) {
          if (o is! Set?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t != o) {
          return false;
        }
        return true;
      })) {
        return false;
      }
    }
    for (final t in others) {
      if (!any((o) {
        if (t is Iterable?) {
          if (o is! Iterable?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Map?) {
          if (o is! Map?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Set?) {
          if (o is! Set?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t != o) {
          return false;
        }
        return true;
      })) {
        return false;
      }
    }
    return true;
  }
}

/// Provides general extensions to [Set<T>?].
extension NullableSetExtensions<T> on Set<T>? {
  /// Returns true if there are no elements in this collection.
  ///
  /// May be computed by checking if iterator.moveNext() returns false.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// Returns true if there is at least one element in this collection.
  ///
  /// May be computed by checking if iterator.moveNext() returns true.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.isNotEmpty;
  }

  /// Returns the number of elements in the iterable.
  ///
  /// This is an efficient operation that doesn't require iterating through the elements.
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Whether value is in the set.
  bool contains(Object? element) {
    if (this == null) {
      return false;
    }
    return this!.contains(element);
  }

  /// Returns `true` if any of the given [others] is in the list.
  bool containsAny(Iterable<Object?> others) {
    if (this == null) {
      return false;
    }
    return others.any((element) => this!.contains(element));
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Set<T>? others) {
    if (this == null && others != null) {
      return false;
    }
    if (this != null && others == null) {
      return false;
    }
    if (this == null && others == null) {
      return true;
    }
    return this!.equalsTo(others!);
  }
}

/// Provides general extensions to [int?].
extension NullableIntExtensions on int? {
  /// Whether this int is null or zero.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this == 0;
  }

  /// Whether this int is not null or zero.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this != 0;
  }
}

/// Provides general extensions to [double?].
extension NullableDoubleExtensions on double? {
  /// Whether this double is null or zero.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this == 0.0;
  }

  /// Whether this double is not null or zero.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this != 0.0;
  }
}

/// Provides general extensions to [int].
extension IntExtensions on int {
  /// Whether this int is zero.
  bool get isEmpty => this == 0;

  /// Whether this int is not zero.
  bool get isNotEmpty => this != 0;

  /// Restrict value from [min] to [max].
  int limit(int min, int max) {
    if (this < min) {
      return min;
    }
    if (this > max) {
      return max;
    }
    return this;
  }

  /// Restrict value from [min].
  int limitLow(int min) {
    if (this < min) {
      return min;
    }
    return this;
  }

  /// Restrict value from [max].
  int limitHigh(int max) {
    if (this > max) {
      return max;
    }
    return this;
  }

  /// Represents a number in [format].
  ///
  /// The [format] depends on NumberFormat.
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    return NumberFormat(format).format(this);
  }
}

/// Provides general extensions to [double].
extension DoubleExtensions on double {
  /// Whether this int is zero.
  bool get isEmpty => this == 0.0;

  /// Whether this int is not zero.
  bool get isNotEmpty => this != 0.0;

  /// Restrict value from [min] to [max].
  double limit(double min, double max) {
    if (this < min) {
      return min;
    }
    if (this > max) {
      return max;
    }
    return this;
  }

  /// Restrict value from [min].
  double limitLow(double min) {
    if (this < min) {
      return min;
    }
    return this;
  }

  /// Restrict value from [max].
  double limitHigh(double max) {
    if (this > max) {
      return max;
    }
    return this;
  }

  /// Represents a number in [format].
  ///
  /// The [format] depends on NumberFormat.
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    return NumberFormat(format).format(this);
  }
}

/// Provides general extensions to [Random].
extension RandomExtensions on Random {
  /// Get a random number from [min] to [max].
  int rangeInt(int min, int max) =>
      ((nextDouble() * (max - min)) + min).toInt().limit(min, max);

  /// Get a random number from [min] to [max].
  double rangeDouble(double min, double max) =>
      ((nextDouble() * (max - min)) + min).limit(min, max);
}

/// Provides general extensions to [Duration].
extension DurationExtensions on Duration {
  /// Format and output the duration.
  ///
  /// Enter the format of the date and time in [format].
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return format
        .replaceAll("dd", inDays.toString())
        .replaceAll("HH", twoDigits(inHours))
        .replaceAll("mm", twoDigits(inMinutes.remainder(60)))
        .replaceAll("ss", twoDigits(inSeconds.remainder(60)));
  }
}

/// Provides general extensions to [DateTime].
extension DateTimeExtensions on DateTime {
  /// True if the specified time or the current time is the same day.
  ///
  /// Pass the date and time you want to compare to [dateTime].
  /// If it is not passed, the current date and time is used.
  bool isToday([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day;
  }

  /// True if the specified time or the current time is the same month.
  ///
  /// Pass the date and time you want to compare to [dateTime].
  /// If it is not passed, the current date and time is used.
  bool isThisMonth([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year && month == dateTime.month;
  }

  /// True if the specified time or the current time is the same year.
  ///
  /// [dateTime]: Time to compare.
  bool isThisYear([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year;
  }

  /// True if the specified time or the current time is the same hour.
  ///
  /// Pass the date and time you want to compare to [dateTime].
  /// If it is not passed, the current date and time is used.
  bool isThisHour([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour;
  }

  /// True if the specified time or the current time is the same minute.
  ///
  /// [dateTime]: Time to compare.
  bool isThisMimute([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour &&
        minute == dateTime.minute;
  }

  /// True if the specified time or the current time is the same second.
  ///
  /// Pass the date and time you want to compare to [dateTime].
  /// If it is not passed, the current date and time is used.
  bool isThisSecond([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour &&
        minute == dateTime.minute &&
        second == dateTime.second;
  }

  /// Format and output the date.
  ///
  /// Enter the format of the date and time in [format].
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    return DateFormat(format).format(this).replaceAll(
          "ww",
          weekNumber.toString().padLeft(2, "0"),
        );
  }

  /// Extract date only.
  DateTime toDate() {
    return DateTime(year, month, day);
  }

  /// Converts a DateTime to a DateID in yyyyMMdd format.
  String toDateID() {
    return format("yyyyMMdd");
  }

  /// Converts a DateTime to a DateTimeID in yyyyMMddHHmmss format.
  String toDateTimeID() {
    return format("yyyyMMddHHmmss");
  }

  /// Rounds DateTime with Duration.
  DateTime round(Duration d) {
    return DateTime.fromMicrosecondsSinceEpoch(
      (microsecondsSinceEpoch / d.inMicroseconds).round() * d.inMicroseconds,
    );
  }

  /// Ceil DateTime with Duration.
  DateTime ceil(Duration d) {
    return DateTime.fromMicrosecondsSinceEpoch(
      (microsecondsSinceEpoch / d.inMicroseconds).ceil() * d.inMicroseconds,
    );
  }

  /// Floor DateTime with Duration.
  DateTime floor(Duration d) {
    return DateTime.fromMicrosecondsSinceEpoch(
      (microsecondsSinceEpoch / d.inMicroseconds).floor() * d.inMicroseconds,
    );
  }

  /// Week number according to ISO 8601.
  int get weekNumber {
    final thursday = DateTime.fromMillisecondsSinceEpoch(
      ((millisecondsSinceEpoch - 259200000) / 604800000).ceil() * 604800000,
    );
    final firstDayOfYear = DateTime(thursday.year, 1, 1);
    return ((thursday.millisecondsSinceEpoch -
                    firstDayOfYear.millisecondsSinceEpoch) /
                604800000)
            .floor() +
        1;
  }
}

/// Provides general extensions to [Iterable<T>].
extension IterableExtensions<T> on Iterable<T> {
  /// Remove duplicate values from the list.
  ///
  /// The [key] can be specified to change what is summarized by a particular element in the element.
  List<T> distinct([Object Function(T element)? key]) {
    if (key == null) {
      return toSet().toList();
    }
    final tmp = <Object, T>{};
    for (final element in this) {
      final o = key.call(element);
      if (tmp.containsKey(o)) {
        continue;
      }
      tmp[o] = element;
    }
    return tmp.values.toList();
  }

  /// Index and loop it through [callback].
  Iterable<T> index(T Function(T item, int index) callback) {
    int i = 0;
    for (final tmp in this) {
      callback(tmp, i);
      i++;
    }
    return this;
  }

  /// Returns the first element.
  ///
  /// Return `null` if the list has no element.
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }
    return first;
  }

  /// Returns the last element.
  ///
  /// Return `null` if the list has no element.
  T? get lastOrNull {
    if (isEmpty) {
      return null;
    }
    return last;
  }

  /// Returns the first value found by searching based on the condition specified in [test].
  ///
  /// If the value is not found, [Null] is returned.
  T? firstWhereOrNull(bool Function(T item) test) {
    if (isEmpty) {
      return null;
    }
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// After replacing the data in the list, delete the null.
  ///
  /// [callback]: Callback function used in map.
  List<TCast> mapAndRemoveEmpty<TCast>(TCast? Function(T item) callback) {
    return map<TCast?>(callback).removeEmpty();
  }

  /// After replacing the data in the list through [callback], delete the [Null].
  List<TCast> expandAndRemoveEmpty<TCast>(
    Iterable<TCast?> Function(T item) callback,
  ) {
    return expand<TCast?>(callback).removeEmpty();
  }

  /// Divides the array by the specified [length] into an array.
  Iterable<Iterable<T>> split(int length) {
    length = length.limit(0, this.length);
    List<T>? tmp;
    final res = <Iterable<T>>[];
    if (length == 0) {
      return res;
    }
    int i = 0;
    for (final item in this) {
      if (i % length == 0) {
        if (tmp != null) {
          res.add(tmp);
        }
        tmp = [];
      }
      tmp?.add(item);
      i++;
    }
    if (tmp != null) {
      res.add(tmp);
    }
    return res;
  }

  /// Create a list of lists, grouping those that match [a] and [b] in [test].
  Iterable<Iterable<T>> splitWhere(bool Function(T a, T b) test) {
    final res = <List<T>>[];
    for (final item in this) {
      if (res.isEmpty) {
        res.add([item]);
      } else {
        final found = res.firstWhereOrNull((e) {
          if (e.isEmpty) {
            return false;
          }
          return test.call(item, e.first);
        });
        if (found == null) {
          res.add([item]);
        } else {
          found.add(item);
        }
      }
    }
    return res;
  }

  /// Convert the map to Map<K,V> by passing [MapEntry] in the callback of [f].
  Map<K, V> toMap<K, V>(
    MapEntry<K, V>? Function(T item) f,
  ) {
    return Map.fromEntries(map((e) => f.call(e)).removeEmpty());
  }

  /// Extract an array with a given range between [start] and [end].
  List<T> limit(int start, int end) {
    if (this is List) {
      return (this as List).sublist(start, min(length, end)).cast<T>();
    } else {
      return toList().sublist(start, min(length, end));
    }
  }

  /// Extract an array with a given range at [start].
  List<T> limitStart(int start) => limit(start, length);

  /// Extract an array with a given range at [end].
  List<T> limitEnd(int end) => limit(0, end);

  /// Returns `true` if any of the given [elements] is in the list.
  bool containsAny(Iterable<Object?> elements) {
    return elements.any((element) => contains(element));
  }

  /// Returns `true` if all of the given [elements] is in the list.
  bool containsAll(Iterable<Object?> elements) {
    return elements.every((element) => contains(element));
  }

  /// The data in the list of [others] is conditionally given to the current list.
  ///
  /// If [test] is `true`, [apply] will be executed.
  ///
  /// Otherwise, [orElse] will be executed.
  Iterable<K> setWhere<K extends Object>(
    Iterable<T> others, {
    required bool Function(T original, T other) test,
    required K? Function(T original, T other) apply,
    K? Function(T original)? orElse,
  }) {
    final tmp = <K>[];
    for (final original in this) {
      final res = others.firstWhereOrNull((item) => test.call(original, item));
      if (res != null) {
        final applied = apply.call(original, res);
        if (applied != null) {
          tmp.add(applied);
        }
      } else {
        final applied = orElse?.call(original);
        if (applied != null) {
          tmp.add(applied);
        }
      }
    }
    return tmp;
  }

  /// Insert [value] for each [per].
  ///
  /// They are not added at the beginning and end.
  Iterable<T> insertEvery(T value, int per) {
    return split(per).joinToList(value);
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Iterable<T> others) {
    for (final t in this) {
      if (!others.any((o) {
        if (t is Iterable?) {
          if (o is! Iterable?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Map?) {
          if (o is! Map?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Set?) {
          if (o is! Set?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t != o) {
          return false;
        }
        return true;
      })) {
        return false;
      }
    }
    for (final t in others) {
      if (!any((o) {
        if (t is Iterable?) {
          if (o is! Iterable?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Map?) {
          if (o is! Map?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Set?) {
          if (o is! Set?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t != o) {
          return false;
        }
        return true;
      })) {
        return false;
      }
    }
    return true;
  }
}

/// Provides general extensions to [Iterable<T?>].
extension NullableValueIterableExtensions<T> on Iterable<T?> {
  /// If the iterator value is empty, delete the element.
  List<T> removeEmpty() {
    final list = <T>[];
    for (final tmp in this) {
      if (tmp == null) {
        continue;
      }
      list.add(tmp);
    }
    return list;
  }
}

/// Provides general extensions to [Iterable<Iterable<T>>].
extension InterableOfIterableExtensions<T> on Iterable<Iterable<T>> {
  /// The list inside are grouped together into a single list.
  ///
  /// You can define a [separator] to put an element in between.
  Iterable<T> joinToList([T? separator]) {
    final res = <T>[];
    for (final list in this) {
      res.addAll(list);
      if (separator != null) {
        res.add(separator);
      }
    }
    if (separator != null && res.isNotEmpty) {
      res.removeLast();
    }
    return res;
  }
}

/// Provides general extensions to [List<T>].
extension ListExtensions<T> on List<T> {
  /// Insert the [element] first.
  List<T> insertFirst(T element) {
    insert(0, element);
    return this;
  }

  /// Insert the [element] last.
  List<T> insertLast(T element) {
    add(element);
    return this;
  }

  /// Inserts an [insert] element at the element's position if True with a [test].
  List<T> insertWhere(
    T element,
    bool Function(T? prev, T? current, T? next) test,
  ) {
    for (int i = length - 1; i >= 0; i--) {
      if (!test(
        i <= 0 ? null : this[i - 1],
        this[i],
        i >= length - 1 ? null : this[i + 1],
      )) {
        continue;
      }
      insert(i, element);
      return this;
    }
    insert(0, element);
    return this;
  }

  /// Get a random value from an array element.
  ///
  /// You can set a random seed by specifying [seed].
  T? getRandom([int? seed]) {
    if (isEmpty) {
      return null;
    }
    final index = Random(seed).nextInt(length);
    return this[index];
  }

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// The [compare] function must act as a [Comparator].
  /// ```dart
  /// final numbers = <String>['two', 'three', 'four'];
  /// // Sort from shortest to longest.
  /// final sorted = numbers.sortTo((a, b) => a.length.compareTo(b.length));
  /// print(sorted); // [two, four, three]
  /// ```
  /// The default [List] implementations use [Comparable.compare] if
  /// [compare] is omitted.
  /// ```dart
  /// final numbers = <int>[13, 2, -11, 0];
  /// final sorted = numbers.sortTo();
  /// print(sorted); // [-11, 0, 2, 13]
  /// ```
  /// In that case, the elements of the list must be [Comparable] to
  /// each other.
  ///
  /// A [Comparator] may compare objects as equal (return zero), even if they
  /// are distinct objects.
  /// The sort function is not guaranteed to be stable, so distinct objects
  /// that compare as equal may occur in any order in the result:
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// final sorted numbers.sortTo((a, b) => a.length.compareTo(b.length));
  /// print(sorted); // [one, two, four, three] OR [two, one, four, three]
  /// ```
  List<T> sortTo([int Function(T a, T b)? compare]) {
    final sorted = List<T>.from(this);
    sorted.sort(compare);
    return sorted;
  }

  /// Returns True if the list contains a key ([index]).
  bool containsKey(int index) {
    return index >= 0 && index < length;
  }

  /// Returns True if the list contains [value].
  ///
  /// Same as [contains].
  bool containsValue(T value) {
    return contains(value);
  }

  /// Extend the list to [length], and if not, put [value].
  List<T?> fill(int length, [T? value]) {
    final tmp = <T?>[];
    for (int i = 0; i < max(length, this.length); i++) {
      if (i < this.length) {
        tmp.add(this[i]);
      } else {
        tmp.add(value);
      }
    }
    return tmp;
  }
}

/// Provides general extensions to [List<T>?].
extension NullableListExtensions<T> on List<T>? {
  /// Insert the [element] first.
  List<T>? insertFirst(T element) {
    if (this == null) {
      return this;
    }
    this!.insert(0, element);
    return this!;
  }

  /// Insert the [element] last.
  List<T>? insertLast(T element) {
    if (this == null) {
      return this;
    }
    this!.add(element);
    return this!;
  }

  /// Inserts an insert element at the element's position if True with a [test].
  List<T>? insertWhere(
    T element,
    bool Function(T? prev, T? current, T? next) test,
  ) {
    if (this == null) {
      return this;
    }
    for (int i = length - 1; i >= 0; i--) {
      if (!test(
        i <= 0 ? null : this![i - 1],
        this![i],
        i >= length - 1 ? null : this![i + 1],
      )) {
        continue;
      }
      this!.insert(i, element);
      return this;
    }
    this!.insert(0, element);
    return this!;
  }

  /// Get a random value from an array element.
  ///
  /// You can set a random seed by specifying [seed].
  T? getRandom([int? seed]) {
    if (isEmpty) {
      return null;
    }
    final index = Random(seed).nextInt(length);
    return this![index];
  }

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// The [compare] function must act as a [Comparator].
  /// ```dart
  /// final numbers = <String>['two', 'three', 'four'];
  /// // Sort from shortest to longest.
  /// final sorted = numbers.sortTo((a, b) => a.length.compareTo(b.length));
  /// print(sorted); // [two, four, three]
  /// ```
  /// The default [List] implementations use [Comparable.compare] if
  /// [compare] is omitted.
  /// ```dart
  /// final numbers = <int>[13, 2, -11, 0];
  /// final sorted = numbers.sortTo();
  /// print(sorted); // [-11, 0, 2, 13]
  /// ```
  /// In that case, the elements of the list must be [Comparable] to
  /// each other.
  ///
  /// A [Comparator] may compare objects as equal (return zero), even if they
  /// are distinct objects.
  /// The sort function is not guaranteed to be stable, so distinct objects
  /// that compare as equal may occur in any order in the result:
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// final sorted numbers.sortTo((a, b) => a.length.compareTo(b.length));
  /// print(sorted); // [one, two, four, three] OR [two, one, four, three]
  /// ```
  List<T>? sortTo([int Function(T a, T b)? compare]) {
    if (this == null) {
      return null;
    }
    final sorted = List<T>.from(this!);
    sorted.sort(compare);
    return sorted;
  }

  /// Returns True if the list contains a key ([index]).
  bool containsKey(int index) {
    if (this == null) {
      return false;
    }
    return index >= 0 && index < length;
  }

  /// Returns True if the list contains [value].
  ///
  /// Same as [contains].
  bool containsValue(T value) {
    if (this == null) {
      return false;
    }
    return contains(value);
  }

  /// Extend the list to [length], and if not, put [value].
  List<T?>? fill(int length, [T? value]) {
    if (this == null) {
      return null;
    }
    final tmp = <T?>[];
    for (int i = 0; i < max(length, this.length); i++) {
      if (i < this.length) {
        tmp.add(this![i]);
      } else {
        tmp.add(value);
      }
    }
    return tmp;
  }
}

/// Provides general extensions to [Iterable<int>].
extension IntIterableExtensions on Iterable<int> {
  /// Get the number closest to [point] from the array.
  ///
  /// If the array has no elements, [Null] is passed.
  int? nearestOrNull(num point) {
    if (isEmpty) {
      return null;
    }
    int? _res;
    int? _point;
    for (final tmp in this) {
      if (tmp == point) {
        return tmp;
      }
      final p = (point - tmp).abs().toInt();
      if (_point == null || p < _point) {
        _res = tmp;
        _point = p;
      }
    }
    return _res;
  }
}

/// Provides general extensions to [Iterable<int>?].
extension NullableIntIterableExtensions on Iterable<int>? {
  /// Get the number closest to [point] from the array.
  ///
  /// If the array has no elements, [Null] is passed.
  int? nearestOrNull(num point) {
    if (isEmpty) {
      return null;
    }
    int? _res;
    int? _point;
    for (final tmp in this!) {
      if (tmp == point) {
        return tmp;
      }
      final p = (point - tmp).abs().toInt();
      if (_point == null || p < _point) {
        _res = tmp;
        _point = p;
      }
    }
    return _res;
  }
}

/// Provides general extensions to [Iterable<double>].
extension DoubleIterableExtensions on Iterable<double> {
  /// Get the number closest to [point] from the array.
  ///
  /// If the array has no elements, [Null] is passed.
  double? nearestOrNull(num point) {
    if (isEmpty) {
      return null;
    }
    double? _res;
    double? _point;
    for (final tmp in this) {
      if (tmp == point) {
        return tmp;
      }
      final p = (point - tmp).abs();
      if (_point == null || p < _point) {
        _res = tmp;
        _point = p;
      }
    }
    return _res;
  }
}

/// Provides general extensions to [Iterable<double>?].
extension NullableDoubleIterableExtensions on Iterable<double>? {
  /// Get the number closest to [point] from the array.
  ///
  /// If the array has no elements, [Null] is passed.
  double? nearestOrNull(num point) {
    if (isEmpty) {
      return null;
    }
    double? _res;
    double? _point;
    for (final tmp in this!) {
      if (tmp == point) {
        return tmp;
      }
      final p = (point - tmp).abs();
      if (_point == null || p < _point) {
        _res = tmp;
        _point = p;
      }
    }
    return _res;
  }
}

/// Provides general extensions to [Iterable<DateTime>].
extension DateTimeIterableExtensions on Iterable<DateTime> {
  /// Get the datetime closest to [point] from the array.
  ///
  /// If the array has no elements, [Null] is passed.
  DateTime? nearestOrNull(DateTime point) {
    if (isEmpty) {
      return null;
    }
    DateTime? _res;
    int? _point;
    final pointMilliseconds = point.millisecondsSinceEpoch;
    for (final tmp in this) {
      final tmpMilliseconds = tmp.millisecondsSinceEpoch;
      if (tmpMilliseconds == pointMilliseconds) {
        return tmp;
      }
      final p = (pointMilliseconds - tmpMilliseconds).abs();
      if (_point == null || p < _point) {
        _res = tmp;
        _point = p;
      }
    }
    return _res;
  }
}

/// Extension method of Dynamic List.
extension JsonDynamicListExtensions on DynamicList {
  /// Convert to JSON string.
  String toJsonString() {
    return jsonEncode(this);
  }
}

/// Extension method of Dynamic Map.
extension JsonDynamicMapExtensions on DynamicMap {
  /// Convert to JSON string.
  String toJsonString() {
    return jsonEncode(this);
  }
}
