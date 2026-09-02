<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune AI Debugger</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

Plug-in packages that add functionality to the Masamune Framework.

For more information about Masamune Framework, please click here.

[https://pub.dev/packages/masamune](https://pub.dev/packages/masamune)

# Usage

A floating UI will be added to the Debug build of the Masamune app that sends instructions, screenshots, and unhandled errors to SamuraiAI. Neither the UI nor the communication will be active in Release/Profile builds. The public controller's lifecycle, upload, send, incident, and log methods are also no-ops outside Debug builds.

```dart
import "package:masamune_ai_debugger/masamune_ai_debugger.dart";

final aiDebugger = AIDebuggerMasamuneAdapter(
  manualModel: AIDebugModel.opus,
  manualPermissionMode: AIDebugPermissionMode.plan,
  errorModel: AIDebugModel.opus,
  errorPermissionMode: AIDebugPermissionMode.plan,
  performanceModel: AIDebugModel.opus,
  performancePermissionMode: AIDebugPermissionMode.plan,
  modelLoadTimeout: const Duration(seconds: 5),
  indicatorTimeout: const Duration(seconds: 10),
);

void main() {
  runMasamuneApp(
    (ref) => MasamuneApp(
      masamuneAdapters: [aiDebugger],
      home: const MyHomePage(),
    ),
    masamuneAdapters: [aiDebugger],
  );
}
```

Create one adapter instance and pass that same instance to both `MasamuneApp` and `runMasamuneApp`. `projectId` is read from `MASAMUNE_AI_DEBUGGER_PROJECT_ID` by default. You can still pass it directly to the constructor when using a custom integration.

Do not embed the connection target and API key in the source code; specify them during debug startup.

```bash
flutter run \
  --dart-define=MASAMUNE_AI_DEBUGGER_PROJECT_ID=Users-mathru-Documents-github-myapp \
  --dart-define=MASAMUNE_AI_DEBUGGER_ENDPOINT=https://your-tailnet-host/__samurai \
  --dart-define=MASAMUNE_AI_DEBUGGER_API_KEY=your-key
```

APIキーは SamuraiAI の Settings で作成します。Debug APK/IPAにも値は含まれるため、配布せず、不要になったキーは無効化してください。スクリーンショットは手動操作時、未処理エラー検出時、性能閾値超過時だけ送信されます。

`projectId` / `endpoint` / `apiKey` をコンストラクタで省略すると、上記の dart-define が読み込まれます。既定の SamuraiAI コールバックを利用する場合は3つの値が必要です。明示的なコンストラクタ引数は dart-define より優先されます。

フローティングアイコンはタップするとそのまま開き、長押しすると現在画面のスクリーンショットを撮影してから開きます。

## デバッグ認証・デバッグ課金

認証用の3コールバックをすべて指定すると、AI指示欄の上にログイン／ログアウトボタンが表示されます。
課金用の4コールバックをすべて指定すると、同じ行に課金管理ボタンが表示されます。これらのUIと
コールバックは他のAIデバッガー機能と同様にDebugビルドでのみ有効です。

`AIDebugPurchaseProduct`はAIデバッガー専用の軽量な商品型です。`masamune_purchase`には依存しないため、
アプリ側でIDを実際の`PurchaseProduct`へ変換してください。

```dart
const debugProducts = [
  AIDebugPurchaseProduct(id: "premium_monthly", label: "プレミアム（月額）"),
  AIDebugPurchaseProduct(id: "premium_yearly", label: "プレミアム（年額）"),
];

final purchaseProductsById = <String, PurchaseProduct>{
  monthlyProduct.productId: monthlyProduct,
  yearlyProduct.productId: yearlyProduct,
};

final aiDebugger = AIDebuggerMasamuneAdapter(
  login: (email, password) => debugAuth.signIn(email, password),
  logout: debugAuth.signOut,
  isLoggedIn: () => debugAuth.isSignedIn,
  purchaseProducts: () => debugProducts,
  purchase: (item) => debugPurchase.forcePurchase(
    purchaseProductsById[item.id]!,
  ),
  cancelPurchase: (item) => debugPurchase.forceCancel(
    purchaseProductsById[item.id]!,
  ),
  isPurchased: (item) => debugPurchase.isPurchased(
    purchaseProductsById[item.id]!,
  ),
);
```

ログイン／ログアウト／課金／解約後は、それぞれ同期getterの`isLoggedIn`／`isPurchased`が再評価され、
UIへ即座に反映されます。コールバック内で実際のストア購入や解約を行うのではなく、アプリのデバッグ用
状態を切り替える実装を渡してください。

Maestroからは次の固定Semanticsラベルを利用できます。

- `AI Debuggerを開く`
- `AIデバッガー指示入力`
- `AIデバッガー認証`
- `デバッグログイン メールアドレス`
- `デバッグログイン パスワード`
- `デバッグログイン実行`
- `AIデバッガー課金管理`
- `デバッグ課金 商品選択`
- `デバッグ強制課金実行`
- `課金解除 <商品ID>`
- `AI入力へ戻る`

Maestroの`pressKey`は修飾キー付きショートカットを送信できないため、フォームを直接開くショートカットは
提供していません。固定Semanticsラベルを`tapOn`／`inputText`で操作してください。

メッセージフォーム下部のMode／Modelボタンでは、次に手動送信するセッションの
`plan / bypassPermissions`と`haiku / sonnet / opus / mythos`を選択できます。
設定ボタンでは、未処理エラー時と計測超過時のMode／Model、およびモデル読込と
インジケーターの超過判定時間を個別に設定できます。これらの値は端末内へ保存され、
同じproject IDの次回起動時に復元されます。

手動送信と未処理エラー／性能閾値超過の自動送信には、現在のWidget構成が
Debugビルド内で自動的に添付されます。ページ名、ルート、調査に必要な状態値も
渡す場合は`contextProvider`を指定してください。providerは送信の直前に呼ばれるため、
その時点の状態を返します。

```dart
final aiDebugger = AIDebuggerMasamuneAdapter(
  contextProvider: () => AIDebugContextSnapshot(
    pageName: "CheckoutPage",
    route: "/checkout",
    values: {
      "cartCount": cartController.items.length,
      "isSubmitting": cartController.isSubmitting,
    },
  ),
);
```

`values`にはAIの調査に必要なJSON互換値だけを明示してください。任意のローカル変数を
自動収集する機能ではありません。token、API key、password、secretなどのキーと、
メールアドレスを含む文字列は送信前に秘匿され、ツリー・値の深さ、件数、文字数にも
上限が適用されます。独自AI providerの既存callbackシグネチャは変わらず、callback内では
`controller.currentContext`から、その送信に対応するスナップショットを参照できます。

## Custom AI provider

SamuraiAI is the default provider. To connect another AI or backend, pass callbacks for each API operation. Custom callbacks receive semantic values instead of SamuraiAI-specific URLs or JSON payloads, so `endpoint` and `apiKey` are not required when all callbacks are supplied.

```dart
final customDebugger = AIDebuggerMasamuneAdapter(
  projectId: "my-project",
  registerRun: myRegisterRun,
  heartbeat: myHeartbeat,
  endRun: myEndRun,
  uploadScreenshot: myUploadScreenshot,
  sendRequest: mySendRequest,
  reportIncident: myReportIncident,
  uploadEvents: myUploadEvents,
);
```

The callback typedefs are `AIDebugRegisterRunCallback`, `AIDebugHeartbeatCallback`, `AIDebugEndRunCallback`, `AIDebugUploadScreenshotCallback`, `AIDebugSendRequestCallback`, `AIDebugReportIncidentCallback`, and `AIDebugUploadEventsCallback`. To receive the selected model and permission mode, use `configuredSendRequest` (`AIDebugConfiguredSendRequestCallback`) and `configuredReportIncident` (`AIDebugConfiguredReportIncidentCallback`). The legacy callbacks remain available for integrations that do not use session settings. The corresponding `AIDebuggerMasamuneAdapter.default*` static functions expose the default SamuraiAI implementations. The existing `post` callback remains available for replacing only the low-level HTTP transport used by those defaults.

`upload()` returns the provider-specific screenshot identifier, not a URL. `AIDebugHttpException` represents a non-2xx response returned by the AI debug API; connection and transport failures may use other exception types.

例外と性能閾値超過による自動incidentには、セッションの過剰生成を防ぐセーフティが適用されます。
同じ種別・メッセージのincidentは、同じアプリ起動中には最初の1回だけ送信します。
内容が異なるincidentも1秒以内に連続した場合は最初の1回だけを送信し、残りは破棄します。
手動で送信したAI Debuggerリクエストはこの制限の対象外です。

## 遅延の自動検出

Debugビルドでは、既存の `LoggerAdapter` のperformance traceを使って次を自動計測します。

- MasamuneのDocument／Collectionモデルの `load`・`reload`・`next`（既定5秒）
- `Future.showIndicator` 経由のインジケーター表示（既定10秒）
- `MeasuredCircularProgressIndicator` / `MeasuredLinearProgressIndicator` の表示時間（既定10秒）

処理が終わらなくても閾値へ達した時点で、現在画面と直近ログをperformance incidentとして送信し、SamuraiAIにPlan Modeの調査セッションを作成します。同一処理はアプリ起動中の重複排除と時間当たり上限の対象です。閾値以下で完了した処理は `duration_ms` の通常ログだけを送ります。

Widgetツリーへ待機表示を直接配置する場合は、固定かつ機密情報を含まない`traceName`を付けた
`MeasuredCircularProgressIndicator`または`MeasuredLinearProgressIndicator`を使用してください。
常設の進捗率表示は標準ProgressIndicatorを使い、すでに計測済みの`showIndicator`へ計測版を渡して
二重計測してはいけません。閾値に `Duration.zero` を指定すると、そのカテゴリの自動incidentを無効化できます。

## 想定内／想定外エラーのcatchと報告

自動で設定される `runZonedGuarded`・`FlutterError.onError`・`PlatformDispatcher.onError` の3つは、いずれも
**誰にもハンドリングされなかった例外**専用のフックです。Dartの仕様上 `try-catch` でキャッチされた例外は
これらに一切到達しないため、握り潰すとAI Debuggerからは完全に不可視になります。

想定内エラーは型付きの `on XxxException catch` で個別に処理し、そのtryの最後に想定外エラー用の型指定なしcatchを置きます。型指定なしcatchで処理を継続する場合は `Logger.error` で明示的に報告してください。アプリテンプレートが生成する `appLogger` を使えば `ref` や `BuildContext` なしでどこからでも呼び出せます。

```dart
try {
  await something();
} on ValidationException catch (e) {
  handleValidationError(e);
} catch (e, stackTrace) {
  await appLogger.error(e, stackTrace);
  handleUnexpectedError();
}
```

これによりスクリーンショットとスタックトレース付きの `exception` incidentが送信されます。
`LoggerAdapter` が一つも設定されていない場合は何もしないため、想定外エラーを処理する際に常に呼び出しても安全です。

`masamune_lints` の `masamune_expected_error_should_have_unexpected_catch` が最終catchの不足を、`masamune_caught_error_should_report` が想定外エラーの報告漏れを警告します。`rethrow` や `throw` で伝播させている場合はグローバルハンドラーが報告するため対象外です。同じエラーをローカル報告してから再送出すると二重報告になるため避けてください。

lintはエラーの業務上の意味を推論しません。想定内エラーは型付きcatchで明示し、型なしcatch内の型判定で振り分けないでください。

握り潰した例外をincident化せずパンくずログ（severity `error`）だけに留めたい場合は
`reportHandledErrors` に `false` を指定します。

```dart
AIDebuggerMasamuneAdapter(
  reportHandledErrors: false,
);
```


# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
