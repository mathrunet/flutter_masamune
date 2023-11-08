part of "others.dart";

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

  NavigationActionPolicy get _navigationActionPolicy {
    switch (this) {
      case StripeNavigationActionPolicy.cancel:
        return NavigationActionPolicy.CANCEL;
      case StripeNavigationActionPolicy.allow:
        return NavigationActionPolicy.ALLOW;
    }
  }
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
  /// Webviewを閉じた際のコールバック
  final void Function()? onCloseWindow;

  @override
  State<StatefulWidget> createState() => _StripeWebviewState();
}

class _StripeWebviewState extends State<StripeWebview> {
  InAppWebViewController? _webViewController;
  double _progress = 0.0;
  late final PullToRefreshController pullToRefreshController;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Theme.of(context).colorScheme.primary,
      ),
      onRefresh: () async {
        if (UniversalPlatform.isAndroid) {
          _webViewController?.reload();
        } else if (UniversalPlatform.isIOS) {
          _webViewController?.loadUrl(
            urlRequest: URLRequest(url: await _webViewController?.getUrl()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColoredBox(color: Theme.of(context).colorScheme.background),
        InAppWebView(
          initialUrlRequest: URLRequest(url: widget.endpoint),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
            ),
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            ),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
            ),
          ),
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onCloseWindow: (controller) => widget.onCloseWindow?.call(),
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return widget.shouldOverrideUrlLoading
                    ?.call(
                      navigationAction.request.url!.toString(),
                    )
                    ._navigationActionPolicy ??
                NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            pullToRefreshController.endRefreshing();
            setState(() {
              _progress = 1.0;
            });
          },
          onLoadError: (controller, url, code, message) {
            pullToRefreshController.endRefreshing();
            setState(() {
              _progress = 1.0;
            });
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController.endRefreshing();
            }
            setState(() {
              _progress = progress / 100.0;
            });
          },
        ),
        if (_progress < 1.0) ...[
          LinearProgressIndicator(value: _progress),
        ]
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_webViewController == null) {
      return;
    }
    widget.onCloseWindow?.call();
  }
}
