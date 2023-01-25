part of katana_cli.pub;

/// Upgrade the Dart package.
///
/// Dartパッケージのバージョンアップを行います。
class PubVersionCliCommand extends CliCommand {
  /// Upgrade the Dart package.
  ///
  /// Dartパッケージのバージョンアップを行います。
  const PubVersionCliCommand();
  static final RegExp _regExp = RegExp(
    r"([a-zA-Z0-9_-]+)\s+(([0-9]+)\.([0-9]+)\.([0-9]+)(\+([0-9]+))?)\s+([a-zA-Z0-9_/-]+)",
  );

  @override
  String get description =>
      "Upgrade the Dart package. Dartパッケージのバージョンアップを行います。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final melos = bin.get("melos", "melos");
    if (!File("melos.yaml").existsSync()) {
      error("The melos.yaml file does not exist.\r\nmelos.yamlのファイルが存在しません。");
      return;
    }
    final mode = context.args.get(2, "");
    if (mode.isNotEmpty) {
      switch (mode) {
        case "import":
          final processVersionRes = await command(
            "Get a list of current management packages.",
            [
              melos,
              "list",
              "-l",
            ],
          );
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
          final processVersionRes = await command(
            "Get a list of current management packages.",
            [
              melos,
              "list",
              "-l",
            ],
          );
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
            error("--manual-version=${tmp.name}:$latestMajor.$latestPatch.0");
            final processVersionUp = await Process.start(melos, [
              "version",
              "--manual-version=${tmp.name}:$latestMajor.$latestPatch.0",
              "--message=\"chore: Fit versions with other packages.\"",
              "--yes"
            ]);
            // ignore: avoid_print
            processVersionUp.stdout.transform(utf8.decoder).forEach(print);
            processVersionUp.stdin
                .write("chore: Fit versions with other packages.");
            await processVersionUp.exitCode;
          }
          break;
        default:
          // ignore: avoid_print
          print(
            "fit: Match the version with other packages. バージョンを他のパッケージと合わせます。",
          );
          // ignore: avoid_print
          print(
            "import: Bring the import version up to date. インポートバージョンを最新にします。",
          );
          break;
      }
    } else {
      await command(
        "Update the version of the management package according to the Git log.",
        [
          melos,
          "version",
          "--yes",
        ],
      );
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
