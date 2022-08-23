library masamune_cli;

import 'dart:convert';
import 'dart:core';
import 'dart:core' as core;
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:katana/katana.dart';
import 'package:yaml/yaml.dart';

part 'command/ads/admob.dart';
part 'command/ads/ads.dart';
part 'command/agora.dart';
part 'command/app.dart';
part 'command/generate.dart';
part 'command/codemagic/android.dart';
part 'command/codemagic/codemagic.dart';
part 'command/codemagic/ios.dart';
part 'command/codemagic/web.dart';
part 'command/csr.dart';
part 'command/firebase/dynamiclinks.dart';
part 'command/firebase/firebase.dart';
part 'command/firebase/init.dart';
part 'command/format.dart';
part 'command/functions/deploy.dart';
part 'command/functions/functions.dart';
part 'command/functions/usercount.dart';
part 'command/hosting.dart';
part 'command/info.dart';
part 'command/init.dart';
part 'command/keystore.dart';
part 'command/localize.dart';
part 'command/messaging/firebase.dart';
part 'command/messaging/local.dart';
part 'command/messaging/messaging.dart';
part 'command/permission.dart';
part 'command/publish.dart';
part 'command/purchase/connect.dart';
part 'command/purchase/mobile.dart';
part 'command/purchase/stripe.dart';
part 'command/purchase/purchase.dart';
part 'command/signin/apple.dart';
part 'command/signin/facebook.dart';
part 'command/signin/google.dart';
part 'command/signin/signin.dart';
part 'command/store/icon.dart';
part 'command/store/screenshot.dart';
part 'command/store/store.dart';
part 'command/upgrade.dart';
part 'command/zip.dart';
part 'src/framework.dart';

const commands = <String, CliCommand>{
  "app": AppCliCommand(),
  "hosting": HostingCliCommand(),
  "functions": FunctionsCliCommand(),
  "info": InfoCliCommand(),
  "csr": CsrCliCommand(),
  "localize": LocalizeCliCommand(),
  "permission": PermissionCliCommand(),
  "firebase": FirebaseCliCommand(),
  "messaging": MessagingCliCommand(),
  "signin": SigninCliCommand(),
  "ads": AdsCliCommand(),
  "purchase": PurchaseCliCommand(),
  "agora": AgoraCliCommand(),
  "codemagic": CodemagicCliCommand(),
  "zip": ZipCliCommand(),
  "keystore": KeystoreCliCommand(),
  "store": StoreCliCommand(),
  "init": InitCliCommand(),
  "format": FormatCliCommand(),
  "publish": PublishCliCommand(),
  "upgrade": UpgradeCliCommand(),
  "generate": GenerateCliCommand(),
};

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    showReadme();
    return;
  }
  final command = args.firstOrNull;
  if (command == "help") {
    showReadme();
    return;
  }
  final masamune = File("masamune.yaml");
  if (!masamune.existsSync()) {
    print(
      "masamune.yaml file could not be found. Place it in the root of the project.",
    );
    return;
  }
  final yaml = loadYaml(await masamune.readAsString());
  if (yaml.isEmpty) {
    print(
      "masamune.yaml file could not be found. Place it in the root of the project.",
    );
    return;
  }
  for (final tmp in commands.entries) {
    if (tmp.key != command) {
      continue;
    }
    await tmp.value.exec(yaml, args);
    return;
  }
  showReadme();
}
