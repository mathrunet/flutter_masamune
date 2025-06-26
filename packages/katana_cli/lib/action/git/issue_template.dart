// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Create an issue template.
///
/// Issueテンプレートを作成します。
class GitIssueTemplateCliAction extends CliCommand with CliActionMixin {
  /// Create an issue template.
  ///
  /// Issueテンプレートを作成します。
  const GitIssueTemplateCliAction();

  @override
  String get description => "Create an issue template. Issueテンプレートを作成します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("github").getAsMap("issue_template");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    label("Create issue_template.");
    final gitDir = await findGitDirectory(Directory.current);
    await GitCreateAppIssueTemplateCliCode(
      workingDirectory: gitDir,
    ).generateFile(
      "01_create_app.yaml",
    );
    await GitNewFeatureIssueTemplateCliCode(
      workingDirectory: gitDir,
    ).generateFile(
      "02_new_feature.yaml",
    );
    await GitEnhancementIssueTemplateCliCode(
      workingDirectory: gitDir,
    ).generateFile(
      "03_enhancement.yaml",
    );
    await GitBugReportIssueTemplateCliCode(
      workingDirectory: gitDir,
    ).generateFile(
      "04_bug_report.yaml",
    );
    await GitQuestionIssueTemplateCliCode(
      workingDirectory: gitDir,
    ).generateFile(
      "05_question.yaml",
    );
    await GitConfigIssueTemplateCliCode(
      workingDirectory: gitDir,
    ).generateFile(
      "config.yaml",
    );
  }
}

/// Create an issue template.
///
/// Create an issue template.
class GitCreateAppIssueTemplateCliCode extends CliCode {
  /// Create an issue template.
  ///
  /// Issueテンプレートを作成します。
  const GitCreateAppIssueTemplateCliCode({
    this.workingDirectory,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  @override
  String get name => "01_create_app";

  @override
  String get prefix => "01_create_app";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/ISSUE_TEMPLATE";
  }

  @override
  String get description =>
      "Create an Issue template for app creation. アプリ作成用のIssueテンプレートを作成します。";

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
name: 📲 新規アプリの作成
description: 新しいアプリを作成する際に使用してください
title: "[新規] "
labels: ["enhancement", "new-feature"]
body:
  - type: markdown
    attributes:
      value: |
        ## 新規アプリ作成依頼

        この テンプレートは新しいアプリを作成する際に使用してください。
        Masamuneフレームワークの設計手順に従って実装を行います。
  
  - type: checkboxes
    id: feature-type
    attributes:
      label: 実施対象（複数選択可）
      description: 実施が必要なコンポーネントを選択してください
      options:
        - label: Page設計書の作成
        - label: Model設計書の作成
        - label: Theme設計書の作成
        - label: MetaData設計書の作成
        - label: Plugin設計書の作成
        - label: Controller設計書の作成
        - label: Widget設計書の作成
        - label: MetaDataの実装
        - label: Pluginの実装
        - label: Themeの実装
        - label: Modelの実装
        - label: Controllerの実装
        - label: Widgetの実装
        - label: Pageの実装
        - label: Routerの実装
        - label: モックデータの実装
        - label: Controllerのテストの実装
        - label: Widgetのテストの実装
        - label: Pageのテストの実装

  - type: textarea
    id: requirements
    attributes:
      label: 要件定義
      description: 実装に必要な詳細な要件を記載してください
      placeholder: |
        ## 機能要件
        - [ ] 機能1の説明
        - [ ] 機能2の説明
        
        ## 非機能要件
        - [ ] パフォーマンス要件
        - [ ] セキュリティ要件
        
        ## UI/UX要件
        - [ ] デザイン要件
        - [ ] ユーザビリティ要件
    validations:
      required: true

  - type: textarea
    id: additional-info
    attributes:
      label: 補足情報
      description: その他の重要な情報があれば記載してください
      placeholder: |
        - 参考資料のURL
        - 関連するIssueのリンク
        - 技術的な制約
        - 外部依存関係 

  - type: textarea
    id: instructions
    attributes:
      label: 作業実施の手順やルール
      description: ClaudeCodeに依頼する作業実施の手順やルールを記載してください
      value: |
        @claude
        下記の手順やルールに従って、上記の内容の実施を行ってください。

        ### 作業実施のルール
        - FlutterおよびMasamuneフレームワークのルールに従って実施。
        - `requirements.md`の代わりに上記の要件定義を参考にアプリケーションの開発を実施。
        - `設計書`の作成手順は`documents/rules/designs/**/*.md`を参考に実施。
        - `実装`の手順は`documents/rules/impls/**/*.md`を参考に実施。
        - `テスト`の手順は`documents/rules/tests/**/*.md`を参考に実施。
        - その他、FlutterおよびMasamuneフレームワークの実装のルールや手順については`documents/rules/docs/**/*.md`を参考にする。
        - コーディングについては`flutter analyze && dart run custom_lint`を実行しながらErrorやWarningが発生しないように開発を実施。
        - PageやWidgetはのアプリケーションUIについては`katana test update`を実行してスクリーンショット画像を作成し、それを確認しながら開発を実施。
        - 変更のコミットは`katana git commit`を利用して実施。
        - PRの作成は`katana git pull_request`、PRへのコメントは`katana git pull_request_comment`を利用して実施。

        ### 作業実施の手順

        1. `documents/rules/designs/design.md`を参考に要件定義から各種設計書を作成。
        2. 作成した各種設計書を元に`documents/rules/impls/impls.md`を参考にしながらアプリケーションの開発を実施。
        3. `documents/rules/tests/tests.md`を参考にしながら各種テストを実施。
        4. `flutter analyze && dart run custom_lint`を実行してErrorやWarningがないか確認。ErrorやWarningが発生していた場合は修正を実施して再度実行。ErrorやWarningがなくなるまで繰り返す。
        5. `katana test update`を実行してゴールデンテスト用のスクリーンショット画像を作成。
        6. `katana test run`を実行してテストが全てパスするか確認。
        7. `katana git commit`を実行して変更をコミット。
        8. `katana git pull_request`を実行してPRを作成、既存のPRがある場合は`katana git pull_request_comment`でコメントを追加。
    validations:
      required: true
""";
  }
}

/// Create an issue template.
///
/// Create an issue template.
class GitNewFeatureIssueTemplateCliCode extends CliCode {
  /// Create an issue template.
  ///
  /// Issueテンプレートを作成します。
  const GitNewFeatureIssueTemplateCliCode({
    this.workingDirectory,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  @override
  String get name => "02_new_feature";

  @override
  String get prefix => "02_new_feature";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/ISSUE_TEMPLATE";
  }

  @override
  String get description =>
      "Create an Issue template for new feature. 新機能追加用のIssueテンプレートを作成します。";

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
name: 🚀 新規機能の追加
description: 新しい機能やページを作成・追加する際に使用してください
title: "[機能追加] "
labels: ["enhancement", "new-feature"]
body:
  - type: markdown
    attributes:
      value: |
        ## 新規機能追加依頼

        この テンプレートは新しい機能やページを追加する際に使用してください。
        Masamuneフレームワークの設計手順に従って実装を行います。

  - type: textarea
    id: requirements
    attributes:
      label: 要件定義
      description: 実装に必要な詳細な要件を記載してください
      placeholder: |
        ## 機能要件
        - [ ] 機能1の説明
        - [ ] 機能2の説明
        
        ## 非機能要件
        - [ ] パフォーマンス要件
        - [ ] セキュリティ要件
        
        ## UI/UX要件
        - [ ] デザイン要件
        - [ ] ユーザビリティ要件
    validations:
      required: true

  - type: textarea
    id: additional-info
    attributes:
      label: 補足情報
      description: その他の重要な情報があれば記載してください
      placeholder: |
        - 参考資料のURL
        - 関連するIssueのリンク
        - 技術的な制約
        - 外部依存関係 

  - type: textarea
    id: instructions
    attributes:
      label: 作業実施の手順やルール
      description: ClaudeCodeに依頼する作業実施の手順やルールを記載してください
      value: |
        @claude
        下記の手順やルールに従って、上記の内容の実施を行ってください。

        ### 作業実施のルール
        - FlutterおよびMasamuneフレームワークのルールに従って実施。
        - `requirements.md`の代わりに上記の要件定義を参考にアプリケーションの開発を実施。
        - `設計書`の作成手順は`documents/rules/designs/**/*.md`を参考に実施。
        - `実装`の手順は`documents/rules/impls/**/*.md`を参考に実施。
        - `テスト`の手順は`documents/rules/tests/**/*.md`を参考に実施。
        - その他、FlutterおよびMasamuneフレームワークの実装のルールや手順については`documents/rules/docs/**/*.md`を参考にする。
        - コーディングについては`flutter analyze && dart run custom_lint`を実行しながらErrorやWarningが発生しないように開発を実施。
        - PageやWidgetはのアプリケーションUIについては`katana test update`を実行してスクリーンショット画像を作成し、それを確認しながら開発を実施。
        - 変更のコミットは`katana git commit`を利用して実施。
        - PRの作成は`katana git pull_request`、PRへのコメントは`katana git pull_request_comment`を利用して実施。

        ### 作業実施の手順

        1. 要件定義から実装を実施。
            - 実装中に`flutter analyze && dart run custom_lint`や`katana test update`を実行してエラーがないか確認しながら１つずつ実装。
        2. `flutter analyze && dart run custom_lint`を実行してErrorやWarningがないか確認。ErrorやWarningが発生していた場合は修正を実施して再度実行。ErrorやWarningがなくなるまで繰り返す。
        3. 画面の作成や変更を行った場合は`katana test update`を実行してゴールデンテスト用のスクリーンショット画像を更新。
        4. `katana test run`を実行してテストが全てパスするか確認。
        5. `katana git commit`を実行して変更をコミット。
        6. `katana git pull_request`を実行してPRを作成、既存のPRがある場合は`katana git pull_request_comment`でコメントを追加。
    validations:
      required: true
""";
  }
}

/// Create an issue template.
///
/// Create an issue template.
class GitEnhancementIssueTemplateCliCode extends CliCode {
  /// Create an issue template.
  ///
  /// Issueテンプレートを作成します。
  const GitEnhancementIssueTemplateCliCode({
    this.workingDirectory,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  @override
  String get name => "03_enhancement";

  @override
  String get prefix => "03_enhancement";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/ISSUE_TEMPLATE";
  }

  @override
  String get description =>
      "Create an Issue template for enhancement. 機能改善用のIssueテンプレートを作成します。";

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
name: ✨ 機能改修・改善
description: 既存の機能を改修・改善する際に使用してください
title: "[改修] "
labels: ["enhancement", "improvement"]
body:
  - type: markdown
    attributes:
      value: |
        ## 機能改修・改善依頼

        このテンプレートは既存の機能やページを改修・改善する際に使用してください。
        変更内容とその影響範囲を明確にして実装を行います。

  - type: input
    id: target-feature
    attributes:
      label: 対象機能
      description: 改修対象の機能名やファイル名を入力してください
      placeholder: "例: ユーザープロフィール画面 (lib/pages/user/my.dart)"
    validations:
      required: true

  - type: textarea
    id: current-behavior
    attributes:
      label: 現在の動作
      description: 現在の機能の動作や状態を詳しく説明してください
      placeholder: |
        現在の動作:
        - 現在どのように動作しているか
        - 現在の問題点
        - 改善したい箇所
    validations:
      required: true

  - type: textarea
    id: desired-behavior
    attributes:
      label: 期待する動作
      description: 改修後にどのような動作になってほしいかを詳しく説明してください
      placeholder: |
        期待する動作:
        - 改修後の理想的な動作
        - 解決すべき課題
        - ユーザーへの影響
    validations:
      required: true

  - type: textarea
    id: additional-info
    attributes:
      label: 補足情報
      description: その他の重要な情報があれば記載してください
      placeholder: |
        - 参考資料のURL
        - 関連するIssueのリンク
        - 技術的な制約
        - 外部依存関係の変更 

  - type: textarea
    id: instructions
    attributes:
      label: 作業実施の手順やルール
      description: ClaudeCodeに依頼する作業実施の手順やルールを記載してください
      value: |
        @claude
        下記の手順やルールに従って、上記の内容の実施を行ってください。

        ### 作業実施のルール
        - FlutterおよびMasamuneフレームワークのルールに従って実施。
        - `requirements.md`の代わりに上記の要件定義を参考にアプリケーションの開発を実施。
        - `設計書`の作成手順は`documents/rules/designs/**/*.md`を参考に実施。
        - `実装`の手順は`documents/rules/impls/**/*.md`を参考に実施。
        - `テスト`の手順は`documents/rules/tests/**/*.md`を参考に実施。
        - その他、FlutterおよびMasamuneフレームワークの実装のルールや手順については`documents/rules/docs/**/*.md`を参考にする。
        - コーディングについては`flutter analyze && dart run custom_lint`を実行しながらErrorやWarningが発生しないように開発を実施。
        - PageやWidgetはのアプリケーションUIについては`katana test update`を実行してスクリーンショット画像を作成し、それを確認しながら開発を実施。
        - 変更のコミットは`katana git commit`を利用して実施。
        - PRの作成は`katana git pull_request`、PRへのコメントは`katana git pull_request_comment`を利用して実施。

        ### 作業実施の手順

        1. 上記要件から改修を実施。
            - 実装中に`flutter analyze && dart run custom_lint`や`katana test update`を実行してエラーがないか確認しながら１つずつ実装。
        2. `flutter analyze && dart run custom_lint`を実行してErrorやWarningがないか確認。ErrorやWarningが発生していた場合は修正を実施して再度実行。ErrorやWarningがなくなるまで繰り返す。
        3. 画面の作成や変更を行った場合は`katana test update`を実行してゴールデンテスト用のスクリーンショット画像を更新。
        4. `katana test run`を実行してテストが全てパスするか確認。
        5. `katana git commit`を実行して変更をコミット。
        6. `katana git pull_request`を実行してPRを作成、既存のPRがある場合は`katana git pull_request_comment`でコメントを追加。
    validations:
      required: true
""";
  }
}

/// Create an issue template.
///
/// Create an issue template.
class GitBugReportIssueTemplateCliCode extends CliCode {
  /// Create an issue template.
  ///
  /// Issueテンプレートを作成します。
  const GitBugReportIssueTemplateCliCode({
    this.workingDirectory,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  @override
  String get name => "04_bug_report";

  @override
  String get prefix => "04_bug_report";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/ISSUE_TEMPLATE";
  }

  @override
  String get description =>
      "Create an Issue template for bug report. バグ報告用のIssueテンプレートを作成します。";

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
name: 🐛 バグ報告・修正
description: バグを発見した場合や修正を依頼する際に使用してください
title: "[バグ修正] "
labels: ["bug"]
body:
  - type: markdown
    attributes:
      value: |
        ## バグ報告・修正依頼

        このテンプレートはバグを発見した場合や修正を依頼する際に使用してください。
        詳細な情報を提供することで、迅速な問題解決が可能になります。

  - type: textarea
    id: bug-description
    attributes:
      label: バグの概要
      description: 発生しているバグについて簡潔に説明してください
      placeholder: "例: ユーザープロフィール画面で保存ボタンを押してもデータが保存されない"
    validations:
      required: true

  - type: textarea
    id: steps-to-reproduce
    attributes:
      label: 再現手順
      description: バグを再現するための詳細な手順を記載してください
      placeholder: |
        1. アプリを起動する
        2. ユーザープロフィール画面に移動する
        3. 名前フィールドを編集する
        4. 保存ボタンをタップする
        5. エラーが発生する
    validations:
      required: true

  - type: textarea
    id: expected-behavior
    attributes:
      label: 期待される動作
      description: 正常な場合にどのような動作をするべきかを記載してください
      placeholder: "保存ボタンをタップした際に、編集した内容が正常に保存され、成功メッセージが表示される"
    validations:
      required: true

  - type: textarea
    id: actual-behavior
    attributes:
      label: 実際の動作
      description: 実際に発生している動作を詳しく記載してください
      placeholder: "保存ボタンをタップしても何も反応せず、データも保存されない。エラーメッセージも表示されない。"
    validations:
      required: true

  - type: checkboxes
    id: affected-platforms
    attributes:
      label: 影響を受けるプラットフォーム
      description: バグが発生するプラットフォームを選択してください
      options:
        - label: iOS
        - label: Android
        - label: Web
        - label: macOS
        - label: Windows
        - label: Linux

  - type: textarea
    id: environment
    attributes:
      label: 環境情報
      description: バグが発生している環境の詳細を記載してください
      placeholder: |
        ## デバイス情報
        - OS: iOS 17.0 / Android 14 / etc
        - デバイス: iPhone 15 Pro / Pixel 8 / etc
        - アプリバージョン: v1.0.0
        
        ## Flutter環境
        - Flutter バージョン: 3.x.x
        - Dart バージョン: 3.x.x
        
        ## その他
        - ネットワーク環境: WiFi / 4G / 5G
        - 特記事項: ___________

  - type: textarea
    id: error-logs
    attributes:
      label: エラーログ・スタックトレース
      description: 関連するエラーログやスタックトレースがあれば貼り付けてください
      placeholder: |
        ```
        ここにエラーログやスタックトレースを貼り付けてください
        ```

  - type: textarea
    id: screenshots
    attributes:
      label: スクリーンショット・画面録画
      description: バグの状況がわかるスクリーンショットや画面録画があれば添付してください
      placeholder: |
        スクリーンショットやGIFファイルをドラッグ&ドロップで添付できます。
        
        または以下のように記載してください:
        ![バグの状況](URL)

  - type: textarea
    id: additional-context
    attributes:
      label: 補足情報
      description: その他のバグに関する重要な情報があれば記載してください
      placeholder: |
        - 関連するIssueのリンク
        - 外部サービスとの連携に関する問題
        - ユーザーからの報告頻度
        - ビジネスへの影響

  - type: textarea
    id: instructions
    attributes:
      label: 作業実施の手順やルール
      description: ClaudeCodeに依頼する作業実施の手順やルールを記載してください
      value: |
        @claude
        下記の手順やルールに従って、上記の内容の実施を行ってください。

        ### 作業実施のルール
        - FlutterおよびMasamuneフレームワークのルールに従って実施。
        - `requirements.md`の代わりに上記の要件定義を参考にアプリケーションの開発を実施。
        - `設計書`の作成手順は`documents/rules/designs/**/*.md`を参考に実施。
        - `実装`の手順は`documents/rules/impls/**/*.md`を参考に実施。
        - `テスト`の手順は`documents/rules/tests/**/*.md`を参考に実施。
        - その他、FlutterおよびMasamuneフレームワークの実装のルールや手順については`documents/rules/docs/**/*.md`を参考にする。
        - コーディングについては`flutter analyze && dart run custom_lint`を実行しながらErrorやWarningが発生しないように開発を実施。
        - PageやWidgetはのアプリケーションUIについては`katana test update`を実行してスクリーンショット画像を作成し、それを確認しながら開発を実施。
        - 変更のコミットは`katana git commit`を利用して実施。
        - PRの作成は`katana git pull_request`、PRへのコメントは`katana git pull_request_comment`を利用して実施。

        ### 作業実施の手順

        1. 上記要件から改修を実施。
            - 実装中に`flutter analyze && dart run custom_lint`や`katana test update`を実行してエラーがないか確認しながら１つずつ実装。
        2. `flutter analyze && dart run custom_lint`を実行してErrorやWarningがないか確認。ErrorやWarningが発生していた場合は修正を実施して再度実行。ErrorやWarningがなくなるまで繰り返す。
        3. 画面の作成や変更を行った場合は`katana test update`を実行してゴールデンテスト用のスクリーンショット画像を更新。
        4. `katana test run`を実行してテストが全てパスするか確認。
        5. `katana git commit`を実行して変更をコミット。
        6. `katana git pull_request`を実行してPRを作成、既存のPRがある場合は`katana git pull_request_comment`でコメントを追加。
    validations:
      required: true
""";
  }
}

/// Create an issue template.
///
/// Create an issue template.
class GitQuestionIssueTemplateCliCode extends CliCode {
  /// Create an issue template.
  ///
  /// Issueテンプレートを作成します。
  const GitQuestionIssueTemplateCliCode({
    this.workingDirectory,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  @override
  String get name => "05_question";

  @override
  String get prefix => "05_question";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/ISSUE_TEMPLATE";
  }

  @override
  String get description =>
      "Create an Issue template for question. 質問用のIssueテンプレートを作成します。";

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
name: ❓ 質問・技術相談
description: コードの内容や技術的な質問がある際に使用してください
title: "[質問] "
labels: ["question", "discussion"]
body:
  - type: markdown
    attributes:
      value: |
        ## 質問・技術相談

        このテンプレートはコードの内容や技術的な質問がある際に使用してください。
        詳細な情報を提供することで、適切な回答やサポートを受けることができます。

  - type: textarea
    id: detailed-question
    attributes:
      label: 質問内容
      description: 質問の詳細な内容と背景を記載してください
      placeholder: |
        ## 質問の背景
        現在実装している機能の説明
        
        ## 具体的に知りたいこと
        - 疑問点1
        - 疑問点2
        
        ## 試したこと
        - 試行錯誤した内容
        - 参照したドキュメント
    validations:
      required: true

  - type: textarea
    id: additional-context
    attributes:
      label: 補足情報
      description: その他の重要な情報があれば記載してください
      placeholder: |
        - 関連するIssueのリンク
        - チーム内での議論内容
        - 外部サービスとの連携要件
        - セキュリティ要件

  - type: textarea
    id: instructions
    attributes:
      label: 作業実施の手順やルール
      description: ClaudeCodeに依頼する作業実施の手順やルールを記載してください
      value: |
        @claude
        上記の質問に対する回答を行ってください。
    validations:
      required: true
""";
  }
}

/// Create an issue template.
///
/// Create an issue template.
class GitConfigIssueTemplateCliCode extends CliCode {
  /// Create an issue template.
  ///
  /// Issueテンプレートを作成します。
  const GitConfigIssueTemplateCliCode({
    this.workingDirectory,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  @override
  String get name => "config";

  @override
  String get prefix => "config";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create an issue template configuration file. Issueテンプレートの設定ファイルを作成します。";

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
blank_issues_enabled: false
contact_links:
  - name: 🖥️ mathru.net
    url: https://mathru.net/
    about: mathru.net
""";
  }
}
