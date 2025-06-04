// Dart imports:

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_location/masamune_location.dart";

/// List of Masamune adapters for the application.
///
/// This includes the MobileLocationMasamuneAdapter for location functionality.
///
/// アプリケーション用のMasamuneアダプターのリスト。
///
/// 位置情報機能用のMobileLocationMasamuneAdapterが含まれています。
final List<MasamuneAdapter> masamuneAdapters = [
  const MobileLocationMasamuneAdapter(),
];

/// Entry point of the application.
///
/// Initializes and runs the Masamune app with location functionality.
/// The app demonstrates real-time location tracking and displays
/// current latitude and longitude coordinates.
///
/// アプリケーションのエントリーポイント。
///
/// 位置情報機能を含むMasamuneアプリを初期化し実行します。
/// このアプリはリアルタイム位置追跡を実演し、現在の緯度と経度座標を表示します。
void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      home: const LocationPage(),
      title: "Flutter Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

/// Main page widget for demonstrating location functionality.
///
/// This widget provides a user interface for displaying real-time location data
/// including latitude and longitude coordinates. Shows a loading indicator
/// while location data is being fetched.
///
/// 位置情報機能を実演するためのメインページウィジェット。
///
/// このウィジェットは緯度と経度座標を含むリアルタイム位置データを表示する
/// ユーザーインターフェースを提供します。位置データの取得中はローディング
/// インジケーターを表示します。
class LocationPage extends StatefulWidget {
  /// Creates a [LocationPage].
  ///
  /// [LocationPage]を作成します。
  const LocationPage({super.key});

  @override
  State<StatefulWidget> createState() => LocationPageState();
}

/// State class for [LocationPage].
///
/// Manages the location controller lifecycle and handles location updates.
/// Automatically starts listening for location changes when initialized
/// and properly disposes resources when the widget is destroyed.
///
/// [LocationPage]のStateクラス。
///
/// 位置情報コントローラーのライフサイクルを管理し、位置更新を処理します。
/// 初期化時に位置変更の監視を自動的に開始し、ウィジェットが破棄される際に
/// リソースを適切に解放します。
class LocationPageState extends State<LocationPage> {
  /// Controller for managing location operations.
  ///
  /// Handles location permission requests, GPS tracking,
  /// and provides real-time location updates.
  ///
  /// 位置情報操作を管理するコントローラー。
  ///
  /// 位置情報権限のリクエスト、GPS追跡を処理し、
  /// リアルタイム位置更新を提供します。
  final Location _controller = Location();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handledOnUpdate);
    _controller.listen();
  }

  /// Handles location updates from the controller.
  ///
  /// Called whenever the location changes. Triggers a rebuild
  /// of the widget to display the latest location data.
  ///
  /// コントローラーからの位置更新を処理します。
  ///
  /// 位置が変更されるたびに呼び出されます。最新の位置データを
  /// 表示するためにウィジェットの再構築をトリガーします。
  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handledOnUpdate);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Demo"),
      ),
      body: Center(
        child: _controller.value == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Latitude: ${_controller.value?.latitude}"),
                  Text("Longitude: ${_controller.value?.longitude}"),
                ],
              ),
      ),
    );
  }
}
