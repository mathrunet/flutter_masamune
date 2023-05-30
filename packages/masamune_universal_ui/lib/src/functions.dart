part of masamune_universal_ui;

/// Open a new external [url].
///
/// In case of Web, setting [openSelfWindowOnWeb] to `true` will open the window in its own window (tab).
///
/// 新しい外部[url]を開きます。
///
/// Webの場合[openSelfWindowOnWeb]を`true`にすると自身のウインドウ（タブ）で開きます。
Future<void> openURL(
  String url, {
  bool openSelfWindowOnWeb = false,
}) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(
      url,
      webOnlyWindowName: kIsWeb && openSelfWindowOnWeb ? "_self" : null,
    );
  } else {
    throw Exception("Could not Launch $url");
  }
}
