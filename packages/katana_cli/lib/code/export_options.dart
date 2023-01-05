part of katana_cli;

/// Contents of ExportOptions.plist.
///
/// ExportOptions.plistの中身。
class ExportOptionsCliCode extends CliCode {
  /// Contents of ExportOptions.plist.
  ///
  /// ExportOptions.plistの中身。
  const ExportOptionsCliCode();

  @override
  String get name => "ExportOptions";

  @override
  String get prefix => "ExportOptions";

  @override
  String get directory => "ios";

  @override
  String get description =>
      "Create ExportOptions.plist for IOS builds. IOSビルド用のExportOptions.plistを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>generateAppStoreInformation</key>
    <false/>
    <key>method</key>
    <string>app-store</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
  </dict>
</plist>
""";
  }
}
