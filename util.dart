library flutter_masamune;

import 'dart:io';

Future<void> main(List<String> args) async {
  final file = File("README.md");
  final packages = Directory("packages");
  packages.listSync().where((e) => !e.path.startsWith(".")).forEach((e) {
    file.copySync("${e.path}/README.md");
  });
}
