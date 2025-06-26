// Project imports:
import "package:katana_cli/action/git/claude_code.dart";
import "package:katana_cli/katana_cli.dart";

/// Add AI Agent using Cursor.
///
/// Cursorを利用したAIエージェント機能を追加します。
class GitCursorCliAction extends CliCommand with CliActionMixin {
  /// Add AI Agent using Cursor.
  ///
  /// Cursorを利用したAIエージェント機能を追加します。
  const GitCursorCliAction();

  @override
  String get description =>
      "Add AI Agent using Cursor. Cursorを利用したAIエージェント機能を追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("generative_ai").getAsMap("cursor");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final cursor = context.yaml.getAsMap("generative_ai").getAsMap("cursor");
    final backgroundMode = cursor.get("background_mode", false);
    final flutterVersion = await getFlutterVersion();
    label("Create global.mdc");
    await const GitCursorGlobalMdcCliCode().generateFile("global.mdc");
    if (backgroundMode) {
      label("Create Dockerfile");
      await GitCursorDockerfileCliCode(flutterVersion: flutterVersion)
          .generateFile("Dockerfile");
      label("Create environment.json");
      await const GitCursorEnvironmentCliCode()
          .generateFile("environment.json");
    }
  }
}

/// Contents of global.mdc.
///
/// global.mdcの中身。
class GitCursorGlobalMdcCliCode extends CliCode {
  /// Contents of global.mdc.
  ///
  /// global.mdcの中身。
  const GitCursorGlobalMdcCliCode();

  @override
  String get name => "global";

  @override
  String get prefix => "global";

  @override
  String get directory => ".cursor/rules";

  @override
  String get description =>
      "Create global.mdc for AI Agent using Cursor. Cursorを利用したAIエージェント機能用のglobal.mdcを作成します。";

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
---
description: Cursorを利用したAIエージェント機能用のglobal.mdc
globs: 
alwaysApply: true
---
${const GitClaudeMarkdownCliCode().body(path, baseName, className)}
""";
  }
}

/// Contents of environment.json.
///
/// environment.jsonの中身。
class GitCursorEnvironmentCliCode extends CliCode {
  /// Contents of environment.json.
  ///
  /// environment.jsonの中身。
  const GitCursorEnvironmentCliCode();

  @override
  String get name => "environment";

  @override
  String get prefix => "environment";

  @override
  String get directory => ".cursor";

  @override
  String get description =>
      "Create environment.json for AI Agent using Cursor. Cursorを利用したAIエージェント機能用のenvironment.jsonを作成します。";

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
{
  "build": {
    "context": ".",
    "dockerfile": "Dockerfile"
  },
  "install": "flutter pub get"
}
""";
  }
}

/// Contents of Dockerfile.
///
/// Dockerfileの中身。
class GitCursorDockerfileCliCode extends CliCode {
  /// Contents of Dockerfile.
  ///
  /// Dockerfileの中身。
  GitCursorDockerfileCliCode({
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
  String get directory => ".cursor";

  @override
  String get description =>
      "Create Dockerfile for AI Agent using Cursor. Cursorを利用したAIエージェント機能用のDockerfileを作成します。";

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
    wget \\
    software-properties-common \\
    build-essential \\
    sudo \\
    vim \\
    nano \\
    && rm -rf /var/lib/apt/lists/*

RUN id -u ubuntu >/dev/null 2>&1 || useradd -m -s /bin/bash ubuntu && \\
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_\$FLUTTER_VERSION-stable.tar.xz \\
    && mkdir -p /usr/local/flutter \\
    && tar -xf flutter.tar.xz -C /usr/local/flutter --strip-components=1 \\
    && rm flutter.tar.xz

RUN chown -R ubuntu:ubuntu /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:\$PATH"

USER ubuntu

WORKDIR /home/ubuntu

RUN mkdir -p /home/ubuntu/.pub-cache

RUN git config --global init.defaultBranch main && \\
    git config --global --add safe.directory /usr/local/flutter

RUN flutter doctor --android-licenses || true && flutter doctor || true

RUN flutter pub global activate katana_cli

ENV PATH="\$PATH:/home/ubuntu/.pub-cache/bin"

RUN flutter --version || echo "Setup complete"

CMD ["/bin/bash"]
""";
  }
}
