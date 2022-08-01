part of masamune_purchase_stripe;

class _StripeConnectWebview extends StatefulWidget {
  const _StripeConnectWebview(
    this.endpoint, {
    this.shouldOverrideUrlLoading,
    this.onCloseWindow,
  });
  final Uri endpoint;
  final NavigationActionPolicy Function(
    InAppWebViewController controller,
    String url,
  )? shouldOverrideUrlLoading;
  final void Function(InAppWebViewController controller)? onCloseWindow;

  @override
  State<StatefulWidget> createState() => _StripeConnectWebviewState();
}

class _StripeConnectWebviewState extends State<_StripeConnectWebview> {
  InAppWebViewController? _webViewController;
  double _progress = 0.0;
  late final PullToRefreshController pullToRefreshController;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Config.isAndroid) {
          _webViewController?.reload();
        } else if (Config.isIOS) {
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
        ColoredBox(color: context.theme.backgroundColor),
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
          onCloseWindow: widget.onCloseWindow,
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return widget.shouldOverrideUrlLoading?.call(
                  controller,
                  navigationAction.request.url!.toString(),
                ) ??
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
    widget.onCloseWindow?.call(_webViewController!);
  }
}
