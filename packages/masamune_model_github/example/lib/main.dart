// Dart imports:

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";

/// List of Masamune adapters for the application.
///
/// アプリケーション用のMasamuneアダプターのリスト。
final List<MasamuneAdapter> masamuneAdapters = [];

/// Entry point of the application.
///
/// アプリケーションのエントリーポイント。
void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      title: "Flutter Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}
