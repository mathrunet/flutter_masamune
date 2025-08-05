part of "/masamune_universal_ui.dart";

/// Open a new external [url].
///
/// In case of Web, setting [openSelfWindowOnWeb] to `true` will open the window in its own window (tab).
///
/// 新しい外部[url]を開きます。
///
/// Webの場合[openSelfWindowOnWeb]を`true`にすると自身のウインドウ（タブ）で開きます。
Future<void> openURL(
  String url, {
  LaunchMode mode = LaunchMode.platformDefault,
  bool openSelfWindowOnWeb = false,
  Map<String, String>? headers,
}) async {
  // canLaunchUrlStringが動かなくなった
  // if (await canLaunchUrlString(url)) {
  await launchUrlString(
    url,
    mode: mode,
    webOnlyWindowName: kIsWeb && openSelfWindowOnWeb ? "_self" : null,
    webViewConfiguration: WebViewConfiguration(headers: headers ?? {}),
  );
  // } else {
  //   throw Exception("Could not Launch $url");
  // }
}
