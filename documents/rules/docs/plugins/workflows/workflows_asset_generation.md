# アセット生成機能

このドキュメントでは、Masamune Workflowのアセット生成機能について詳しく説明します。
Gemini APIを使用した画像生成、Google Text-to-Speechによる音声生成、マルチモーダル入力からのテキスト生成などの機能を提供します。

## 概要

アセット生成機能は、AI/MLを活用して以下の3つの主要な機能を提供します：

1. **画像生成（generate_image_with_gemini）**: Gemini APIを使用したテキストから画像生成
2. **音声生成（generate_audio_with_google_tts）**: Google Text-to-Speechによる自然な音声合成
3. **マルチモーダルテキスト生成（generate_text_from_multimodal）**: 画像・動画・音声を組み合わせたテキスト生成

これらの機能により、マーケティングコンテンツ、教育資料、クリエイティブアセットなどを自動生成できます。

## 画像生成 - generate_image_with_gemini

### 概要

Gemini APIを使用して、テキストプロンプトから高品質な画像を生成します。

**アクションID**: `generate_image_with_gemini`

### パラメータ

```typescript
{
  "prompt": string,              // 必須: 生成する画像の説明
  "negative_prompt": string,     // 任意: 除外したい要素
  "width": number,               // 任意: 画像幅（デフォルト: 1024）
  "height": number,              // 任意: 画像高さ（デフォルト: 1024）
  "input_image": string,         // 任意: 入力画像（gs://形式）
  "reference_image": string,     // 任意: スタイル参照画像
  "model": string,              // 任意: 使用モデル（デフォルト: gemini-2.0-flash-exp）
  "seed": number,               // 任意: シード値（再現性のため）
  "output_path": string,        // 任意: 保存先パス
  "image_type": string          // 任意: 画像カテゴリ
}
```

### サポートする画像タイプ

- `illustration` - イラスト
- `photograph` - 写真
- `artwork` - アートワーク
- `diagram` - 図表
- `logo` - ロゴ
- `icon` - アイコン

### レスポンス

```typescript
{
  "results": {
    "imageGeneration": {
      "files": [{
        "width": 1024,
        "height": 1024,
        "format": "png",
        "size": 2048576
      }],
      "inputTokens": 100,
      "outputTokens": 50,
      "cost": 0.005
    }
  },
  "assets": {
    "generatedImage": {
      "url": "gs://bucket/generated/image.png",
      "public_url": "https://storage.googleapis.com/...",
      "content_type": "image/png",
      "signedUrl": "https://storage.googleapis.com/...?signature=..."
    }
  }
}
```

### 実装例

```dart
// マーケティング用画像の生成
final action = await ref.app.model(
  ActionModel.collection().create({
    "type": "generate_image_with_gemini",
    "data": {
      "prompt": "モダンでプロフェッショナルなスマートフォンアプリのランディングページ、青と白を基調としたデザイン",
      "negative_prompt": "人物、文字、ロゴ",
      "width": 1920,
      "height": 1080,
      "model": "gemini-2.0-flash-exp",
      "image_type": "artwork"
    }
  }),
);

// 生成された画像のURLを取得
final imageUrl = action.response["assets"]["generatedImage"]["signedUrl"];
```

### プロンプトのベストプラクティス

1. **詳細な説明**: 色、スタイル、構図、雰囲気を具体的に記述
2. **ネガティブプロンプト**: 除外したい要素を明確に指定
3. **シード値の活用**: 同じ結果を再現したい場合はシード値を固定
4. **解像度の選択**: 用途に応じて適切な解像度を選択

```dart
// 良いプロンプトの例
"日本の伝統的な桜の風景、春の晴れた日、富士山が背景に見える、パステルピンクと青空、写実的な水彩画スタイル"

// 改善が必要なプロンプトの例
"桜の絵"  // 詳細が不足
```

## 音声生成 - generate_audio_with_google_tts

### 概要

Google Cloud Text-to-Speech APIを使用して、テキストから自然な音声を生成します。

**アクションID**: `generate_audio_with_google_tts`

### パラメータ

```typescript
{
  "text": string,                // 必須: 読み上げるテキスト
  "voice_name": string,          // 任意: 音声の種類
  "language": string,            // 任意: 言語コード（デフォルト: ja-JP）
  "gender": string,              // 任意: 性別 (MALE/FEMALE/NEUTRAL)
  "output_format": string,       // 任意: 出力形式 (mp3/wav/ogg)
  "speaking_rate": number,       // 任意: 話速 (0.25-4.0、デフォルト: 1.0)
  "pitch": number,               // 任意: ピッチ (-20.0-20.0、デフォルト: 0.0)
  "volume_gain_db": number,      // 任意: 音量 (-96.0-16.0、デフォルト: 0.0)
  "output_path": string          // 任意: 保存先パス
}
```

### サポートする音声タイプ（日本語）

| 音声名 | 性別 | 特徴 |
|--------|------|------|
| ja-JP-Neural2-B | 男性 | ニューラル音声、自然な発音 |
| ja-JP-Neural2-C | 男性 | ニューラル音声、落ち着いた声 |
| ja-JP-Neural2-D | 男性 | ニューラル音声、若い声 |
| ja-JP-Neural2-A | 女性 | ニューラル音声、明瞭な発音 |
| ja-JP-Wavenet-A | 女性 | WaveNet、高品質 |
| ja-JP-Wavenet-B | 女性 | WaveNet、柔らかい声 |
| ja-JP-Standard-A | 女性 | 標準音声、基本品質 |

### レスポンス

```typescript
{
  "results": {
    "audioGeneration": {
      "files": [{
        "duration": 3.5,
        "format": "mp3",
        "size": 56320,
        "characters": 12
      }],
      "characters": 12,
      "cost": 0.001
    }
  },
  "assets": {
    "generatedAudio": {
      "url": "gs://bucket/generated/audio.mp3",
      "public_url": "https://storage.googleapis.com/...",
      "content_type": "audio/mpeg",
      "signedUrl": "https://storage.googleapis.com/...?signature=..."
    }
  }
}
```

### 実装例

```dart
// ナレーション音声の生成
final action = await ref.app.model(
  ActionModel.collection().create({
    "type": "generate_audio_with_google_tts",
    "data": {
      "text": "こんにちは。本日は素晴らしい天気ですね。新製品のご紹介をさせていただきます。",
      "voice_name": "ja-JP-Neural2-A",
      "language": "ja-JP",
      "gender": "FEMALE",
      "output_format": "mp3",
      "speaking_rate": 0.95,
      "pitch": 1.0,
      "volume_gain_db": 2.0
    }
  }),
);

// 多言語対応の例
final multilingualAction = await ref.app.model(
  ActionModel.collection().create({
    "type": "generate_audio_with_google_tts",
    "data": {
      "text": "Welcome to our service.",
      "voice_name": "en-US-Neural2-J",
      "language": "en-US",
      "gender": "MALE",
      "output_format": "wav"
    }
  }),
);
```

### 音声パラメータの調整ガイド

| パラメータ | 用途 | 推奨値 |
|-----------|------|--------|
| speaking_rate | ナレーション | 0.9-1.0 |
| speaking_rate | 緊急アナウンス | 1.1-1.3 |
| pitch | 子供向けコンテンツ | 2.0-5.0 |
| pitch | 落ち着いた説明 | -2.0-0.0 |
| volume_gain_db | BGM付き音声 | 3.0-6.0 |

## マルチモーダルテキスト生成 - generate_text_from_multimodal

### 概要

画像、動画、音声、ドキュメントなど複数のメディアファイルを総合的に分析し、Gemini APIを使用してテキストを生成します。

**アクションID**: `generate_text_from_multimodal`

### action.materialsフィールド

メディア素材は`action.materials`フィールドに配置します：

| フィールド | 型 | 説明 |
|----------|-----|------|
| images | string[] | 画像ファイルのgs:// URLリスト |
| videos | string[] | 動画ファイルのgs:// URLリスト |
| audio | string[] | 音声ファイルのgs:// URLリスト |
| documents | string[] | ドキュメントファイルのgs:// URLリスト |

### パラメータ（ActionCommand.data）

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| prompt | string | ✓ | メイン生成プロンプト |
| system_prompt | string | | システムインストラクション |
| output_format | string | | 出力形式 ("text" または "markdown"、デフォルト: "text") |
| max_tokens | number | | 最大トークン数（デフォルト: 8192） |
| temperature | number | | 生成温度（0.0-2.0、デフォルト: 0.7） |
| model | string | | Geminiモデル（デフォルト: gemini-2.0-flash-exp） |
| region | string | | GCPリージョン（デフォルト: us-central1） |

### サポートされているメディア形式

| カテゴリ | サポート形式 |
|---------|------------|
| 画像 | JPEG, PNG, GIF, WebP, BMP |
| 動画 | MP4, MPEG, MOV, AVI, FLV, MPG, WebM, WMV, 3GPP |
| 音声 | WAV, MP3, MPEG, AIFF, AAC, OGG, FLAC |
| ドキュメント | PDF, TXT, Markdown |

### レスポンス

```typescript
{
  "results": {
    "textGeneration": {
      "files": [{
        "path": "generated-texts/xxx.txt",
        "content_type": "text/plain",
        "size": 1024
      }],
      "generatedText": "生成されたテキスト内容...",
      "inputTokens": 500,
      "outputTokens": 300,
      "cost": 0.0225,
      "processedMaterials": {
        "images": 2,
        "videos": 1,
        "audio": 1,
        "documents": 1
      }
    }
  },
  "assets": {
    "generatedText": {
      "url": "gs://bucket/generated-texts/xxx.txt",
      "public_url": "https://storage.googleapis.com/...",
      "content_type": "text/plain"
    }
  }
}
```

### 実装例1: 商品説明文生成

```dart
final workflow = WorkflowWorkflowModel(
  name: "商品説明文生成",
  prompt: "商品画像と動画から魅力的な説明文を作成",
  materials: {
    "images": [
      "gs://bucket/products/product-photo1.jpg",
      "gs://bucket/products/product-photo2.jpg",
      "gs://bucket/products/product-photo3.jpg"
    ],
    "videos": [
      "gs://bucket/products/demo-video.mp4"
    ],
    "audio": [
      "gs://bucket/products/customer-review.mp3"
    ]
  },
  actions: [
    WorkflowActionCommandValue(
      command: "generate_text_from_multimodal",
      index: 0,
      data: {
        "prompt": """
提供された画像、動画、音声レビューを基に、以下の要素を含む商品説明文を作成してください：

1. 商品の主要な特徴（画像から読み取れる内容）
2. 使用方法とデモンストレーション（動画の内容）
3. 実際のユーザーの声（音声レビューの要約）
4. 商品のメリットとユニークセリングポイント

文体：親しみやすく、購買意欲を高める内容
文字数：800-1200文字程度""",
        "system_prompt": "あなたはECサイトの商品説明文を作成する専門のコピーライターです。",
        "output_format": "markdown",
        "max_tokens": 2000,
        "temperature": 0.8
      }
    )
  ]
);
```

### 実装例2: プレゼンテーション資料分析

```dart
final workflow = WorkflowWorkflowModel(
  name: "プレゼンテーション資料分析",
  prompt: "プレゼン資料の総合分析レポート作成",
  materials: {
    "images": [
      "gs://bucket/presentation/slide1.png",
      "gs://bucket/presentation/slide2.png",
      "gs://bucket/presentation/slide3.png"
    ],
    "videos": [
      "gs://bucket/presentation/demo.mp4"
    ],
    "documents": [
      "gs://bucket/presentation/notes.pdf"
    ]
  },
  actions: [
    WorkflowActionCommandValue(
      command: "generate_text_from_multimodal",
      index: 0,
      data: {
        "prompt": """
プレゼンテーション資料を分析し、以下の形式でレポートを作成してください：

# プレゼンテーション分析レポート

## 1. 概要
- プレゼンの主題とメッセージ
- ターゲット・オーディエンス

## 2. スライド内容の要約
- 各スライドの主要ポイント
- 視覚的要素の効果

## 3. デモンストレーション内容
- 動画で示された機能や特徴
- デモの有効性評価

## 4. 改善提案
- プレゼンテーションの強化ポイント
- 追加すべき要素
""",
        "output_format": "markdown",
        "max_tokens": 4096,
        "temperature": 0.5
      }
    )
  ]
);
```

### 実装例3: ビジュアルストーリー作成

```dart
final workflow = WorkflowWorkflowModel(
  name: "ビジュアルストーリー作成",
  prompt: "画像と音楽からストーリーを生成",
  materials: {
    "images": [
      "gs://bucket/story/scene1.jpg",
      "gs://bucket/story/scene2.jpg",
      "gs://bucket/story/scene3.jpg",
      "gs://bucket/story/scene4.jpg"
    ],
    "audio": [
      "gs://bucket/story/bgm.mp3"
    ]
  },
  actions: [
    WorkflowActionCommandValue(
      command: "generate_text_from_multimodal",
      index: 0,
      data: {
        "prompt": """
提供された画像を順番に見て、BGMの雰囲気も考慮しながら、
これらを繋げた物語を創作してください。

- ジャンル：ファンタジー
- 文体：小説風
- 長さ：2000文字程度
- 各画像をシーンとして必ず含める
- BGMの雰囲気を文章に反映させる
""",
        "system_prompt": "あなたは創造的な物語作家です。",
        "output_format": "text",
        "max_tokens": 3000,
        "temperature": 0.9
      }
    )
  ]
);
```

## コスト計算

### Gemini API料金体系

**Gemini 2.0 Flash Experimental**（推奨）
- 入力トークン: $0.075 / 1M トークン
- 出力トークン: $0.30 / 1M トークン
- 無料枠: 月間150万トークン

**マルチモーダル入力のトークン換算**
- 画像: 約258トークン/画像（1024x1024）
- 動画: フレーム数×258トークン（1秒あたり1フレームサンプリング）
- 音声: 約25トークン/秒

### Google Text-to-Speech料金

| 音声タイプ | 料金（100万文字） |
|-----------|------------------|
| Standard | $4.00 |
| WaveNet | $16.00 |
| Neural2 | $16.00 |
| Studio | $160.00 |

### コスト最適化のヒント

1. **モデル選択**
   - 開発・テスト: `gemini-2.0-flash-exp`（無料枠活用）
   - 本番環境: 品質要件に応じて選択

2. **メディア最適化**
   - 画像: 必要最小限の解像度に圧縮
   - 動画: サンプリングレート調整
   - 音声: 必要部分のみ抽出

3. **キャッシュ戦略**
   ```dart
   // 生成結果をキャッシュ
   final cache = AssetCache();

   final cachedResult = await cache.get(promptHash);
   if (cachedResult != null) {
     return cachedResult;
   }

   final result = await generateAsset(...);
   await cache.set(promptHash, result);
   ```

## エラーハンドリング

```dart
try {
  final action = await ref.app.model(
    ActionModel.collection().create({
      "type": "generate_image_with_gemini",
      "data": {...}
    }),
  );

  if (action.status == ActionStatus.error) {
    switch (action.error["code"]) {
      case "QUOTA_EXCEEDED":
        // API制限エラー
        print("APIクォータを超過しました。翌日まで待機してください。");
        break;
      case "INVALID_PROMPT":
        // プロンプトエラー
        print("プロンプトが不適切です。内容を修正してください。");
        break;
      case "SAFETY_BLOCK":
        // 安全性フィルタ
        print("コンテンツが安全性フィルタによりブロックされました。");
        break;
      default:
        print("予期しないエラー: ${action.error}");
    }
  }
} catch (e) {
  print("実行エラー: $e");
}
```

## ベストプラクティス

### 1. バッチ処理の活用

```dart
// 複数の画像を並列生成
final prompts = [
  "春の風景",
  "夏の海",
  "秋の紅葉",
  "冬の雪景色"
];

final futures = prompts.map((prompt) =>
  ref.app.model(
    ActionModel.collection().create({
      "type": "generate_image_with_gemini",
      "data": {"prompt": prompt}
    })
  )
);

final results = await Future.wait(futures);
```

### 2. プログレッシブ生成

```dart
// 低解像度から高解像度へ段階的に生成
final lowRes = await generateImage(width: 512, height: 512);
final highRes = await upscaleImage(lowRes, targetWidth: 2048);
```

### 3. 品質管理

```dart
// 生成結果の検証
class AssetValidator {
  static bool validateImage(Map<String, dynamic> result) {
    final width = result["imageGeneration"]["files"][0]["width"];
    final height = result["imageGeneration"]["files"][0]["height"];
    final size = result["imageGeneration"]["files"][0]["size"];

    return width >= 1024 &&
           height >= 1024 &&
           size < 10 * 1024 * 1024; // 10MB以下
  }

  static bool validateAudio(Map<String, dynamic> result) {
    final duration = result["audioGeneration"]["files"][0]["duration"];
    return duration > 0 && duration < 300; // 5分以下
  }
}
```

## 活用シナリオ

### 1. マーケティングコンテンツ生成

- SNS投稿用画像の自動生成
- 商品説明文と画像のセット作成
- 多言語音声ガイドの作成

### 2. 教育コンテンツ作成

- 教材用イラストの生成
- ナレーション音声の作成
- インタラクティブコンテンツの開発

### 3. カスタマーサポート

- FAQの音声版作成
- 説明用図表の自動生成
- マルチメディアマニュアルの作成

## まとめ

アセット生成機能は、AI技術を活用してさまざまなメディアコンテンツを自動生成する強力なツールです。適切な設定とプロンプトエンジニアリングにより、高品質なアセットを効率的に作成できます。

### 次のステップ
- [メインワークフローに戻る](../workflow.dart)
- [マーケティング分析機能](marketing_analytics.dart) - 生成アセットの効果測定
- [基本ワークフロー機能](basic_workflow.dart) - スケジューラーとタスク管理
- [セールス機能](sales_functions.dart) - ビジネス開発支援
