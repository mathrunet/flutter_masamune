part of "/masamune_test.dart";

/// Wrapper for testing widgets (primarily screens) with device constraints.
///
/// デバイスの制約を持つウィジェットをテストするためのラッパー。
class MasamuneTestContainer extends StatelessWidget {
  /// Wrapper for testing widgets (primarily screens) with device constraints.
  ///
  /// デバイスの制約を持つウィジェットをテストするためのラッパー。
  const MasamuneTestContainer({
    required this.name,
    required this.builder,
    this.device,
    super.key,
  });

  /// The name of the scenario.
  ///
  /// シナリオの名前。
  final String name;

  /// The device of the scenario.
  ///
  /// シナリオのデバイス。
  final MasamuneTestDevice? device;

  /// The builder of the scenario.
  ///
  /// シナリオのビルダー。
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    final device = this.device;
    if (device == null) {
      return GoldenTestScenario(
        name: name,
        child: Builder(builder: (context) => builder(context)),
      );
    }
    return GoldenTestScenario(
      name: "$name (device: ${device.name})",
      child: ClipRect(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            size: device.size,
            padding: device.safeArea,
            platformBrightness: device.brightness,
            devicePixelRatio: device.devicePixelRatio,
            textScaler: TextScaler.linear(device.textScaleFactor),
          ),
          child: SizedBox(
            height: device.size.height,
            width: device.size.width,
            child: Builder(builder: (context) => builder(context)),
          ),
        ),
      ),
    );
  }
}
