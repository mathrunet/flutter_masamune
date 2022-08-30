part of katana;


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
