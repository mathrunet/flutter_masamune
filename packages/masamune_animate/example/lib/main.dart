// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune_animate/masamune_animate.dart";

/// Entry point of the application.
///
/// Initializes and runs the Masamune Animate example app.
///
/// アプリケーションのエントリーポイント。
///
/// Masamune Animateサンプルアプリを初期化し実行します。
void main() {
  runApp(const MyApp());
}

/// Root application widget.
///
/// Sets up the MaterialApp with basic theming and navigation.
///
/// ルートアプリケーションウィジェット。
///
/// 基本的なテーマとナビゲーションを設定したMaterialAppをセットアップします。
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  ///
  /// [MyApp]を作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

/// Main page widget for demonstrating Masamune Animate functionality.
///
/// This page showcases the AnimateScope widget with a simple opacity animation
/// that continuously fades in and out a red colored box.
///
/// Masamune Animateの機能を実演するメインページウィジェット。
///
/// このページはAnimateScopeウィジェットを使用して、赤い色付きボックスが
/// 継続的にフェードイン・フェードアウトするシンプルな透明度アニメーションを実演します。
class MainPage extends StatefulWidget {
  /// Creates a [MainPage].
  ///
  /// [MainPage]を作成します。
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => MainPageState();
}

/// State class for [MainPage].
///
/// Manages the animation demonstration using AnimateScope.
///
/// [MainPage]のStateクラス。
///
/// AnimateScopeを使用してアニメーションデモンストレーションを管理します。
class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Masamune Animate Example"),
      ),
      body: Center(
        child: SizedBox(
          width: 256,
          height: 256,
          child: AnimateScope(
            repeat: true,
            autoPlay: true,
            scenario: (runner) async {
              // Fade in animation
              await runner.opacity(
                duration: const Duration(seconds: 1),
                begin: 0.0,
                end: 1.0,
              );
              // Wait for 1 second
              await runner.wait(const Duration(seconds: 1));
              // Fade out animation
              await runner.opacity(
                duration: const Duration(seconds: 1),
                begin: 1.0,
                end: 0.0,
              );
            },
            child: const ColoredBox(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
