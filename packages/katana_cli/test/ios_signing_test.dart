// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

Future<void> _expectSigningError(
  Future<void> Function() action,
  String message, {
  List<String> hidden = const [],
}) async {
  try {
    await action();
  } on IOSSigningEnvironmentException catch (e) {
    for (final value in hidden) {
      _check(!e.toString().contains(value), "$message: values are hidden");
    }
    return;
  }
  throw StateError("$message: no exception was thrown");
}

Future<void> _openssl(List<String> arguments) async {
  final result = await Process.run("openssl", arguments);
  if (result.exitCode != 0) {
    throw StateError("openssl ${arguments.first} failed: ${result.stderr}");
  }
}

Future<List<int>> _createKey(Directory directory, String name) async {
  final path = "${directory.path}/$name.key";
  await _openssl([
    "req",
    "-x509",
    "-nodes",
    "-newkey",
    "rsa:2048",
    "-keyout",
    path,
    "-out",
    "${directory.path}/$name.pem",
    "-days",
    "1",
    "-subj",
    "/CN=Katana Test $name",
  ]);
  await _openssl([
    "x509",
    "-in",
    "${directory.path}/$name.pem",
    "-outform",
    "DER",
    "-out",
    "${directory.path}/$name.cer",
  ]);
  return File(path).readAsBytes();
}

int _temporaryDirectoryCount() {
  return Directory.systemTemp
      .listSync()
      .where((e) => e.path.split("/").last.startsWith("katana_ios_signing_"))
      .length;
}

Future<void> main() async {
  // Environment detection.
  _check(
    IOSSigningEnvironment.isApiKeyConfigured({
      "ASC_KEY_ID": "ABC123",
      "ASC_PRIVATE_KEY_B64": "AAAA",
    }),
    "Key ID and private key should enable the API key.",
  );
  _check(
    !IOSSigningEnvironment.isApiKeyConfigured({
      "ASC_KEY_ID": " ",
      "ASC_PRIVATE_KEY_B64": "AAAA",
    }),
    "A blank key ID should not enable the API key.",
  );
  _check(
    IOSSigningEnvironment.isCertificateConfigured({
      "IOS_DEVELOPMENT_CERTIFICATE_B64": "AAAA",
      "IOS_CERTIFICATE_SIGNING_REQUEST_KEY_B64": "AAAA",
    }),
    "Certificate and key should enable the certificate.",
  );
  _check(
    !IOSSigningEnvironment.isCertificateConfigured({
      "IOS_DEVELOPMENT_CERTIFICATE_B64": "AAAA",
    }),
    "A missing key should not enable the certificate.",
  );

  // Issuer ID fallback.
  _check(
    IOSSigningEnvironment.issuerId("configured", {"ASC_ISSUER_ID": "env"}) ==
        "configured",
    "katana.yaml issuer_id should take precedence.",
  );
  _check(
    IOSSigningEnvironment.issuerId("", {"ASC_ISSUER_ID": " env "}) == "env",
    "ASC_ISSUER_ID should be used when issuer_id is empty.",
  );
  _check(
    IOSSigningEnvironment.issuerId("", {}) == "",
    "The issuer ID should be empty when neither is set.",
  );

  // App Store Connect API key.
  const p8 =
      "-----BEGIN PRIVATE KEY-----\nc2VjcmV0LWtleQ==\n-----END PRIVATE KEY-----\n";
  final encodedP8 = base64.encode(utf8.encode(p8));
  final apiKey = IOSSigningEnvironment.apiKey({
    "ASC_KEY_ID": " ABC123 ",
    "ASC_PRIVATE_KEY_B64":
        "${encodedP8.substring(0, 10)}\n${encodedP8.substring(10)}",
  });
  _check(apiKey.keyId == "ABC123", "The key ID should be trimmed.");
  _check(
    apiKey.privateKeyBase64 == encodedP8,
    "The private key should be normalized base64 of the p8 file.",
  );
  _check(
    !apiKey.source.contains("PRIVATE KEY"),
    "The source should not contain the key.",
  );
  await _expectSigningError(
    () async => IOSSigningEnvironment.apiKey({
      "ASC_KEY_ID": "ABC123",
      "ASC_PRIVATE_KEY_B64": "not base64 secret!",
    }),
    "Invalid base64 should be rejected",
    hidden: ["not base64 secret!"],
  );
  await _expectSigningError(
    () async => IOSSigningEnvironment.apiKey({
      "ASC_KEY_ID": "ABC123",
      "ASC_PRIVATE_KEY_B64": base64.encode(utf8.encode("plain-secret")),
    }),
    "A non PEM key should be rejected",
    hidden: ["plain-secret"],
  );
  await _expectSigningError(
    () async => IOSSigningEnvironment.apiKey({
      "ASC_KEY_ID": "../ABC",
      "ASC_PRIVATE_KEY_B64": encodedP8,
    }),
    "A key ID with path characters should be rejected",
  );

  // Password generation.
  final password = IOSSigningEnvironment.generatePassword();
  _check(
    password.length == 32 &&
        RegExp(r"^[A-Za-z0-9]+$").hasMatch(password) &&
        password != IOSSigningEnvironment.generatePassword(),
    "Passwords should be random alphanumerics.",
  );

  // p12 creation.
  final temporary = await Directory.systemTemp.createTemp("katana_ios_test_");
  try {
    final key = await _createKey(temporary, "development");
    final otherKey = await _createKey(temporary, "other");
    final der = await File("${temporary.path}/development.cer").readAsBytes();
    final pem = await File("${temporary.path}/development.pem").readAsBytes();
    final before = _temporaryDirectoryCount();
    for (final certificate in [der, pem]) {
      final bundle = await IOSSigningEnvironment.createP12(
        environment: {
          "IOS_DEVELOPMENT_CERTIFICATE_B64": base64.encode(certificate),
          "IOS_CERTIFICATE_SIGNING_REQUEST_KEY_B64": base64.encode(key),
        },
      );
      _check(
        bundle.password.length == 32,
        "A random p12 password should be generated.",
      );
      final p12File = File("${temporary.path}/output.p12");
      await p12File.writeAsBytes(base64.decode(bundle.p12Base64));
      final info = await Process.run(
        "openssl",
        [
          "pkcs12",
          "-in",
          p12File.path,
          "-info",
          "-noout",
          "-passin",
          "env:KATANA_TEST_P12_PASSWORD",
        ],
        environment: {"KATANA_TEST_P12_PASSWORD": bundle.password},
      );
      _check(info.exitCode == 0, "The p12 should open with its password.");
      final description = "${info.stdout}${info.stderr}";
      final version = (await Process.run("openssl", ["version"])).stdout;
      if (version.toString().startsWith("OpenSSL 3")) {
        _check(
          description.contains("MAC: sha1") &&
              description.contains("pbeWithSHA1And3-KeyTripleDES-CBC") &&
              !description.contains("AES"),
          "OpenSSL 3 should create a keychain compatible p12.",
        );
      }
      final wrong = await Process.run(
        "openssl",
        [
          "pkcs12",
          "-in",
          p12File.path,
          "-noout",
          "-passin",
          "pass:wrong",
        ],
      );
      _check(wrong.exitCode != 0, "The p12 should require its password.");
    }
    final fixed = await IOSSigningEnvironment.createP12(
      environment: {
        "IOS_DEVELOPMENT_CERTIFICATE_B64": base64.encode(der),
        "IOS_CERTIFICATE_SIGNING_REQUEST_KEY_B64": base64.encode(key),
      },
      password: "fixed-password",
    );
    _check(
      fixed.password == "fixed-password",
      "An explicit password should be used.",
    );
    await _expectSigningError(
      () => IOSSigningEnvironment.createP12(
        environment: {
          "IOS_DEVELOPMENT_CERTIFICATE_B64": base64.encode(der),
          "IOS_CERTIFICATE_SIGNING_REQUEST_KEY_B64": base64.encode(otherKey),
        },
      ),
      "A key that does not match the certificate should be rejected",
    );
    await _expectSigningError(
      () => IOSSigningEnvironment.createP12(
        environment: {
          "IOS_DEVELOPMENT_CERTIFICATE_B64":
              base64.encode(utf8.encode("broken-certificate")),
          "IOS_CERTIFICATE_SIGNING_REQUEST_KEY_B64": base64.encode(key),
        },
      ),
      "A broken certificate should be rejected",
      hidden: ["broken-certificate"],
    );
    await _expectSigningError(
      () => IOSSigningEnvironment.createP12(
        environment: {
          "IOS_DEVELOPMENT_CERTIFICATE_B64": base64.encode(der),
          "IOS_CERTIFICATE_SIGNING_REQUEST_KEY_B64":
              base64.encode(utf8.encode("plain-key")),
        },
      ),
      "A non PEM private key should be rejected",
      hidden: ["plain-key"],
    );
    _check(
      _temporaryDirectoryCount() == before,
      "Temporary directories should be deleted, including on errors.",
    );
  } finally {
    await temporary.delete(recursive: true);
  }

  stdout.writeln("ios_signing_test: all checks passed.");
}
