// Copyright 2023 mathru. All rights reserved.

/// Package for receiving PUSH notifications using Firebase Messaging. Firebase Functions can also be used to send notifications.
///
/// To use, import `package:masamune_notification_firebase/masamune_notification_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_notification_firebase;

// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:katana_firebase/katana_firebase.dart';
import 'package:masamune/masamune.dart';

part 'adapter/push_notification_masamune_adapter.dart';
part 'functions/send_notification_functions_action.dart';

part 'src/push_notification.dart';
part 'src/push_notification_value.dart';
