part of masamune_cli;

abstract class CliCommand {
  const CliCommand();
  String get description;
  Future<void> exec(YamlMap yaml, List<String> args);
}

abstract class CliCommandGroup extends CliCommand {
  const CliCommandGroup();
  Map<String, CliCommand> get commands;

  String get groupDescription;

  @override
  String get description {
    return """
$groupDescription
${commands.toList((key, value) => "    $key:\r\n        - ${value.description}").join("\r\n")}
""";
  }

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    if (args.length <= 1) {
      print(description);
      return;
    }
    final mode = args[1];
    if (mode.isEmpty) {
      print(description);
      return;
    }
    for (final tmp in commands.entries) {
      if (tmp.key != mode) {
        continue;
      }
      await tmp.value.exec(yaml, args);
      return;
    }
    print(description);
  }
}

void showReadme() {
  print(
    """
Masamune command line interfaces.

${commands.toList((key, value) => "$key:\r\n    - ${value.description}").join("\r\n")}
""",
  );
}

void applyFunctionsTemplate() {
  File("${Directory.current.path}/firebase/index.ts.template")
      .copySync("${Directory.current.path}/firebase/functions/src/index.ts");
}

FileSystemEntity search(RegExp regExp) {
  final root = Directory.current.path.replaceAll(r"\", "/");
  return Directory.current.listSync(recursive: true).firstWhere((file) {
    final path = file.path.replaceAll(r"\", "/").replaceAll("$root/", "");
    return regExp.hasMatch(path);
  });
}

List<FileSystemEntity> get currentFiles {
  final root = Directory.current.path.replaceAll(r"\", "/");
  return Directory.current.listSync(recursive: true).where((file) {
    final path = file.path.replaceAll(r"\", "/").replaceAll("$root/", "");
    if (path.endsWith(".firebaserc")) {
      return true;
    }
    if (path.startsWith(".") || path.contains("/.")) {
      return false;
    }
    if (path.startsWith("masamune")) {
      return false;
    }
    if (path.startsWith("build/") ||
        path.startsWith("assets/") ||
        path.startsWith("firebase/functions/node_modules/")) {
      return false;
    }
    if (path.endsWith(".dart") ||
        path.endsWith(".json") ||
        path.endsWith(".xml") ||
        path.endsWith(".js") ||
        path.endsWith(".ts") ||
        path.endsWith(".txt") ||
        path.endsWith(".gradle") ||
        path.endsWith(".ts.template") ||
        path.endsWith(".html") ||
        path.endsWith(".properties") ||
        path.endsWith(".entitlements") ||
        path.endsWith(".yaml") ||
        path.endsWith(".xcconfig") ||
        path.endsWith(".strings") ||
        path.endsWith(".plist") ||
        path.endsWith(".pbxproj") ||
        path.endsWith(".md")) {
      return true;
    }
    return false;
  }).toList();
}

String formatQueryParamater(Map<String, dynamic> paramater) {
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

extension ProcessExtensions on Process {
  Future<String> print() async {
    var res = "";
    this.stdout.transform(utf8.decoder).forEach((e) {
      res += e;
      core.print(e);
    });
    await this.exitCode;
    return res;
  }
}

extension ZipFileEncoderExtensions on ZipFileEncoder {
  void checkAndAddDirectory(
    String dirPath, [
    List<String> ignoredList = const [],
  ]) {
    final dir = Directory(dirPath);
    final list = dir.listSync(recursive: true);
    for (final tmp in list) {
      final path = tmp.path.replaceAll(r"\", "/").replaceAll(dirPath, "");
      if (path.contains(".git/") || path.contains("/node_modules/")) {
        continue;
      }
      print("Check: $path");
      if (ignoredList.any((element) => path.contains(RegExp(element)))) {
        continue;
      }
      final file = File(path);
      if (!file.existsSync()) {
        continue;
      }
      print("Contain: $path");
      addFile(file, path);
    }
  }
}
