import "dart:io";
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/action/firebase/init.dart";
Future<void> main() async {
  final login = await Process.run("firebase", ["login:list"]);
  if (login.exitCode != 0) throw StateError("Cannot read existing Firebase CLI account");
  final accountArguments = firebaseInitializationAccountArguments(login.stdout.toString());
  if (accountArguments.length != 2 || accountArguments.first != "--account") {
    throw StateError("Existing Firebase CLI account must be explicit");
  }
  print("Existing Firebase CLI account selected explicitly without changing credentials");
  final xcode = XCode();
  await xcode.load();
  final values = xcode.pbxBuildConfiguration.expand((configuration) =>
      configuration.buildSettings.where((setting) =>
          setting.key == "PRODUCT_BUNDLE_IDENTIFIER").map((setting) => setting.value));
  if (values.isEmpty) throw StateError("Original Xcode identity is missing");
  final actual = firebaseAppleBundleId(values.first);
  if (actual != "net.mathru.kanade.play") {
    throw StateError("Unexpected original Runner identity: $actual");
  }
  print("Original Xcode identity resolved for FlutterFire: $actual");
}
