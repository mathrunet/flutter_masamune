part of masamune_cli;

class PurchaseMobileCliCommand extends CliCommand {
  const PurchaseMobileCliCommand();

  @override
  String get description =>
      "masamune.yamlを元にストア課金のサーバー検証やサブスクリプションの更新処理をデプロイします。事前に https://www.notion.so/Android-1d4a60948a1446d7a82c010d96417a3d の設定を済ませておくこと、firebaseを`Blaze`プランにしておくことが必要です。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final purchase = yaml["purchase"] as YamlMap;
    final mobile = purchase["mobile"] as YamlMap;
    final command = bin["firebase"] as String?;
    final json = File("android/app/google-services.json");
    if (!json.existsSync()) {
      print("google-services.json could not be found in android/app.");
      return;
    }
    final plist = File("ios/Runner/GoogleService-Info.plist");
    if (!plist.existsSync()) {
      print("GoogleService-Info.plist could not be found in ios/Runner.");
      return;
    }
    final text = json.readAsStringSync();
    final data = jsonDecode(text) as Map;
    final projectInfo = data["project_info"] as Map;
    final projectId = projectInfo["project_id"] as String;
    final clientId = mobile["client_id"] as String?;
    final clientSecret = mobile["client_secret"] as String?;
    final sharedSecret = mobile["shared_secret"] as String?;
    if (clientId.isEmpty || clientSecret.isEmpty || sharedSecret.isEmpty) {
      print(
          "ClientID and ClientSecret are not specified. Set up and obtain the OAuth client and OAuth consent screen for GoogleCloutPlatform with redirect url: https://asia-northeast1-$projectId.cloudfunctions.net/android_token.");
      return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("// TODO_MOBILE_PURCHASING_SERVER",
          "// [InAppPurchase]\r\n    android_auth_code: \"./functions/purchase/android_auth_code\",\r\n    android_token: \"./functions/purchase/android_token\",\r\n    consumable_verify_android: \"./functions/purchase/consumable_verify_android\",\r\n    consumable_verify_ios: \"./functions/purchase/consumable_verify_ios\",\r\n    nonconsumable_verify_android: \"./functions/purchase/nonconsumable_verify_android\",\r\n    nonconsumable_verify_ios: \"./functions/purchase/nonconsumable_verify_ios\",\r\n    subscription_verify_android: \"./functions/purchase/subscription_verify_android\",\r\n    subscription_verify_ios: \"./functions/purchase/subscription_verify_ios\",\r\n    subscription_schedule: \"./functions/purchase/subscription_schedule\",\r\n    purchase_webhook_android: \"./functions/purchase/purchase_webhook_android\",\r\n    purchase_webhook_ios: \"./functions/purchase/purchase_webhook_ios\",\r\n");
      text = text.replaceAll("// TODO_REPLACE_BILLING_APPLY_PLUGIN", """
// ToDo: Comment out using In App Purchase
    // [InAppPurchase]
    implementation 'com.android.billingclient:billing:3.0.2'
            """);
      text = text.replaceAllMapped(
          RegExp(r"// ([A-Z0-9]+) /\* StoreKit.framework"),
          (m) => "${m.group(1)} /* StoreKit.framework");
      File(file.path).writeAsStringSync(text);
    });
    applyFunctionsTemplate();
    final resultFirst = await Process.run(
      command!,
      [
        "functions:config:set",
        "purchase.android.client_id=$clientId",
        "purchase.android.client_secret=$clientSecret",
        "purchase.android.redirect_uri=https://asia-northeast1-$projectId.cloudfunctions.net/android_token",
        "purchase.ios.shared_secret=$sharedSecret",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    print(resultFirst.stdout);
    final resultFirstDeploy = await Process.run(
      command,
      [
        "deploy",
        "--only",
        "functions",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    print(resultFirstDeploy.stdout);
    final refreshToken = mobile["refresh_token"] as String?;
    if (refreshToken.isEmpty) {
      print(
          "RefreshToken are not specified. Please access to https://asia-northeast1-$projectId.cloudfunctions.net/android_auth_code?id=$clientId");
      return;
    }
    final resultLast = await Process.run(
      command,
      [
        "functions:config:set",
        "purchase.android.client_id=$clientId",
        "purchase.android.client_secret=$clientSecret",
        "purchase.android.refresh_token=$refreshToken",
        "purchase.android.redirect_uri=https://asia-northeast1-$projectId.cloudfunctions.net/android_token",
        "purchase.ios.shared_secret=$sharedSecret",
        "purchase.expiry_date_key=expiredTime",
        "purchase.token_key=token",
        "purchase.user_id_key=user",
        "purchase.order_id_key=orderId",
        "purchase.package_name_key=packageName",
        "purchase.product_id_key=productId",
        "purchase.expired_key=expired",
        "purchase.purchase_id_key=purchaseId",
        "purchase.platform_key=platform",
        "purchase.renew_hour_duration=2",
        "purchase.subscription_path=subscription",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    print(resultLast.stdout);
    final resultLastDeploy = await Process.run(
      command,
      [
        "deploy",
        "--only",
        "functions",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    print(resultLastDeploy.stdout);
  }
}
