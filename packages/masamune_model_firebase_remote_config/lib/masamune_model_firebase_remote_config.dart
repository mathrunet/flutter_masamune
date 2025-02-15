// Copyright (c) 2024 mathru. All rights reserved.

/// Package that allows remote configurations to be retrieved as a Masamune framework documentation model.
///
/// To use, import `package:masamune_model_firebase_remote_config/masamune_model_firebase_remote_config.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_model_firebase_remote_config;

// Package imports:
import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:katana_firebase/katana_firebase.dart';
import 'package:masamune/masamune.dart';
import 'package:universal_platform/universal_platform.dart';

part 'adapter/firebase_remote_config_model_adapter.dart';
