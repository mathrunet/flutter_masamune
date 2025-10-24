# `Storage`の実装方法とその利用方法

## `Storage`の概要

`Storage`は、ファイルのアップロード・ダウンロードを行うための仕組みを提供します。

アダプターパターンを採用しており、ローカルストレージ、クラウドストレージ(Firebase Storage)など、異なるストレージバックエンドを簡単に切り替えることができます。

## インストール

```bash
flutter pub add katana_storage
```

Firebase Storageを使用する場合は、追加で以下をインストールします。

```bash
flutter pub add katana_storage_firebase
```

## 初期設定

アプリケーションのルート(通常は`main.dart`)で`StorageAdapterScope`を設定します。

### ローカルストレージを使用する場合

```dart
StorageAdapterScope(
  adapter: const LocalStorageAdapter(),
  child: MaterialApp(
    home: MyHomePage(),
  ),
)
```

### Firebase Storageを使用する場合

```dart
StorageAdapterScope(
  adapter: const FirebaseStorageAdapter(),
  child: MaterialApp(
    home: MyHomePage(),
  ),
)
```

### ランタイムストレージ(テスト用)を使用する場合

```dart
StorageAdapterScope(
  adapter: const RuntimeStorageAdapter(),
  child: MaterialApp(
    home: MyHomePage(),
  ),
)
```

## `Storage`オブジェクトの作成

`Storage`オブジェクトは`StorageQuery`を使用して作成します。

```dart
final storage = Storage(const StorageQuery("test/file"));
```

`StorageQuery`の引数には、ストレージ内のファイルパスを指定します。

## ファイルのアップロード

### ローカルファイルからアップロード

```dart
final storageValue = await storage.upload("/path/to/local/file.jpg");
print(storageValue.remote.path); // リモートのパス
print(storageValue.local.path);  // ローカルのパス
```

### バイトデータから直接アップロード

```dart
final bytes = Uint8List.fromList(text.codeUnits);
final storageValue = await storage.uploadWithBytes(bytes);
print(storageValue.remote.path); // リモートのパス
print(storageValue.local.path);  // ローカルのパス
```

## ファイルのダウンロード

```dart
final storageValue = await storage.download("file.jpg");
print(storageValue.local.path); // ダウンロードされたローカルのパス
```

## `StorageValue`について

`StorageValue`は、アップロード・ダウンロードの結果を表すオブジェクトです。

### プロパティ

- `remote`: リモート(クラウド)のファイル情報
  - `remote.path`: リモートのファイルパス
- `local`: ローカルのファイル情報
  - `local.path`: ローカルのファイルパス

## ストレージアダプターの種類

### `RuntimeStorageAdapter`

メモリ内に保存されるアダプター。テスト用に使用します。

```dart
const RuntimeStorageAdapter()
```

### `LocalStorageAdapter`

デバイスのローカルストレージに保存されるアダプター。

```dart
const LocalStorageAdapter()
```

### `FirebaseStorageAdapter`

Cloud Storage for Firebaseに保存されるアダプター。

```dart
FirebaseStorageAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
)
```

## 使用例

### 画像のアップロードとダウンロード

```dart
// Storageオブジェクトの作成
final storage = Storage(const StorageQuery("images/profile.jpg"));

// ローカルの画像ファイルをアップロード
final uploadResult = await storage.upload("/path/to/image.jpg");
print("アップロード完了: ${uploadResult.remote.path}");

// 画像をダウンロード
final downloadResult = await storage.download("profile.jpg");
print("ダウンロード完了: ${downloadResult.local.path}");
```

### バイトデータのアップロード

```dart
final storage = Storage(const StorageQuery("data/textfile.txt"));

// テキストをバイトデータに変換してアップロード
final text = "Hello, World!";
final bytes = Uint8List.fromList(text.codeUnits);
final result = await storage.uploadWithBytes(bytes);
print("アップロード完了: ${result.remote.path}");
```

## ストレージアダプターの切り替え

アダプターを切り替えることで、開発時はローカルストレージを使用し、本番環境ではFirebase Storageを使用するといった運用が可能です。

```dart
// 開発時
final storageAdapter = const LocalStorageAdapter();

// 本番環境
final storageAdapter = const FirebaseStorageAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

アプリケーションコード側では、どのアダプターを使用していても同じコードで動作します。

## 注意事項

- `StorageQuery`で指定するパスは、ストレージシステム内での相対パスとなります
- Firebase Storageを使用する場合は、事前にFirebaseプロジェクトの設定が必要です
- アップロード・ダウンロードは非同期処理となるため、`await`または`.then()`を使用して結果を待つ必要があります
