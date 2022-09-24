part of katana;

/// Generate and retrieve the UUID for Version 4.
/// Version4のUUIDを生成し取得します。
///
/// Returned as a string with 32 hyphenated characters removed.
/// 32文字のハイフンが取り除かれた文字列として返されます。
String get uuid {
  const uuid = Uuid();
  return uuid.v4().replaceAll("-", "");
}

/// Wait until all Futures given in [futures] are completed.
/// [futures]で与えられたFutureがすべて終了するまで待ちます。
Future<void> wait(Iterable<dynamic> futures) async {
  await Future.wait(futures.whereType<Future>());
}

/// Generates and returns a random string with the number of characters given by [length].
/// [length]で与えられた文字数でランダムな文字列を生成して返します。
///
/// If [seed] is given, the random generation can be seeded.
/// [seed]を与えた場合、ランダム生成にシードを与えることができます。
///
/// Only the characters given in [charSet] will be included in the randomly generated string.
/// [charSet]で与えた文字のみがランダム生成する文字列に含まれます。
///
/// Characters such as `1`, `l`, and `i`, which are indistinguishable in some fonts, are eliminated by default.
/// `1`や`l`、`i`などフォントによっては見分けがつかない文字をデフォルトでは排除しています。
String generateCode(
  int length, {
  int seed = 0,
  String charSet = "23456789abcdefghjkmnpqrstuvwxy",
}) {
  final _length = charSet.length;
  final rand = seed != 0 ? Random(seed) : Random();
  final codeUnits = List.generate(
    length,
    (index) {
      final n = rand.nextInt(_length);
      return charSet.codeUnitAt(n);
    },
  );
  return String.fromCharCodes(codeUnits);
}

/// Converts [json] to a Json-decoded Map<String, dynamic> object.
/// [json]をJsonデコードされたMap<String, dynamic>オブジェクトに変換します。
///
/// If [String] is in a format that cannot be decoded by Json, [defaultValue] is returned.
/// [String]がJsonでデコード不可能な形式だった場合[defaultValue]が返されます。
Map<String, T> jsonDecodeAsMap<T extends Object>(
  String json, [
  Map<String, T> defaultValue = const {},
]) {
  try {
    return (jsonDecode(json) as DynamicMap).cast<String, T>();
    // ignore: empty_catches
  } catch (e) {}
  return defaultValue;
}

/// Converts [json] to a Json-decoded List<dynamic> object.
/// [json]をJsonデコードされたList<dynamic>オブジェクトに変換します。
///
/// If [String] is in a format that cannot be decoded by Json, [defaultValue] is returned.
/// [String]がJsonでデコード不可能な形式だった場合[defaultValue]が返されます。
List<T> jsonDecodeAsList<T extends Object>(
  String json, [
  List<T> defaultValue = const [],
]) {
  try {
    return (jsonDecode(json) as List).cast<T>();
    // ignore: empty_catches
  } catch (e) {}
  return defaultValue;
}
