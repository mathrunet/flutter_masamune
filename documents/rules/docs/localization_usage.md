# ローカライゼーション（多言語対応）の実装と利用方法

Masamuneフレームワークでは、型安全で効率的な多言語対応を実現するローカライゼーションシステムを提供しています。
YAMLファイルベースの翻訳管理とコード生成により、タイプミスを防ぎながら簡単に多言語対応を実装できます。

## 基本的な実装フロー

### 1. YAMLファイルの作成と編集

プロジェクトのルートディレクトリに`localize.app.yaml`ファイルを作成し、翻訳内容を定義します。

```yaml
localize:
  - key: "Hello"
    en_US: "Hello"
    ja_JP: "こんにちは"
    es_ES: "Hola"
    zh_CN: "你好"
    ko_KR: "안녕하세요"
    fr_FR: "Bonjour"
    de_DE: "Hallo"
    pt_PT: "Olá"
    ru_RU: "Здравствуйте"
    id_ID: "Halo"

  - key: "Welcome {name}"
    en_US: "Welcome {name}"
    ja_JP: "ようこそ {name}さん"
    es_ES: "Bienvenido {name}"
    zh_CN: "欢迎 {name}"
    ko_KR: "환영합니다 {name}님"
    fr_FR: "Bienvenue {name}"
    de_DE: "Willkommen {name}"
    pt_PT: "Bem-vindo {name}"
    ru_RU: "Добро пожаловать {name}"
    id_ID: "Selamat datang {name}"

  - key: "You have {count} new messages"
    en_US: "You have {count} new messages"
    ja_JP: "{count}件の新着メッセージがあります"
    es_ES: "Tienes {count} nuevos mensajes"
    zh_CN: "您有{count}条新消息"
    ko_KR: "{count}개의 새 메시지가 있습니다"
    fr_FR: "Vous avez {count} nouveaux messages"
    de_DE: "Sie haben {count} neue Nachrichten"
    pt_PT: "Você tem {count} novas mensagens"
    ru_RU: "У вас есть {count} новых сообщений"
    id_ID: "Anda memiliki {count} pesan baru"
```

**ポイント:**
- `key`は英語の文章と同じにすることを推奨（可読性向上のため）
- `{変数名}`を使用して動的な値を埋め込み可能
- 下記の言語の翻訳を追加することを推奨
  - en_US
  - ja_JP
  - es_ES
  - zh_CN
  - ko_KR
  - fr_FR
  - de_DE
  - pt_PT
  - ru_RU
  - id_ID

### 2. ローカライゼーションクラスの定義

`lib/localize.dart`ファイルを作成し、`@YamlLocalize`アノテーションを使用してローカライゼーションクラスを定義します。

```dart
// lib/localize.dart
import 'package:katana_localization_annotation/katana_localization_annotation.dart';

part 'localize.localize.dart';

@YamlLocalize(
  version: 1,  // 翻訳更新時にバージョンを上げる
  path: [
    "localize.base.yaml",  // 基本的な翻訳（オプション）
    "localize.app.yaml"    // アプリ固有の翻訳
  ],
)
class AppLocalize extends _$AppLocalize {}

// グローバルインスタンス
final l = AppLocalize();
```

**バージョン管理について:**
- 翻訳内容を変更した場合は`version`を増やす
- バージョンが変わらない場合はキャッシュが使用される（パフォーマンス最適化）

### 3. コード生成の実行

YAMLファイルとローカライゼーションクラスを定義したら、以下のコマンドでコードを生成します。

```bash
katana code generate
```

このコマンドにより、`lib/localize.localize.dart`ファイルが自動生成され、型安全な翻訳アクセスが可能になります。

### 4. UIへの統合

`main.dart`で`LocalizeScope`を使用してアプリに統合します。

```dart
import 'package:flutter/material.dart';
import 'package:katana_localization/katana_localization.dart';
import 'localize.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizeScope(
      localize: l,  // グローバルローカライゼーションインスタンス
      builder: (context, localize) {
        return MaterialApp(
          // ローカライゼーション設定
          locale: localize.locale,
          localizationsDelegates: localize.delegates(),
          supportedLocales: localize.supportedLocales(),
          localeResolutionCallback: localize.localeResolutionCallback(),

          title: localize().appTitle,  // 翻訳の使用
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
```

## 翻訳の使用方法

### 基本的な使用

```dart
// グローバルインスタンスから翻訳を取得
Text(l().hello)  // 現在のロケールで "Hello" を表示

// BuildContext経由でも取得可能（非推奨）
Text(AppLocalize.of(context).hello)
```

### メソッドチェーンスタイル

```dart
// YAMLの定義例
// - key: "{action} has been completed"
//   ja_JP: "{action}が完了しました"

// 使用例
l().$(l().saving).hasBeenCompleted  // "保存が完了しました"

// より複雑な例
l().$(l().$("Government").ofThe.$("People")).byThe.$("People").forThe.$("People")
// "Government of the People, by the People, for the People"
```

## 言語の切り替え

### プログラムによる言語切り替え

```dart
// 言語を日本語に切り替え
l.setCurrentLocale(const Locale("ja", "JP"));

// 現在の言語を取得
final currentLocale = l.locale;
print("Current language: ${currentLocale.languageCode}_${currentLocale.countryCode}");

// サポートされている言語一覧を取得
final supportedLocales = l.supportedLocales();
for (final locale in supportedLocales) {
  print("Supported: ${locale.languageCode}_${locale.countryCode}");
}
```

### システム言語に従う

```dart
// BuildContextからシステムの言語設定を取得して適用
l.setCurrentLocaleWithContext(context);
```

## 高度な機能

### 複数のYAMLファイルの統合

基本的な翻訳とアプリ固有の翻訳を分離できます。

```dart
@YamlLocalize(
  version: 1,
  path: [
    "localize.base.yaml",    // 共通の基本翻訳
    "localize.app.yaml",     // アプリ固有の翻訳
    "localize.custom.yaml"   // カスタマイズ翻訳
  ],
)
```

後に読み込まれたファイルの翻訳が優先されます。

### Google Spreadsheetとの連携

チーム開発や翻訳者との協業には、Google Spreadsheetを使用することもできます。

```dart
@GoogleSpreadSheetLocalize(
  [
    "https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID/edit"
  ],
  version: 1,
)
class AppLocalize extends _$AppLocalize {}
```

### 言語変更のリスニング

`AppLocalizeBase`は`ChangeNotifier`を継承しているため、言語変更を監視できます。

```dart
class LanguageSettingsPage extends StatefulWidget {
  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  @override
  void initState() {
    super.initState();
    l.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    l.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    setState(() {
      // UIを再構築
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l().languageSettings),
      ),
      body: ListView(
        children: [
          for (final locale in l.supportedLocales())
            RadioListTile<Locale>(
              title: Text(_getLanguageName(locale)),
              value: locale,
              groupValue: l.locale,
              onChanged: (locale) {
                if (locale != null) {
                  l.setCurrentLocale(locale);
                }
              },
            ),
        ],
      ),
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      case 'zh':
        return '中文';
      case 'ko':
        return '한국어';
      default:
        return locale.languageCode;
    }
  }
}
```

## ベストプラクティス

### 1. キーの命名規則

```yaml
# 良い例：意味が明確で文脈がわかる
- key: "Welcome to our app"
- key: "Please enter your email"
- key: "Password must be at least 8 characters"

# 悪い例：意味不明な略語
- key: "wlcm_msg"
- key: "pwd_err_1"
```

### 2. 変数名の統一

```yaml
# 良い例：一貫性のある変数名
- key: "Hello {userName}"
- key: "You have {messageCount} messages"
- key: "Last login: {loginDate}"

# 悪い例：不統一な変数名
- key: "Hello {name}"
- key: "You have {count} messages"
- key: "Last login: {date}"
```

### 3. プレースホルダーの活用

```yaml
# 数値や日付は変数化して、フォーマットはコード側で制御
- key: "Total: {amount}"
  en_US: "Total: ${amount}"
  ja_JP: "合計: {amount}円"

# 使用例
Text(l().total(amount: NumberFormat.currency(locale: 'ja_JP').format(1000)))
```

### 4. コンテキスト別の翻訳管理

```yaml
# 画面やコンテキストごとにプレフィックスを付ける
- key: "login.title"
  en_US: "Sign In"
  ja_JP: "ログイン"

- key: "login.email_label"
  en_US: "Email Address"
  ja_JP: "メールアドレス"

- key: "settings.title"
  en_US: "Settings"
  ja_JP: "設定"
```

## トラブルシューティング

### 翻訳が更新されない場合

1. `@YamlLocalize`の`version`を増やしたか確認
2. `katana code generate`を実行したか確認
3. ホットリロードではなくホットリスタートを試す

### コード生成エラーが発生する場合

1. YAMLファイルの構文が正しいか確認
2. 特殊文字は適切にエスケープする
3. 重複するキーがないか確認

```yaml
# 特殊文字のエスケープ例
- key: "Quote example"
  en_US: "He said \"Hello\""
  ja_JP: "彼は「こんにちは」と言った"
```

### 言語が自動で切り替わらない場合

```dart
// システム言語を明示的に適用
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    l.setCurrentLocaleWithContext(context);
  });
}
```

## 実装例の参照

実際のプロジェクトでの実装例：
- [localize.app.yaml](https://github.com/mathrunet/flutter_app_nansuru/blob/main/localize.app.yaml)
- [lib/localize.dart](https://github.com/mathrunet/flutter_app_nansuru/blob/main/lib/localize.dart)

これらの実装例を参考に、プロジェクトに応じたローカライゼーションを実装してください。

## まとめ

Masamuneのローカライゼーションシステムは：

- **型安全**: コード生成により、存在しない翻訳キーへのアクセスはコンパイルエラーになる
- **効率的**: バージョン管理によるキャッシング、ChangeNotifierによる最小限の再構築
- **柔軟**: YAML管理、Google Spreadsheet連携、複数ファイル統合をサポート
- **使いやすい**: BuildContext不要、グローバルアクセス可能、IDE補完対応

これらの機能により、保守性の高い多言語対応アプリケーションを効率的に開発できます。
