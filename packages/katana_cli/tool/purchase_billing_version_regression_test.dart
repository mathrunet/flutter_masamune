import "dart:io";

import "package:katana_cli/action/purchase/purchase.dart";
import "package:katana_cli/config.dart";
import "package:xml/xml.dart";

void main() {
  for (final existingValue in <String?>[null, "7.0.0", "8.0.0"]) {
    final document = XmlDocument.parse('''
<manifest xmlns:android="http://schemas.android.com/apk/res/android" xmlns:tools="http://schemas.android.com/tools">
  <application>
    <meta-data android:name="unrelated" android:value="keep" />
    ${existingValue == null ? "" : '<meta-data android:name="com.google.android.play.billingclient.version" android:value="$existingValue" />'}
  </application>
</manifest>
''');
    final application = document.findAllElements("application").single;

    ensureAndroidBillingVersionMetadata(application);
    final once = document.toXmlString();
    ensureAndroidBillingVersionMetadata(application);
    final twice = document.toXmlString();

    if (once != twice) {
      throw StateError("Billing metadata update is not idempotent.");
    }
    final billingMetadata = application.findElements("meta-data").where(
          (element) =>
              element.getAttribute("android:name") ==
              "com.google.android.play.billingclient.version",
        );
    if (billingMetadata.length != 1 ||
        billingMetadata.single.getAttribute("android:value") !=
            Config.androidBillingVersion ||
        billingMetadata.single.getAttribute("tools:replace") !=
            "android:value") {
      throw StateError(
          "Billing metadata was not set to the configured version.");
    }
    if (application
            .findElements("meta-data")
            .first
            .getAttribute("android:value") !=
        "keep") {
      throw StateError("Unrelated metadata was changed.");
    }
  }
  stdout.writeln("Android billing metadata checks passed.");
}
