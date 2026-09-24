import "dart:io";

import "package:katana_cli/action/purchase/purchase.dart";

const _handlers = [
  "consumableVerifyIOS",
  "nonconsumableVerifyIOS",
  "subscriptionVerifyIOS",
  "purchaseWebhookIOS",
  "consumableVerifyAndroid",
  "nonconsumableVerifyAndroid",
  "subscriptionVerifyAndroid",
  "purchaseWebhookAndroid",
];

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

Future<String> _applyInTemporaryProject(
  String original, {
  required bool enableAppStore,
  required bool enableGooglePlay,
  required String options,
  String? preservedCall,
}) async {
  final previousDirectory = Directory.current;
  final temporaryDirectory =
      await Directory.systemTemp.createTemp("katana-purchase-");
  try {
    Directory.current = temporaryDirectory;
    final index = File("cloudflare/src/index.ts");
    await index.parent.create(recursive: true);
    await index.writeAsString(original);
    _check(
      await applyPurchaseCloudflareFunctions(
        enableAppStore: enableAppStore,
        enableGooglePlay: enableGooglePlay,
        options: options,
      ),
      "Purchase handlers could not be applied",
    );
    final first = await index.readAsString();
    if (preservedCall != null) {
      _check(first.contains(preservedCall),
          "Existing purchase handler arguments were overwritten");
    }
    _check(
      await applyPurchaseCloudflareFunctions(
        enableAppStore: enableAppStore,
        enableGooglePlay: enableGooglePlay,
        options: options,
      ),
      "Purchase handlers could not be reapplied",
    );
    _check(
        await index.readAsString() == first, "Reapplying changed the Worker");
    return first;
  } finally {
    Directory.current = previousDirectory;
    await temporaryDirectory.delete(recursive: true);
  }
}

Future<void> main(List<String> args) async {
  const import = 'import * as m from "@mathrunet/masamune_cloudflare";\n'
      'import * as purchase from "@mathrunet/masamune_cloudflare_purchase";\n';
  const existing = "${import}m.deploy([\n"
      '  purchase.Functions.consumableVerifyIOS({ database: makeCustomDatabase(), scope: "tabelia" }),\n'
      "]);\n";
  final updated = await _applyInTemporaryProject(
    existing,
    enableAppStore: true,
    enableGooglePlay: true,
    options: "{ database: new turso.TursoDatabaseAdapter() }",
    preservedCall:
        'purchase.Functions.consumableVerifyIOS({ database: makeCustomDatabase(), scope: "tabelia" })',
  );
  _check(
    updated.contains(
      'purchase.Functions.consumableVerifyIOS({ database: makeCustomDatabase(), scope: "tabelia" })',
    ),
    "Existing purchase handler arguments were overwritten",
  );
  for (final handler in _handlers) {
    _check(
      "purchase.Functions.$handler(".allMatches(updated).length == 1,
      "$handler is missing or duplicated",
    );
  }

  final fresh = await _applyInTemporaryProject(
    "${import}m.deploy([]);\n",
    enableAppStore: true,
    enableGooglePlay: true,
    options: "",
  );
  for (final handler in _handlers) {
    _check(
      fresh.contains("purchase.Functions.$handler(),"),
      "Fresh Worker did not get $handler",
    );
  }

  if (args.isNotEmpty) {
    final source = await File(args.single).readAsString();
    final reapplied = await _applyInTemporaryProject(
      source,
      enableAppStore: true,
      enableGooglePlay: true,
      options: "{ database: new turso.TursoDatabaseAdapter() }",
    );
    _check(reapplied == source, "TABELIA Worker purchase settings changed");
  }
  stdout.writeln("Purchase Cloudflare regression checks passed");
}
