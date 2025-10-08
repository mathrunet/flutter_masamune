# `UniversalEdgeInsets`の利用方法

`ResponsiveEdgeInsets`は下記のように利用する。

## 概要

`EdgeInsets`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。ブレークポイントに応じて余白の値を変更可能。

## 基本的な利用方法

```dart
Container(
  padding: ResponsiveEdgeInsets(
    const EdgeInsets.all(8),
    breakpoint: Breakpoint.md,
    greaterThanBreakpoint: const EdgeInsets.all(24),
  ),
  child: const Text("レスポンシブなパディング"),
);
```

## UniversalUIウィジェットと組み合わせた例

```dart
UniversalPadding(
  padding: ResponsiveEdgeInsets(
    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    breakpoint: Breakpoint.md,
    greaterThanBreakpoint: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  ),
  child: const Text("デスクトップでは余白が大きくなる"),
);
```

## 明示的にresponsive()メソッドを使う例

`UniversalUI`に対応していないウィジェットでも、`responsive()`メソッドを使用することで明示的にレスポンシブな余白を適用できます：

```dart
Container(
  padding: ResponsiveEdgeInsets(
    const EdgeInsets.all(8),
    breakpoint: Breakpoint.md,
    greaterThanBreakpoint: const EdgeInsets.all(24),
  ).responsive(context),
  child: const Text("明示的にresponsiveを適用"),
);
```

## プロパティ

- `primary`（第1引数）: メインの`EdgeInsets`。通常はこちらが利用されます。`MasamuneUniversalUI`対応のウィジェットでない場合は`primary`がそのまま適用されます。
- `breakpoint`: レスポンシブ対応するためのブレークポイント。
- `greaterThanBreakpoint`: ブレークポイントより大きい場合に適用される`EdgeInsets`。

## メソッド

- `responsive(BuildContext context, {Breakpoint? breakpoint})`: `context`を渡すことで現在のブレークポイントに対応する`EdgeInsets`を取得します。`breakpoint`を指定すると優先的に使用するブレークポイントを指定できます。

## 動作の仕組み

- 画面の横幅が`breakpoint`より**下回っている場合**は`primary`が利用されます。
- `greaterThanBreakpoint`が指定されていて画面の横幅が`breakpoint`より**上回っている場合**は`greaterThanBreakpoint`が利用されます。
- `UniversalScaffold`と組み合わせることで、自動的にレスポンシブ対応が行われます。

## 注意点

- `EdgeInsetsGeometry`にそのまま渡すことができ、`MasamuneUniversalUI`に対応したウィジェットであれば、設定した`breakpoint`によって内容が自動的に変化します。
- `MasamuneUniversalUI`対応のウィジェットでない場合は、`responsive()`メソッドを明示的に呼び出す必要があります。
- `UniversalScaffold`を使用している場合、`breakpoint`を省略すると`UniversalScaffold`の`breakpoint`が自動的に使用されます。
