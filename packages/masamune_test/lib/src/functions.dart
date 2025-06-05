part of "/masamune_test.dart";

/// Tests a page.
///
/// Pass the test name to [name], and the [Widget] of the page you want to test to [builder].
///
/// ページのテストを行います。
///
/// [name]にテスト名を渡し、[builder]にテストをしたいページの[Widget]を渡します。
@isTest
void masamunePageTest<T>({
  required String name,
  required Widget Function(BuildContext context, MasamuneTestRef ref, T? value)
      builder,
  FutureOr<T?> Function(BuildContext context, MasamuneTestRef ref)? loader,
  List<MasamuneTestDevice> devices = const [
    MasamuneTestDevice.phonePortrait,
    MasamuneTestDevice.phoneLandscape,
    MasamuneTestDevice.tabletPortrait,
    MasamuneTestDevice.tabletLandscape,
  ],
}) =>
    _masamuneUITest(
      name: "$name Page",
      builder: builder,
      loader: loader,
      devices: devices,
    );

/// Tests a widget.
///
/// Pass the test name to [name], and the [Widget] of the widget you want to test to [builder].
///
/// Widgetのテストを行います。
///
/// [name]にテスト名を渡し、[builder]にテストをしたい[Widget]を渡します。
@isTest
void masamuneWidgetTest<T>({
  required String name,
  required Widget Function(BuildContext context, MasamuneTestRef ref, T? value)
      builder,
  FutureOr<T?> Function(BuildContext context, MasamuneTestRef ref)? loader,
  double width = 640,
  double? height,
}) =>
    _masamuneUITest(
      name: "$name Widget",
      loader: loader,
      builder: (context, ref, value) {
        return _PageContainer(
          child: builder.call(context, ref, value),
        );
      },
      width: width,
      height: height,
    );

void _masamuneUITest<T>({
  required String name,
  required Widget Function(BuildContext context, MasamuneTestRef ref, T? value)
      builder,
  FutureOr<T?> Function(BuildContext context, MasamuneTestRef ref)? loader,
  List<MasamuneTestDevice>? devices,
  double? width,
  double? height,
}) {
  group(name.toPascalCase(), () {
    final ref = MasamuneTestConfig.currentRef;
    goldenTest(
      name.toPascalCase(),
      fileName: name.toSnakeCase(),
      pumpBeforeTest: _pumpAndSettle,
      pumpWidget: _pumpWidget,
      builder: () {
        return GoldenTestGroup(
          columns: devices?.length ?? 1,
          children: [
            if (devices != null) ...[
              ...devices.map(
                (device) => MasamuneTestContainer(
                  name: device.name,
                  device: device,
                  width: width,
                  height: height,
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
                        onLoad: loader,
                        builder: (context, ref, value) {
                          return builder.call(context, ref, value);
                        },
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              MasamuneTestContainer(
                name: name,
                width: width,
                height: height,
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
                      onLoad: loader,
                      builder: (context, ref, value) {
                        return builder.call(context, ref, value);
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
@isTest
void masamuneModelTileTest<T extends ModelRefBase>({
  required String name,
  required T Function(BuildContext context, MasamuneTestRef ref) document,
  required Widget Function(BuildContext context, MasamuneTestRef ref, T value)
      builder,
}) {
  name = "$name Tile Extension";
  group(name.toPascalCase(), () {
    final ref = MasamuneTestConfig.currentRef;
    goldenTest(
      name.toPascalCase(),
      fileName: name.toSnakeCase(),
      pumpBeforeTest: _pumpAndSettle,
      pumpWidget: _pumpWidget,
      builder: () {
        return GoldenTestGroup(
          columns: 1,
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
                    onLoad: (context, ref) async {
                      final doc = document.call(context, ref);
                      await doc.load();
                      return doc;
                    },
                    builder: (context, ref, value) {
                      if (value == null) {
                        return const SizedBox.shrink();
                      }
                      return builder.call(context, ref, value);
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
@isTest
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

Future<void> _pumpAndSettle(flutter_test.WidgetTester tester) async {
  await tester.pumpAndSettle();
}

Future<void> _pumpWidget(
    flutter_test.WidgetTester tester, Widget widget) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(widget);
    for (var element in flutter_test.find.byType(Image).evaluate()) {
      if (element.widget is! Image) {
        continue;
      }
      final image = (element.widget as Image).image;
      await precacheImage(image, element);
      await tester.pumpAndSettle();
    }
  });
}
