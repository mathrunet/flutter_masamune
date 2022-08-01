part of masamune_local_messaging;

@immutable
class LocalMessagingAdapter extends MessagingAdapter<MessagingValue> {
  const LocalMessagingAdapter({
    this.androidDefaultIcon = "@mipmap/ic_launcher",
    this.androidChannelId = "defaultChannel",
    this.androidChannelName = "Default Channel",
    this.onUpdateLinkWhenAlways,
    this.onUpdateLinkWhenAuthenticated,
    this.enableNavigatePage = true,
    this.navigatePageWhenOnlyOpenedApp = true,
  });

  final String androidDefaultIcon;
  final String androidChannelId;
  final String androidChannelName;

  final bool navigatePageWhenOnlyOpenedApp;
  final bool enableNavigatePage;

  final void Function(BuildContext context, MessagingValue message)?
      onUpdateLinkWhenAuthenticated;
  final void Function(BuildContext context, MessagingValue message)?
      onUpdateLinkWhenAlways;

  @override
  Future<void> initialize(
    BuildContext context, {
    List<void Function(MessagingValue message)> callback = const [],
    List<String> subscribe = const [],
  }) async {
    await LocalMessagingCore.initialize(
      context,
      callback: callback,
      androidDefaultIcon: androidDefaultIcon,
    );
  }

  @override
  Future<void> send({
    required String title,
    required String text,
    required String topic,
    String? path,
    DynamicMap? data,
  }) async {
    await LocalMessagingCore.send(
      title: title,
      text: text,
      topic: topic,
      path: path,
      data: data,
      androidChannelId: androidChannelId,
      androidChannelName: androidChannelName,
    );
  }

  @override
  Future<void> schedule({
    required String title,
    required String text,
    required String topic,
    required DateTime dateTime,
    String? path,
    DynamicMap? data,
    MessagingScheduleRepeatType repeatType = MessagingScheduleRepeatType.none,
  }) async {
    await LocalMessagingCore.schedule(
      title: title,
      text: text,
      topic: topic,
      dateTime: dateTime,
      path: path,
      data: data,
      repeatType: repeatType,
      androidChannelId: androidChannelId,
      androidChannelName: androidChannelName,
    );
  }

  @override
  @mustCallSuper
  Future<void> onAfterFinishBoot(BuildContext context) async {
    await _initialize(context);
    return super.onAfterFinishBoot(context);
  }

  Future<void> _initialize(BuildContext context) async {
    await initialize(
      context,
      callback: [
        (value) {
          final signIn = context.model?.isSignedIn ?? false;
          if (onUpdateLinkWhenAuthenticated != null) {
            if (signIn) {
              onUpdateLinkWhenAuthenticated?.call(context, value);
            } else {
              onUpdateLinkWhenAlways?.call(context, value);
            }
          } else if (onUpdateLinkWhenAlways != null) {
            onUpdateLinkWhenAlways?.call(context, value);
          } else {
            if (!enableNavigatePage) {
              return;
            }
            if (navigatePageWhenOnlyOpenedApp && !value.onOpenedApp) {
              return;
            }
            final path = value.path;
            if (path.isEmpty) {
              return;
            }
            context.rootNavigator.pushNamed(
              path!,
              arguments: RouteQuery.fullscreen,
            );
          }
        },
      ],
    );
  }

  @override
  void listen(void Function(MessagingValue message) callback) {
    LocalMessagingCore.listen(callback);
  }

  @override
  void unlisten(void Function(MessagingValue message) callback) {
    LocalMessagingCore.unlisten(callback);
  }

  /// Remove all listening.
  @override
  void unlistenAll() {
    LocalMessagingCore.unlistenAll();
  }

  @override
  void subscribe(String topic) {
    throw UnimplementedError();
  }

  @override
  void unsubscribe(String topic) {
    throw UnimplementedError();
  }

  @override
  Future<void> cancelAllSchedule() {
    return LocalMessagingCore.cancelAllSchedule();
  }

  @override
  Future<void> cancelSchedule(String topic) {
    return LocalMessagingCore.cancelSchedule(topic);
  }

  @override
  MessagingValue? get currentValue => LocalMessagingCore.currentValue;
}
