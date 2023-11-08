part of '/katana_theme.dart';

/// Get one at random from the major MaterialColor.
///
/// Colors specified in [ignoreColors] are excluded.
///
/// Get a random color based on the value specified in [seed].
///
/// 主要なMaterialColorからランダムで一つ取得します。
///
/// [ignoreColors]に指定した色は除外されます。
///
/// [seed]に指定した値を元にランダムな色を取得します。
MaterialColor generateRandomMaterialColor({
  List<Color>? ignoreColors,
  int? seed,
}) {
  ignoreColors ??= [];
  const colors = [
    Colors.pink,
    Colors.red,
    Colors.deepOrange,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.blue,
    Colors.indigo,
    Colors.blue,
    Colors.purple,
    Colors.blueGrey,
    Colors.brown,
  ];
  return colors
          .where((element) => !ignoreColors.contains(element))
          .toList()
          .getRandom(seed) ??
      Colors.red;
}
