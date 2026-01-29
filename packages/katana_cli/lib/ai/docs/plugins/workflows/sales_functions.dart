import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Class for generating sales feature documentation
///
/// This class provides detailed documentation on the collection of developer information from Google Play and the App Store,
/// which is a sales feature of Masamune Workflow.
///
/// セールス機能のドキュメントを生成するクラス
///
/// このクラスでは、Masamune Workflowのセールス機能である
/// Google PlayとApp Storeの開発者情報収集に関する詳細なドキュメントを提供します。
class PluginWorkflowSalesFunctionsCliAiCode extends PluginUsageCliAiCode {
  /// Class for generating sales feature documentation
  ///
  /// This class provides detailed documentation on the collection of developer information from Google Play and the App Store,
  /// which is a sales feature of Masamune Workflow.
  ///
  /// セールス機能のドキュメントを生成するクラス
  ///
  /// このクラスでは、Masamune Workflowのセールス機能である
  /// Google PlayとApp Storeの開発者情報収集に関する詳細なドキュメントを提供します。
  const PluginWorkflowSalesFunctionsCliAiCode();

  @override
  String get name => "セールス機能";

  @override
  String get description =>
      "Masamune Workflowのセールス機能（Google Play/App Store開発者情報収集）に関する詳細ドキュメント";

  @override
  String get directory => "docs/plugins/workflows";

  @override
  String get excerpt =>
      "このドキュメントでは、Masamune Workflowのセールス機能である開発者情報収集について詳しく説明します。\nGoogle PlayとApp Storeから開発者の連絡先情報を収集し、ビジネス開発やパートナーシップの機会を創出します。";

  @override
  String get globs => "*";

  @override
  String body(String baseName, String className) {
    return """
$excerpt

## 概要

セールス機能は、以下の2つの主要な機能を提供します：

1. **Google Play開発者情報収集**: Google Play Storeから開発者情報を収集
2. **App Store開発者情報収集**: App Storeから開発者情報を収集

これらの機能により、潜在的なビジネスパートナーやクライアントを効率的に特定し、連絡を取ることが可能になります。

## Google Play開発者情報収集

### collect_google_play_developers

Google Play Storeから開発者情報を収集します。3つのモードで動作可能です。

**アクションID**: `collect_google_play_developers`

### 動作モード

#### 1. 開発者ID指定モード

特定の開発者IDを指定して情報を収集します。

**パラメータ**:
```typescript
{
  "mode": "developer_ids",
  "developerIds": string[],  // 開発者IDの配列
  "lang": string,            // 任意: 言語コード（デフォルト: "ja"）
  "country": string          // 任意: 国コード（デフォルト: "jp"）
}
```

**使用例**:
```dart
final action = await ref.app.model(
  ActionModel.collection().create({
    "type": "collect_google_play_developers",
    "data": {
      "mode": "developer_ids",
      "developerIds": [
        "5700313618786177705",  // Nintendo
        "6720847872433251783",  // Sony
        "4898307374348440402"   // Square Enix
      ],
      "lang": "ja",
      "country": "jp"
    }
  }),
);
```

#### 2. カテゴリランキングモード

特定のカテゴリのトップアプリから開発者情報を収集します。

**パラメータ**:
```typescript
{
  "mode": "category_ranking",
  "categoryConfig": {
    "category": string,     // カテゴリID（後述のカテゴリ一覧参照）
    "collection": string,   // コレクション種別
    "num": number          // 取得するアプリ数（デフォルト: 100）
  },
  "maxCount": number        // 最大収集数（任意）
}
```

**カテゴリID一覧**:
```
// ゲームカテゴリ
GAME_ACTION          - アクションゲーム
GAME_ADVENTURE       - アドベンチャー
GAME_ARCADE          - アーケード
GAME_BOARD           - ボード
GAME_CARD            - カード
GAME_CASINO          - カジノ
GAME_CASUAL          - カジュアル
GAME_EDUCATIONAL     - 教育
GAME_MUSIC           - 音楽
GAME_PUZZLE          - パズル
GAME_RACING          - レース
GAME_ROLE_PLAYING    - ロールプレイング
GAME_SIMULATION      - シミュレーション
GAME_SPORTS          - スポーツ
GAME_STRATEGY        - ストラテジー
GAME_TRIVIA          - 雑学
GAME_WORD            - 言葉

// アプリカテゴリ
ART_AND_DESIGN       - アート&デザイン
AUTO_AND_VEHICLES    - 自動車
BEAUTY               - 美容
BOOKS_AND_REFERENCE  - 書籍&参考書
BUSINESS             - ビジネス
COMICS               - コミック
COMMUNICATION        - 通信
DATING               - 出会い
EDUCATION            - 教育
ENTERTAINMENT        - エンタメ
EVENTS               - イベント
FINANCE              - ファイナンス
FOOD_AND_DRINK       - フード&ドリンク
HEALTH_AND_FITNESS   - 健康&フィットネス
HOUSE_AND_HOME       - 住まい&インテリア
LIBRARIES_AND_DEMO   - ライブラリ&デモ
LIFESTYLE            - ライフスタイル
MAPS_AND_NAVIGATION  - 地図&ナビ
MEDICAL              - 医療
MUSIC_AND_AUDIO      - 音楽&オーディオ
NEWS_AND_MAGAZINES   - ニュース&雑誌
PARENTING            - 子育て
PERSONALIZATION      - カスタマイズ
PHOTOGRAPHY          - 写真
PRODUCTIVITY         - 仕事効率化
SHOPPING             - ショッピング
SOCIAL               - ソーシャル
SPORTS               - スポーツ
TOOLS                - ツール
TRAVEL_AND_LOCAL     - 旅行&地域
VIDEO_PLAYERS        - 動画プレーヤー
WEATHER              - 天気
```

**コレクション種別**:
```
TOP_FREE            - 無料トップ
TOP_PAID            - 有料トップ
TOP_GROSSING        - 売上トップ
TRENDING            - 急上昇
NEW_FREE            - 新着無料
NEW_PAID            - 新着有料
```

**使用例**:
```dart
// フィットネスカテゴリの無料トップ100アプリから開発者情報を収集
final action = await ref.app.model(
  ActionModel.collection().create({
    "type": "collect_google_play_developers",
    "data": {
      "mode": "category_ranking",
      "categoryConfig": {
        "category": "HEALTH_AND_FITNESS",
        "collection": "TOP_FREE",
        "num": 100
      },
      "maxCount": 200,
      "lang": "ja",
      "country": "jp"
    }
  }),
);
```

#### 3. キーワード検索モード

キーワードでアプリを検索し、その開発者情報を収集します。

**パラメータ**:
```typescript
{
  "mode": "search_keyword",
  "searchConfig": {
    "query": string,       // 検索キーワード
    "num": number         // 検索結果数（デフォルト: 50）
  },
  "maxCount": number      // 最大収集数（任意）
}
```

**使用例**:
```dart
// "フィットネス"で検索したアプリの開発者情報を収集
final action = await ref.app.model(
  ActionModel.collection().create({
    "type": "collect_google_play_developers",
    "data": {
      "mode": "search_keyword",
      "searchConfig": {
        "query": "フィットネス トレーニング",
        "num": 50
      },
      "maxCount": 100,
      "lang": "ja",
      "country": "jp"
    }
  }),
);
```

### レスポンス構造

```typescript
{
  "results": {
    "googlePlayDevelopers": {
      "stats": {
        "mode": string,           // 使用したモード
        "targetCount": number,    // 対象アプリ数
        "collectedCount": number, // 収集した開発者数
        "withEmailCount": number, // メールアドレス取得数
        "savedCount": number      // 保存された開発者数
      },
      "developers": [
        {
          "developerId": string,        // 開発者ID
          "developerName": string,      // 開発者名
          "companyName": string,        // 会社名（任意）
          "email": string,              // メールアドレス（任意）
          "website": string,            // ウェブサイト（任意）
          "privacyPolicyUrl": string,   // プライバシーポリシー（任意）
          "address": string,            // 住所（任意）
          "apps": [
            {
              "appId": string,         // アプリID（パッケージ名）
              "title": string,         // アプリタイトル
              "score": number,         // 評価スコア
              "price": number,         // 価格
              "free": boolean,         // 無料アプリか
              "genre": string,         // ジャンル
              "installs": string,      // インストール数範囲
              "updated": string        // 最終更新日
            }
          ]
        }
      ]
    }
  }
}
```

## App Store開発者情報収集

### collect_app_store_developers

App Storeから開発者情報を収集します。Google Playと同様の3つのモードで動作します。

**アクションID**: `collect_app_store_developers`

### 動作モード

Google Playと同様に以下の3つのモードがあります：

1. **開発者ID指定モード**: 特定の開発者IDを指定
2. **カテゴリランキングモード**: カテゴリのトップアプリから収集
3. **キーワード検索モード**: キーワード検索結果から収集

**App Storeカテゴリ一覧**:
```
// メインカテゴリ
6018  - ブック
6000  - ビジネス
6022  - カタログ
6017  - 教育
6016  - エンターテインメント
6015  - ファイナンス
6023  - フード/ドリンク
6014  - ゲーム
6013  - ヘルスケア/フィットネス
6012  - ライフスタイル
6020  - 医療
6011  - ミュージック
6010  - ナビゲーション
6009  - ニュース
6008  - 写真/ビデオ
6007  - 仕事効率化
6006  - 辞書/辞典/その他
6005  - ソーシャルネットワーキング
6004  - スポーツ
6003  - 旅行
6002  - ユーティリティ
6001  - 天気

// ゲームサブカテゴリ
7001  - アクション
7002  - アドベンチャー
7003  - アーケード
7004  - ボード
7005  - カード
7006  - カジノ
7009  - ファミリー
7011  - ミュージック
7012  - パズル
7013  - レーシング
7014  - ロールプレイング
7015  - シミュレーション
7016  - スポーツ
7017  - ストラテジー
7018  - トリビア
7019  - 単語
```

**レスポンス構造**:
```typescript
{
  "results": {
    "appStoreDevelopers": {
      "stats": {
        "mode": string,
        "targetCount": number,
        "collectedCount": number,
        "withEmailCount": number,
        "savedCount": number
      },
      "developers": [
        {
          "developerId": number,         // 開発者ID
          "developerName": string,      // 開発者名
          "email": string,              // サポートメール（任意）
          "website": string,            // ウェブサイト（任意）
          "apps": [
            {
              "appId": number,         // アプリID
              "bundleId": string,      // バンドルID
              "title": string,         // アプリタイトル
              "price": number,         // 価格
              "free": boolean,         // 無料アプリか
              "genre": string,         // ジャンル
              "rating": number,        // 評価
              "ratingCount": number    // 評価数
            }
          ]
        }
      ]
    }
  }
}
```

## 実装例

### 包括的な開発者情報収集ワークフロー

```dart
// 1. 特定カテゴリからの開発者収集
final fitnessWorkflow = await ref.app.model(
  WorkflowModel.collection().create({
    "name": "フィットネスアプリ開発者収集",
    "actions": [
      // Google Play
      {
        "type": "collect_google_play_developers",
        "data": {
          "mode": "category_ranking",
          "categoryConfig": {
            "category": "HEALTH_AND_FITNESS",
            "collection": "TOP_FREE",
            "num": 200
          }
        }
      },
      // App Store
      {
        "type": "collect_app_store_developers",
        "data": {
          "mode": "category_ranking",
          "categoryConfig": {
            "category": "6013",  // ヘルスケア/フィットネス
            "collection": "TOP_FREE",
            "num": 200
          }
        }
      }
    ]
  }),
);

// 2. タスクの実行
final task = await ref.app.model(
  TaskModel.collection().create({
    "workflowId": fitnessWorkflow.uid,
    "status": TaskStatus.waiting
  }),
);

// 3. 結果の取得と処理
task.watch(
  onUpdate: (task) async {
    if (task.value?.status == TaskStatus.completed) {
      final googlePlayDevs = task.value?.response["googlePlayDevelopers"]["developers"];
      final appStoreDevs = task.value?.response["appStoreDevelopers"]["developers"];

      // メールアドレスがある開発者のみフィルタリング
      final contactableDevs = [
        ...googlePlayDevs.where((dev) => dev["email"] != null),
        ...appStoreDevs.where((dev) => dev["email"] != null),
      ];

      print("連絡可能な開発者数: \${contactableDevs.length}");

      // CSVエクスポートなどの処理
      await exportToCSV(contactableDevs);
    }
  },
);
```

### 競合分析ワークフロー

```dart
// 競合他社の開発者IDを指定して情報収集
final competitorAnalysis = await ref.app.model(
  WorkflowModel.collection().create({
    "name": "競合分析",
    "actions": [
      {
        "type": "collect_google_play_developers",
        "data": {
          "mode": "developer_ids",
          "developerIds": [
            "競合A_開発者ID",
            "競合B_開発者ID",
            "競合C_開発者ID"
          ]
        }
      }
    ]
  }),
);

// アプリ情報から競合の戦略を分析
final task = await runWorkflow(competitorAnalysis.uid);
final competitors = task.response["googlePlayDevelopers"]["developers"];

for (final competitor in competitors) {
  print("開発者: \${competitor['developerName']}");
  print("アプリ数: \${competitor['apps'].length}");
  print("主要カテゴリ: \${_analyzeCategories(competitor['apps'])}");
  print("平均評価: \${_calculateAverageRating(competitor['apps'])}");
}
```

### キーワードベースの潜在顧客発掘

```dart
// ビジネス向けアプリ開発者を発掘
final b2bLeadGeneration = await ref.app.model(
  WorkflowModel.collection().create({
    "name": "B2B向け開発者リード生成",
    "actions": [
      {
        "type": "collect_google_play_developers",
        "data": {
          "mode": "search_keyword",
          "searchConfig": {
            "query": "業務管理 効率化 ビジネス",
            "num": 100
          }
        }
      },
      {
        "type": "collect_app_store_developers",
        "data": {
          "mode": "search_keyword",
          "searchConfig": {
            "query": "business productivity enterprise",
            "num": 100
          }
        }
      }
    ]
  }),
);
```

## 活用シナリオ

### 1. ビジネス開発

- **パートナーシップの機会**: 補完的なアプリを開発している企業との提携
- **M&A候補の特定**: 買収対象となる可能性のあるアプリ開発者の発見
- **投資機会の探索**: 成長性の高いアプリ開発者への投資検討

### 2. マーケティング

- **ターゲット広告**: 特定カテゴリの開発者へのダイレクトマーケティング
- **イベント招待**: カンファレンスや展示会への招待リスト作成
- **コンテンツマーケティング**: 開発者向けコンテンツの配信リスト構築

### 3. 競合分析

- **市場動向の把握**: カテゴリ別の開発者分布と活動状況
- **新規参入者の監視**: 新しく市場に参入した開発者の特定
- **価格戦略の分析**: 競合アプリの価格設定とマネタイズ戦略

## ベストプラクティス

### データ収集の最適化

1. **段階的な収集**: 大量データは複数回に分けて収集
2. **キャッシュの活用**: 同じ開発者IDは再収集を避ける
3. **レート制限の考慮**: APIレート制限を超えないよう適切な間隔を設定

```dart
// 段階的収集の例
const batchSize = 50;
const totalDevelopers = 500;

for (int i = 0; i < totalDevelopers; i += batchSize) {
  await collectDevelopers(
    start: i,
    limit: batchSize,
  );

  // レート制限回避のための待機
  await Future.delayed(Duration(seconds: 5));
}
```

### データの品質管理

1. **重複の排除**: 同じ開発者の重複エントリを削除
2. **情報の検証**: メールアドレスやウェブサイトの有効性確認
3. **更新頻度**: 定期的にデータを更新して最新性を保つ

```dart
// データクリーニングの例
List<Map<String, dynamic>> cleanDeveloperData(List<Map<String, dynamic>> developers) {
  // 重複の排除
  final uniqueDevs = <String, Map<String, dynamic>>{};
  for (final dev in developers) {
    uniqueDevs[dev['developerId']] = dev;
  }

  // 有効なメールアドレスのフィルタリング
  return uniqueDevs.values.where((dev) {
    final email = dev['email'] as String?;
    return email != null && isValidEmail(email);
  }).toList();
}
```

## 注意事項

### 法的・倫理的考慮事項

1. **プライバシー規制の遵守**
   - GDPR、CCPA等の個人情報保護法の遵守
   - 収集したメールアドレスの適切な管理
   - オプトアウト要求への対応

2. **利用規約の遵守**
   - Google PlayおよびApp Storeの利用規約を確認
   - 自動収集に関する制限事項の理解
   - 商用利用の可否確認

3. **スパム防止**
   - 未承諾の大量メール送信を避ける
   - CAN-SPAM法等の規制遵守
   - 適切な配信停止メカニズムの実装

### 技術的制限

1. **レート制限**
   - API呼び出し回数の制限
   - 時間あたりの収集可能数の上限
   - エラーハンドリングとリトライロジック

2. **データの完全性**
   - すべての開発者情報が取得できるとは限らない
   - 一部のフィールドが空の場合がある
   - 定期的な更新が必要

3. **ストレージ容量**
   - 大量データの保存に必要な容量
   - データベースのパフォーマンス最適化
   - バックアップとリカバリー戦略

## エラーハンドリング

```dart
try {
  final action = await ref.app.model(
    ActionModel.collection().create({
      "type": "collect_google_play_developers",
      "data": {...}
    }),
  );

  if (action.status == ActionStatus.error) {
    switch (action.error["code"]) {
      case "RATE_LIMIT_EXCEEDED":
        // レート制限エラー
        await Future.delayed(Duration(minutes: 5));
        // リトライ
        break;
      case "INVALID_CATEGORY":
        // 無効なカテゴリ
        print("指定されたカテゴリが存在しません");
        break;
      case "NETWORK_ERROR":
        // ネットワークエラー
        print("ネットワーク接続を確認してください");
        break;
      default:
        print("予期しないエラー: \${action.error}");
    }
  }
} catch (e) {
  print("実行エラー: \$e");
}
```

## まとめ

セールス機能は、Google PlayとApp Storeから開発者情報を効率的に収集し、ビジネス開発の機会を創出する強力なツールです。適切な利用により、パートナーシップの構築、マーケティング活動の最適化、競合分析の精度向上が可能になります。

法的・倫理的な考慮事項を遵守しながら、データの品質管理と技術的制限を理解して活用することで、最大限の価値を引き出すことができます。

### 次のステップ
- [メインワークフローに戻る](../workflow.dart)
- [マーケティング分析機能](marketing_analytics.dart) - 収集データの分析
- [基本ワークフロー機能](basic_workflow.dart) - スケジューラーとタスク管理
""";
  }
}
