// Dart imports:

// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_camera/masamune_camera.dart";

/// List of Masamune adapters for the application.
///
/// This includes the MobileCameraMasamuneAdapter for camera functionality.
///
/// アプリケーション用のMasamuneアダプターのリスト。
///
/// カメラ機能用のMobileCameraMasamuneAdapterが含まれています。
final List<MasamuneAdapter> masamuneAdapters = [
  const MobileCameraMasamuneAdapter(),
];

/// Entry point of the application.
///
/// Initializes and runs the Masamune app with camera integration.
/// The app demonstrates basic camera functionality including photo capture.
///
/// アプリケーションのエントリーポイント。
///
/// カメラ統合を含むMasamuneアプリを初期化し実行します。
/// このアプリは写真撮影を含む基本的なカメラ機能を実演します。
void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      home: const CameraPage(),
      title: "Flutter Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

/// Main page widget for demonstrating camera functionality.
///
/// This widget provides a camera preview interface and allows users
/// to capture photos. Captured photos are displayed in a modal dialog.
///
/// カメラ機能を実演するためのメインページウィジェット。
///
/// このウィジェットはカメラプレビューインターフェースを提供し、
/// ユーザーが写真を撮影できるようにします。撮影された写真はモーダルダイアログに表示されます。
class CameraPage extends StatefulWidget {
  /// Creates a [CameraPage].
  ///
  /// [CameraPage]を作成します。
  const CameraPage({super.key});

  @override
  State<StatefulWidget> createState() => CameraPageState();
}

/// State class for [CameraPage].
///
/// Manages the camera controller lifecycle and handles photo capture operations.
///
/// [CameraPage]のStateクラス。
///
/// カメラコントローラーのライフサイクルを管理し、写真撮影操作を処理します。
class CameraPageState extends State<CameraPage> {
  /// Controller for managing camera operations.
  ///
  /// Handles camera initialization, preview display, and photo capture.
  ///
  /// カメラ操作を管理するコントローラー。
  ///
  /// カメラの初期化、プレビュー表示、写真撮影を処理します。
  final cameraController = Camera();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeCamera();
  }

  /// Initializes the camera controller.
  ///
  /// Shows a loading indicator while the camera is being initialized.
  /// Updates the UI state after initialization is complete.
  ///
  /// カメラコントローラーを初期化します。
  ///
  /// カメラの初期化中にローディングインジケーターを表示します。
  /// 初期化完了後にUI状態を更新します。
  Future<void> _initializeCamera() async {
    if (!mounted) {
      return;
    }
    await cameraController.initialize().showIndicator(context);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.initialized == false) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
      ),
      body: cameraController.preview,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _takePicture();
        },
        child: const Icon(Icons.camera),
      ),
    );
  }

  /// Captures a photo and displays it in a modal dialog.
  ///
  /// Takes a picture using the camera controller and shows the result
  /// in a modal dialog if the capture was successful.
  ///
  /// 写真を撮影してモーダルダイアログに表示します。
  ///
  /// カメラコントローラーを使用して写真を撮影し、撮影が成功した場合は
  /// モーダルダイアログに結果を表示します。
  Future<void> _takePicture() async {
    final value = await cameraController.takePicture();
    if (value?.bytes == null || !mounted) {
      return;
    }
    await Modal.show(
      context,
      contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
      modal: CameraModal(value: value),
    );
  }
}

/// Modal widget for displaying captured photos.
///
/// Shows the captured photo in a preview format with a close button.
///
/// 撮影された写真を表示するためのモーダルウィジェット。
///
/// 撮影された写真をプレビュー形式で表示し、閉じるボタンを提供します。
class CameraModal extends Modal {
  /// Creates a [CameraModal] with the captured photo data.
  ///
  /// [value] contains the captured photo data including bytes.
  ///
  /// 撮影された写真データを持つ[CameraModal]を作成します。
  ///
  /// [value]にはバイトデータを含む撮影された写真データが含まれています。
  const CameraModal({required this.value});

  /// The captured camera value containing photo data.
  ///
  /// 写真データを含む撮影されたカメラ値。
  final CameraValue? value;

  @override
  Widget build(BuildContext context, ModalRef ref) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            width: 256,
            height: 256,
            child: Image.memory(
              value!.bytes!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            ref.close();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
