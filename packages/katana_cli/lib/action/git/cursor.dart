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
    final value = context.yaml.getAsMap("github").getAsMap("cursor");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final flutterVersion = await getFlutterVersion();
    label("Create global.mdc");
    await const GitCursorGlobalMdcCliCode().generateFile("global.mdc");
    label("Create Dockerfile");
    await GitCursorDockerfileCliCode(flutterVersion: flutterVersion)
        .generateFile("Dockerfile");
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

# 基本的な開発ツールのインストール
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

# 非rootユーザーの作成
RUN useradd -m -s /bin/bash ubuntu && \\
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Flutterのインストール
RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_\$FLUTTER_VERSION-stable.tar.xz \\
    && mkdir -p /usr/local/flutter \\
    && tar -xf flutter.tar.xz -C /usr/local/flutter --strip-components=1 \\
    && git config --global --add safe.directory /usr/local/flutter \\
    && rm flutter.tar.xz

# PATHの設定
ENV PATH="/usr/local/flutter/bin:\$PATH"

# Flutterの初期設定
RUN flutter doctor --android-licenses || true && flutter doctor || true

# Katana CLIのインストール
RUN flutter pub global activate katana_cli

# グローバルパッケージのPATH追加
ENV PATH="\$PATH:/home/ubuntu/.pub-cache/bin"

# ubuntuユーザーに切り替え
USER ubuntu

# ワークディレクトリの設定
WORKDIR /home/ubuntu

# .pub-cacheディレクトリの所有権設定
RUN mkdir -p /home/ubuntu/.pub-cache

# Gitの基本設定
RUN git config --global init.defaultBranch main

# 動作確認
RUN flutter --version && katana --version || echo "Setup complete"

CMD ["/bin/bash"]
""";
  }
}
