part of masamune_firebase_messaging;

@immutable
class FirebaseMessagingAdapter extends MessagingAdapter<MessagingValue> {
  const FirebaseMessagingAdapter({
    required this.serverKey,
    this.subscribeTopics = const [],
    this.androidNotificationChannelId = "masamune_firebase_messaging_channel",
    this.androidNotificationChannelTitle = "Important Notification",
    this.androidNotificationChannelDescription =
        "This notification channel is used for important notifications.",
    this.onUpdateLinkWhenAlways,
    this.onUpdateLinkWhenAuthenticated,
    this.navigatePageWhenOnlyOpenedApp = true,
    this.enableNavigatePage = true,
  });

  final String serverKey;
  final String androidNotificationChannelId;
  final String androidNotificationChannelTitle;
  final String androidNotificationChannelDescription;

  final List<String> subscribeTopics;

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
    await FirebaseMessagingCore.initialize(
      context,
      serverKey: serverKey,
      androidNotificationChannelDescription:
          androidNotificationChannelDescription,
      androidNotificationChannelId: androidNotificationChannelId,
      androidNotificationChannelTitle: androidNotificationChannelTitle,
      subscribe: subscribe,
      callback: callback,
    );
  }

  @override
  void listen(void Function(MessagingValue message) callback) {
    FirebaseMessagingCore.listen(callback);
  }

  @override
  void unlisten(void Function(MessagingValue message) callback) {
    FirebaseMessagingCore.unlisten(callback);
  }

  /// Remove all listening.
  @override
  void unlistenAll() {
    FirebaseMessagingCore.unlistenAll();
  }

  @override
  Future<void> send({
    required String title,
    required String text,
    required String topic,
    String? path,
    DynamicMap? data,
  }) async {
    await FirebaseMessagingCore.send(
      title: title,
      text: text,
      topic: topic,
      path: path,
      data: data,
    );
  }

  @override
  void subscribe(String topic) {
    FirebaseMessagingCore.subscribe(topic);
  }

  @override
  void unsubscribe(String topic) {
    FirebaseMessagingCore.unsubscribe(topic);
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
      subscribe: subscribeTopics,
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
  Future<void> cancelAllSchedule() {
    throw UnimplementedError();
  }

  @override
  Future<void> cancelSchedule(String topic) {
    throw UnimplementedError();
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
  }) {
    throw UnimplementedError();
  }

  @override
  MessagingValue? get currentValue => FirebaseMessagingCore.currentValue;
}
