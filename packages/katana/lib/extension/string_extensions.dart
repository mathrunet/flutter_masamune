part of katana;

/// Provides extended methods for [String].
///
/// [String]用の拡張メソッドを提供します。
extension StringExtensions on String {
  static final RegExp _tail = RegExp(r"[^/]+$");

  /// Divides [String] by [separator] and returns the number of elements.
  ///
  /// [String]を[separator]で分割し、その要素数を返します。
  ///
  /// ```dart
  /// final path = "aaaa/bbbb/cccc/dddd";
  /// final length = path.splitLength(); // 4
  /// ```
  int splitLength({String separator = "/"}) {
    if (isEmpty) {
      return 0;
    }
    final paths = split(separator);
    final length = paths.length;
    return length;
  }

  /// [String] is divided by [separator] and moved one level up.
  ///
  /// [String]を[separator]で分割し一つ上の階層に移動します。
  ///
  /// ```dart
  /// final path = "aaaa/bbbb/cccc/dddd";
  /// final parentPath = path.parentPath(); // "aaaa/bbbb/cccc"
  /// ```
  String parentPath({String separator = "/"}) {
    if (isEmpty) {
      return this;
    }
    final path = trimString(separator);
    return path.replaceAll(_tail, "").trimStringRight(separator);
  }

  /// Converts [String] to an array of one character at a time.
  ///
  /// [String]を1文字ずつの配列に変換します。
  ///
  /// ```dart
  /// final text = "abcde";
  /// final characters = ["a", "b", "c", "d", "e"];
  /// ```
  List<String> splitByCharacter() {
    if (isEmpty) {
      return <String>[];
    }
    if (length <= 1) {
      return [this];
    }
    final tmp = <String>[];
    for (int i = 0; i < length; i++) {
      tmp.add(substring(i, min(i + 1, length)));
    }
    return tmp;
  }

  /// Convert [String] to Bigram, i.e., an array of two characters each.
  ///
  /// [String]をBigram、つまり2文字ずつの配列に変換します。
  ///
  /// ```dart
  /// final text = "abcde";
  /// final characters = ["ab", "bc", "cd", "de"];
  /// ```
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

  /// Convert [String] to Trigram, i.e., an array of 3 characters each.
  ///
  /// [String]をTrigram、つまり3文字ずつの配列に変換します。
  ///
  /// ```dart
  /// final text = "abcde";
  /// final characters = ["abc", "bcd", "cde"];
  /// ```
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

  /// Trims URL query characters (after ?).
  ///
  /// URLのクエリ文字（?以降）をトリムします。
  ///
  /// ```dart
  /// final url = "https://google.com?q=searchtext";
  /// final trimed = url.trimQuery(); // "https://google.com"
  /// ```
  String trimQuery() {
    if (!contains("?")) {
      return this;
    }
    return split("?").first;
  }

  /// Trims the characters given by [chars] from before and after [String].
  ///
  /// [String]の前後から[chars]で与えられた文字をトリムします。
  ///
  /// ```dart
  /// final text = "__text___";
  /// final trimed = text.trimString("_"); // "text"
  /// ```
  String trimString(String chars) {
    final pattern = chars.isNotEmpty
        ? RegExp("^[$chars]+|[$chars]+\$")
        : RegExp(r"^\s+|\s+$");
    return replaceAll(pattern, "");
  }

  /// Trims the characters given by [chars] from before [String].
  ///
  /// [String]の前から[chars]で与えられた文字をトリムします。
  ///
  /// ```dart
  /// final text = "__text___";
  /// final trimed = text.trimString("_"); // "text___"
  /// ```
  String trimStringLeft(String chars) {
    final pattern = chars.isNotEmpty ? RegExp("^[$chars]+") : RegExp(r"^\s+");
    return replaceAll(pattern, "");
  }

  /// Trims the characters given by [chars] from after [String].
  ///
  /// [String]の後から[chars]で与えられた文字をトリムします。
  ///
  /// ```dart
  /// final text = "__text___";
  /// final trimed = text.trimString("_"); // "__text"
  /// ```
  String trimStringRight(String chars) {
    final pattern = chars.isNotEmpty ? RegExp("[$chars]+\$") : RegExp(r"\s+$");
    return replaceAll(pattern, "");
  }

  /// Convert [String] to snake case.
  ///
  /// [String]をスネークケースに変換します。
  ///
  /// ```dart
  /// final text = "SnakeCaseText";
  /// final snakeCase = text.toSnakeCase(); // "snake_case_text"
  ///
  /// final text = "Snake_Case_Text";
  /// final snakeCase = text.toSnakeCase(); // "snake_case_text"
  /// ```
  String toSnakeCase() {
    return snakeCase;
  }

  /// Convert [String] to CamelCase (first letter is lower case).
  ///
  /// [String]をキャメルケース（最初の文字は小文字）に変換します。
  ///
  /// ```dart
  /// final text = "CAMEL_CASE_TEXT";
  /// final snakeCase = text.toSnakeCase(); // "camelCaseText"
  ///
  /// final text = "camel_case_text";
  /// final snakeCase = text.toSnakeCase(); // "camelCaseText"
  /// ```
  String toCamelCase() {
    return camelCase;
  }

  /// Converts [String] to [int].
  ///
  /// If the string cannot be converted, [defaultValue] is returned.
  ///
  /// [String]を[int]に変換します。
  ///
  /// 変換できない文字列の場合、[defaultValue]が返されます。
  int toInt([int defaultValue = 0]) {
    if (isEmpty) {
      return defaultValue;
    }
    final i = int.tryParse(this);
    if (i != null) {
      return i;
    }
    return defaultValue;
  }

  /// Converts [String] to [double].
  ///
  /// If the string cannot be converted, [defaultValue] is returned.
  ///
  /// [String]を[double]に変換します。
  ///
  /// 変換できない文字列の場合、[defaultValue]が返されます。
  double toDouble([double defaultValue = 0.0]) {
    if (isEmpty) {
      return defaultValue;
    }
    final d = double.tryParse(this);
    if (d != null) {
      return d;
    }
    return defaultValue;
  }

  /// Converts [String] to [bool].
  ///
  /// If the string cannot be converted, [defaultValue] is returned.
  ///
  /// [String]を[bool]に変換します。
  ///
  /// 変換できない文字列の場合、[defaultValue]が返されます。
  ///
  /// ```dart
  /// final text = "True";
  /// final boolValue = text.toBool(); // true
  ///
  /// final text = "false";
  /// final boolValue = text.toBool(); // false
  ///
  /// final text = "TRUE";
  /// final boolValue = text.toBool(); // true
  /// ```
  bool toBool([bool defaultValue = false]) {
    if (toLowerCase() == "true") {
      return true;
    } else if (toLowerCase() == "false") {
      return false;
    }
    return defaultValue;
  }

  /// Converts a [String] to a type that can be parsed as [bool], [int], or [double], in that order, and returns the type as is.
  ///
  /// If it cannot be converted, it is returned as [String].
  ///
  /// [String]を[bool]、[int]、[double]の順でパースできる型に変換しその型のまま返します。
  ///
  /// 変換できない場合は[String]のまま返されます。
  ///
  /// ```dart
  /// final text = "100";
  /// final any = text.toAny(); // 100 (int)
  /// final text = "100.9";
  /// final any = text.toAny(); // 100.9 (double)
  /// final text = "false";
  /// final any = text.toAny(); // false (bool)
  /// final text = "abc100";
  /// final any = text.toAny(); // "abc100" (String)
  /// ```
  dynamic toAny() {
    if (isEmpty) {
      return "";
    }
    final b = toLowerCase();
    if (b == "true") {
      return true;
    } else if (b == "false") {
      return false;
    }
    final i = int.tryParse(this);
    if (i != null) {
      return i;
    }
    final d = double.tryParse(this);
    if (d != null) {
      return d;
    }
    return this;
  }

  /// Converts [String] to [DateTime].
  ///
  /// If [String] cannot be parsed after parsing with [DateTime.tryParse], further parsing is attempted using the sequence "yyyyMMddHHmmss".
  ///
  /// If parsing is not possible, [defaultValue] or [DateTime.now] is returned.
  ///
  /// [String]を[DateTime]に変換します。
  ///
  /// [String]を[DateTime.tryParse]でパースしたのちパースできなければ、"yyyyMMddHHmmss"の並びでさらにパースを試みます。
  ///
  /// パースできなかった場合、[defaultValue]、もしくは[DateTime.now]を返します。
  DateTime toDateTime([DateTime? defaultValue]) {
    if (isEmpty) {
      return defaultValue ?? DateTime.now();
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
      return defaultValue ?? DateTime.now();
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

  /// Encode [String] into a Base64 string.
  ///
  /// [String]をBase64の文字列にエンコードします。
  String toBase64() => utf8.fuse(base64).encode(this);

  /// Encode [String] into a Base64URL string.
  ///
  /// [String]をBase64URLの文字列にエンコードします。
  String toBase64Url() => utf8.fuse(base64Url).encode(this);

  /// Decodes Base64-encoded [String].
  ///
  /// Base64エンコードされた[String]をデコードします。
  String fromBase64() => utf8.fuse(base64).decode(this);

  /// Decodes Base64URL-encoded [String].
  ///
  /// Base64URLエンコードされた[String]をデコードします。
  String fromBase64Url() => utf8.fuse(base64Url).decode(this);

  /// Hash [String] with SHA1.
  ///
  /// [String]をSHA1でハッシュ化します。
  String toSHA1() => sha1.convert(utf8.encode(this)).toString();

  /// Give [password] to [String] and hash it with HMAC-SHA256.
  ///
  /// [String]に[password]を与えてをHMAC-SHA256でハッシュ化します。
  String toSHA256(String password) {
    final hmacSha256 = Hmac(sha256, utf8.encode(password));
    return hmacSha256.convert(utf8.encode(this)).toString();
  }

  /// Pass [key] of at least 32 characters to [String] for AES encryption.
  ///
  /// The encrypted string is returned Base64-encoded.
  ///
  /// The `IV` is created from [key].
  ///
  /// [String]に32文字以上の[key]を渡してAES暗号化します。
  ///
  /// 暗号化された文字列はBase64エンコードされ返されます。
  ///
  /// `IV`は[key]から作成されます。
  String toAES(String key) {
    assert(key.length >= 32, "Please pass at least 32 characters for [key].");
    final encodedKey = Key.fromUtf8(key.substring(0, 32));
    final iv = IV.fromUtf8(key.substring(max(0, key.length - 16), key.length));
    return Encrypter(AES(encodedKey)).encrypt(this, iv: iv).base64;
  }

  /// Decrypts AES-encrypted and Base64-encoded [String].
  ///
  /// The [key] should be the same as that given for the AES encryption.
  ///
  /// AES暗号化されBase64エンコードされた[String]を復号化します。
  ///
  /// [key]はAES暗号化された際に与えたものと同じものを与えてください。
  String fromAES(String key) {
    assert(key.length >= 32, "Please pass at least 32 characters for [key].");
    final encodedKey = Key.fromUtf8(key.substring(0, 32));
    final iv = IV.fromUtf8(key.substring(max(0, key.length - 16), key.length));
    return Encrypter(AES(encodedKey)).decrypt64(this, iv: iv);
  }

  /// Replaces [String] with the C printf format.
  ///
  /// Pass the object to be replaced to [arg].
  ///
  /// Please list the letters to be replaced in the format below.
  ///
  /// [String]をC言語のprintfの書式で置き換え返します。
  ///
  /// [arg]に置き換えるオブジェクトを渡します。
  ///
  /// 下記のフォーマットで置き換える文字を記載してください。
  ///
  /// - `%s` Outputs a string. 文字列を出力する。	`%8s`, `%-10s`
  /// - `%d` Output an integer in decimal. 整数を10進で出力する。	`%-2d`, `%03d`
  /// - `%o` Output an integer in octal. 整数を8進で出力する。 `%06o`, `%03o`
  /// - `%x` Output an integer in hexadecimal. 整数を16進で出力する。 `%04x`
  /// - `%f` Output real numbers. 実数を出力する。 `%5.2f`
  String format(List<Object> arg) {
    return sprintf(this, arg);
  }

  /// Divides a [String] by [separator] and returns the first part.
  ///
  /// [String]を[separator]で分割しその最初の部分を返します。
  ///
  /// ```dart
  /// final path = "aaaa/bbbb/cccc/dddd";
  /// final first = path.first(); // aaaa
  /// ```
  String first({String separator = "/"}) {
    return split(separator).firstOrNull ?? "";
  }

  /// Divides a [String] by [separator] and returns the last part.
  ///
  /// [String]を[separator]で分割しその最後の部分を返します。
  ///
  /// ```dart
  /// final path = "aaaa/bbbb/cccc/dddd";
  /// final first = path.first(); // dddd
  /// ```
  String last({String separator = "/"}) {
    return split(separator).lastOrNull ?? "";
  }

  /// [String] with [length] to limit the number of characters.
  ///
  /// If the string is restricted, [suffix] is added at the end.
  ///
  /// [String]を[length]で文字数を制限します。
  ///
  /// 文字列が制限された場合、最後尾に[suffix]が追加されます。
  ///
  /// ```dart
  /// final text = "abcdefghijklmn";
  /// final limited = text.limit(5); // "abcde..."
  /// ```
  String limit(int length, {String suffix = "..."}) {
    if (this.length <= length) {
      return this;
    }
    return "${substring(0, length)}$suffix";
  }

  /// Captialize and return [String].
  ///
  /// [String]をキャピタライズして返します。
  ///
  /// ```dart
  /// final text = "capitalize";
  /// final capitalized = text.capitalize(); // "Capitalize"
  /// ```
  String capitalize() {
    if (isEmpty) {
      return "";
    }
    if (length <= 1) {
      return this[0].toUpperCase();
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  /// Converts [String] to a Json-decoded object.
  ///
  /// If [String] is in a format that cannot be decoded by Json, [defaultValue] is returned.
  ///
  /// [String]をJsonデコードされたオブジェクトに変換します。
  ///
  /// [String]がJsonでデコード不可能な形式だった場合[defaultValue]が返されます。
  dynamic toJsonObject([Object? defaultValue]) {
    return jsonDecode(this) ?? defaultValue;
  }

  /// Converts [String] to a Json-decoded Map<String, dynamic> object.
  ///
  /// If [String] is in a format that cannot be decoded by Json, [defaultValue] is returned.
  ///
  /// [String]をJsonデコードされたMap<String, dynamic>オブジェクトに変換します。
  ///
  /// [String]がJsonでデコード不可能な形式だった場合[defaultValue]が返されます。
  Map<String, T> toJsonMap<T extends Object>([
    Map<String, T> defaultValue = const {},
  ]) {
    return jsonDecodeAsMap<T>(this, defaultValue);
  }

  /// Converts [String] to a Json-decoded List<dynamic> object.
  ///
  /// If [String] is in a format that cannot be decoded by Json, [defaultValue] is returned.
  ///
  /// [String]をJsonデコードされたList<dynamic>オブジェクトに変換します。
  ///
  /// [String]がJsonでデコード不可能な形式だった場合[defaultValue]が返されます。
  List<T> toJsonList<T extends Object>([
    List<T> defaultValue = const [],
  ]) {
    return jsonDecodeAsList<T>(this, defaultValue);
  }
}
