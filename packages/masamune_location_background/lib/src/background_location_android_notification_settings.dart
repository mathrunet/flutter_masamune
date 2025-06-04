part of "/masamune_location_background.dart";

/// Settings for Android notification.
///
/// Androidの通知の設定。
class BackgroundLocationAndroidNotificationSettings {
  /// Initialize the [BackgroundLocationAndroidNotificationSettings].
  ///
  /// [BackgroundLocationAndroidNotificationSettings]を初期化します。
  const BackgroundLocationAndroidNotificationSettings({
    this.channelName = "Location tracking",
    this.title = "Start Location Tracking",
    this.message = "Track location in background",
    this.longMessage =
        "Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.",
    this.icon = "",
    this.iconColor = Colors.grey,
  });

  /// Android notification channel name.
  ///
  /// Androidの通知のチャンネル名。
  final String channelName;

  /// Title of the notification. Only applies for android. Default is "Start Location Tracking".
  ///
  /// 通知のタイトル。 Androidにのみ適用されます。 デフォルトは「位置情報追跡を開始」です。
  final String title;

  /// Message of notification. Only applies for android. Default is "Track location in background".
  ///
  /// 通知のメッセージ。 Androidにのみ適用されます。 デフォルトは「バックグラウンドでの位置情報の追跡」です。
  final String message;

  /// Message to be displayed in the expanded content area of the notification. Only applies for android. Default is "Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.".
  ///
  /// 通知の拡張コンテンツ領域に表示されるメッセージ。 Androidにのみ適用されます。 デフォルトは「バックグラウンドで位置情報がオンになっているため、アプリを最新の状態に保ちます。 これは、アプリが実行されていないときにメイン機能が正常に機能するために必要です。」です。
  final String longMessage;

  /// Icon name for notification. Only applies for android. The icon should be in "mipmap" Directory.
  ///
  /// 通知のアイコン名。 Androidにのみ適用されます。 アイコンは「mipmap」ディレクトリにある必要があります。
  final String icon;

  /// Icon color for notification from notification drawer. Only applies for android. Default color is grey.
  ///
  /// 通知ドロワーからの通知のアイコン色。 Androidにのみ適用されます。 デフォルトの色はグレーです。
  final Color iconColor;
}
