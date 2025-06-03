part of '/masamune_test.dart';

/// Tests a page.
///
/// Pass the test name to [name], and the [Widget] of the page you want to test to [builder].
///
/// ページのテストを行います。
///
/// [name]にテスト名を渡し、[builder]にテストをしたいページの[Widget]を渡します。
Future<void> masamunePageTest({
  required String name,
  required Widget Function(BuildContext context, MasamuneTestRef ref) builder,
  List<MasamuneTestDevice> devices = const [
    MasamuneTestDevice.phonePortrait,
    MasamuneTestDevice.phoneLandscape,
    MasamuneTestDevice.tabletPortrait,
    MasamuneTestDevice.tabletLandscape,
  ],
}) =>
    _masamuneUITest(name: "$name Page", builder: builder, devices: devices);

/// Tests a widget.
///
/// Pass the test name to [name], and the [Widget] of the widget you want to test to [builder].
///
/// Widgetのテストを行います。
///
/// [name]にテスト名を渡し、[builder]にテストをしたい[Widget]を渡します。
Future<void> masamuneWidgetTest({
  required String name,
  required Widget Function(BuildContext context, MasamuneTestRef ref) builder,
}) =>
    _masamuneUITest(name: "$name Widget", builder: builder);

Future<void> _masamuneUITest({
  required String name,
  required Widget Function(BuildContext context, MasamuneTestRef ref) builder,
  List<MasamuneTestDevice>? devices,
}) async {
  group(name.toPascalCase(), () async {
    final ref = MasamuneTestConfig.currentRef;
    await goldenTest(
      name.toPascalCase(),
      fileName: name.toSnakeCase(),
      builder: () {
        return GoldenTestGroup(
          columns: devices.length,
          children: [
            if (devices != null) ...[
              ...devices.map(
                (device) => MasamuneTestContainer(
                  name: device.name,
                  device: device,
                  builder: (context) {
                    return MasamuneApp(
                      debugShowCheckedModeBanner: false,
                      title: name,
                      appRef: ref.appRef,
                      theme: ref.theme,
                      authAdapter: ref.authAdapter,
                      modelAdapter: ref.modelAdapter,
                      storageAdapter: ref.storageAdapter,
                      functionsAdapter: ref.functionsAdapter,
                      loggerAdapters: ref.loggerAdapters,
                      masamuneAdapters: ref.masamuneAdapters,
                      localizationsDelegates: ref.localizationsDelegates,
                      home: MasamuneTestLoader(
                        ref: ref,
                        builder: (context, ref, doc) {
                          return builder.call(context, ref);
                        },
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              MasamuneTestContainer(
                name: name,
                builder: (context) {
                  return MasamuneApp(
                    debugShowCheckedModeBanner: false,
                    title: name,
                    appRef: ref.appRef,
                    theme: ref.theme,
                    authAdapter: ref.authAdapter,
                    modelAdapter: ref.modelAdapter,
                    storageAdapter: ref.storageAdapter,
                    functionsAdapter: ref.functionsAdapter,
                    loggerAdapters: ref.loggerAdapters,
                    masamuneAdapters: ref.masamuneAdapters,
                    localizationsDelegates: ref.localizationsDelegates,
                    home: MasamuneTestLoader(
                      ref: ref,
                      builder: (context, ref, doc) {
                        return builder.call(context, ref);
                      },
                    ),
                  );
                },
              ),
            ]
          ],
        );
      },
    );
  });
}

/// Tests the `toTile` extension of the Model.
///
/// Pass the test name via [name], obtain the model using [document]. Based on this, pass the [Widget] to be tested to [builder].
///
/// Modelの`toTile`エクステンションをテストします。
///
/// [name]にテスト名を渡し、[document]でモデルを取得します。それを元に[builder]にテストをしたい[Widget]を渡します。
void masamuneModelTileTest<T extends ModelRefBase>({
  required String name,
  required T Function(MasamuneTestRef ref) document,
  required Widget Function(
          BuildContext context, MasamuneTestRef ref, T document)
      builder,
  List<MasamuneTestDevice> devices = const [
    MasamuneTestDevice.phonePortrait,
    MasamuneTestDevice.phoneLandscape,
    MasamuneTestDevice.tabletPortrait,
    MasamuneTestDevice.tabletLandscape,
  ],
}) {
  name = "$name Tile Extension";
  group(name.toPascalCase(), () {
    final ref = MasamuneTestConfig.currentRef;
    goldenTest(
      name.toPascalCase(),
      fileName: name.toSnakeCase(),
      builder: () {
        return GoldenTestGroup(
          columns: devices.length,
          children: [
            MasamuneTestContainer(
              name: name,
              builder: (context) {
                return MasamuneApp(
                  debugShowCheckedModeBanner: false,
                  title: name,
                  appRef: ref.appRef,
                  theme: ref.theme,
                  authAdapter: ref.authAdapter,
                  modelAdapter: ref.modelAdapter,
                  storageAdapter: ref.storageAdapter,
                  functionsAdapter: ref.functionsAdapter,
                  loggerAdapters: ref.loggerAdapters,
                  masamuneAdapters: ref.masamuneAdapters,
                  localizationsDelegates: ref.localizationsDelegates,
                  home: MasamuneTestLoader(
                    ref: ref,
                    document: document,
                    builder: (context, ref, T? doc) {
                      if (doc == null) {
                        return const SizedBox.shrink();
                      }
                      return builder.call(context, ref, doc);
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  });
}

/// Perform controller testing.
///
/// Pass the test name to [name], and perform the controller test you want to test on [tests].
///
/// コントローラのテストを行います。
///
/// [name]にテスト名を渡し、[tests]にテストをしたいコントローラのテストを行います。
void masamuneControllerTest({
  required String name,
  required List<MasamuneControllerTest> tests,
}) async {
  for (final t in tests) {
    test(
      "$name - ${t.name.toPascalCase()}",
      () async {
        return t.run(MasamuneTestConfig.currentRef);
      },
    );
  }
}
