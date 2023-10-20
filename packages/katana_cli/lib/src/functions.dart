// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Class for specifying Functions of Firebase Functions.
///
/// Firebase FunctionsのFunctionを指定するためのクラス。
class Fuctions {
  Fuctions();

  static final _regExp = RegExp(
    r"m.deploy\([\s\S]*?exports,[\s\S]*?\[(?<regions>[^\]]*?)\],[\s\S]*?\[(?<functions>[^\]]*?)\],?[\s\S]*\);",
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

  /// List of Regions.
  ///
  /// Regionの一覧。
  List<String> get regions => _regions;
  late List<String> _regions;

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
    _regions = region
            .namedGroup("regions")
            ?.split(",")
            .map((e) => e.trim().trimString('"').trimString("'"))
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
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
  [${regions.map((e) => '"$e"').join(", ")}],
  [
${functions.map((e) {
      if (e.startsWith("new ")) {
        return "    $e,";
      } else {
        return "    m.Functions.$e,";
      }
    }).join("\n")}
  ],
);""");
    final gradle = File("firebase/functions/src/index.ts");
    await gradle.writeAsString(_rawData);
  }
}
