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
  required String path,
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
      name: "${name.replaceAll(RegExp(r"Page$"), "")} Page".toPascalCase(),
      path: "pages/${path.trimString("/")}",
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
  required String path,
  required Widget Function(BuildContext context, MasamuneTestRef ref, T? value)
      builder,
  FutureOr<T?> Function(BuildContext context, MasamuneTestRef ref)? loader,
  double width = 640,
  double? height,
}) =>
    _masamuneUITest(
      name: "${name.replaceAll(RegExp(r"Widget$"), "")} Widget".toPascalCase(),
      path: "widgets/${path.trimString("/")}",
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
  required String path,
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
      tags: [],
      name.toPascalCase(),
      fileName: path,
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
  required String path,
  required T Function(BuildContext context, MasamuneTestRef ref) document,
  required Widget Function(BuildContext context, MasamuneTestRef ref, T value)
      builder,
}) {
  name = "${name.replaceAll(RegExp(r"Model$"), "")} Model".toPascalCase();
  group(name.toPascalCase(), () {
    final ref = MasamuneTestConfig.currentRef;
    goldenTest(
      tags: [],
      name.toPascalCase(),
      fileName: "models/${path.trimString("/")}",
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
}) {
  for (final t in tests) {
    test(
      "$name - ${t.name.toPascalCase()}",
      () {
        return t.run(MasamuneTestConfig.currentRef);
      },
    );
  }
}

Future<void> _pumpWidget(
    flutter_test.WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(widget);
  await tester.runAsync(() async {
    var retryCount = 0;
    while (flutter_test.find.byType(_MasamuneTestLoaded).evaluate().isEmpty) {
      retryCount++;
      await tester.pumpAndSettle();
      await tester.pumpWidget(widget);
      if (retryCount > 10) {
        throw Exception("Failed to find MasamuneTestLoaded");
      }
    }
    final images = <Future<void>>[];
    for (final element in flutter_test.find.byType(Image).evaluate()) {
      final widget = element.widget as Image;
      final image = widget.image;
      images.add(precacheImage(image, element));
    }
    for (final element in flutter_test.find.byType(FadeInImage).evaluate()) {
      final widget = element.widget as FadeInImage;
      final image = widget.image;
      images.add(precacheImage(image, element));
    }
    for (final element in flutter_test.find.byType(DecoratedBox).evaluate()) {
      final widget = element.widget as DecoratedBox;
      final decoration = widget.decoration;
      if (decoration is BoxDecoration && decoration.image != null) {
        final image = decoration.image!.image;
        images.add(precacheImage(image, element));
      }
    }
    await Future.wait(images);
  });
  await tester.pumpWidget(widget);
}
