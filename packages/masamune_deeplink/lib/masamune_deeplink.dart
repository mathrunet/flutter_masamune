// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin library to handle Deeplink. Launch the application from the URL to launch the internal page.
///
/// To use, import `package:masamune_deeplink/masamune_deeplink.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_deeplink;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:app_links/app_links.dart';
import 'package:masamune/masamune.dart';

part 'adapter/deeplink_masamune_adapter.dart';
part 'src/deeplink.dart';
part 'src/deeplink_logger_event.dart';
