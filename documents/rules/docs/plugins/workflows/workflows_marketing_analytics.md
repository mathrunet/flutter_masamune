# マーケティング分析機能

このドキュメントでは、Masamune Workflowのマーケティング分析機能について詳しく説明します。
アプリストアやFirebase Analyticsからのデータ収集、AIによる分析、GitHub活動の解析、市場調査などの機能を提供します。

## 概要

マーケティング分析機能は、データドリブンな意思決定を支援する以下の機能群を提供します：

1. **アプリストアデータ収集**: Google Play ConsoleとApp Store Connectからのメトリクス取得
2. **Firebase Analytics連携**: ユーザー行動データの収集と分析
3. **AI分析機能**: 収集データの自動分析とインサイト生成
4. **GitHub解析**: 開発活動とコミュニティの分析
5. **市場調査**: Perplexity APIを使用した市場トレンド調査

これらの機能により、アプリのパフォーマンス、ユーザー行動、市場動向を総合的に把握できます。

## アプリストアデータ収集

### collect_from_google_play_console

Google Play Console APIを使用して、アプリのパフォーマンスデータを収集します。

**アクションID**: `collect_from_google_play_console`

### パラメータ

```typescript
{
  "packageName": string,        // 必須: アプリのパッケージ名
  "startDate": string,         // 必須: データ収集開始日（YYYY-MM-DD）
  "endDate": string,           // 必須: データ収集終了日（YYYY-MM-DD）
  "metrics": string[],         // 任意: 収集するメトリクス
  "dimensions": string[]       // 任意: データのディメンション
}
```

### 収集可能なメトリクス

| メトリクス | 説明 | データ型 |
|-----------|------|---------|
| installs | インストール数 | 数値 |
| uninstalls | アンインストール数 | 数値 |
| ratings | 評価 | 数値（1-5） |
| reviews | レビュー | テキスト配列 |
| revenue | 収益 | 金額 |
| crashes | クラッシュレポート | 詳細情報 |
| anrs | ANR（アプリ応答なし） | 詳細情報 |

### ディメンション

- `country` - 国別
- `device` - デバイス別
- `os_version` - OSバージョン別
- `app_version` - アプリバージョン別
- `carrier` - 通信キャリア別

### レスポンス

```typescript
{
  "status": "success",
  "data": {
    "installs": {
      "total": 50000,
      "daily_average": 500,
      "trend": "increasing",
      "by_country": {
        "JP": 30000,
        "US": 15000,
        "KR": 5000
      }
    },
    "ratings": {
      "average": 4.5,
      "total_count": 1200,
      "distribution": {
        "5": 600,
        "4": 400,
        "3": 150,
        "2": 30,
        "1": 20
      },
      "recent_trend": 4.7
    },
    "reviews": [
      {
        "rating": 5,
        "text": "素晴らしいアプリです！",
        "date": "2024-01-15",
        "language": "ja",
        "device": "Pixel 7",
        "app_version": "2.1.0",
        "reply": "ありがとうございます！"
      }
    ],
    "revenue": {
      "total": 10000,
      "currency": "USD",
      "monthly_trend": [800, 900, 1000, 1200, 1500],
      "by_product": {
        "premium": 7000,
        "subscription": 3000
      }
    },
    "crashes": {
      "crash_rate": 0.02,
      "affected_users": 100,
      "top_issues": [
        {
          "error": "NullPointerException",
          "occurrences": 45,
          "affected_versions": ["2.0.5", "2.0.6"]
        }
      ]
    }
  }
}
```

### 実装例

```dart
// Google Play Consoleからデータを収集
final action = await ref.app.model(
  ActionModel.collection().create({
    "type": "collect_from_google_play_console",
    "data": {
      "packageName": "com.example.app",
      "startDate": "2024-01-01",
      "endDate": "2024-12-31",
      "metrics": ["installs", "ratings", "revenue", "crashes"],
      "dimensions": ["country", "device", "app_version"]
    }
  }),
);

// 収集データの処理
final data = action.response["data"];
print("総インストール数: ${data['installs']['total']}");
print("平均評価: ${data['ratings']['average']}");
print("総収益: ${data['revenue']['total']} ${data['revenue']['currency']}");
```

### collect_from_app_store

App Store Connect APIを使用して、iOS/iPadOSアプリのデータを収集します。

**アクションID**: `collect_from_app_store`

### パラメータ

```typescript
{
  "appId": string,              // 必須: App Store Connect内のアプリID
  "vendorNumber": string,       // 必須: ベンダー番号
  "startDate": string,         // 必須: データ収集開始日
  "endDate": string,           // 必須: データ収集終了日
  "metrics": string[],         // 任意: 収集するメトリクス
  "territories": string[]      // 任意: 対象地域（ISO 3166-1 alpha-2）
}
```

### レスポンス例

```typescript
{
  "status": "success",
  "data": {
    "downloads": {
      "total": 45000,
      "daily_average": 450,
      "trend": "stable"
    },
    "ratings": {
      "average": 4.7,
      "total_count": 980,
      "by_territory": {
        "US": 4.6,
        "JP": 4.8,
        "GB": 4.7
      }
    },
    "revenue": {
      "total": 12000,
      "currency": "USD",
      "by_territory": {
        "US": 6000,
        "JP": 3000,
        "GB": 3000
      }
    }
  }
}
```

### collect_from_firebase_analytics

Firebase Analytics APIを使用して、ユーザー行動データを収集します。

**アクションID**: `collect_from_firebase_analytics`

### パラメータ

```typescript
{
  "propertyId": string,         // 必須: Google Analytics 4プロパティID
  "startDate": string,         // 必須: データ収集開始日
  "endDate": string,           // 必須: データ収集終了日
  "metrics": string[],         // 任意: 収集するメトリクス
  "dimensions": string[]       // 任意: データのディメンション
}
```

### 収集可能なメトリクス

| メトリクス | 説明 |
|-----------|------|
| activeUsers | アクティブユーザー数 |
| newUsers | 新規ユーザー数 |
| sessions | セッション数 |
| screenViews | 画面表示数 |
| engagementTime | エンゲージメント時間 |
| eventCount | イベント数 |
| conversions | コンバージョン数 |
| revenue | 収益 |

### 実装例

```dart
// Firebase Analyticsデータの収集と分析
final workflow = WorkflowWorkflowModel(
  name: "月次分析レポート",
  actions: [
    // データ収集
    WorkflowActionCommandValue(
      command: "collect_from_firebase_analytics",
      data: {
        "propertyId": "123456789",
        "startDate": "2024-01-01",
        "endDate": "2024-01-31",
        "metrics": [
          "activeUsers",
          "sessions",
          "engagementTime",
          "conversions"
        ],
        "dimensions": ["country", "platform", "userType"]
      }
    ),
    // AI分析
    WorkflowActionCommandValue(
      command: "analyze_marketing_data",
      data: {
        "analysisType": "comprehensive"
      }
    )
  ]
);
```

## AI分析機能

### analyze_marketing_data

収集したマーケティングデータをAIで分析し、インサイトと改善提案を生成します。

**アクションID**: `analyze_marketing_data`

### パラメータ

```typescript
{
  "analysisType": string,      // 必須: 分析タイプ
  "timePeriod": string,        // 任意: 分析期間
  "comparisonPeriod": string,  // 任意: 比較期間
  "focusAreas": string[]       // 任意: 重点分析領域
}
```

### 分析タイプ

- `comprehensive` - 包括的分析
- `user_acquisition` - ユーザー獲得分析
- `retention` - リテンション分析
- `monetization` - 収益化分析
- `engagement` - エンゲージメント分析

### レスポンス

```typescript
{
  "status": "success",
  "analysis": {
    "summary": "アプリのパフォーマンスは全体的に向上傾向にあります。",
    "key_insights": [
      {
        "category": "user_acquisition",
        "insight": "オーガニック流入が前月比30%増加",
        "impact": "high",
        "trend": "positive",
        "data_points": {
          "current": 15000,
          "previous": 11500,
          "change": "+30.4%"
        }
      },
      {
        "category": "retention",
        "insight": "7日目リテンション率が35%（業界平均40%）",
        "impact": "high",
        "trend": "negative",
        "data_points": {
          "current": 0.35,
          "benchmark": 0.40,
          "gap": "-12.5%"
        }
      }
    ],
    "recommendations": [
      {
        "priority": "high",
        "category": "retention",
        "action": "オンボーディング体験の改善",
        "expected_impact": "7日目リテンション率を5-10%向上",
        "implementation": {
          "steps": [
            "チュートリアルを簡素化",
            "初回起動時の価値提供を明確化",
            "プログレスインジケーターの追加"
          ],
          "estimated_effort": "2週間",
          "required_resources": ["UIデザイナー", "開発者"]
        }
      }
    ],
    "predicted_metrics": {
      "next_month": {
        "installs": 18000,
        "revenue": 15000,
        "confidence": 0.85
      }
    }
  }
}
```

### generate_marketing_pdf

AI分析結果を基に、PDF形式のマーケティングレポートを生成します。

**アクションID**: `generate_marketing_pdf`

### パラメータ

```typescript
{
  "reportType": string,         // 必須: レポートタイプ
  "startDate": string,         // 必須: レポート期間開始日
  "endDate": string,           // 必須: レポート期間終了日
  "includeCharts": boolean,    // 任意: グラフを含めるか
  "includeRawData": boolean,   // 任意: 生データを含めるか
  "language": string           // 任意: レポート言語
}
```

### レポートタイプ

- `daily` - 日次レポート
- `weekly` - 週次レポート
- `monthly` - 月次レポート
- `quarterly` - 四半期レポート
- `annual` - 年次レポート

### 実装例

```dart
// 月次マーケティングレポートの生成
final reportAction = await ref.app.model(
  ActionModel.collection().create({
    "type": "generate_marketing_pdf",
    "data": {
      "reportType": "monthly",
      "startDate": "2024-01-01",
      "endDate": "2024-01-31",
      "includeCharts": true,
      "includeRawData": false,
      "language": "ja"
    }
  }),
);

// 生成されたレポートのURL取得
final reportUrl = reportAction.response["report"]["url"];
print("レポートURL: $reportUrl");
```

## GitHub解析機能

### analyze_github（3段階プロセス）

GitHubリポジトリの開発活動を分析します。大規模リポジトリに対応するため、3段階のプロセスで実行されます。

#### 1. analyze_github_init - 初期化

**アクションID**: `analyze_github_init`

```typescript
{
  "githubRepository": string,   // 必須: リポジトリ（owner/repo形式）
  "githubRepositoryPath": string, // 任意: 特定パスの分析
  "startDate": string,         // 任意: 分析開始日
  "endDate": string            // 任意: 分析終了日
}
```

#### 2. analyze_github_process - 処理

**アクションID**: `analyze_github_process`

```typescript
{
  "batchIndex": number         // 自動設定: バッチインデックス
}
```

#### 3. analyze_github_summary - サマリー生成

**アクションID**: `analyze_github_summary`

パラメータなし（自動的に前段階の結果を集計）

### レスポンス例

```typescript
{
  "status": "success",
  "githubAnalysis": {
    "repository": "owner/repo",
    "framework": "Flutter",
    "overview": {
      "stars": 1500,
      "forks": 200,
      "contributors": 45,
      "total_commits": 5000,
      "open_issues": 120,
      "open_prs": 15
    },
    "architecture": {
      "main_language": "Dart",
      "language_distribution": {
        "Dart": 75.5,
        "TypeScript": 15.3,
        "Swift": 5.2,
        "Kotlin": 4.0
      },
      "directory_structure": [
        "lib/",
        "test/",
        "android/",
        "ios/"
      ]
    },
    "activity": {
      "commits_per_day": 3.5,
      "peak_activity_hour": 14,
      "most_active_contributors": [
        {
          "username": "developer1",
          "commits": 450,
          "lines_added": 12000,
          "lines_deleted": 8000
        }
      ]
    },
    "features": [
      "状態管理: Riverpod",
      "ルーティング: GoRouter",
      "データベース: Firestore"
    ],
    "health_metrics": {
      "issue_resolution_time": "5.2 days",
      "pr_merge_time": "2.8 days",
      "test_coverage": 78.5,
      "documentation_score": 85
    }
  }
}
```

### 実装例

```dart
// GitHubリポジトリの包括的分析
final workflow = WorkflowWorkflowModel(
  name: "GitHub開発活動分析",
  actions: [
    // 1. 初期化
    WorkflowActionCommandValue(
      command: "analyze_github_init",
      data: {
        "githubRepository": "flutter/flutter",
        "githubRepositoryPath": "packages/flutter",
        "startDate": "2024-01-01",
        "endDate": "2024-12-31"
      }
    ),
    // 2. 処理（自動的に必要な回数実行）
    WorkflowActionCommandValue(
      command: "analyze_github_process",
      data: {} // batchIndexは自動設定
    ),
    // 3. サマリー生成
    WorkflowActionCommandValue(
      command: "analyze_github_summary",
      data: {}
    )
  ]
);

// 結果の活用
task.watch(
  onUpdate: (task) {
    if (task.value?.status == TaskStatus.completed) {
      final analysis = task.value?.response["githubAnalysis"];

      // 開発健全性のチェック
      final issueResolutionTime = analysis["health_metrics"]["issue_resolution_time"];
      if (parsedays(issueResolutionTime) > 7) {
        print("警告: Issue解決に時間がかかりすぎています");
      }

      // 活発な開発者の特定
      final topContributors = analysis["activity"]["most_active_contributors"];
      print("トップコントリビューター: ${topContributors[0]['username']}");
    }
  },
);
```

## 市場調査機能

### research_market

Perplexity APIを使用して、指定したトピックの市場調査を実行します。

**アクションID**: `research_market`

### パラメータ

```typescript
{
  "query": string,              // 必須: 調査クエリ
  "region": string,            // 任意: 調査地域
  "includeCompetitors": boolean // 任意: 競合分析を含めるか
}
```

### レスポンス

```typescript
{
  "status": "success",
  "marketResearch": {
    "marketPotential": {
      "size": "250億円",
      "growth_rate": "年間35%",
      "key_drivers": [
        "AI技術の普及",
        "リモートワークの定着",
        "デジタル化の加速"
      ]
    },
    "competitorAnalysis": {
      "main_competitors": [
        {
          "name": "競合A",
          "market_share": "15%",
          "strengths": ["ブランド力", "技術力"],
          "weaknesses": ["価格", "サポート"]
        }
      ],
      "market_gaps": [
        "中小企業向けソリューション",
        "多言語対応"
      ]
    },
    "businessOpportunities": [
      {
        "opportunity": "エンタープライズ市場への参入",
        "potential": "high",
        "requirements": ["セキュリティ強化", "SLA保証"],
        "estimated_revenue": "年間5000万円"
      }
    ],
    "trends": [
      "生成AIの統合が主流化",
      "プライバシー重視の高まり",
      "サブスクリプションモデルの普及"
    ]
  }
}
```

### analyze_market_research

市場調査結果を分析し、戦略的推奨事項を生成します。

**アクションID**: `analyze_market_research`

### 実装例

```dart
// 市場調査と戦略立案の完全なワークフロー
final workflow = WorkflowWorkflowModel(
  name: "四半期市場分析",
  actions: [
    // 1. 市場調査
    WorkflowActionCommandValue(
      command: "research_market",
      data: {
        "query": "AI搭載モバイルアプリ市場 2024",
        "region": "日本",
        "includeCompetitors": true
      }
    ),
    // 2. 調査結果の分析
    WorkflowActionCommandValue(
      command: "analyze_market_research",
      data: {}
    ),
    // 3. 戦略レポート生成
    WorkflowActionCommandValue(
      command: "generate_marketing_pdf",
      data: {
        "reportType": "quarterly",
        "includeCharts": true
      }
    )
  ]
);
```

## 統合分析ダッシュボード

### 複数データソースの統合

```dart
// 包括的なマーケティング分析ダッシュボード
class MarketingDashboard {
  final DatabaseReference ref;

  Future<Map<String, dynamic>> generateDashboard() async {
    // 並列でデータ収集
    final futures = await Future.wait([
      collectGooglePlayData(),
      collectAppStoreData(),
      collectFirebaseData(),
      analyzeGitHubActivity(),
      researchMarket()
    ]);

    // データ統合
    final integratedData = {
      "google_play": futures[0],
      "app_store": futures[1],
      "firebase": futures[2],
      "github": futures[3],
      "market": futures[4]
    };

    // AI分析
    final analysis = await analyzeIntegratedData(integratedData);

    // ダッシュボードデータ生成
    return {
      "kpis": generateKPIs(analysis),
      "charts": generateCharts(analysis),
      "insights": analysis["key_insights"],
      "recommendations": analysis["recommendations"],
      "alerts": generateAlerts(analysis)
    };
  }

  Map<String, dynamic> generateKPIs(Map<String, dynamic> analysis) {
    return {
      "total_users": analysis["users"]["total"],
      "monthly_revenue": analysis["revenue"]["monthly"],
      "app_rating": analysis["ratings"]["average"],
      "retention_7d": analysis["retention"]["day_7"],
      "crash_rate": analysis["stability"]["crash_rate"]
    };
  }

  List<Map<String, dynamic>> generateAlerts(Map<String, dynamic> analysis) {
    final alerts = <Map<String, dynamic>>[];

    // クラッシュ率のチェック
    if (analysis["stability"]["crash_rate"] > 0.01) {
      alerts.add({
        "type": "critical",
        "message": "クラッシュ率が1%を超えています",
        "value": analysis["stability"]["crash_rate"],
        "action": "即座の調査と修正が必要"
      });
    }

    // 評価の低下チェック
    if (analysis["ratings"]["trend"] == "decreasing") {
      alerts.add({
        "type": "warning",
        "message": "アプリ評価が低下傾向",
        "value": analysis["ratings"]["average"],
        "action": "レビューの分析と改善策の実施"
      });
    }

    return alerts;
  }
}
```

## エラーハンドリング

```dart
try {
  final action = await ref.app.model(
    ActionModel.collection().create({
      "type": "collect_from_google_play_console",
      "data": {...}
    }),
  );

  if (action.status == ActionStatus.error) {
    switch (action.error["code"]) {
      case "AUTH_ERROR":
        // 認証エラー
        print("Google Play Console APIの認証に失敗しました");
        // 認証情報の再設定
        await refreshGooglePlayCredentials();
        break;
      case "RATE_LIMIT":
        // レート制限
        print("API制限に達しました。しばらく待機します");
        await Future.delayed(Duration(minutes: 15));
        break;
      case "DATA_NOT_AVAILABLE":
        // データ未提供
        print("指定期間のデータは利用できません");
        break;
      default:
        print("予期しないエラー: ${action.error}");
    }
  }
} catch (e) {
  print("実行エラー: $e");
  // エラーログの記録
  await logError(e);
}
```

## ベストプラクティス

### 1. データ収集の最適化

```dart
// インクリメンタルデータ収集
class IncrementalDataCollector {
  DateTime lastCollected;

  Future<void> collectIncremental() async {
    final now = DateTime.now();

    // 前回収集時点から現在までのデータのみ取得
    await collectData(
      startDate: lastCollected,
      endDate: now,
    );

    lastCollected = now;
  }
}
```

### 2. キャッシュ戦略

```dart
// 分析結果のキャッシュ
class AnalysisCache {
  static const Duration cacheExpiry = Duration(hours: 6);
  final Map<String, CachedResult> _cache = {};

  Future<Map<String, dynamic>> getAnalysis(String key) async {
    final cached = _cache[key];

    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    // 新規分析実行
    final result = await runAnalysis(key);
    _cache[key] = CachedResult(result, DateTime.now());

    return result;
  }
}
```

### 3. アラートの優先順位付け

```dart
// アラートの重要度判定
enum AlertPriority {
  critical,  // 即座の対応が必要
  high,      // 24時間以内の対応推奨
  medium,    // 1週間以内の対応推奨
  low        // 次回更新時に対応
}

class AlertManager {
  List<Alert> prioritizeAlerts(List<Alert> alerts) {
    return alerts
      ..sort((a, b) => a.priority.index.compareTo(b.priority.index));
  }

  Future<void> sendNotification(Alert alert) async {
    if (alert.priority == AlertPriority.critical) {
      // 即座に通知
      await sendImmediateNotification(alert);
    } else if (alert.priority == AlertPriority.high) {
      // メール通知
      await sendEmailNotification(alert);
    }
    // medium/lowはダッシュボードに表示
  }
}
```

## 活用シナリオ

### 1. 定期レポートの自動化

```dart
// 月次レポートの自動生成と配信
@CloudFunction()
Future<void> monthlyReportScheduler(ScheduledEvent event) async {
  final lastMonth = DateTime.now().subtract(Duration(days: 30));

  // データ収集
  await collectAllData(
    startDate: lastMonth,
    endDate: DateTime.now(),
  );

  // 分析実行
  final analysis = await analyzeMarketingData();

  // レポート生成
  final report = await generateMarketingPdf(
    reportType: "monthly",
    analysis: analysis,
  );

  // ステークホルダーへ配信
  await distributeReport(report, recipients: [
    "ceo@company.com",
    "marketing@company.com",
    "product@company.com"
  ]);
}
```

### 2. 競合モニタリング

```dart
// 競合アプリの動向監視
class CompetitorMonitor {
  final List<String> competitorPackages = [
    "com.competitor1.app",
    "com.competitor2.app",
  ];

  Future<void> monitorCompetitors() async {
    for (final package in competitorPackages) {
      final data = await collectCompetitorData(package);

      // 重要な変更を検出
      if (data["major_update"]) {
        await notifyProductTeam(
          "競合アプリ ${package} が大型アップデートをリリース",
          data["update_details"]
        );
      }

      if (data["rating_change"] > 0.3) {
        await notifyMarketingTeam(
          "競合アプリ ${package} の評価が大幅に変動",
          data["rating_analysis"]
        );
      }
    }
  }
}
```

### 3. A/Bテスト分析

```dart
// A/Bテストの効果測定
class ABTestAnalyzer {
  Future<Map<String, dynamic>> analyzeABTest(
    String testId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Firebase Analyticsからテストデータ取得
    final testData = await collectFirebaseData(
      events: ["ab_test_${testId}"],
      startDate: startDate,
      endDate: endDate,
    );

    // 統計分析
    final analysis = {
      "variant_a": calculateMetrics(testData["variant_a"]),
      "variant_b": calculateMetrics(testData["variant_b"]),
      "statistical_significance": calculateSignificance(testData),
      "winner": determineWinner(testData),
      "confidence": calculateConfidence(testData)
    };

    return analysis;
  }
}
```

## まとめ

マーケティング分析機能は、複数のデータソースから情報を収集し、AIによる高度な分析を通じて、データドリブンな意思決定を支援する包括的なツールセットです。

定期的なデータ収集、自動分析、レポート生成により、マーケティングチームは常に最新の情報に基づいた戦略立案が可能になります。

### 次のステップ
- [メインワークフローに戻る](../workflow.dart)
- [アセット生成機能](asset_generation.dart) - マーケティング素材の自動生成
- [基本ワークフロー機能](basic_workflow.dart) - スケジューラーとタスク管理
- [セールス機能](sales_functions.dart) - リード獲得と営業支援
