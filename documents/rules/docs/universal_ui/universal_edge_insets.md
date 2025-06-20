# `UniversalEdgeInsets`の利用方法

`ResponsiveEdgeInsets`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
ResponsiveEdgeInsets(
  const EdgeInsets.all(8),
  breakpoint: Breakpoint.md,
  greaterThanBreakpoint: const EdgeInsets.all(24),
);
```

## プロパティ

- 第1引数: メインの[EdgeInsets]。通常はこちらが利用されます。
- `breakpoint`: レスポンシブ対応するためのブレークポイント。
- `greaterThanBreakpoint`: ブレークポイントより大きい場合に適用される[EdgeInsets]。

## 注意点

- `UniversalScaffold`と組み合わせることで、自動的にレスポンシブ対応が行われる。
- ブレークポイントより小さい場合は`breakpoint`の値が適用される。
- ブレークポイントより大きい場合は`greaterThanBreakpoint`の値が適用される。
