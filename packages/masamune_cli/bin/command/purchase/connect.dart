part of masamune_cli;

class PurchaseConnectCliCommand extends CliCommand {
  const PurchaseConnectCliCommand();

  @override
  String get description =>
      "masamune.yamlや`google-services.json`や`GoogleService-Info.plist`を元にStripeConnectの初期設定を行います。予めStripeのプロジェクトを作成し`APIKey`と`APISecret`を取得しておくのと`firebase`のコマンドを実行しておくこと、firebaseを`Blazeプラン`にしておくことが必要です。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final purchase = yaml["purchase"] as YamlMap;
    final stripe = purchase["stripe"] as YamlMap;
    final connect = purchase["connect"] as YamlMap;
    final command = bin["firebase"] as String?;
    final email = yaml["email"] as YamlMap;
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
    final emailType = connect["email_type"] as String? ?? "gmail";
    final domain = connect["domain"] as String?;
    if (apiSecret.isEmpty) {
      print("Api secret is invalid.");
      return;
    }
    if (domain.isEmpty) {
      print("Domain is invalid.");
      return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("TODO_REPLACE_FIREBASE_ID", projectId);
      File(file.path).writeAsStringSync(text);
    });
    switch (emailType) {
      case "gmail":
        final gmail = email["gmail"] as YamlMap;
        final id = gmail["id"] as String?;
        final password = gmail["password"] as String?;
        if (id.isEmpty || password.isEmpty) {
          print("Gmail information is invalid.");
          return;
        }
        final resultMail = await Process.start(
          command!,
          [
            "functions:config:set",
            "mail.gmail.id=$id",
            "mail.gmail.password=$password",
          ],
          runInShell: true,
          workingDirectory: "${Directory.current.path}/firebase",
        );
        await resultMail.print();
        break;
      case "sendgrid":
        final sendgrid = email["sendgrid"] as YamlMap;
        final sendgridApiKey = sendgrid["api_key"] as String?;
        if (sendgridApiKey.isEmpty) {
          print("Sendgrid information is invalid.");
          return;
        }
        final resultMail = await Process.start(
          command!,
          [
            "functions:config:set",
            "mail.sendgrid.api_key=$sendgridApiKey",
          ],
          runInShell: true,
          workingDirectory: "${Directory.current.path}/firebase",
        );
        await resultMail.print();
        break;
      default:
        print("Email type is invalid.");
        return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll(
        "// TODO_STRIPE_CONNECT_SERVER",
        "// [stripe]\r\n    stripe_connect: \"./functions/stripe/stripe_connect\",\r\n    stripe_webhook: \"./functions/stripe/stripe_webhook\",\r\n    stripe_connect_webhook: \"./functions/stripe/stripe_connect_webhook\",\r\n    stripe_secure_webhook: \"./functions/stripe/stripe_secure_webhook\",\r\n",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_IOS_STRIPE_CONNECT -->",
        """
<key>com.apple.developer.associated-domains</key>
	<array>
		<string>applinks:$domain</string>
	</array>
            """,
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_ANDROID_STRIPE_CONNECT -->",
        """
<intent-filter>
                <action android:name="android.intent.action.VIEW"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <category android:name="android.intent.category.BROWSABLE"/>
                <data
                    android:host="$domain"
                    android:scheme="https"/>
            </intent-filter>
            """,
      );
      File(file.path).writeAsStringSync(text);
    });
    final resultKeys = await Process.start(
      command,
      [
        "functions:config:set",
        "purchase.stripe.capability_key=capability",
        "purchase.stripe.account_key=account",
        "purchase.stripe.customer_key=customer",
        "purchase.stripe.user_path=stripe/connect/user",
        "purchase.stripe.payment_path=payment",
        "purchase.stripe.purchase_path=purchase",
        "purchase.stripe.email_provider=$emailType",
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
          "checkout.session.completed",
          "customer.updated",
          "payment_intent.amount_capturable_updated",
          "payment_intent.payment_failed",
          "payment_intent.requires_action",
          "payment_intent.succeeded",
          "payment_method.updated",
          "payment_method.detached",
        ],
        "connect": "false",
      }),
    );
    print(stripeRes.body);
    final connectRes = await http.post(
      Uri.parse("https://api.stripe.com/v1/webhook_endpoints"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Basic $encodedApiSecret"
      },
      body: formatQueryParamater({
        "url":
            "https://asia-northeast1-$projectId.cloudfunctions.net/stripe_connect_webhook",
        "description": "",
        "enabled_events": ["account.updated"],
        "connect": "true",
      }),
    );
    print(connectRes.body);
    final stripeResMap = jsonDecode(stripeRes.body) as Map<String, dynamic>;
    final connectResMap = jsonDecode(connectRes.body) as Map<String, dynamic>;
    final resultHooks = await Process.start(
      command,
      [
        "functions:config:set",
        "purchase.stripe.webhook_secret=${stripeResMap["secret"]}",
        "purchase.stripe.webhook_connect_secret=${connectResMap["secret"]}",
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
    final resultHostingDeploy = await Process.start(
      command,
      [
        "deploy",
        "--only",
        "hosting",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    await resultHostingDeploy.print();
  }
}
