// Copyright (c) 2024 mathru. All rights reserved.

/// Plug-in for Masamune that provides a app review function.
///
/// To use, import `package:masamune_app_review/masamune_app_review.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_app_review;

// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

// Package imports:
import "package:in_app_review/in_app_review.dart";
import "package:masamune/masamune.dart";
import "package:universal_platform/universal_platform.dart";
import "package:url_launcher/url_launcher.dart";

part "adapter/app_review_masamune_adapter.dart";
part "src/app_review.dart";
