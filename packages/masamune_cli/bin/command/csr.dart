part of masamune_cli;

class CsrCliCommand extends CliCommand {
  const CsrCliCommand();

  @override
  String get description =>
      "AppStoreでの認証を行うための`CertificateSigningRequest.certSigningRequest`を自動出力します。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final openssl = bin["openssl"] as String?;
    final process = await Process.start(
      openssl!,
      [
        "req",
        "-nodes",
        "-newkey",
        "rsa:2048",
        "-keyout",
        "ios/ios_enterprise.key",
        "-out",
        "ios/CertificateSigningRequest.certSigningRequest",
      ],
      runInShell: true,
      mode: ProcessStartMode.normal,
    );
    process.stdout.transform(utf8.decoder).forEach(print);
    process.stdin.write(".\n");
    process.stdin.write(".\n");
    process.stdin.write(".\n");
    process.stdin.write(".\n");
    process.stdin.write(".\n");
    process.stdin.write(".\n");
    process.stdin.write("support@mathru.net\n");
    process.stdin.write("\n");
    process.stdin.write("\n");
    await process.exitCode;
  }
}
