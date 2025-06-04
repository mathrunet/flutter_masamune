// Dart imports:
import "dart:io";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_picker/masamune_picker.dart";

/// Entry point of the application.
///
/// Initializes and runs the Masamune app with file picker functionality.
/// The app demonstrates how to pick and display images from the device.
///
/// アプリケーションのエントリーポイント。
///
/// ファイルピッカー機能を含むMasamuneアプリを初期化し実行します。
/// このアプリはデバイスから画像を選択し表示する方法を実演します。
void main() {
  runApp(const MyApp());
}

/// Root application widget.
///
/// Sets up the MasamuneApp with picker adapter and basic theming.
/// Configures the app to use file picker functionality.
///
/// ルートアプリケーションウィジェット。
///
/// ピッカーアダプターと基本テーマを使用してMasamuneAppをセットアップします。
/// ファイルピッカー機能を使用するようにアプリを設定します。
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  ///
  /// [MyApp]を作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MasamuneApp(
      home: const PickerPage(),
      title: "Flutter Demo",
      masamuneAdapters: const [PickerMasamuneAdapter()],
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    );
  }
}

/// Main page widget for demonstrating file picker functionality.
///
/// This widget provides a user interface for picking images from the device
/// gallery or camera and displaying them. Shows the selected image in the
/// center of the screen.
///
/// ファイルピッカー機能を実演するためのメインページウィジェット。
///
/// このウィジェットはデバイスのギャラリーやカメラから画像を選択し表示する
/// ユーザーインターフェースを提供します。選択された画像を画面の中央に表示します。
class PickerPage extends StatefulWidget {
  /// Creates a [PickerPage].
  ///
  /// [PickerPage]を作成します。
  const PickerPage({super.key});

  @override
  State<StatefulWidget> createState() => PickerPageState();
}

/// State class for [PickerPage].
///
/// Manages the picker instance and handles image selection operations.
/// Maintains the selected image state and updates the UI accordingly.
///
/// [PickerPage]のStateクラス。
///
/// ピッカーインスタンスを管理し、画像選択操作を処理します。
/// 選択された画像の状態を維持し、それに応じてUIを更新します。
class PickerPageState extends State<PickerPage> {
  /// Picker instance for selecting files from the device.
  ///
  /// Handles access to device gallery, camera, and file system
  /// for image and file selection.
  ///
  /// デバイスからファイルを選択するためのピッカーインスタンス。
  ///
  /// 画像およびファイル選択のためのデバイスギャラリー、カメラ、
  /// ファイルシステムへのアクセスを処理します。
  final picker = Picker();

  /// Currently selected picker value containing file information.
  ///
  /// Stores the selected file data including URI, metadata,
  /// and other file properties.
  ///
  /// ファイル情報を含む現在選択されているピッカー値。
  ///
  /// URI、メタデータ、その他のファイルプロパティを含む
  /// 選択されたファイルデータを保存します。
  PickerValue? _value;

  @override
  void initState() {
    super.initState();
    picker.addListener(_handledOnUpdate);
  }

  /// Handles picker state updates.
  ///
  /// Called when the picker state changes. Triggers a UI rebuild
  /// to reflect any changes in the picker's state.
  ///
  /// ピッカー状態の更新を処理します。
  ///
  /// ピッカーの状態が変更された際に呼び出されます。ピッカーの状態の
  /// 変更を反映するためにUIの再構築をトリガーします。
  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    picker.removeListener(_handledOnUpdate);
    picker.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: Center(
        child: _value == null
            ? const SizedBox.shrink()
            : Image.file(
                File(_value!.uri!.toString()),
                fit: BoxFit.cover,
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _pickImage();
        },
        label: const Text("Pick"),
        icon: const Icon(Icons.add_a_photo),
      ),
    );
  }

  /// Picks an image from the device and updates the UI.
  ///
  /// Opens the device picker to allow user selection of an image
  /// from gallery or camera. Updates the displayed image if selection
  /// is successful.
  ///
  /// デバイスから画像を選択してUIを更新します。
  ///
  /// デバイスピッカーを開いて、ギャラリーまたはカメラからの
  /// 画像選択をユーザーに許可します。選択が成功した場合、表示される画像を更新します。
  Future<void> _pickImage() async {
    final selectedValue = await picker.pickSingle();
    if (selectedValue.uri != null) {
      setState(() {
        _value = selectedValue;
      });
    }
  }
}
