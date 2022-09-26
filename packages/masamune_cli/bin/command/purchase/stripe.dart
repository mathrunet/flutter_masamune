part of masamune_cli;

class PurchaseStripeCliCommand extends CliCommand {
  const PurchaseStripeCliCommand();

  @override
  String get description =>
      "masamune.yamlや`firebase_options.dart`を元にStripeの初期設定を行います。予めStripeのプロジェクトを作成し`APIKey`と`APISecret`を取得しておくのと`masamune firebase init`のコマンドを実行しておくこと、firebaseを`Blazeプラン`にしておくことが必要です。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final command = bin.get("firebase", "firebase");
    final purchase = yaml.getAsMap("purchase");
    final stripe = purchase.getAsMap("stripe");
    final options = firebaseOptions();
    if (options == null) {
      print(
        "firebase_options.dart is not found. Please run `masamune firebase init`",
      );
      return;
    }

    final projectId = options.get("projectId", "");
    if (projectId.isEmpty) {
      print("Project ID from firebase_options.dart could not be obtained.");
      return;
    }
    final apiSecret = stripe.get("api_secret", "");
    if (apiSecret.isEmpty) {
      print("purchase/stripe/api_secret is invalid.");
      return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("TODO_REPLACE_FIREBASE_ID", projectId);
      text = text.replaceAll(
        "// TODO_STRIPE_SERVER",
        "// [stripe]\r\n    stripe: \"./functions/stripe/stripe\",\r\n    stripe_webhook: \"./functions/stripe/stripe_webhook\",\r\n",
      );
      File(file.path).writeAsStringSync(text);
    });
    final resultKeys = await Process.start(
      command,
      [
        "functions:config:set",
        "purchase.stripe.subscription_path=subscription",
        "purchase.stripe.expired_path=expired",
        "purchase.stripe.user_path=user",
        "purchase.stripe.api_key=$apiSecret",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    await resultKeys.print();
    final endpointsRes = await Api.get(
      "https://api.stripe.com/v1/webhook_endpoints",
      headers: {
        "Authorization": "Basic ${base64Encode(utf8.encode("$apiSecret:"))}"
      },
    );
    if (endpointsRes.statusCode != 200) {
      print("Api secret is invalid.");
      return;
    }
    final endpoints = jsonDecode(endpointsRes.body)["data"] as List;
    final encodedApiSecret = base64Encode(utf8.encode("$apiSecret:"));
    if (endpoints.isNotEmpty) {
      for (final endpoint in endpoints) {
        final data = endpoint as Map<String, dynamic>;
        final res = await Api.delete(
          "https://api.stripe.com/v1/webhook_endpoints/${data["id"]}",
          headers: {"Authorization": "Basic $encodedApiSecret"},
        );
        print(res.body);
      }
    }
    final stripeRes = await Api.post(
      "https://api.stripe.com/v1/webhook_endpoints",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Basic $encodedApiSecret"
      },
      body: formatQueryParamater({
        "url":
            "https://asia-northeast1-$projectId.cloudfunctions.net/stripe_webhook",
        "description": "",
        "enabled_events": [
          "customer.subscription.trial_will_end",
          "customer.subscription.deleted",
          "customer.subscription.created",
          "customer.subscription.updated",
        ],
        "connect": "false",
      }),
    );
    print(stripeRes.body);
    final stripeResMap = jsonDecode(stripeRes.body) as Map<String, dynamic>;
    final resultHooks = await Process.start(
      command,
      [
        "functions:config:set",
        "purchase.stripe.webhook_secret=${stripeResMap["secret"]}",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    await resultHooks.print();
    applyFunctionsTemplate();
    final resultHooksDeploy = await Process.start(
      command,
      [
        "deploy",
        "--only",
        "functions",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    await resultHooksDeploy.print();
  }
}
