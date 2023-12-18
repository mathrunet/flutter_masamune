part of '/masamune_agora.dart';

/// A widget that displays the connected video.
///
/// Specify [AgoraUser] obtained from [AgoraController.value] in [value].
///
/// You can specify the size by specifying [width] and [height].
///
/// You can specify icons, etc. for disconnection by using [iconSize], [disabledColor], [disabledBackgroundColor], [disabled], etc.
///
/// 接続されている映像を表示するウィジェット。
///
/// [value]に[AgoraController.value]から取得した[AgoraUser]を指定します。
///
/// [width]と[height]を指定してサイズを指定できます。
///
/// [iconSize]や[disabledColor]、[disabledBackgroundColor]、[disabled]等を利用して、切断時のアイコン等を指定できます。
class AgoraScreen extends StatefulWidget {
  /// A widget that displays the connected video.
  ///
  /// Specify [AgoraUser] obtained from [AgoraController.value] in [value].
  ///
  /// You can specify the size by specifying [width] and [height].
  ///
  /// You can specify icons, etc. for disconnection by using [iconSize], [disabledColor], [disabledBackgroundColor], [disabled], etc.
  ///
  /// 接続されている映像を表示するウィジェット。
  ///
  /// [value]に[AgoraController.value]から取得した[AgoraUser]を指定します。
  ///
  /// [width]と[height]を指定してサイズを指定できます。
  ///
  /// [iconSize]や[disabledColor]、[disabledBackgroundColor]、[disabled]等を利用して、切断時のアイコン等を指定できます。
  const AgoraScreen({
    super.key,
    required this.value,
    this.iconSize = 48.0,
    this.disabledColor,
    this.disabledBackgroundColor,
    this.disabled,
    this.height,
    this.width,
    this.useAndroidSurfaceView = false,
    this.useFlutterTexture = false,
  });

  /// Specify [AgoraUser] obtained from [AgoraController.value].
  ///
  /// [AgoraController.value]から取得した[AgoraUser]を指定します。
  final AgoraUser? value;

  /// Specifies the height of the screen.
  ///
  /// スクリーンの高さを指定します。
  final double? height;

  /// Specifies the width of the screen.
  ///
  /// スクリーンの幅を指定します。
  final double? width;

  /// Icon size to be displayed when disconnected.
  ///
  /// 切断時に表示するアイコンサイズ。
  final double iconSize;

  /// The color of the icon when disconnected.
  ///
  /// 切断時のアイコンの色。
  final Color? disabledColor;

  /// Background color at disconnection.
  ///
  /// 切断時の背景色。
  final Color? disabledBackgroundColor;

  /// Widget to display when disconnected.
  ///
  /// 切断時に表示するウィジェット。
  final Widget? disabled;

  /// true` if drawing using Flutter's Texture.
  ///
  /// FlutterのTextureを使って描画する場合は`true`。
  final bool useFlutterTexture;

  /// For Android, `true` if SurfaceView is used; for non-Android, no change.
  ///
  /// Androidの場合SurfaceViewを利用する場合は`true`。Android以外の場合は変化なし。
  final bool useAndroidSurfaceView;

  @override
  State<StatefulWidget> createState() => _AgoraScreenState();
}

class _AgoraScreenState extends State<AgoraScreen> {
  @override
  void initState() {
    super.initState();
    widget.value?._controller.addListener(_handledOnUpdate);
    widget.value?.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant AgoraScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      oldWidget.value?.removeListener(_handledOnUpdate);
      oldWidget.value?._controller.removeListener(_handledOnUpdate);
      widget.value?.addListener(_handledOnUpdate);
      widget.value?._controller.addListener(_handledOnUpdate);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.value?._controller.removeListener(_handledOnUpdate);
    widget.value?.removeListener(_handledOnUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.value;
    if (user == null) {
      return const Empty();
    }
    final number = user.number;
    final channel = user.channel;
    final remoteState = user.status;
    if (AgoraController._engine == null || channel.isEmpty) {
      return const Empty();
    }
    if (remoteState == RemoteVideoState.remoteVideoStateStopped ||
        remoteState == RemoteVideoState.remoteVideoStateFailed) {
      return Container(
        color: widget.disabledBackgroundColor ?? Colors.black,
        alignment: Alignment.center,
        child: IconTheme(
          data: IconThemeData(
            color: widget.disabledColor ?? Theme.of(context).disabledColor,
            size: widget.iconSize,
          ),
          child: widget.disabled ?? const Icon(Icons.videocam_off),
        ),
      );
    }
    if (user.isLocalUser) {
      if (user._controller.channelProfile ==
              ChannelProfileType.channelProfileLiveBroadcasting &&
          user._controller.clientRole == ClientRoleType.clientRoleAudience) {
        return const Empty();
      }
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: AgoraController._engine!,
          canvas: const VideoCanvas(uid: 0),
          useFlutterTexture: widget.useFlutterTexture,
          useAndroidSurfaceView:
              UniversalPlatform.isAndroid && widget.useAndroidSurfaceView,
        ),
        onAgoraVideoViewCreated: (viewId) {
          AgoraController._engine!.startPreview();
        },
      );
    }
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: AgoraController._engine!,
        canvas: VideoCanvas(uid: number),
        connection: RtcConnection(channelId: channel ?? ""),
        useFlutterTexture: widget.useFlutterTexture,
        useAndroidSurfaceView:
            UniversalPlatform.isAndroid && widget.useAndroidSurfaceView,
      ),
    );
  }
}
