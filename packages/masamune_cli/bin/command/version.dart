part of masamune_cli;

class VersionCliCommand extends CliCommand {
  const VersionCliCommand();
  static final RegExp _regExp = RegExp(
    r"([a-zA-Z0-9_-]+)\s+(([0-9]+)\.([0-9]+)\.([0-9]+)(\+([0-9]+)?))\s+([a-zA-Z0-9_/-]+)",
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
    final version = args[1];
    print(version);
    if (version.isNotEmpty) {
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
      print(packageVersions);
      final latestMajor =
          packageVersions.fold<int>(0, (p, e) => p < e.major ? e.major : p);
      final latestPatch =
          packageVersions.fold<int>(0, (p, e) => p < e.patch ? e.patch : p);
      // for (final tmp in packageVersions) {
      //   if (latestMajor <= tmp.major && latestPatch <= tmp.patch) {
      //     continue;
      //   }
      //   final processVersionUp = await Process.start(melos, [
      //     "version",
      //     "--manual-version=${tmp.name}:$latestMajor.$latestPatch.0",
      //   ]);
      //   await processVersionUp.print();
      // }
    } else {
      final processVersion = await Process.start(
        melos!,
        [
          "version",
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
