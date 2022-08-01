part of katana_flutter;

/// Gets a random material design color (the color available in white text color).
///
/// If you specify [ignoreColors], you can exclude the color.
///
/// [seed] can be specified.
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

/// Open a new external [url].
Future<void> openURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    print("Could not Launch $url");
  }
}

/// Share [text] and [files] with external applications.
///
/// You can specify the subject by entering [title].
Future<void> share({
  String? text,
  String? title,
  List<String> files = const [],
}) async {
  if (files.isNotEmpty) {
    await Share.shareFiles(files, subject: title, text: text);
  } else {
    assert(text.isNotEmpty, "Text is empty.");
    await Share.share(text ?? "", subject: title);
  }
}
