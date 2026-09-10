// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:masamune_firebase_app_check/masamune_firebase_app_check.dart";

void main() {
  group("FirebaseAppCheckMasamuneAdapter", () {
    test("keeps the configured reCAPTCHA v3 provider", () {
      final provider = ReCaptchaV3Provider("recaptcha-v3-site-key");
      final adapter = FirebaseAppCheckMasamuneAdapter(
        webProvider: provider,
      );

      expect(adapter.webProvider, same(provider));
      expect(adapter.webProvider, isA<WebProvider>());
    });

    test("accepts the reCAPTCHA Enterprise provider", () {
      final provider = ReCaptchaEnterpriseProvider("enterprise-site-key");
      final adapter = FirebaseAppCheckMasamuneAdapter(
        webProvider: provider,
      );

      expect(adapter.webProvider, same(provider));
    });

    test("accepts the Web debug provider", () {
      final provider = WebDebugProvider(debugToken: "debug-token");
      final adapter = FirebaseAppCheckMasamuneAdapter(
        webProvider: provider,
      );

      expect(adapter.webProvider, same(provider));
    });
  });
}
