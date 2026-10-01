part of "debug.dart";

/// Captures Firebase App Check debug tokens from device logs (and, on iOS
/// simulators, from the app's UserDefaults) and writes them as
/// `<deviceId, token>` pairs into `.app_check_debug_tokens.json` at the
/// project root.
///
/// Firebase App Check のデバッグトークンをデバイスのログ（iOS シミュレータではアプリの
/// UserDefaults も）から捕捉し、
/// プロジェクト直下の `.app_check_debug_tokens.json` に
/// `<デバイスID, トークン>` のペアで書き出します。
class DebugAppCheckTokenCliCommand extends CliCommand {
  /// Captures Firebase App Check debug tokens from device logs.
  ///
  /// Firebase App Check のデバッグトークンをデバイスのログから捕捉します。
  const DebugAppCheckTokenCliCommand();

  @override
  String get description =>
      "Capture Firebase App Check debug tokens from Android logcat / iOS simulator UserDefaults or logs and save them per device. Firebase App Check のデバッグトークンを Android logcat / iOS シミュレータの UserDefaults またはログから捕捉し、デバイスごとに保存します。";

  @override
  String? get example =>
      "katana debug app_check_token [--device <device_id>] [--last <duration>] [--bundle-id <ios_bundle_id>]";

  @override
  Future<void> exec(ExecContext context) async {
    final args = context.args.skip(2).toList();
    String? deviceFilter;
    var last = "1h";
    String? bundleId;
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
      } else if (argument == "--bundle-id") {
        if (i + 1 >= args.length) {
          error("Invalid argument: --bundle-id requires one value.");
          return;
        }
        bundleId = args[++i];
      } else if (argument.startsWith("--bundle-id=")) {
        bundleId = argument.substring("--bundle-id=".length);
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

    bundleId ??= resolveIosBundleId();
    final store = AppCheckDebugTokenStore.defaultFile();
    final captured = <AppCheckDebugTokenDevice>[];
    final unregistered = <AppCheckDebugTokenDevice>[];
    final missed = <AppCheckDebugTokenDevice>[];

    for (final device in targets) {
      label(
        "Capture debug token from ${device.platform}: ${device.id} (${device.name}).",
      );
      String? token;
      if (device.platform == "android") {
        token = await extractAndroidDebugToken(device.id, adb: adb);
      } else if (device.platform == "ios_simulator") {
        final defaults = bundleId == null
            ? null
            : await readIosSimulatorDebugTokenFromDefaults(
                device.id,
                bundleId: bundleId,
              );
        if (defaults != null) {
          token = defaults.token;
          if (!defaults.registered) {
            unregistered.add(device);
          }
          // ignore: avoid_print
          print(
            "  Read from UserDefaults of `$bundleId` (${defaults.registered ? "registered in Firebase" : "NOT registered in Firebase yet"}).",
          );
        } else {
          token = await extractIosSimulatorDebugToken(device.id, last: last);
        }
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
    if (unregistered.isNotEmpty) {
      // ignore: avoid_print
      print("");
      // ignore: avoid_print
      print(
        "The App Check SDK has not recorded these iOS simulator tokens as registered in Firebase:",
      );
      for (final device in unregistered) {
        // ignore: avoid_print
        print("  - ${device.platform}: ${device.id} (${device.name})");
      }
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
        "iOS note: tokens are read from the app's UserDefaults${bundleId == null ? " (bundle ID could not be resolved; pass --bundle-id)" : " of `$bundleId`"}. Launch the debug build once so App Check generates a token, then re-run this command.",
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
