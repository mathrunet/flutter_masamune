// Copyright (c) 2025 mathru. All rights reserved.

/// Package for receiving PUSH notifications using Firebase Messaging. Firebase Functions can also be used to send notifications.
///
/// To use, import `package:masamune_notification_firebase/masamune_notification_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:io";

// Flutter imports:
import "package:flutter/foundation.dart";

// Package imports:
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:katana_firebase/katana_firebase.dart";
import "package:masamune/masamune.dart";
import "package:masamune_notification/masamune_notification.dart";
import "package:universal_platform/universal_platform.dart";

export "package:masamune_notification/masamune_notification.dart";

// Project imports:
part "adapter/firebase_remote_notification_masamune_adapter.dart";
