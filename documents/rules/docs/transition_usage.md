# Router`による`Page`遷移時のトランジション利用方法

`Router`の利用(`documents/rules/docs/router_usage.md`)時に`Page`遷移時のトランジションを下記のように設定することが可能。

- `TransitionQuery.fullscreen`
    - フルスクリーン時のアニメーションで次のページを表示。
    - 戻るボタンが強制的に閉じるボタンに変更される。

- `TransitionQuery.none`
    - アニメーションを行なわない。

- `TransitionQuery.fade`
    - フェードのアニメーションで次のページを表示。

- `TransitionQuery.centerModal`
    - 真ん中から出現するモーダルのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。（ただし少し暗く見える）

- `TransitionQuery.bottomModal`
    - 下から出現するモーダルのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。（ただし少し暗く見える）

- `TransitionQuery.leftModal`
    - 左から出現するモーダルのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。（ただし少し暗く見える）

- `TransitionQuery.rightModal`
    - 右から出現するモーダルのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。（ただし少し暗く見える）

- `TransitionQuery.leftSheet`
    - 左から出現するシートのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。（暗くは見えない）

- `TransitionQuery.rightSheet`
    - 右から出現するシートのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。（暗くは見えない）

- `TransitionQuery.bottomSheet`
    - 下から出現するシートのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。（暗くは見えない）
