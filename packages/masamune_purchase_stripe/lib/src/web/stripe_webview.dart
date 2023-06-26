part of masamune_purchase_stripe.web;

/// Navigation action policy definition in WebView.
///
/// WebViewでのナビゲーションアクションポリシー定義。
enum StripeNavigationActionPolicy {
  /// Cancellation.
  ///
  /// キャンセル。
  cancel,

  /// Permission for next action.
  ///
  /// 次のアクションへの許可。
  allow;
}

/// WebView for using Stripe's web configuration screen.
///
/// Open the [endpoint] URL.
///
/// Not available on the web platform.
///
/// ストライプのWeb設定画面を利用するためのWebView。
///
/// [endpoint]のURLを開きます。
///
/// webのプラットフォームでは利用できません。
class StripeWebview extends StatefulWidget {
  /// WebView for using Stripe's web configuration screen.
  ///
  /// Open the [endpoint] URL.
  ///
  /// Not available on the web platform.
  ///
  /// ストライプのWeb設定画面を利用するためのWebView。
  ///
  /// [endpoint]のURLを開きます。
  ///
  /// webのプラットフォームでは利用できません。
  const StripeWebview(
    this.endpoint, {
    super.key,
    this.shouldOverrideUrlLoading,
    this.onCloseWindow,
  });

  /// URL to open Webview.
  ///
  /// Webviewを開くURL。
  final Uri endpoint;

  /// Callback to specify whether to load or not load for a given [url] before page transition.
  ///
  /// ページ遷移する前、与えられた[url]に対して読み込むか読み込まないかを指定するためのコールバック。
  final StripeNavigationActionPolicy Function(
    String url,
  )? shouldOverrideUrlLoading;

  /// Callback when the webview is closed.
  ///
  /// Webviewを閉じた際のコールバック。
  final void Function()? onCloseWindow;

  @override
  State<StatefulWidget> createState() => _StripeWebviewState();
}

class _StripeWebviewState extends State<StripeWebview> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColoredBox(color: Theme.of(context).colorScheme.error),
        Positioned.fill(
          child: Center(
            child: Text(
              "WebView display is not supported on this platform. Use [endpoint] to transition the page itself.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onError),
            ),
          ),
        ),
      ],
    );
  }
}
