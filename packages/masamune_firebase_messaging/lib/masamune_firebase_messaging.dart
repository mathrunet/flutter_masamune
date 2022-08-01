// Copyright 2022 mathru. All rights reserved.

/// Masamune firebase messaging framework library.
///
/// To use, import `package:masamune_firebase_messaging/masamune_firebase_messaging.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_firebase_messaging;

import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:masamune_firebase/masamune_firebase.dart';

export 'package:masamune/masamune.dart';
export 'package:masamune_firebase/masamune_firebase.dart';

part 'src/firebase_messaging_core.dart';
part 'src/firebase_messaging_model.dart';
part 'adapter/firebase_messaging_adapter.dart';
