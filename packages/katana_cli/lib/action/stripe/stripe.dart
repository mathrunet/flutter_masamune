// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use Stripe.
///
/// Stripeを利用するためのモジュールを追加します。
class StripeCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use Stripe.
  ///
  /// Stripeを利用するためのモジュールを追加します。
  const StripeCliAction();

  @override
  String get description =>
      "Add a module to use Stripe. Stripeを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("stripe");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final firebaseCommand = bin.get("firebase", "firebase");
    final stripe = context.yaml.getAsMap("stripe");
    final gmail = context.yaml.getAsMap("gmail");
    final sendgrid = context.yaml.getAsMap("sendgrid");
    final secretKey = stripe.get("secret_key", "");
    final enableConnect = stripe.get("enable_connect", false);
    final urlScheme =
        stripe.get("url_scheme", "").replaceAll(RegExp(r"://$"), "");
    final emailProvider = stripe.get("email_provider", "sendgrid");
    final threeDSecureRidirectPages =
        stripe.getAsMap("three_d_secure_redirect_page");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final function = firebase.getAsMap("functions");
    final region = function.get("region", "");
    if (secretKey.isEmpty) {
      error("[stripe]->[secret_key] is empty.");
      return;
    }
    if (urlScheme.isEmpty) {
      error("[stripe]->[url_scheme] is empty.");
      return;
    }
    if (emailProvider.isEmpty) {
      error("[stripe]->[email_provider] is empty.");
    }
    switch (emailProvider) {
      case "gmail":
        final enableGmail = gmail.get("enable", false);
        final gmailUserId = gmail.get("user_id", "");
        final gmailUserPassword = gmail.get("user_password", "");
        if (!enableGmail) {
          error(
            "If [stripe]->[email_provider] is `gmail`, please include [gmail]->[enable].",
          );
          return;
        }
        if (gmailUserId.isEmpty) {
          error(
            "If [stripe]->[email_provider] is `gmail`, please include [gmail]->[user_id].",
          );
          return;
        }
        if (gmailUserPassword.isEmpty) {
          error(
            "If [stripe]->[email_provider] is `gmail`, please include [gmail]->[user_password].",
          );
          return;
        }
        break;
      default:
        final enalbeSendGrid = sendgrid.get("enable", false);
        final sendGridApiKey = sendgrid.get("api_key", "");
        if (!enalbeSendGrid) {
          error(
            "If [stripe]->[email_provider] is `sendgrid`, please include [sendgrid]->[enable].",
          );
          return;
        }
        if (sendGridApiKey.isEmpty) {
          error(
            "If [stripe]->[email_provider] is `sendgrid`, please include [sendgrid]->[api_key].",
          );
          return;
        }
        break;
    }
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    if (region.isEmpty) {
      error(
        "The item [firebase]->[functions]->[region] is missing. Please provide the region for the configuration.",
      );
      return;
    }
    final firebaseDir = Directory("firebase");
    if (!firebaseDir.existsSync()) {
      error(
        "The directory `firebase` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    final functionsDir = Directory("firebase/functions");
    if (!functionsDir.existsSync()) {
      error(
        "The directory `firebase/functions` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    final hostingDir = Directory("firebase/hosting");
    if (!hostingDir.existsSync()) {
      error(
        "The directory `firebase/hosting` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_purchase_stripe",
        "katana_functions_firebase",
      ],
    );
    label("Edit AndroidManifest.xml.");
    final file = File("android/app/src/main/AndroidManifest.xml");
    if (!file.existsSync()) {
      throw Exception(
        "AndroidManifest does not exist in `android/app/src/main/AndroidManifest.xml`. Do `katana create` to complete the initial setup of the project.",
      );
    }
    final androidDocument = XmlDocument.parse(await file.readAsString());
    final activity = androidDocument.findAllElements("activity");
    if (activity.isEmpty) {
      throw Exception(
        "The structure of AndroidManifest.xml is broken. Do `katana create` to complete the initial setup of the project.",
      );
    }
    if (!activity.first.children.any((p0) =>
        p0 is XmlElement &&
        p0.name.toString() == "intent-filter" &&
        (p0.findElements("action").firstOrNull?.attributes.any((item) =>
                item.name.toString() == "android:name" &&
                item.value == "android.intent.action.VIEW") ??
            false) &&
        (p0.findElements("data").firstOrNull?.attributes.any((item) =>
                item.name.toString() == "android:scheme" &&
                item.value == urlScheme) ??
            false))) {
      activity.first.children.add(
        XmlElement(
          XmlName("intent-filter"),
          [],
          [
            XmlElement(
              XmlName("action"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "android.intent.action.VIEW",
                ),
              ],
              [],
            ),
            XmlElement(
              XmlName("category"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "android.intent.category.DEFAULT",
                ),
              ],
              [],
            ),
            XmlElement(
              XmlName("category"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "android.intent.category.BROWSABLE",
                ),
              ],
              [],
            ),
            XmlElement(
              XmlName("data"),
              [
                XmlAttribute(
                  XmlName("android:scheme"),
                  urlScheme,
                ),
              ],
              [],
            ),
          ],
        ),
      );
    }
    await file.writeAsString(
      androidDocument.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
    );
    label("Edit Info.plist.");
    final plist = File("ios/Runner/Info.plist");
    final iosDocument = XmlDocument.parse(await plist.readAsString());
    final dict = iosDocument.findAllElements("dict").firstOrNull;
    if (dict == null) {
      throw Exception(
        "Could not find `dict` element in `ios/Runner/Info.plist`. File is corrupt.",
      );
    }
    final bundleUrlTypes = dict.children.firstWhereOrNull((p0) {
      return p0 is XmlElement &&
          p0.name.toString() == "key" &&
          p0.innerText == "CFBundleURLTypes";
    });
    if (bundleUrlTypes == null) {
      dict.children.addAll(
        [
          XmlElement(
            XmlName("key"),
            [],
            [
              XmlText("CFBundleURLTypes"),
            ],
          ),
          XmlElement(
            XmlName("array"),
            [],
            [
              XmlElement(
                XmlName("dict"),
                [],
                [
                  XmlElement(
                    XmlName("key"),
                    [],
                    [
                      XmlText("CFBundleTypeRole"),
                    ],
                  ),
                  XmlElement(
                    XmlName("string"),
                    [],
                    [
                      XmlText("Editor"),
                    ],
                  ),
                  XmlElement(
                    XmlName("key"),
                    [],
                    [
                      XmlText("CFBundleURLSchemes"),
                    ],
                  ),
                  XmlElement(
                    XmlName("array"),
                    [],
                    [
                      XmlElement(
                        XmlName("string"),
                        [],
                        [
                          XmlText(urlScheme),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      final urlSchemeArray = bundleUrlTypes.nextElementSibling;
      if (urlSchemeArray == null) {
        throw Exception(
          "Could not find `CFBundleURLTypes` value element in `ios/Runner/Info.plist`. File is corrupt.",
        );
      }
      if (!urlSchemeArray.children.any(
        (p1) =>
            p1 is XmlElement &&
            p1.children.any((p2) =>
                p2 is XmlElement &&
                p2.name.toString() == "array" &&
                p2.children.any((p3) =>
                    p3 is XmlElement &&
                    p3.name.toString() == "string" &&
                    p3.innerText == urlScheme)),
      )) {
        urlSchemeArray.children.add(
          XmlElement(
            XmlName("dict"),
            [],
            [
              XmlElement(
                XmlName("key"),
                [],
                [
                  XmlText("CFBundleTypeRole"),
                ],
              ),
              XmlElement(
                XmlName("string"),
                [],
                [
                  XmlText("Editor"),
                ],
              ),
              XmlElement(
                XmlName("key"),
                [],
                [
                  XmlText("CFBundleURLSchemes"),
                ],
              ),
              XmlElement(
                XmlName("array"),
                [],
                [
                  XmlElement(
                    XmlName("string"),
                    [],
                    [
                      XmlText(urlScheme),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }
    await plist.writeAsString(
      iosDocument.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
    );
    label("Configuration Webhooks.");
    String? webHookSecret;
    String? webHookConnectSecret;
    final encodedApiSecret = base64Encode(utf8.encode("$secretKey:"));
    final endpointsRes = await Api.get(
      "https://api.stripe.com/v1/webhook_endpoints",
      headers: {"Authorization": "Basic $encodedApiSecret"},
    );
    if (endpointsRes.statusCode != 200) {
      error("Api secret is invalid.");
      return;
    }
    final endpoints = jsonDecodeAsMap(endpointsRes.body).getAsList("data");
    if (endpoints.isNotEmpty) {
      for (final endpoint in endpoints) {
        final data = endpoint as DynamicMap;
        final id = data.get("id", "");
        if (id.isEmpty) {
          continue;
        }
        await Api.delete(
          "https://api.stripe.com/v1/webhook_endpoints/$id",
          headers: {"Authorization": "Basic $encodedApiSecret"},
        );
      }
    }
    final stripeRes = await Api.post(
      "https://api.stripe.com/v1/webhook_endpoints",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Basic $encodedApiSecret"
      },
      body: _formatQueryParamater({
        "url": "https://$region-$projectId.cloudfunctions.net/stripe_webhook",
        "description": "",
        "enabled_events": [
          "customer.subscription.trial_will_end",
          "customer.subscription.deleted",
          "customer.subscription.created",
          "customer.subscription.updated",
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
    final stripeResMap = jsonDecodeAsMap(stripeRes.body);
    webHookSecret = stripeResMap.get("secret", "");
    if (webHookSecret.isEmpty) {
      error(
          "Could not create webhook: https://$region-$projectId.cloudfunctions.net/stripe_webhook");
      return;
    }
    if (enableConnect) {
      final connectRes = await Api.post(
        "https://api.stripe.com/v1/webhook_endpoints",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Basic $encodedApiSecret"
        },
        body: _formatQueryParamater({
          "url":
              "https://$region-$projectId.cloudfunctions.net/stripe_webhook_connect",
          "description": "",
          "enabled_events": [
            "account.updated",
          ],
          "connect": "true",
        }),
      );
      final connectResMap = jsonDecodeAsMap(connectRes.body);
      webHookConnectSecret = connectResMap.get("secret", "");
      if (webHookConnectSecret.isEmpty) {
        error(
            "Could not create webhook: https://$region-$projectId.cloudfunctions.net/stripe_webhook_connect");
        return;
      }
    }
    label("Add firebase functions");
    final functions = Fuctions();
    await functions.load();
    if (!functions.functions.any((e) => e == "stripe()")) {
      functions.functions.add("stripe()");
    }
    if (!functions.functions.any((e) => e == "stripeWebhook()")) {
      functions.functions.add("stripeWebhook()");
    }
    if (!functions.functions.any((e) => e == "stripeWebhookSecure()")) {
      functions.functions.add("stripeWebhookSecure()");
    }
    if (enableConnect &&
        !functions.functions.any((e) => e == "stripeWebhookConnect()")) {
      functions.functions.add("stripeWebhookConnect()");
    }
    switch (emailProvider) {
      case "gmail":
        if (!functions.functions.any((e) => e == "gmail()")) {
          functions.functions.add("gmail()");
        }
        break;
      default:
        if (!functions.functions.any((e) => e == "sendGrid()")) {
          functions.functions.add("sendGrid()");
        }
        break;
    }
    await functions.save();
    await command(
      "Set firebase functions config.",
      [
        firebaseCommand,
        "functions:config:set",
        "purchase.stripe.secret_key=$secretKey",
        "purchase.stripe.email_provider=$emailProvider",
        "purchase.stripe.user_path=plugins/stripe/user",
        "purchase.stripe.payment_path=payment",
        "purchase.stripe.purchase_path=purchase",
        if (webHookSecret.isNotEmpty)
          "purchase.stripe.webhook_secret=$webHookSecret",
        if (enableConnect && webHookConnectSecret.isNotEmpty)
          "purchase.stripe.webhook_connect_secret=$webHookConnectSecret",
        if (emailProvider == "gmail") ...[
          "mail.gmail.id=${gmail.get("user_id", "")}",
          "mail.gmail.password=${gmail.get("user_password", "")}",
        ] else ...[
          "mail.sendgrid.api_key=${sendgrid.get("api_key", "")}",
        ]
      ],
      workingDirectory: "firebase",
    );
    await command(
      "Deploy firebase functions.",
      [
        firebaseCommand,
        "deploy",
        "--only",
        "functions",
      ],
      workingDirectory: "firebase",
    );
    for (final locale in threeDSecureRidirectPages.entries) {
      final value = locale.value as Map;
      final successUrl = value.get("success", "");
      final failureUrl = value.get("failure", "");
      if (successUrl.isEmpty) {
        error(
          "The item [stripe]->[three_d_secure_redirect_page]->[${locale.key}]->[success] is missing. Please provide the URL of the Success page.",
        );
        return;
      }
      if (failureUrl.isEmpty) {
        error(
          "The item [stripe]->[three_d_secure_redirect_page]->[${locale.key}]->[failure] is missing. Please provide the URL of the Failure page.",
        );
        return;
      }
      final successResponse = await Api.get(successUrl);
      if (successResponse.statusCode != 200) {
        error(
          "The URL of the Success page is invalid. Please provide the URL of the Success page.",
        );
        return;
      }
      final failureResponse = await Api.get(failureUrl);
      if (failureResponse.statusCode != 200) {
        error(
          "The URL of the Failure page is invalid. Please provide the URL of the Failure page.",
        );
        return;
      }
      final successContent = successResponse.body;
      final failureContent = failureResponse.body;
      final dir = Directory("firebase/hosting/${locale.key}/secure");
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final successFile =
          File("firebase/hosting/${locale.key}/secure/success.html");
      await successFile.writeAsString(successContent);
      final failureFile =
          File("firebase/hosting/${locale.key}/secure/failure.html");
      await failureFile.writeAsString(failureContent);
    }
    await command(
      "Deploy to Firebase Hosting.",
      [
        firebaseCommand,
        "deploy",
        "--only",
        "hosting",
      ],
      workingDirectory: "firebase",
    );
  }
}

String _formatQueryParamater(Map<String, dynamic> paramater) {
  final res = <String>[];
  for (final tmp in paramater.entries) {
    if (tmp.value is List) {
      for (final item in tmp.value) {
        res.add("${tmp.key}[]=${item.toString()}");
      }
    } else {
      res.add("${tmp.key}=${tmp.value.toString()}");
    }
  }
  return res.join("&");
}
