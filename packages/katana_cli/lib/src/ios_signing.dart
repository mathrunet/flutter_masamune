// Dart imports:
import "dart:convert";
import "dart:io";
import "dart:math";

/// Exception thrown when iOS signing values supplied by environment variables
/// cannot be used.
///
/// The message only contains variable names and never the values.
class IOSSigningEnvironmentException implements Exception {
  /// Creates an exception with [message].
  const IOSSigningEnvironmentException(this.message);

  /// Description of the problem.
  final String message;

  @override
  String toString() => message;
}

/// A PKCS#12 bundle generated from environment variables.
class IOSCertificateBundle {
  /// Creates a bundle.
  const IOSCertificateBundle({
    required this.p12,
    required this.password,
  });

  /// PKCS#12 file content.
  final List<int> p12;

  /// Password of [p12].
  final String password;

  /// Base64 encoded [p12].
  String get p12Base64 => base64.encode(p12);
}

/// App Store Connect API key supplied by a file or environment variables.
class IOSApiKey {
  /// Creates an API key.
  const IOSApiKey({
    required this.keyId,
    required this.privateKeyBase64,
    required this.source,
  });

  /// Key ID of the API key.
  final String keyId;

  /// Base64 encoded content of `AuthKey_<KEY_ID>.p8`.
  final String privateKeyBase64;

  /// Description of where the key was read from. It never contains the key.
  final String source;
}

/// Provides iOS signing materials from environment variables when the
/// corresponding files are not placed under `ios/`.
///
/// Files always take precedence so that existing projects keep working.
class IOSSigningEnvironment {
  const IOSSigningEnvironment._();

  /// Environment variable holding the App Store Connect API key ID.
  static const apiKeyIdVariable = "ASC_KEY_ID";

  /// Environment variable holding the App Store Connect issuer ID.
  static const apiIssuerIdVariable = "ASC_ISSUER_ID";

  /// Environment variable holding the base64 encoded `AuthKey_<KEY_ID>.p8`.
  static const apiPrivateKeyVariable = "ASC_PRIVATE_KEY_B64";

  /// Environment variable holding the base64 encoded development certificate
  /// (`development.cer`, DER or PEM).
  static const certificateVariable = "IOS_DEVELOPMENT_CERTIFICATE_B64";

  /// Environment variable holding the base64 encoded PEM private key used for
  /// the certificate signing request (`ios_enterprise.key`).
  static const certificateKeyVariable =
      "IOS_CERTIFICATE_SIGNING_REQUEST_KEY_B64";

  static const _passwordEnvironment = "KATANA_IOS_P12_PASSWORD";

  /// Returns the value of [name] in [environment] when it is not blank.
  static String? value(String name, [Map<String, String>? environment]) {
    final value = (environment ?? Platform.environment)[name];
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value;
  }

  /// Whether the App Store Connect API key is supplied by [environment].
  static bool isApiKeyConfigured([Map<String, String>? environment]) {
    return value(apiKeyIdVariable, environment) != null &&
        value(apiPrivateKeyVariable, environment) != null;
  }

  /// Whether the certificate and its private key are supplied by
  /// [environment].
  static bool isCertificateConfigured([Map<String, String>? environment]) {
    return value(certificateVariable, environment) != null &&
        value(certificateKeyVariable, environment) != null;
  }

  /// Returns [configured] when it is not blank, otherwise the issuer ID from
  /// [environment], or an empty string.
  static String issuerId(String configured,
      [Map<String, String>? environment]) {
    if (configured.trim().isNotEmpty) {
      return configured;
    }
    return value(apiIssuerIdVariable, environment)?.trim() ?? "";
  }

  /// Decodes the base64 value of [variable] in [environment].
  ///
  /// Whitespace is ignored. Throws [IOSSigningEnvironmentException] when the
  /// variable is missing or not valid base64.
  static List<int> decode(String variable, [Map<String, String>? environment]) {
    final raw = value(variable, environment);
    if (raw == null) {
      throw IOSSigningEnvironmentException("`$variable` is not set.");
    }
    try {
      final bytes = base64.decode(raw.replaceAll(RegExp(r"\s"), ""));
      if (bytes.isEmpty) {
        throw const FormatException();
      }
      return bytes;
    } on FormatException {
      throw IOSSigningEnvironmentException(
        "`$variable` is not valid base64.",
      );
    }
  }

  /// Returns the App Store Connect API key supplied by [environment].
  ///
  /// Throws [IOSSigningEnvironmentException] when the values are invalid.
  static IOSApiKey apiKey([Map<String, String>? environment]) {
    final keyId = value(apiKeyIdVariable, environment)?.trim();
    if (keyId == null) {
      throw const IOSSigningEnvironmentException(
        "`$apiKeyIdVariable` is not set.",
      );
    }
    if (!RegExp(r"^[A-Za-z0-9]+$").hasMatch(keyId)) {
      throw const IOSSigningEnvironmentException(
        "`$apiKeyIdVariable` must only contain letters and digits.",
      );
    }
    final bytes = decode(apiPrivateKeyVariable, environment);
    final content = utf8.decode(bytes, allowMalformed: true);
    if (!content.contains("PRIVATE KEY-----")) {
      throw const IOSSigningEnvironmentException(
        "`$apiPrivateKeyVariable` does not contain a PEM private key (AuthKey_<KEY_ID>.p8).",
      );
    }
    return IOSApiKey(
      keyId: keyId,
      privateKeyBase64: base64.encode(bytes),
      source: "`$apiKeyIdVariable` and `$apiPrivateKeyVariable`",
    );
  }

  /// Generates a random password suitable for a PKCS#12 file.
  static String generatePassword([int length = 32]) {
    const characters =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    final random = Random.secure();
    return List.generate(
      length,
      (_) => characters[random.nextInt(characters.length)],
    ).join();
  }

  /// Creates a PKCS#12 bundle from the certificate and private key supplied
  /// by [environment].
  ///
  /// The files are written to a temporary directory accessible only by the
  /// owner and deleted before returning. The password is generated randomly
  /// unless [password] is given, and is passed to [openssl] through an
  /// environment variable instead of the process arguments.
  ///
  /// With OpenSSL 3, SHA1-3DES encryption and a SHA1 MAC are used so that the
  /// file can be imported into the macOS keychain.
  static Future<IOSCertificateBundle> createP12({
    Map<String, String>? environment,
    String openssl = "openssl",
    String? password,
  }) async {
    final certificate = decode(certificateVariable, environment);
    final privateKey = decode(certificateKeyVariable, environment);
    if (!utf8
        .decode(privateKey, allowMalformed: true)
        .contains("PRIVATE KEY-----")) {
      throw const IOSSigningEnvironmentException(
        "`$certificateKeyVariable` does not contain a PEM private key.",
      );
    }
    final p12Password = password ?? generatePassword();
    final temporary =
        await Directory.systemTemp.createTemp("katana_ios_signing_");
    try {
      if (!Platform.isWindows) {
        await _run("chmod", ["700", temporary.path]);
      }
      final certificateFile = File("${temporary.path}/development.cer");
      final certificatePemFile = File("${temporary.path}/development.pem");
      final keyFile = File("${temporary.path}/ios_enterprise.key");
      final p12File = File("${temporary.path}/development.p12");
      await _writePrivate(certificateFile, certificate);
      await _writePrivate(keyFile, privateKey);
      final isPem = utf8
          .decode(certificate, allowMalformed: true)
          .contains("-----BEGIN CERTIFICATE-----");
      await _run(
        openssl,
        [
          "x509",
          "-in",
          certificateFile.path,
          "-inform",
          if (isPem) "PEM" else "DER",
          "-out",
          certificatePemFile.path,
          "-outform",
          "PEM",
        ],
        failure: "`$certificateVariable` is not a valid certificate.",
      );
      final version = await _run(openssl, ["version"]);
      final isOpenSSL3 = RegExp(r"^OpenSSL\s+[3-9]\.").hasMatch(version.trim());
      await _run(
        openssl,
        [
          "pkcs12",
          "-export",
          "-in",
          certificatePemFile.path,
          "-inkey",
          keyFile.path,
          "-out",
          p12File.path,
          "-passout",
          "env:$_passwordEnvironment",
          if (isOpenSSL3) ...[
            "-certpbe",
            "PBE-SHA1-3DES",
            "-keypbe",
            "PBE-SHA1-3DES",
            "-macalg",
            "sha1",
          ],
        ],
        environment: {_passwordEnvironment: p12Password},
        failure:
            "Could not create a p12 file. Check that `$certificateKeyVariable` is the private key of `$certificateVariable`.",
      );
      return IOSCertificateBundle(
        p12: await p12File.readAsBytes(),
        password: p12Password,
      );
    } finally {
      await temporary.delete(recursive: true);
    }
  }

  static Future<void> _writePrivate(File file, List<int> bytes) async {
    await file.writeAsBytes(const []);
    if (!Platform.isWindows) {
      await _run("chmod", ["600", file.path]);
    }
    await file.writeAsBytes(bytes, flush: true);
  }

  static Future<String> _run(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    String? failure,
  }) async {
    final ProcessResult result;
    try {
      result = await Process.run(
        executable,
        arguments,
        environment: environment,
      );
    } on ProcessException {
      throw IOSSigningEnvironmentException(
        "Could not run `$executable`. Install it or set [bin]->[openssl] in katana.yaml.",
      );
    }
    if (result.exitCode != 0) {
      // The output of openssl is not shown since it may describe the inputs.
      throw IOSSigningEnvironmentException(
        failure ?? "`$executable ${arguments.first}` failed.",
      );
    }
    return result.stdout.toString();
  }
}
