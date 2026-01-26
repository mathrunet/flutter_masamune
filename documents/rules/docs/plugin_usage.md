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
