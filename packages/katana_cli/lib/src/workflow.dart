import "package:katana_cli/katana_cli.dart";

/// Packages of Masamune workflows.
///
/// Masamuneワークフローパッケージ。
enum MasamuneWorkflowPackage {
  /// Masamune workflow asset package.
  ///
  /// Masamuneワークフローアセットパッケージ。
  masamuneWorkflowAsset(
      id: "masamune_workflow_asset", prefix: "workflow_asset"),

  /// Masamune workflow marketing package.
  ///
  /// Masamuneワークフローマーケティングパッケージ。
  masamuneWorkflowMarketing(
      id: "masamune_workflow_marketing", prefix: "workflow_marketing"),

  /// Masamune workflow sales package.
  ///
  /// Masamuneワークフローセールスパッケージ。
  masamuneWorkflowSales(
      id: "masamune_workflow_sales", prefix: "workflow_sales");

  const MasamuneWorkflowPackage({
    required this.id,
    required this.prefix,
  });

  /// Label of the package.
  ///
  /// パッケージのラベル。
  final String id;

  /// Prefix of the package.
  ///
  /// パッケージのプレフィックス。
  final String prefix;

  /// Apply import to the functions.
  ///
  /// 関数にインポートを適用します。
  Functions applyImport(ExecContext context, Functions functions) {
    if (!functions.imports.any((e) => e.contains("@mathrunet/$id"))) {
      functions.imports.add("import * as $prefix from \"@mathrunet/$id\";");
    }
    return functions;
  }
}

/// Types of Masamune workflows.
///
/// Masamuneワークフローの種類。
enum MasamuneWorkflowType {
  /// Generate audio with Google TTS.
  ///
  /// Google TTSを使用して音声を生成します。
  generateAudioWithGoogleTTS(
      id: "generate_audio_with_google_tts",
      package: MasamuneWorkflowPackage.masamuneWorkflowAsset),

  /// Generate image with Gemini.
  ///
  /// Geminiを使用して画像を生成します。
  generateImageWithGemini(
      id: "generate_image_with_gemini",
      package: MasamuneWorkflowPackage.masamuneWorkflowAsset),

  /// Research market.
  ///
  /// 市場調査を行います。
  researchMarket(
      id: "research_market",
      package: MasamuneWorkflowPackage.masamuneWorkflowMarketing),

  /// Collect from App Store.
  ///
  /// App Storeからデータを収集します。
  collectFromAppStore(
      id: "collect_from_app_store",
      package: MasamuneWorkflowPackage.masamuneWorkflowMarketing),

  /// Collect from Google Play Console.
  ///
  /// Google Play Consoleからデータを収集します。
  collectFromGooglePlayConsole(
      id: "collect_from_google_play_console",
      package: MasamuneWorkflowPackage.masamuneWorkflowMarketing),

  /// Collect from Firebase Analytics.
  ///
  /// Firebase Analyticsからデータを収集します。
  collectFromFirebaseAnalytics(
      id: "collect_from_firebase_analytics",
      package: MasamuneWorkflowPackage.masamuneWorkflowMarketing),

  /// Analyze marketing data.
  ///
  /// マーケティングデータを分析します。
  analyzeMarketingData(
      id: "analyze_marketing_data",
      package: MasamuneWorkflowPackage.masamuneWorkflowMarketing),

  /// Analyze GitHub.
  ///
  /// GitHubのデータを分析します。
  analyzeGithub(
      id: "analyze_github",
      package: MasamuneWorkflowPackage.masamuneWorkflowMarketing),

  /// Analyze market research.
  ///
  /// 市場調査のデータを分析します。
  analyzeMarketResearch(
      id: "analyze_market_research",
      package: MasamuneWorkflowPackage.masamuneWorkflowMarketing),

  /// Generate marketing PDF.
  ///
  /// マーケティングデータをPDF形式で生成します。
  generateMarketingPdf(
      id: "generate_marketing_pdf",
      package: MasamuneWorkflowPackage.masamuneWorkflowMarketing),

  /// Generate marketing Markdown.
  ///
  /// マーケティングデータをMarkdown形式で生成します。
  generateMarketingMarkdown(
      id: "generate_marketing_markdown",
      package: MasamuneWorkflowPackage.masamuneWorkflowMarketing),

  /// Collect Google Play developers.
  ///
  /// Google Playの開発者情報を収集します。
  collectGooglePlayDevelopers(
      id: "collect_google_play_developers",
      package: MasamuneWorkflowPackage.masamuneWorkflowSales),

  /// Collect App Store developers.
  ///
  /// App Storeの開発者情報を収集します。
  collectAppStoreDevelopers(
      id: "collect_app_store_developers",
      package: MasamuneWorkflowPackage.masamuneWorkflowSales);

  /// Masamune workflow type.
  ///
  /// Masamuneワークフローの種類。
  const MasamuneWorkflowType({
    required this.id,
    required this.package,
  });

  /// Label of the workflow.
  ///
  /// ワークフローのラベル。
  final String id;

  /// Package of the workflow.
  ///
  /// ワークフローパッケージ。
  final MasamuneWorkflowPackage package;

  /// Whether the workflow is enabled.
  ///
  /// ワークフローが有効かどうか。
  bool enabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final workflow = firebase.getAsMap("workflow");
    return workflow.getAsMap(id).get("enable", false);
  }

  /// Get packages of enabled workflows.
  ///
  /// 有効なワークフローパッケージを取得します。
  static Set<MasamuneWorkflowPackage> getPackages(ExecContext context) {
    final packages = <MasamuneWorkflowPackage>{};
    for (final type in MasamuneWorkflowType.values) {
      final enabled = type.enabled(context);
      if (!enabled) {
        continue;
      }
      packages.add(type.package);
    }
    return packages;
  }

  /// Apply imports to the functions.
  ///
  /// 関数にインポートを適用します。
  static Functions applyImport(ExecContext context, Functions functions) {
    final packages = getPackages(context);
    for (final package in packages) {
      functions = package.applyImport(context, functions);
    }
    return functions;
  }

  /// Apply functions to the functions.
  ///
  /// 関数に関数を適用します。
  static Functions applyFunctions(ExecContext context, Functions functions) {
    for (final type in MasamuneWorkflowType.values) {
      final enabled = type.enabled(context);
      if (!enabled) {
        continue;
      }
      final package = type.package;
      switch (type) {
        default:
          functions.functions
              .add("${package.prefix}.Functions.${type.name}();");
          break;
      }
    }
    return functions;
  }
}
