// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:camera/camera.dart" as camera_plugin;
import "package:permission_handler/permission_handler.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_camera/masamune_camera.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
}

class _TestCameraMasamuneAdapter extends CameraMasamuneAdapter {
  _TestCameraMasamuneAdapter() : super(enableAudio: false);

  int initializeCount = 0;
  Completer<void>? initializeGate;
  Object? initializeError;
  camera_plugin.CameraController? _controller;
  final List<camera_plugin.CameraController?> disposedControllers = [];

  camera_plugin.CameraController? get controller => _controller;

  @override
  Widget preview({required camera_plugin.CameraController? controller}) {
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
