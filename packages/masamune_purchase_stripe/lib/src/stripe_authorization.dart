part of masamune_purchase_stripe;

class StripeAuthorization extends ChangeNotifier {
  StripeAuthorization({required this.userId});

  final String userId;

  static Completer<void>? _completer;

  Future<void> authorization({
    required double priceAmount,
    Locale locale = const Locale("en", "US"),
    bool online = true,
    required void Function(
      Widget webView,
      VoidCallback onClosed,
    ) builder,
    VoidCallback? onClosed,
    String? emailTitleOnRequired3DSecure,
    String? emailContentOnRequired3DSecure,
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    Completer<void>? internalCompleter = Completer<void>();
    try {
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;
      final callbackHost = StripePurchaseMasamuneAdapter.primary.callbackHost
          .toString()
          .trimQuery()
          .trimString("/");

      final response = await functionsAdapter.stipe(
        action: StripeAuthorizationAction(
          userId: userId,
          priceAmount: priceAmount,
          online: online,
          currency: StripePurchaseMasamuneAdapter.primary.currency,
          email: StripeMail(
            from: StripePurchaseMasamuneAdapter.primary.supportEmail,
            title: emailTitleOnRequired3DSecure ??
                StripePurchaseMasamuneAdapter
                    .primary.threeDSecureOptions.emailTitle,
            content: emailContentOnRequired3DSecure ??
                StripePurchaseMasamuneAdapter
                    .primary.threeDSecureOptions.emailContent,
          ),
          returnUrl: online
              ? Uri.parse("$callbackHost/authorization/finished")
              : Uri.parse(
                  "${functionsAdapter.endpoint}/${StripePurchaseMasamuneAdapter.primary.threeDSecureOptions.redirectFunctionPath}"),
        ),
      );

      if (response == null || response.authorizedId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      bool authenticated = true;
      onCompleted() {
        if (authenticated) {
          internalCompleter?.complete();
          internalCompleter = null;
        } else {
          internalCompleter
              ?.completeError(Exception("3D Secure authentication failed."));
          internalCompleter = null;
        }
      }

      if (response.nextActionUrl != null) {
        final webView = _StripeWebview(
          response.nextActionUrl!,
          shouldOverrideUrlLoading: (controller, url) {
            final path = url.trimQuery().replaceAll(callbackHost, "");
            switch (path) {
              case "/authorization/finished":
                onClosed?.call();
                onCompleted.call();
                return NavigationActionPolicy.CANCEL;
            }
            final uri = Uri.parse(url);
            if (uri.host == "hooks.stripe.com" &&
                uri.queryParameters.containsKey("authenticated")) {
              authenticated = uri.queryParameters["authenticated"] == "true";
            }
            return NavigationActionPolicy.ALLOW;
          },
          onCloseWindow: (controller) {
            onCompleted();
          },
        );
        builder.call(webView, onCompleted);
        await internalCompleter!.future;
      }
      final responseConfirm = await functionsAdapter.stipe(
        action: StripeConfirmAuthorizationAction(
          authorizedId: response.authorizedId,
        ),
      );
      if (responseConfirm == null) {
        throw Exception("Response is invalid.");
      }
      _completer?.complete();
      _completer = null;
      internalCompleter?.complete();
      internalCompleter = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      internalCompleter?.completeError(e);
      internalCompleter = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
      internalCompleter?.complete();
      internalCompleter = null;
    }
  }
}
