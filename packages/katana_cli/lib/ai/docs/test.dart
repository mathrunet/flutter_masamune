// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of test.md.
///
/// test.mdの中身。
class TestMdCliAiCode extends CliAiCode {
  /// Contents of test.md.
  ///
  /// test.mdの中身。
  const TestMdCliAiCode();

  @override
  String get name => "テストの実装および実施方法について";

  @override
  String get description => "テストの実装および実施方法について";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## テストの実装および実施方法について。

- Masamuneフレームワークでのテスト
    - Masamuneフレームワークでは`Controller`、`Widget`、`Page`の3種類のテストを行う。それぞれ`Controller`=>単体テスト、`Widget`と`Page`=>ゴールデンテストという方法でテストを行う。
    - Flutterのフレームワークに準じてテストを行うためすべてのテストファイルは`test`フォルダに作成されている。
        - `Controller`のテストファイルは`test/controllers`フォルダに、`Widget`のテストファイルは`test/widgets`フォルダに、`Page`のテストファイルは`test/pages`フォルダに作成されている。
    - Masamuneフレームワークではテストを行うための各種メソッドが用意されており、必ずそれに沿ってテストコードを実装する。

### テストの準備

- テストの環境設定は`test/flutter_test_config.dart`ファイルに記載されている。
- モック用のruntimeModelAdapterやruntimeAuthAdapter、runtimeStorageAdapter、runtimeFunctionsAdapter、runtimeLoggerAdapters、runtimeMasamuneAdaptersが設定されており、これらを使用してテストを行う。
- 各種モックデータは`lib/adapter.dart`ファイルに記載されている。
    - モックデータの取扱い関しては`documents/rules/docs/mock_data_usage.md`に記載されているのでそちらを参照。

```dart
import "dart:async";

import "package:masamune_test/masamune_test.dart";

import "package:gitvibes/main.dart";

/// Performing test initialization.
Future<void> testExecutable(FutureOr<void> Function() testMain) {
  return MasamuneTestConfig.initialize(
    run: testMain,
    initialUserId: "01979a941df17912ad971dc123cc75da",
    theme: theme,
    modelAdapter: runtimeModelAdapter,
    authAdapter: runtimeAuthAdapter,
    storageAdapter: runtimeStorageAdapter,
    functionsAdapter: runtimeFunctionsAdapter,
    loggerAdapters: runtimeLoggerAdapters,
    masamuneAdapters: runtimeMasamuneAdapters,
  );
}
```

### `Controller`のテストコード実装

- 基本的に`katana code controller [controller_name]`で`test/controllers`以下にテストコードが作成されている。
    - 存在しない場合は`katana code test controller [controller_name]`でテストコードを作成する。
- `masamuneControllerTest`メソッドを用いてテストを行う。
    - `name`にテスト名（通常はコントローラーのクラス名から`Controller`を取り除いたもの）を渡し、`tests`にテストをしたいコントローラのテストを行う。
    - `tests`に`MasamuneControllerTest`のクラスを複数定義可能。
        - それぞれにテスト名とテストを行う関数を渡す。（非同期も可能）
        - 通常のFlutterテスト`expect`を使用することができる。
    - テストを行う関数は`FutureOr<void> Function(MasamuneTestRef ref)`の型を持つ。
        - `MasamuneTestRef`はテストを行うための参照。
        - `ref.appRef`はアプリケーションの参照。
        - `ref.appAuth`はアプリケーション認証の参照。
        - `ref.theme`はアプリケーションのテーマの参照。

```dart
// test/controllers/user_test.dart

import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";
import "package:masamune_test/masamune_test.dart";

void main() {
  masamuneControllerTest(
    name: "User",
    tests: [
      // TODO: Write test code.
      MasamuneControllerTest(
        "testChangeName", // テスト名
        (ref) async {
          final controller = ref.appRef.controller(
            UserController.query(),
          );
          final previousName = controller.name;
          await controller.changeName("newName");
          final changedName = controller.name;
          expect(previousName != changedName, true);
          expect(changedName, "newName");
        },
      ),
      MasamuneControllerTest(
        "testChangeBirthday", // テスト名
        (ref) async {
          final controller = ref.appRef.controller(
            UserController.query(),
          );
          final previousBirthday = controller.birthday;
          await controller.changeBirthday(DateTime(2005, 5, 10));
          final changedBirthday = controller.birthday;
          expect(previousBirthday != changedBirthday, true);
          expect(changedBirthday, DateTime(2005, 5, 10));
        },
      ),
    ],
  );
}
```

### `Widget`のテストコード実装

- 基本的に`katana code widget [widget_name]`で`test/widgets`以下にテストコードが作成されている。
    - 存在しない場合は`katana code test widget [widget_name]`でテストコードを作成する。
- `masamuneWidgetTest`メソッドを用いてテストを行う。
    - `name`にテスト名（通常はウィジェットのクラス名から`Widget`を取り除いたもの）を渡し、`path`にゴールデンテストの画像を出力する名前を記載。`builder`にテストをしたいウィジェットの[Widget]を返す関数を渡す。
        - `builder`にて事前にデータの読み込みが必要な場合は`loader`にそれを読み込むための関数を渡す。するとbuilderに渡される`value`に読み込んだデータが渡される。
    - `loader`の`ref`には`MasamuneTestRef`が渡される。
        - `MasamuneTestRef`はテストを行うための参照。
        - `ref.appRef`はアプリケーションの参照。
        - `ref.appAuth`はアプリケーション認証の参照。
        - `ref.theme`はアプリケーションのテーマの参照。

```dart
// test/widgets/user_profile_test.dart

import "package:flutter/material.dart";

import "package:masamune/masamune.dart";
import "package:masamune_test/masamune_test.dart";

import "package:any_app/adapter.dart";
import "package:any_app/models/user.dart";
import "package:any_app/widgets/user_profile.dart";

void main() {
  masamuneWidgetTest(
    name: "UserProfileWidget",
    path: "user_profile",
    loader: (context, ref) async {
      final user = ref.appRef.model(UserModel.document(userId));
      await user.load();
      return user;
    },
    builder: (context, ref, value) {
      if (value == null) {
        return const SizedBox.shrink();
      }
      return UserProfileWidget(
        user: value,
      );
    },
  );
}
```

### `Page`のテストコード実装

- 基本的に`katana code page [page_name]`で`test/pages`以下にテストコードが作成されている。
    - 存在しない場合は`katana code test page [page_name]`でテストコードを作成する。
- `masamunePageTest`メソッドを用いてテストを行う。
    - `name`にテスト名（通常はページのクラス名から`Page`を取り除いたもの）を渡し、`path`にゴールデンテストの画像を出力する名前を記載。`builder`にテストをしたいページの[Widget]を返す関数を渡す。
        - `builder`にて事前にデータの読み込みが必要な場合は`loader`にそれを読み込むための関数を渡す。するとbuilderに渡される`value`に読み込んだデータが渡される。
    - `loader`の`ref`には`MasamuneTestRef`が渡される。
        - `MasamuneTestRef`はテストを行うための参照。
        - `ref.appRef`はアプリケーションの参照。
        - `ref.appAuth`はアプリケーション認証の参照。
        - `ref.theme`はアプリケーションのテーマの参照。

```dart
// test/widgets/user_test.dart

import "package:flutter/material.dart";

import "package:masamune/masamune.dart";
import "package:masamune_test/masamune_test.dart";

import "package:any_app/adapter.dart";
import "package:any_app/models/user.dart";
import "package:any_app/pages/user.dart";

void main() {
  masamuneWidgetTest(
    name: "UserPage",
    path: "user",
    loader: (context, ref) async {
      final user = ref.appRef.model(UserModel.document(userId));
      await user.load();
      return user;
    },
    builder: (context, ref, value) {
      if (value == null) {
        return const SizedBox.shrink();
      }
      return UserPage(
        user: value,
      );
    },
  );
}
```

### テストの実施

- テストの実施は下記のコマンドで行う。
    ```shell
    katana test run
    ```

    - これにより単体テストの実施とすでに存在しているゴールデンテストの画像ファイルとテストコードの実行結果を比較し、一致しない場合はエラーとなる。

- `Widget`や`Page`のテストを新しく作成した場合や`Widget`や`Page`の更新を行った場合、下記のコマンドでゴールデンテスト用の画像ファイルを生成する。
    - 新規に作成したり更新していない`Widget`や`Page`の場合は画像ファイルは作成しない。

    ```bash
    katana test update [Page名],[Widget名],...
    ```

    - 例
        ```bash
        katana test update UserPage,UserProfileWidget
        ```
""";
  }
}
