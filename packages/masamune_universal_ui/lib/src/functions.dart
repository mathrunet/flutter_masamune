part of masamune_universal_ui;

/// Open a new external [url].
///
/// 新しい外部[url]を開きます。
Future<void> openURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw Exception("Could not Launch $url");
  }
}
