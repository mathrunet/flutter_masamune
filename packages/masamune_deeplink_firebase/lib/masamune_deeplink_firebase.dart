// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library for using Firebase DynamicLinks to launch applications from URLs and launch internal pages.
///
/// To use, import `package:masamune_deeplink_firebase/masamune_deeplink_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_deeplink_firebase;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:masamune/masamune.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

part 'adapter/firebase_deeplink_masamune_adapter.dart';
part 'src/deep_link.dart';
