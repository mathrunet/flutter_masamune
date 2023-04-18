part of masamune_agora;

class AgoraScreen extends StatefulWidget {
  const AgoraScreen({
    super.key,
    required this.value,
    this.iconSize = 48.0,
    this.disabledColor,
    this.disabledBackgroundColor,
    this.disabled,
  });

  final AgoraUser value;

  final double iconSize;
  final Color? disabledColor;
  final Color? disabledBackgroundColor;
  final Widget? disabled;

  @override
  State<StatefulWidget> createState() => _AgoraScreenState();
}

class _AgoraScreenState extends State<AgoraScreen> {
  @override
  void initState() {
    super.initState();
    widget.value._controller.addListener(_handledOnUpdate);
    widget.value.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant AgoraScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      oldWidget.value.removeListener(_handledOnUpdate);
      oldWidget.value._controller.removeListener(_handledOnUpdate);
      widget.value.addListener(_handledOnUpdate);
      widget.value._controller.addListener(_handledOnUpdate);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.value._controller.removeListener(_handledOnUpdate);
    widget.value.removeListener(_handledOnUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final number = widget.value.number;
    final channel = widget.value.channel;
    final remoteState = widget.value.status;
    if (channel.isEmpty) {
      return const Empty();
    }
    if (remoteState == VideoRemoteState.Stopped ||
        remoteState == VideoRemoteState.Failed) {
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
    if (widget.value.isLocalUser) {
      if (widget.value._controller.channelProfile ==
              ChannelProfile.LiveBroadcasting &&
          widget.value._controller.clientRole == ClientRole.Audience) {
        return const Empty();
      }
      return const rtc_local_view.SurfaceView();
    }
    return rtc_remote_view.SurfaceView(
      uid: number,
      channelId: channel!,
    );
  }
}
