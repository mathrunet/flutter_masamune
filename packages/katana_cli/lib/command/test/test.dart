library;

// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

part "update.dart";
part "run.dart";

/// Providing test commands.
///
/// テスト用のコマンドを提供します。
class TestCliCommand extends CliCommandGroup {
  /// Providing test commands.
  ///
  /// テスト用のコマンドを提供します。
  const TestCliCommand();

  @override
  String get groupDescription => "Providing test commands. テスト用のコマンドを提供します。";

  @override
  Map<String, CliCommand> get commands => const {
        "update": TestUpdateCliCommand(),
        "run": TestRunCliCommand(),
      };
}

/// Contents of Dockerfile.
///
/// Dockerfileの中身。
class TestDockerfileCliCode extends CliCode {
  /// Contents of Dockerfile.
  ///
  /// Dockerfileの中身。
  const TestDockerfileCliCode({
    required this.flutterVersion,
  });

  /// Flutter version.
  ///
  /// Flutterのバージョン。
  final String flutterVersion;

  @override
  String get name => "Dockerfile";

  @override
  String get prefix => "Dockerfile";

  @override
  String get directory => "docker";

  @override
  String get description =>
      "Create Dockerfile for test. テスト用のDockerfileを作成します。";

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
    return """
FROM ubuntu:24.04

ARG FLUTTER_VERSION=$flutterVersion

ENV FLUTTER_VERSION=\$FLUTTER_VERSION

RUN apt-get update && apt-get install -y \\
    curl \\
    git \\
    unzip \\
    xz-utils \\
    zip \\
    libglu1-mesa \\
    && rm -rf /var/lib/apt/lists/*

RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_\$FLUTTER_VERSION-stable.tar.xz \\
    && mkdir -p /usr/local/flutter \\
    && tar -xf flutter.tar.xz -C /usr/local/flutter --strip-components=1 \\
    && git config --global --add safe.directory /usr/local/flutter \\
    && rm flutter.tar.xz

ENV PATH="/usr/local/flutter/bin:\$PATH"

RUN flutter doctor --android-licenses || true && flutter doctor || true

RUN flutter pub global activate katana_cli

ENV PATH="\$PATH:/root/.pub-cache/bin"

RUN katana --version || echo "katana version check failed"

CMD ["flutter", "--version"]
""";
  }
}
