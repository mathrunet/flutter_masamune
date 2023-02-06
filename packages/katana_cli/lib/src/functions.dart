import 'dart:io';

/// Class for specifying Functions of Firebase Functions.
///
/// Firebase FunctionsのFunctionを指定するためのクラス。
class Fuctions {
  Fuctions();

  static final _regExp = RegExp(
    r"m.deploy\([\s\S]*?exports,[\s\S]*?\[(?<functions>[^\]]*?)\],?[\s\S]*\);",
  );

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// List of Functions.
  ///
  /// Functionの一覧。
  List<String> get functions => _functions;
  late List<String> _functions;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    final index = File("firebase/functions/src/index.ts");
    _rawData = await index.readAsString();
    final region = _regExp.firstMatch(_rawData);
    if (region == null) {
      return;
    }
    _functions = region
            .namedGroup("functions")
            ?.split(",")
            .map((e) => e.trim().replaceAll(RegExp("^m.Functions."), ""))
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = _rawData.replaceAll(_regExp, """
m.deploy(
    exports,
    [
${functions.map((e) => "        m.Functions.$e").join(",")}
    ],
);
""");
    final gradle = File("firebase/functions/src/index.ts");
    await gradle.writeAsString(_rawData);
  }
}
