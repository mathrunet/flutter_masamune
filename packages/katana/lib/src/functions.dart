part of "/katana.dart";

/// Generate and retrieve the UUID for Version 7.
///
/// The strings can be sorted in chronological order of generation.
///
/// Returned as a string with 32 hyphenated characters removed.
///
/// If [baseTime] is specified, the date and time to be generated can be adjusted. If [reverse] is specified, the elapsed time from [baseTime] is reversed.
///
/// Version7のUUIDを生成し取得します。
///
/// 文字列を生成した時系列順にソート可能です。
///
/// 32文字のハイフンが取り除かれた文字列として返されます。
///
/// [baseTime]を指定した場合、生成する日時を調節できます。[reverse]を指定した場合は、[baseTime]からの経過時間を反転させた値を使用します。
String uuid({DateTime? baseTime, bool reverse = false}) {
  const uuid = Uuid();
  baseTime ??= Clock.now();
  final generated = uuid
      .v7(
        config: V7Options(
          baseTime.toUtc().millisecondsSinceEpoch,
          _randomData(),
        ),
      )
      .replaceAll("-", "");
  if (reverse) {
    return _createComplementaryString(generated);
  }
  return generated;
}

String _createComplementaryString(String originalString) {
  final buffer = StringBuffer();
  const charList = "0123456789abcdef";

  for (var i = 0; i < originalString.length; i++) {
    final chatIndex = charList.indexOf(originalString[i]);
    if (chatIndex == -1) {
      continue;
    }
    final complementIndex = charList.length - chatIndex - 1;
    buffer.write(charList[complementIndex]);
  }

  return buffer.toString();
}

List<int> _randomData() {
  Uint8List seedBytes = MathRNG().generate();

  List<int> randomData = [
    seedBytes[0],
    seedBytes[1],
    seedBytes[2],
    seedBytes[3],
    seedBytes[4],
    seedBytes[5],
    seedBytes[6],
    seedBytes[7],
    seedBytes[8],
    seedBytes[9]
  ];

  return randomData;
}

/// Wait until all Futures given in [futures] are completed.
///
/// [futures]で与えられたFutureがすべて終了するまで待ちます。
Future<void> wait(Iterable<dynamic> futures) async {
  await Future.wait(futures.whereType<Future>());
}

/// Generates and returns a random string with the number of characters given by [length].
///
/// If [seed] is given, the random generation can be seeded.
///
/// Only the characters given in [charSet] will be included in the randomly generated string.
///
/// Characters such as `1`, `l`, and `i`, which are indistinguishable in some fonts, are eliminated by default.
///
/// [length]で与えられた文字数でランダムな文字列を生成して返します。
///
/// [seed]を与えた場合、ランダム生成にシードを与えることができます。
///
/// [charSet]で与えた文字のみがランダム生成する文字列に含まれます。
///
/// `1`や`l`、`i`などフォントによっては見分けがつかない文字をデフォルトでは排除しています。
String generateCode(
  int length, {
  int seed = 0,
  String charSet = "23456789abcdefghjkmnpqrstuvwxy",
}) {
  final tmpLength = charSet.length;
  final rand = seed != 0 ? Random(seed) : Random();
  final codeUnits = List.generate(
    length,
    (index) {
      final n = rand.nextInt(tmpLength);
      return charSet.codeUnitAt(n);
    },
  );
  return String.fromCharCodes(codeUnits);
}

/// Converts [json] to a Json-decoded Map&lt;String, dynamic&gt; object.
///
/// If [String] is in a format that cannot be decoded by Json, [defaultValue] is returned.
///
/// [json]をJsonデコードされたMap&lt;String, dynamic&gt;オブジェクトに変換します。
///
/// [String]がJsonでデコード不可能な形式だった場合[defaultValue]が返されます。
Map<String, T> jsonDecodeAsMap<T extends Object?>(
  String json, [
  Map<String, T> defaultValue = const {},
]) {
  try {
    return (jsonDecode(json) as DynamicMap).cast<String, T>();
    // ignore: empty_catches
  } catch (e) {}
  return defaultValue;
}

/// Converts [json] to a Json-decoded List&lt;dynamic&gt; object.
///
/// If [String] is in a format that cannot be decoded by Json, [defaultValue] is returned.
///
/// [json]をJsonデコードされたList&lt;dynamic&gt;オブジェクトに変換します。
///
/// [String]がJsonでデコード不可能な形式だった場合[defaultValue]が返されます。
List<T> jsonDecodeAsList<T extends Object?>(
  String json, [
  List<T> defaultValue = const [],
]) {
  try {
    return (jsonDecode(json) as List).cast<T>();
    // ignore: empty_catches
  } catch (e) {}
  return defaultValue;
}

/// If this object is Json encodable, `true` is returned.
///
/// If a [List] or [Map] exists, its contents are also checked.
///
/// このオブジェクトがJsonでエンコード可能な場合`true`が返されます。
///
/// [List]や[Map]が存在していた場合はその中身までチェックされます。
bool jsonEncodable(Object? o) {
  if (o is List<dynamic>) {
    return o.isJsonEncodable;
  } else if (o is Map<String, dynamic>) {
    return o.isJsonEncodable;
  }
  return o is num || o is bool || o is String;
}
