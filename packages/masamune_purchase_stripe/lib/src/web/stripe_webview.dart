part of masamune_purchase_stripe.web;

enum StripeNavigationActionPolicy {
  cancel,
  allow;
}

class StripeWebview extends StatefulWidget {
  const StripeWebview(
    this.endpoint, {
    super.key,
    this.shouldOverrideUrlLoading,
    this.onCloseWindow,
  });
  final Uri endpoint;
  final StripeNavigationActionPolicy Function(
    String url,
  )? shouldOverrideUrlLoading;
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
