// Dart imports:
import "dart:async";
import "dart:io";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:camera/camera.dart" as camera_plugin;
import "package:image/image.dart" as image;
import "package:masamune/masamune.dart";
import "package:permission_handler/permission_handler.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_camera/masamune_camera.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TestPlatformInfoAdapterScope.setTestAdapter(
    adapter: RuntimePlatformInfoAdapter(
      platformType: PlatformType.macOS,
      applicationId: "masamune_camera_test",
      temporaryDirectory: Directory.systemTemp.path,
    ),
  );

  test(
    "initialize propagates a shared failure without an uncaught Zone error and can retry",
    () async {
      final adapter = _TestCameraMasamuneAdapter();
      final camera = Camera(adapter: adapter);
      final failure = StateError("camera initialization failed");
      adapter.initializeError = failure;
      adapter.initializeGate = Completer<void>();
      final uncaughtErrors = <Object>[];
      late Future<void> firstExpectation;
      late Future<void> secondExpectation;

      runZonedGuarded(
        () {
          final first = camera.initialize();
          final second = camera.initialize();
          expect(second, same(first));
          firstExpectation = expectLater(first, throwsA(same(failure)));
          secondExpectation = expectLater(second, throwsA(same(failure)));
        },
        (error, stackTrace) => uncaughtErrors.add(error),
      );

      expect(adapter.initializeCount, 1);
      adapter.initializeGate!.complete();
      await Future.wait([firstExpectation, secondExpectation]);
      await Future<void>.delayed(Duration.zero);
      expect(uncaughtErrors, isEmpty);
      expect(camera.initialized, isFalse);

      adapter
        ..initializeError = null
        ..initializeGate = null;
      await expectLater(camera.initialize(), completes);
      expect(adapter.initializeCount, 2);
      expect(camera.initialized, isTrue);
    },
  );

  test("initialize invokes the adapter only once after success", () async {
    final adapter = _TestCameraMasamuneAdapter()
      ..initializeGate = Completer<void>();
    final camera = Camera(adapter: adapter);

    final first = camera.initialize();
    final second = camera.initialize();
    expect(second, same(first));
    expect(adapter.initializeCount, 1);

    adapter.initializeGate!.complete();
    await Future.wait([first, second]);
    await camera.initialize();

    expect(adapter.initializeCount, 1);
    expect(camera.initialized, isTrue);
  });

  test(
    "dispose rejects a delayed initialization and disposes its controller",
    () async {
      final adapter = _TestCameraMasamuneAdapter()
        ..initializeGate = Completer<void>();
      final camera = Camera(adapter: adapter);
      final uncaughtErrors = <Object>[];
      var notificationCount = 0;
      camera.addListener(() => notificationCount++);
      late Future<void> expectation;

      runZonedGuarded(
        () {
          expectation = expectLater(
            camera.initialize(),
            throwsA(
              isA<StateError>().having(
                (error) => error.message,
                "message",
                "Camera was disposed during initialization.",
              ),
            ),
          );
        },
        (error, stackTrace) => uncaughtErrors.add(error),
      );

      expect(adapter.initializeCount, 1);
      camera.dispose();
      adapter.initializeGate!.complete();
      await expectation;
      await Future<void>.delayed(Duration.zero);

      expect(adapter.disposedControllers, [adapter.controller]);
      expect(camera.initialized, isFalse);
      expect(notificationCount, 0);
      expect(uncaughtErrors, isEmpty);
    },
  );

  group("debug picture", () {
    final source = image.Image(width: 4, height: 3)
      ..clear(image.ColorRgb8(255, 0, 0));
    final provider = MemoryImage(image.encodePng(source));
    final adapters = <String, CameraMasamuneAdapter>{
      "mock": const MockCameraMasamuneAdapter(),
      "mobile": const MobileCameraMasamuneAdapter(),
    };

    for (final MapEntry(key: name, value: adapter) in adapters.entries) {
      test("replaces preview and captured image for the $name adapter",
          () async {
        final camera = Camera(adapter: adapter);
        addTearDown(camera.dispose);

        camera.setDebugPicture(provider);

        expect(
          camera.preview,
          isA<Image>().having((widget) => widget.image, "image", provider),
        );

        final value = await camera.takePicture(
          width: 2,
          height: 2,
          format: MediaFormat.png,
        );
        final captured = image.decodeImage(value!.bytes!);

        expect(value.format, MediaFormat.png);
        expect(captured, isNotNull);
        expect(captured!.width, 2);
        expect(captured.height, 2);
        expect(captured.getPixel(0, 0).r, 255);
        expect(captured.getPixel(0, 0).g, 0);
        expect(captured.getPixel(0, 0).b, 0);
      });
    }

    test("unset restores adapter behavior and only notifies on changes",
        () async {
      final adapter = _TestCameraMasamuneAdapter();
      final camera = Camera(adapter: adapter);
      addTearDown(camera.dispose);
      var notificationCount = 0;
      camera.addListener(() => notificationCount++);

      camera.setDebugPicture(provider);
      camera.setDebugPicture(provider);
      camera.unsetDebugPicture();
      camera.unsetDebugPicture();

      expect(notificationCount, 2);
      expect(camera.preview, isA<SizedBox>());
      expect(adapter.previewCount, 1);
      expect(await camera.takePicture(), isNull);
      expect(adapter.initializeCount, 1);
      expect(adapter.takePictureCount, 1);
    });

    test("dispose removes the debug picture", () {
      final adapter = _TestCameraMasamuneAdapter();
      final camera = Camera(adapter: adapter)..setDebugPicture(provider);

      camera.dispose();

      expect(camera.preview, isA<SizedBox>());
      expect(adapter.previewCount, 1);
      expect(camera.unsetDebugPicture, throwsStateError);
    });
  });
}

class _TestCameraMasamuneAdapter extends CameraMasamuneAdapter {
  _TestCameraMasamuneAdapter() : super(enableAudio: false);

  int initializeCount = 0;
  int previewCount = 0;
  int takePictureCount = 0;
  Completer<void>? initializeGate;
  Object? initializeError;
  camera_plugin.CameraController? _controller;
  final List<camera_plugin.CameraController?> disposedControllers = [];

  camera_plugin.CameraController? get controller => _controller;

  @override
  Widget preview({required camera_plugin.CameraController? controller}) {
    previewCount++;
    return const SizedBox.shrink();
  }

  @override
  Future<camera_plugin.CameraController?> initialize({
    ResolutionPreset? resolutionPreset,
  }) async {
    initializeCount++;
    await initializeGate?.future;
    final error = initializeError;
    if (error != null) {
      throw error;
    }
    return _controller ??= camera_plugin.CameraController(
      const camera_plugin.CameraDescription(
        name: "test-camera",
        lensDirection: camera_plugin.CameraLensDirection.back,
        sensorOrientation: 0,
      ),
      camera_plugin.ResolutionPreset.low,
      enableAudio: false,
    );
  }

  @override
  Future<PermissionStatus> requestCameraPermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    return PermissionStatus.granted;
  }

  @override
  Future<PermissionStatus> requestMicrophonePermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    return PermissionStatus.granted;
  }

  @override
  Future<CameraValue?> takePicture({
    required camera_plugin.CameraController? controller,
    int? width,
    int? height,
    MediaFormat? format,
  }) async {
    takePictureCount++;
    return null;
  }

  @override
  Future<void> startVideoRecording({
    required camera_plugin.CameraController? controller,
  }) async {}

  @override
  Future<CameraValue?> stopVideoRecording({
    required camera_plugin.CameraController? controller,
    required DateTime startRecordingTime,
  }) async {
    return null;
  }

  @override
  void dispose({required camera_plugin.CameraController? controller}) {
    disposedControllers.add(controller);
  }
}
