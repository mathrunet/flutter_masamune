# `Plugin`の一覧とその利用方法

アプリ開発で利用可能な`Plugin`の一覧とその利用方法を下記に記載する。

## `Plugin`の一覧

| PluginID | PluginName | Summary | Usage |
| --- | --- | --- | --- |
| `ads | アプリ広告 | `アプリ広告`はアプリ内にGoogle Mobile Ads（AdMob）を表示する機能を提供するプラグイン。バナー広告、インタースティシャル広告、リワード広告、リワードインタースティシャル広告、ネイティブ広告に対応。 | Usage(`documents/rules/plugins/ads.md`) |
| `agora | Agora | `Agora`は音声通話、ビデオ通話、クラウドレコーディング、スクリーンキャプチャ、データストリーム、カスタムビデオソースの機能を提供するプラグイン。Agora.io SDKを利用した高品質なリアルタイムコミュニケーションを実現。 | Usage(`documents/rules/plugins/agora.md`) |
| `animate | アニメーション | `アニメーション`はシナリオベースのアニメーションを構築できるプラグイン。`AnimateScope`と`AnimateController`を使用して、フェードイン/アウト、移動、回転、スケール、カラーフィルターなどのアニメーションフローを作成。 | Usage(`documents/rules/plugins/animate.md`) |
| `calendar | カレンダー | `カレンダー`は月別や週別のカレンダーのUIを表示するためのプラグイン。 | Usage(`documents/rules/plugins/calendar.md`) |
| `camera | カメラ | `カメラ`はファイルピッカー以外でのカメラの利用する機能。写真撮影および映像撮影含む。 | Usage(`documents/rules/plugins/camera.md`) |
| `google_map | マップ表示 | `マップ表示`は地図やマップを表示する機能を提供するプラグイン。 | Usage(`documents/rules/plugins/google_map.md`) |
| `introduction | チュートリアル | `チュートリアル`はアプリ起動時にアプリの説明を行うためのプラグイン。 | Usage(`documents/rules/plugins/introduction.md`) |
| `local_notification | ローカルPUSH通知 | `ローカルPUSH通知`は端末内に閉じたPUSH通知機能。通知を行う日時と内容を設定して端末内で設定後、設定した日時に通知を行う。 | Usage(`documents/rules/plugins/local_notification.md`) |
| `location | 位置情報 | `位置情報`は端末の位置情報を取得する機能を提供するプラグイン。 | Usage(`documents/rules/plugins/location.md`) |
| `generative_ai | Generative AI | `Generative AI`はOpenAI ChatGPTやGeminiなどの生成系AIをアプリに統合するプラグイン。マルチターン会話、ストリーミング応答、ツール連携(MCP)に対応。 | Usage(`documents/rules/plugins/generative_ai.md`) |
| `picker | ファイルピッカー | `ファイルピッカー`は端末内から画像や映像などを取得しアプリ内で利用可能にするプラグイン。 | Usage(`documents/rules/plugins/picker.md`) |
| `purchase | アプリ内課金 | `アプリ内課金`はGooglePlayやAppStore内で提供される課金機能。消費型、非消費型、サプスクリプションの課金アイテムを利用可能。 | Usage(`documents/rules/plugins/purchase.md`) |
| `mail | メール送信 | `メール送信`はメールを送信する機能を提供するプラグイン。 | Usage(`documents/rules/plugins/mail.md`) |
| `speech_to_text | Speech-To-Text | `Speech-To-Text`は音声認識してテキストに変換する機能を提供するプラグイン。 | Usage(`documents/rules/plugins/speech_to_text.md`) |
| `stripe | Stripe決済 | `Stripe決済`はStripeを使用した柔軟な決済機能を提供するプラグイン。サーバー側で金額を決定する決済や、定期購読、3Dセキュア認証に対応。 | Usage(`documents/rules/plugins/stripe.md`) |
| `text_to_speech | Text-To-Speech | `Text-To-Speech`はテキストを音声にして発話させる機能を提供するプラグイン。 | Usage(`documents/rules/plugins/text_to_speech.md`) |
| `app_review | アプリレビュー | `アプリレビュー`はアプリ内でレビューダイアログを表示し、ユーザーにアプリストアでのレビューを促す機能。ネイティブダイアログが利用できない場合は自動的にストアURLを開く。 | Usage(`documents/rules/plugins/app_review.md`) |
| `force_updater | 強制アップデート | `強制アップデート`はアプリのバージョンをチェックし、古いバージョンの場合にアップデートダイアログを表示してストアへ誘導する機能。 | Usage(`documents/rules/plugins/force_updater.md`) |
| `app_check | Firebase App Check | `Firebase App Check`はアプリの正当性を検証し、不正なトラフィックからFirebaseリソースを保護するセキュリティ機能。 | Usage(`documents/rules/plugins/app_check.md`) |
| `logger | Firebase Analytics / Crashlytics | `Firebase Logger`はFirebase AnalyticsとCrashlyticsを統合し、イベントログ、パフォーマンス測定、クラッシュレポートを提供するプラグイン。 | Usage(`documents/rules/plugins/logger.md`) |
| `algolia | Algolia検索 | `Algolia検索`はAlgoliaを使用した高速全文検索機能を提供するプラグイン。Firestoreと組み合わせてコレクションの検索を強化。 | Usage(`documents/rules/plugins/algolia.md`) |
| `data_connect | Firebase Data Connect | `Firebase Data Connect`はGraphQLを使用したデータアクセスを提供し、DartモデルからGraphQLスキーマを自動生成するプラグイン。 | Usage(`documents/rules/plugins/data_connect.md`) |
| `remote_config | Firebase Remote Config | `Firebase Remote Config`はアプリを再リリースすることなく、設定値をリモートで管理し動的に変更できる機能。機能フラグ、APIエンドポイント、表示コンテンツの切り替えなどに利用可能。 | Usage(`documents/rules/plugins/remote_config.md`) |
| `firestore_rules_and_indexes_generator | Firestoreルール・インデックス自動生成 | `Firestoreルール・インデックス自動生成`はDartモデルの定義から、Firestoreのセキュリティルール(`firestore.rules`)とコンポジットインデックス(`firestore.indexes.json`)を自動生成する機能。 | Usage(`documents/rules/plugins/firestore_rules_and_indexes_generator.md`) |
| `deeplink | ディープリンク | `ディープリンク`はカスタムURLスキームやユニバーサルリンク(iOS)/アプリリンク(Android)を使用して、外部からアプリの特定画面を開く機能。 | Usage(`documents/rules/plugins/deeplink.md`) |
| `scheduler | スケジューラー | `スケジューラー`は指定した時間にFirestoreのドキュメントをコピーしたり、削除したりする仕組みを提供する機能。 | Usage(`documents/rules/plugins/scheduler.md`) |
| `delete_user | ユーザー削除機能 | `ユーザー削除機能`はFirebase Authenticationのユーザーアカウントをバックエンドから安全に削除する機能。 | Usage(`documents/rules/plugins/delete_user.md`) |
| `sns_auth | SNSログイン機能 | `SNSログイン機能`はApple、Google、GitHub、FacebookなどのSNSアカウントを使ってFirebase Authenticationにサインインする機能。 | Usage(`documents/rules/plugins/sns_auth.md`) |
| `workflow | Workflow | `Workflow`はワークフローを管理する機能を提供するプラグイン。 | Usage(`documents/rules/plugins/workflow.md`) |
| `workflows/basic_workflow | 基本ワークフロー機能 | このドキュメントでは、Masamune Workflowの基本機能であるスケジューラーとアセット管理について詳しく説明します。 | Usage(`documents/rules/plugins/workflows_basic_workflow.md`) |
| `workflows/sales_functions | セールス機能 | このドキュメントでは、Masamune Workflowのセールス機能である開発者情報収集について詳しく説明します。
Google PlayとApp Storeから開発者の連絡先情報を収集し、ビジネス開発やパートナーシップの機会を創出します。 | Usage(`documents/rules/plugins/workflows_sales_functions.md`) |
| `workflows/asset_generation | アセット生成機能 | このドキュメントでは、Masamune Workflowのアセット生成機能について詳しく説明します。
Gemini APIを使用した画像生成、Google Text-to-Speechによる音声生成、マルチモーダル入力からのテキスト生成などの機能を提供します。 | Usage(`documents/rules/plugins/workflows_asset_generation.md`) |
| `workflows/marketing_analytics | マーケティング分析機能 | このドキュメントでは、Masamune Workflowのマーケティング分析機能について詳しく説明します。
アプリストアやFirebase Analyticsからのデータ収集、AIによる分析、GitHub活動の解析、市場調査などの機能を提供します。 | Usage(`documents/rules/plugins/workflows_marketing_analytics.md`) |

## プラグインコントローラーの共通利用方法

多くのプラグインには専用のコントローラーが用意されており、これらは全て共通のパターンで利用できます。

### 基本的な取得方法

プラグインのコントローラーは、一般的なコントローラーと同様に`query`メソッドを使用して取得します。詳細な状態管理については[状態管理の利用方法](state_management_usage.md)を参照してください。

#### Model、Controller、RedirectQuery内での利用

```dart
// プラグインコントローラーの取得
final purchaseController = appRef.controller(Purchase.query());
final locationController = appRef.controller(Location.query());
```

#### Page・Widget内での利用

```dart
// アプリケーション全体で状態を保持
final purchaseController = ref.app.controller(Purchase.query());
final locationController = ref.app.controller(Location.query());

// ページ内でのみ状態を保持
final speechController = ref.page.controller(SpeechToText.query());
```

### プラグインコントローラーのライフサイクル

ほとんどのプラグインコントローラーは以下のライフサイクルメソッドを提供しています：

#### 1. 初期化（Initialize）

```dart
// 初期化（権限チェックを含む場合あり）
await locationController.initialize();
await purchaseController.initialize();
```

#### 2. データ読み込み（Load/Reload）

```dart
// 初回読み込み
await locationController.load();

// データの再読み込み
await locationController.reload();
```

#### 3. リスニング（Listen/Unlisten）

```dart
// 位置情報の継続的な監視開始
await locationController.listen(
  updateInterval: Duration(seconds: 5),
);

// 監視の停止
await locationController.unlisten();
```

#### 4. リスナー登録による変更通知

```dart
// コントローラーの状態変更を監視
locationController.addListener(() {
  // 位置情報が更新された時の処理
  final currentLocation = locationController.value;
});
```

### 代表的なプラグインコントローラーの使用例

#### 位置情報（Location）

```dart
// 取得と初期化
final location = ref.app.controller(Location.query());
await location.initialize();

// 現在位置を1回取得
await location.load();
final currentLocation = location.value;

// 継続的な位置情報監視
await location.listen(
  updateInterval: Duration(seconds: 10),
);
```

#### アプリ内課金（Purchase）

```dart
// 取得と初期化
final purchase = ref.app.controller(Purchase.query());
await purchase.initialize();
await purchase.load();

// 商品の購入
final product = purchase.products.firstWhere(
  (p) => p.productId == "premium_upgrade",
);
await product.purchase();
```

#### インタースティシャル広告（GoogleAdInterstitial）

```dart
// コントローラーの取得
final interstitial = ref.page.controller(
  GoogleAdInterstitial.query(adUnitId: "ca-app-pub-xxxx/yyyy"),
);

// 広告の事前ロード
await interstitial.load();

// 広告の表示
try {
  await interstitial.show(
    onAdClicked: () {
      print("Interstitial clicked.");
    },
  );
} on GoogleAdsNoFillError catch (e) {
  // 広告が利用できない場合の処理
  print("No ad available");
}
```

#### リワード広告（GoogleAdRewarded）

```dart
// コントローラーの取得
final rewarded = ref.page.controller(GoogleAdRewarded.query());

// 広告のロードと表示
await rewarded.load();
await rewarded.show(
  onEarnedReward: (amount, type) async {
    // ユーザーに報酬を付与
    await grantReward(amount, type);
  },
);
```

### ウィジェットベースのプラグイン

一部のプラグインはコントローラーではなく、ウィジェットとして直接使用します：

#### バナー広告（GoogleBannerAd）

```dart
// ウィジェットツリーに直接配置
GoogleBannerAd(
  size: GoogleBannerAdSize.banner,
  adUnitId: "ca-app-pub-xxxx/yyyy", // 省略時はdefaultAdUnitIdを使用
  onAdClicked: () {
    print("Banner clicked.");
  },
);
```

#### ネイティブ広告（GoogleNativeAd）

```dart
// ウィジェットツリーに直接配置
GoogleNativeAd(
  templateType: GoogleNativeAdTemplateType.medium,
  backgroundColor: Colors.white,
  cornerRadius: 8.0,
);
```

### 利用時の注意事項

1. **初期化の必要性**: ほとんどのプラグインコントローラーは使用前に`initialize()`を呼ぶ必要があります
2. **権限の確認**: 位置情報、カメラなど一部のプラグインは権限チェックが含まれます
3. **リソース管理**: `listen()`を使用した場合は、不要になったら必ず`unlisten()`を呼び出してください
4. **スコープの選択**: アプリ全体で共有する場合は`ref.app`、ページ内のみで使用する場合は`ref.page`を使用してください
5. **エラーハンドリング**: 広告系のプラグインでは`GoogleAdsNoFillError`などの特定のエラーを適切に処理してください

※ 各プラグインの詳細な使用方法については、上記テーブルの「Usage」列にあるリンクから個別のドキュメントを参照してください。
