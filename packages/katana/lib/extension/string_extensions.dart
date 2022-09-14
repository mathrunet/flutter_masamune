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

  /// Convert the letters to snake case.
  String toSnakeCase() {
    return snakeCase;
  }

  /// Convert the letters to camel case.
  String toCamelCase() {
    return camelCase;
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
