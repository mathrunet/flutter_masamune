// Copyright (c) 2025 mathru. All rights reserved.

/// Plug-in for Masamune framework to use Agora.io. Includes support for recording.
///
/// To use, import `package:masamune_agora/masamune_agora.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:math";
import "dart:typed_data";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:agora_rtc_engine/agora_rtc_engine.dart";
import "package:masamune/masamune.dart";

// import 'package:agora_rtc_engine/src/render/video_view_controller.dart' as rtc_local_view;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

import "src/others/others.dart"
    if (dart.library.io) "src/others/others.dart"
    if (dart.library.js) "src/web/web.dart"
    if (dart.library.html) "src/web/web.dart";

export "package:agora_rtc_engine/agora_rtc_engine.dart"
    show
        ClientRoleType,
        ChannelProfileType,
        CameraDirection,
        AudioSampleRateType,
        AudioRecordingQualityType,
        VideoPixelFormat;

part "adapter/agora_masamune_adapter.dart";
part "functions/agora_token_functions_action.dart";

part "src/agora_storage_bucket_config.dart";
part "src/agora_controller.dart";
part "src/agora_user.dart";
part "src/agora_logger_event.dart";
part "src/extensions.dart";
part "src/agora_screen.dart";
part "src/agora_video_profile.dart";
part "src/agora_video_orientation.dart";
