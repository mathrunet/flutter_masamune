// Copyright 2023 mathru. All rights reserved.

/// Package for receiving PUSH notifications using Firebase Messaging. Firebase Functions can also be used to send notifications.
///
/// To use, import `package:masamune_notification_firebase/masamune_notification_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_notification_firebase;

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:katana_firebase/katana_firebase.dart';
import 'package:masamune/masamune.dart';

part 'src/notification.dart';
part 'src/notification_value.dart';
