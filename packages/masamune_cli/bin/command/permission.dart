part of masamune_cli;

class PermissionCliCommand extends CliCommand {
  const PermissionCliCommand();

  @override
  String get description =>
      "masamune.yamlで指定したカメラや位置情報のPermission許可時の文言をアプリに反映させます。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final permission = yaml["permission"] as YamlMap;
    if (permission.isEmpty) {
      print("Permission data could not be found.");
      return;
    }
    const permissionMap = {
      "cameraUsage": "NSCameraUsageDescription",
      "microphoneUsage": "NSMicrophoneUsageDescription",
      "locationWhenInUseUsage": "NSLocationWhenInUseUsageDescription",
      "locationAlwaysAndWhenInUseUsage":
          "NSLocationAlwaysAndWhenInUseUsageDescription",
      "locationAlwaysUsage": "NSLocationAlwaysUsageDescription",
      "motionUsageDescription": "NSMotionUsageDescription",
      "serviceMediaLibrary": "kTCCServiceMediaLibrary",
      "photoLibraryUsage": "NSPhotoLibraryUsageDescription",
      "photoLibraryAddUsage": "NSPhotoLibraryAddUsageDescription",
      "contactsUsage": "NSContactsUsageDescription",
      "calendarsUsage": "NSCalendarsUsageDescription",
      "remindersUsage": "NSRemindersUsageDescription",
      "bluetoothPeripheralUsage": "NSBluetoothPeripheralUsageDescription",
      "appleMusicUsage": "NSAppleMusicUsageDescription",
      "speechRecognitionUsage": "NSSpeechRecognitionUsageDescription",
      "userTrackingUsage": "NSUserTrackingUsageDescription",
    };
    const langMap = {
      "en": "En",
      "ja": "Ja",
      "zh": "ZhHans",
    };
    for (final tmp in permissionMap.entries) {
      if (!permission.containsKey(tmp.key)) {
        continue;
      }
      final lang = permission[tmp.key] as YamlMap;
      if (lang.isEmpty) {
        continue;
      }
      var def = lang.containsKey("en") ? lang["en"] as String? : null;
      if (def.isEmpty) {
        def = lang.containsKey("ja") ? lang["ja"] as String? : null;
      }
      if (def.isEmpty) {
        def = lang.values.first as String?;
      }
      if (def.isEmpty) {
        continue;
      }
      final key = "TODO_REPLACE_${tmp.value}";
      currentFiles.forEach((file) {
        var text = File(file.path).readAsStringSync();
        text = text.replaceAll("<!-- $key -->", """
<key>${tmp.value}</key>
	<string>$def</string>""");
        text =
            text.replaceAll("/* ${key}_Default */", "${tmp.value} = \"$def\";");
        for (final l in langMap.entries) {
          if (!lang.containsKey(l.key)) {
            continue;
          }
          final v = lang[l.key] as String?;
          if (v.isEmpty) {
            continue;
          }
          text = text.replaceAll(
              "/* ${key}_${l.value} */", "${tmp.value} = \"$v\";");
        }
        File(file.path).writeAsStringSync(text);
      });
    }
  }
}
