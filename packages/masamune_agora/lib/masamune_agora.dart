// Copyright 2022 mathru. All rights reserved.

/// Masamune agora framework library.
///
/// To use, import `package:masamune_agora/masamune_agora.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_agora;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:http/http.dart';
import 'package:masamune_firebase/masamune_firebase.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

export 'package:agora_rtc_engine/rtc_engine.dart' hide Rect, RectCallback;
export 'package:masamune/masamune.dart';

part 'src/agora_rtc_core.dart';
part 'adapter/agora_streaming_adapter.dart';
part 'src/agora_rtc_channel_model.dart';
part 'src/screen_fit_grid_view.dart';
part 'src/agora_storage_bucket_config.dart';
