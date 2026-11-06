// ignore_for_file: implementation_imports

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:ios_window_control_layout/src/platform.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

// Project imports:
import "package:masamune_universal_ui/masamune_universal_ui.dart";

final class _FakePlatform
    with MockPlatformInterfaceMixin
    implements IosWindowControlLayoutPlatform {
  _FakePlatform(this.data);

  final IosWindowControlLayoutData data;

  @override
  Stream<void> get occlusionChanges => const Stream<void>.empty();

  @override
  Future<IosWindowControlLayoutData> query() async => data;
}

IosWindowControlLayoutData _windowed({double left = 0.0}) {
  return IosWindowControlLayoutData(
    isAvailable: true,
    isPad: true,
    isFullScreen: false,
    baseMargins: EdgeInsets.zero,
    horizontalMargins: EdgeInsets.only(left: left),
    verticalMargins: EdgeInsets.zero,
  );
}

const _leadingKey = ValueKey("leading");
const _titleKey = ValueKey("title");

Widget _app({
  required Widget appBar,
  bool enableWindowControlAvoidance = true,
  double windowControlLeadingSpacing = kDefaultWindowControlLeadingSpacing,
}) {
  final adapter = UniversalMasamuneAdapter(
    enableWindowControlAvoidance: enableWindowControlAvoidance,
    windowControlLeadingSpacing: windowControlLeadingSpacing,
  );
  return Builder(
    builder: (context) => adapter.onBuildApp(
      context,
      MaterialApp(home: UniversalScaffold(appBar: appBar)),
    ),
  );
}

void main() {
  late IosWindowControlLayoutPlatform original;

  setUp(() {
    original = IosWindowControlLayoutPlatform.instance;
  });

  tearDown(() {
    IosWindowControlLayoutPlatform.instance = original;
  });

  Future<double> leadingLeft(
    WidgetTester tester, {
    required double avoidance,
    double? leadingWidth,
    bool enableWindowControlAvoidance = true,
    double windowControlLeadingSpacing = kDefaultWindowControlLeadingSpacing,
    double? appBarLeadingSpacing,
  }) async {
    IosWindowControlLayoutPlatform.instance = _FakePlatform(
      _windowed(left: avoidance),
    );
    // Discard the previous [IosWindowControlLayout] so that it queries again.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      _app(
        enableWindowControlAvoidance: enableWindowControlAvoidance,
        windowControlLeadingSpacing: windowControlLeadingSpacing,
        appBar: UniversalAppBar(
          windowControlLeadingSpacing: appBarLeadingSpacing,
          leading: IconButton(
            key: _leadingKey,
            icon: const Icon(Icons.close),
            onPressed: () {},
          ),
          leadingWidth: leadingWidth,
          title: const Text("Title", key: _titleKey),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.getTopLeft(find.byKey(_leadingKey)).dx;
  }

  testWidgets("Leading is shifted by the window control avoidance", (
    tester,
  ) async {
    final base = await leadingLeft(tester, avoidance: 0.0);
    final shifted = await leadingLeft(tester, avoidance: 80.0);
    expect(shifted - base, 80.0 + kDefaultWindowControlLeadingSpacing);
  });

  testWidgets("Leading spacing can be changed by the adapter", (tester) async {
    final base = await leadingLeft(tester, avoidance: 0.0);
    final shifted = await leadingLeft(
      tester,
      avoidance: 80.0,
      windowControlLeadingSpacing: 4.0,
    );
    expect(shifted - base, 84.0);
  });

  testWidgets("Leading spacing can be overridden by the app bar", (
    tester,
  ) async {
    final base = await leadingLeft(tester, avoidance: 0.0);
    final shifted = await leadingLeft(
      tester,
      avoidance: 80.0,
      windowControlLeadingSpacing: 4.0,
      appBarLeadingSpacing: 24.0,
    );
    expect(shifted - base, 104.0);
  });

  testWidgets("Leading spacing is not added without the avoidance", (
    tester,
  ) async {
    final base = await leadingLeft(
      tester,
      avoidance: 0.0,
      windowControlLeadingSpacing: 0.0,
    );
    final full = await leadingLeft(tester, avoidance: 0.0);
    expect(full, base);
  });

  testWidgets("Custom leadingWidth is extended by the avoidance", (
    tester,
  ) async {
    final base = await leadingLeft(tester, avoidance: 0.0, leadingWidth: 48.0);
    final shifted = await leadingLeft(
      tester,
      avoidance: 80.0,
      leadingWidth: 48.0,
    );
    expect(shifted - base, 80.0 + kDefaultWindowControlLeadingSpacing);
  });

  testWidgets("Nothing is shifted when the avoidance is disabled", (
    tester,
  ) async {
    final base = await leadingLeft(tester, avoidance: 0.0);
    final disabled = await leadingLeft(
      tester,
      avoidance: 80.0,
      enableWindowControlAvoidance: false,
    );
    expect(disabled, base);
  });

  testWidgets("Title is shifted when there is no leading", (tester) async {
    Future<double> titleLeft(double avoidance) async {
      IosWindowControlLayoutPlatform.instance = _FakePlatform(
        _windowed(left: avoidance),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        _app(
          appBar: const UniversalAppBar(
            automaticallyImplyLeading: AutomaticallyImplyLeadingType.none,
            centerTitle: false,
            title: Text("Title", key: _titleKey),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return tester.getTopLeft(find.byKey(_titleKey)).dx;
    }

    final base = await titleLeft(0.0);
    final shifted = await titleLeft(80.0);
    expect(shifted - base, 80.0 + kDefaultWindowControlLeadingSpacing);
  });

  testWidgets("UniversalWindowControlInsets follows the text direction", (
    tester,
  ) async {
    IosWindowControlLayoutPlatform.instance = _FakePlatform(
      _windowed(left: 80.0),
    );
    late UniversalWindowControlInsets ltr;
    late UniversalWindowControlInsets rtl;
    late UniversalWindowControlInsets notPrimary;
    await tester.pumpWidget(
      IosWindowControlLayout(
        child: Column(
          textDirection: TextDirection.ltr,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Builder(
                builder: (context) {
                  ltr = UniversalWindowControlInsets.of(context);
                  notPrimary = UniversalWindowControlInsets.of(
                    context,
                    primary: false,
                  );
                  return const SizedBox.shrink();
                },
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Builder(
                builder: (context) {
                  rtl = UniversalWindowControlInsets.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      ltr,
      const UniversalWindowControlInsets(
        leading: 80.0 + kDefaultWindowControlLeadingSpacing,
      ),
    );
    expect(rtl, const UniversalWindowControlInsets(trailing: 80.0));
    expect(notPrimary, UniversalWindowControlInsets.zero);
  });
}
