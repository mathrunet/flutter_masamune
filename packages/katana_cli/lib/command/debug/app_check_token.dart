part of "debug.dart";

/// Captures Firebase App Check debug tokens from device logs and writes them
/// as `<deviceId, token>` pairs into `.app_check_debug_tokens.json` at the
/// project root.
///
/// Firebase App Check のデバッグトークンをデバイスのログから捕捉し、
/// プロジェクト直下の `.app_check_debug_tokens.json` に
/// `<デバイスID, トークン>` のペアで書き出します。
class DebugAppCheckTokenCliCommand extends CliCommand {
  /// Captures Firebase App Check debug tokens from device logs.
  ///
  /// Firebase App Check のデバッグトークンをデバイスのログから捕捉します。
  const DebugAppCheckTokenCliCommand();

  @override
  String get description =>
      "Capture Firebase App Check debug tokens from Android logcat / iOS simulator logs and save them per device. Firebase App Check のデバッグトークンを Android logcat / iOS シミュレータのログから捕捉し、デバイスごとに保存します。";

  @override
  String? get example =>
      "katana debug app_check_token [--device <device_id>] [--last <duration>]";

  @override
  Future<void> exec(ExecContext context) async {
    final args = context.args.skip(2).toList();
    String? deviceFilter;
    var last = "1h";
    for (var i = 0; i < args.length; i++) {
      final argument = args[i];
      if (argument == "--device") {
        if (i + 1 >= args.length) {
          error("Invalid argument: --device requires one value.");
          return;
        }
        deviceFilter = args[++i];
      } else if (argument.startsWith("--device=")) {
        deviceFilter = argument.substring("--device=".length);
      } else if (argument == "--last") {
        if (i + 1 >= args.length) {
          error("Invalid argument: --last requires one value.");
          return;
        }
        last = args[++i];
      } else if (argument.startsWith("--last=")) {
        last = argument.substring("--last=".length);
      } else {
        error(
          "Unknown argument for `katana debug app_check_token`: $argument",
        );
        return;
      }
    }

    final bin = context.yaml.getAsMap("bin");
    final adb = bin.get("adb", "adb");

    label("Enumerate connected devices.");
    final androidDevices = await listAndroidDevices(adb: adb);
    final iosSimulators = await listBootedIosSimulators();
    final all = [...androidDevices, ...iosSimulators];
    if (all.isEmpty) {
      error(
        "No connected Android devices or booted iOS simulators were found. Boot the target device and run the app first.",
      );
      return;
    }
    final targets = deviceFilter == null
        ? all
        : all.where((d) => d.id == deviceFilter).toList();
    if (targets.isEmpty) {
      error(
        "Device `$deviceFilter` was not found in connected devices: ${all.map((d) => d.id).join(", ")}",
      );
      return;
    }

    final store = AppCheckDebugTokenStore.defaultFile();
    final captured = <AppCheckDebugTokenDevice>[];
    final missed = <AppCheckDebugTokenDevice>[];

    for (final device in targets) {
      label(
        "Capture debug token from ${device.platform}: ${device.id} (${device.name}).",
      );
      String? token;
      if (device.platform == "android") {
        token = await extractAndroidDebugToken(device.id, adb: adb);
      } else if (device.platform == "ios_simulator") {
        token = await extractIosSimulatorDebugToken(device.id, last: last);
      }
      if (token == null) {
        missed.add(device);
        continue;
      }
      store.upsert(
        device: device,
        token: token,
        updatedAt: DateTime.now(),
      );
      captured.add(device);
      // ignore: avoid_print
      print("  -> ${device.id}: $token");
    }

    label("Update .gitignore.");
    _updateGitignore(context);

    // ignore: avoid_print
    print("");
    if (captured.isNotEmpty) {
      // ignore: avoid_print
      print(
        "Captured ${captured.length} debug token(s) into `.app_check_debug_tokens.json`.",
      );
      // ignore: avoid_print
      print(
        "Register each token in Firebase Console: Project settings -> App Check -> (App) -> Manage debug tokens.",
      );
    }
    if (missed.isNotEmpty) {
      // ignore: avoid_print
      print("");
      // ignore: avoid_print
      print("Could not capture debug tokens from:");
      for (final device in missed) {
        // ignore: avoid_print
        print("  - ${device.platform}: ${device.id} (${device.name})");
      }
      // ignore: avoid_print
      print(
        "Restart the app so the debug token line is emitted, then re-run this command.",
      );
      // ignore: avoid_print
      print(
        "iOS note: Firebase App Check debug tokens are not currently emitted from the Masamune adapter on iOS (see FirebaseAppCheckMasamuneAdapter). Check Console.app or the Xcode debug console directly if needed.",
      );
    }
  }

  void _updateGitignore(ExecContext context) {
    final gitignore = File(".gitignore");
    if (!gitignore.existsSync()) {
      return;
    }
    final lines = gitignore.readAsLinesSync();
    final ignore = context.yaml.getAsMap("git").get("ignore_secure_file", true);
    final hasEntry =
        lines.any((e) => e.trim() == ".app_check_debug_tokens.json");
    if (ignore && !hasEntry) {
      lines.add(".app_check_debug_tokens.json");
      gitignore.writeAsStringSync("${lines.join("\n")}\n");
    }
  }
}
