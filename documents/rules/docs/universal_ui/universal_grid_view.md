# `UniversalGridView`の利用方法

`UniversalGridView`は下記のように利用する。

## 概要

`GridView`の`UniversalUI`版。UniversalScaffold`と連携しSliverWidgetへの変換。`onRefresh`を設定可能でグリッドの更新を可能にする。`onLoadNext`を設定可能でグリッドの追加読み込みを可能にする。`padding`や`decoration`を設定可能でグリッドの外側に余白やボーダーを設定可能。

## 利用方法

```dart
UniversalGridView(
  padding: const EdgeInsets.all(16),
  crossAxisCount: 2,
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  onRefresh: () async {
      // TODO: Implement the refresh logic.
  },
  onLoadNext: () async {
      // TODO: Implement the load next logic.
  },
  children: [
      // Any widget.
  ],
);
```

## プロパティ

- `padding`: グリッドの外側の余白を設定する。
- `crossAxisCount`: グリッドの列数を設定する。
- `mainAxisSpacing`: グリッドのアイテム間の縦方向の間隔を設定する。
- `crossAxisSpacing`: グリッドのアイテム間の横方向の間隔を設定する。
- `onRefresh`: グリッドを更新する際のコールバックを設定する。
- `onLoadNext`: グリッドを追加読み込みする際のコールバックを設定する。
- `children`: グリッドに表示するウィジェットのリストを設定する。
- `decoration`: グリッドの外側のボーダーなどを設定する。
- `controller`: グリッドのスクロールコントローラーを設定する。
- `physics`: グリッドのスクロール動作を設定する。
- `shrinkWrap`: グリッドの高さを内容に合わせるかどうかを設定する。
- `primary`: グリッドを主要なスクロール可能ウィジェットとして扱うかどうかを設定する。

## 注意点

- `UniversalScaffold`と組み合わせて使用することで、自動的にSliverWidgetに変換される。
- `onRefresh`を設定すると、プルトゥリフレッシュが有効になる。
- `onLoadNext`を設定すると、グリッドの最後まで到達した際に追加読み込みが行われる。
- `crossAxisCount`は必須のパラメータで、グリッドの列数を指定する必要がある。
