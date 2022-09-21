part of masamune_cli;

class VersionCliCommand extends CliCommand {
  const VersionCliCommand();
  static final RegExp _regExp = RegExp(
    r"([a-zA-Z0-9_-]+)\s+(([0-9]+)\.([0-9]+)\.([0-9]+)(\+([0-9]+))?)\s+([a-zA-Z0-9_/-]+)",
  );

  @override
  String get description => "Dartパッケージのバージョンアップを行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final melos = bin["melos"] as String?;
    if (!File("melos.yaml").existsSync()) {
      print("melos.yamlのファイルが存在しません。");
      return;
    }
    if (args.length > 1 && args[1].isNotEmpty) {
      final mode = args[1];
      switch (mode) {
        case "import":
          final processVersion = await Process.start(
            melos!,
            ["list", "-l"],
            runInShell: true,
            workingDirectory: Directory.current.path,
          );

          final processVersionRes = await processVersion.print();
          final packages = processVersionRes
              .replaceAll("\r", "\n")
              .replaceAll("\r\n", "\n")
              .split("\n");
          final packageVersions = packages.mapAndRemoveEmpty((e) {
            final match = _regExp.firstMatch(e);
            if (match == null) {
              return null;
            }
            return _PackageVersion(
              name: match.group(1)!,
              version: match.group(2)!,
              major: int.parse(match.group(3)!),
              patch: int.parse(match.group(4)!),
              minor: int.parse(match.group(5)!),
              build: int.tryParse(match.group(7) ?? "") ?? 0,
            );
          });
          final latestMajor =
              packageVersions.fold<int>(0, (p, e) => p < e.major ? e.major : p);
          final latestPatch =
              packageVersions.fold<int>(0, (p, e) => p < e.patch ? e.patch : p);

          final root = Directory.current.path.replaceAll(r"\", "/");
          Directory.current.listSync(recursive: true).forEach((file) {
            final path =
                file.path.replaceAll(r"\", "/").replaceAll("$root/", "");
            if (!path.endsWith("pubspec.yaml")) {
              return;
            }
            var text = File(file.path).readAsStringSync();
            for (final tmp in packageVersions) {
              text = text.replaceAll(
                RegExp("${tmp.name}:" r" \^[0-9]+.[0-9]+.[0-9]+"),
                "${tmp.name}: ^$latestMajor.$latestPatch.0",
              );
            }
            File(file.path).writeAsStringSync(text);
          });
          break;
        case "fit":
          final processVersion = await Process.start(
            melos!,
            ["list", "-l"],
            runInShell: true,
            workingDirectory: Directory.current.path,
          );

          final processVersionRes = await processVersion.print();
          final packages = processVersionRes
              .replaceAll("\r", "\n")
              .replaceAll("\r\n", "\n")
              .split("\n");
          final packageVersions = packages.mapAndRemoveEmpty((e) {
            final match = _regExp.firstMatch(e);
            if (match == null) {
              return null;
            }
            return _PackageVersion(
              name: match.group(1)!,
              version: match.group(2)!,
              major: int.parse(match.group(3)!),
              patch: int.parse(match.group(4)!),
              minor: int.parse(match.group(5)!),
              build: int.parse(match.group(7)!),
            );
          });
          final latestMajor =
              packageVersions.fold<int>(0, (p, e) => p < e.major ? e.major : p);
          final latestPatch =
              packageVersions.fold<int>(0, (p, e) => p < e.patch ? e.patch : p);
          for (final tmp in packageVersions) {
            if (latestMajor <= tmp.major && latestPatch <= tmp.patch) {
              continue;
            }
            print("--manual-version=${tmp.name}:$latestMajor.$latestPatch.0");
            final processVersionUp = await Process.start(melos, [
              "version",
              "--manual-version=${tmp.name}:$latestMajor.$latestPatch.0",
              "--message=\"chore: Fit versions with other packages.\"",
              "--yes"
            ]);
            processVersionUp.stdout.transform(utf8.decoder).forEach(print);
            processVersionUp.stdin
                .write("chore: Fit versions with other packages.");
            await processVersionUp.exitCode;
          }
          break;
        default:
          print("fit: バージョンを他のパッケージと合わせます。");
          print("import: インポートバージョンを最新にします。");
          break;
      }
    } else {
      final processVersion = await Process.start(
        melos!,
        [
          "version",
          "--yes",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      );
      await processVersion.print();
    }
  }
}

class _PackageVersion {
  const _PackageVersion({
    required this.name,
    required this.version,
    required this.major,
    required this.patch,
    required this.minor,
    required this.build,
  });

  final String name;
  final String version;
  final int major;
  final int patch;
  final int minor;
  final int build;
}
