part of "/masamune_test.dart";

/// Controller test items.
///
/// コントローラのテスト項目。
class MasamuneControllerTest {
  /// Controller test items.
  ///
  /// コントローラのテスト項目。
  const MasamuneControllerTest(
    this.name,
    this.run,
  );

  /// The name of the controller test.
  ///
  /// コントローラのテスト名。
  final String name;

  /// The run function of the controller test.
  ///
  /// コントローラのテスト実行関数。
  final FutureOr<void> Function(MasamuneTestRef ref) run;
}
