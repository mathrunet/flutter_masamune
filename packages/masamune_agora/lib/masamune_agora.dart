// Copyright 2023 mathru. All rights reserved.

/// Plug-in for Masamune framework to use Agora.io. Includes support for recording.
///
/// To use, import `package:masamune_agora/masamune_agora.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_agora;

// Dart imports:
import 'dart:convert';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:masamune/masamune.dart';

import 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

export 'package:agora_rtc_engine/rtc_engine.dart'
    show
        ClientRole,
        VideoFrameRate,
        VideoOutputOrientationMode,
        ChannelProfile,
        CameraDirection,
        AudioSampleRateType,
        AudioRecordingQuality;

part 'adapter/agora_masamune_adapter.dart';
part 'src/agora_storage_bucket_config.dart';
part 'src/agora_controller.dart';
part 'src/agora_user.dart';
part 'src/agora_logger_event.dart';
part 'src/extensions.dart';
part 'src/agora_screen.dart';
part 'src/agora_video_profile.dart';
part 'src/agora_video_orientation.dart';
