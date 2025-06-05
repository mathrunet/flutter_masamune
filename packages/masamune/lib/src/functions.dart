part of "/masamune.dart";

/// Test adapters and containers can be specified and replaced.
///
/// Run it at the beginning of the test.
///
/// テスト用のアダプターやコンテナーを指定して入れ替えることができます。
///
/// テストの最初に実行してください。
void masamuneApplyTestMocks({
  bool ensureInitialized = true,
  ScopedValueContainer? scopedValueContainer,
  AuthAdapter? authAdapter,
  StorageAdapter? storageAdapter,
  FunctionsAdapter? functionsAdapter,
  List<LoggerAdapter> loggerAdapters = const [],
  List<MasamuneAdapter> masamuneAdapters = const [],
  ModelAdapter? modelAdapter,
  DateTime? testCurrentTime,
}) {
  if (ensureInitialized) {
    WidgetsFlutterBinding.ensureInitialized();
  }
  if (scopedValueContainer != null) {
    TestAppScoped.setTestContainer(scopedValueContainer);
  }
  if (modelAdapter != null) {
    TestModelAdapterScope.setTestAdapter(modelAdapter);
  }
  if (authAdapter != null) {
    TestAuthAdapterScope.setTestAdapter(authAdapter);
  }
  if (storageAdapter != null) {
    TestStorageAdapterScope.setTestAdapter(storageAdapter);
  }
  if (functionsAdapter != null) {
    TestFunctionsAdapterScope.setTestAdapter(functionsAdapter);
  }
  if (loggerAdapters.isNotEmpty) {
    TestLoggerAdapterScope.setTestAdapters(loggerAdapters);
  }
  if (masamuneAdapters.isNotEmpty) {
    TestMasamuneAdapterScope.setTestAdapters(masamuneAdapters);
  }
  if (testCurrentTime != null) {
    Clock.setTestCurrentTime(testCurrentTime);
  }
}
