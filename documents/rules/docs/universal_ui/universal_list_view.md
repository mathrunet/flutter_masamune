# `UniversalListView`の利用方法

`UniversalListView`は下記のように利用する。

## 概要

`ListView`の`UniversalUI`版。UniversalScaffold`と連携しSliverWidgetへの変換。`onRefresh`を設定可能でリストの更新を可能にする。`onLoadNext`を設定可能でリストの追加読み込みを可能にする。`padding`や`decoration`を設定可能でリストの外側に余白やボーダーを設定可能。

## 利用方法

```dart
UniversalListView(
  padding: const EdgeInsets.all(16),
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

- `padding`: リストの外側の余白を設定する。
- `onRefresh`: リストを更新する際のコールバックを設定する。
- `onLoadNext`: リストを追加読み込みする際のコールバックを設定する。
- `children`: リストに表示するウィジェットのリストを設定する。
- `decoration`: リストの外側のボーダーなどを設定する。
- `controller`: リストのスクロールコントローラーを設定する。
- `physics`: リストのスクロール動作を設定する。
- `shrinkWrap`: リストの高さを内容に合わせるかどうかを設定する。
- `primary`: リストを主要なスクロール可能ウィジェットとして扱うかどうかを設定する。

## 注意点

- `UniversalScaffold`と組み合わせて使用することで、自動的にSliverWidgetに変換される。
- `onRefresh`を設定すると、プルトゥリフレッシュが有効になる。
- `onLoadNext`を設定すると、リストの最後まで到達した際に追加読み込みが行われる。
