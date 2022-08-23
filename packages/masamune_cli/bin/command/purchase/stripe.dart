part of masamune_cli;

class PurchaseStripeCliCommand extends CliCommand {
  const PurchaseStripeCliCommand();

  @override
  String get description =>
      "masamune.yamlや`google-services.json`や`GoogleService-Info.plist`を元にStripeの初期設定を行います。予めStripeのプロジェクトを作成し`APIKey`と`APISecret`を取得しておくのと`firebase`のコマンドを実行しておくこと、firebaseを`Blazeプラン`にしておくことが必要です。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final command = bin["firebase"] as String?;
    final purchase = yaml["purchase"] as YamlMap;
    final stripe = purchase["stripe"] as YamlMap;
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
    if (projectId.isEmpty) {
      print("Project ID could not be obtained.");
      return;
    }
    final apiSecret = stripe["api_secret"] as String?;
    if (apiSecret.isEmpty) {
      print("Api secret is invalid.");
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
      command!,
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
    final endpointsRes = await http.get(
      Uri.parse("https://api.stripe.com/v1/webhook_endpoints"),
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
        final res = await http.delete(
          Uri.parse(
            "https://api.stripe.com/v1/webhook_endpoints/${data["id"]}",
          ),
          headers: {"Authorization": "Basic $encodedApiSecret"},
        );
        print(res.body);
      }
    }
    final stripeRes = await http.post(
      Uri.parse("https://api.stripe.com/v1/webhook_endpoints"),
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
