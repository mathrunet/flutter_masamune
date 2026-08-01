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
  projectId: "Users-mathru-Documents-github-myapp",
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

Create one adapter instance and pass that same instance to both `MasamuneApp` and `runMasamuneApp`. The `projectId` should be the absolute project directory with the leading slash removed and the remaining slashes replaced by hyphens.

Do not embed the connection target and API key in the source code; specify them during debug startup.

```bash
flutter run \
  --dart-define=MASAMUNE_AI_DEBUGGER_ENDPOINT=https://your-tailnet-host/__samurai \
  --dart-define=MASAMUNE_AI_DEBUGGER_API_KEY=your-key
```

APIキーは SamuraiAI の Settings で作成します。Debug APK/IPAにも値は含まれるため、配布せず、不要になったキーは無効化してください。スクリーンショットは手動操作時、未処理エラー検出時、性能閾値超過時だけ送信されます。

`endpoint` と `apiKey` をコンストラクタで省略すると、上記の dart-define が読み込まれます。既定の SamuraiAI コールバックを利用する場合は両方の値が必要です。

フローティングアイコンはタップするとそのまま開き、長押しすると現在画面のスクリーンショットを撮影してから開きます。

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

The callback typedefs are `AIDebugRegisterRunCallback`, `AIDebugHeartbeatCallback`, `AIDebugEndRunCallback`, `AIDebugUploadScreenshotCallback`, `AIDebugSendRequestCallback`, `AIDebugReportIncidentCallback`, and `AIDebugUploadEventsCallback`. The corresponding `AIDebuggerMasamuneAdapter.default*` static functions expose the default SamuraiAI implementations. The existing `post` callback remains available for replacing only the low-level HTTP transport used by those defaults.

`upload()` returns the provider-specific screenshot identifier, not a URL. `AIDebugHttpException` represents a non-2xx response returned by the AI debug API; connection and transport failures may use other exception types.

## 遅延の自動検出

Debugビルドでは、既存の `LoggerAdapter` のperformance traceを使って次を自動計測します。

- MasamuneのDocument／Collectionモデルの `load`・`reload`・`next`（既定5秒）
- `Future.showIndicator` 経由のインジケーター表示（既定10秒）
- `MeasuredCircularProgressIndicator` / `MeasuredLinearProgressIndicator` の表示時間（既定10秒）

処理が終わらなくても閾値へ達した時点で、現在画面と直近ログをperformance incidentとして送信し、SamuraiAIにPlan Modeの調査セッションを作成します。同一処理は既存の重複排除と時間当たり上限の対象です。閾値以下で完了した処理は `duration_ms` の通常ログだけを送ります。

Widgetツリーへ待機表示を直接配置する場合は、固定かつ機密情報を含まない`traceName`を付けた
`MeasuredCircularProgressIndicator`または`MeasuredLinearProgressIndicator`を使用してください。
常設の進捗率表示は標準ProgressIndicatorを使い、すでに計測済みの`showIndicator`へ計測版を渡して
二重計測してはいけません。閾値に `Duration.zero` を指定すると、そのカテゴリの自動incidentを無効化できます。


# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
