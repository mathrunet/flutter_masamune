// Copyright (c) 2025 mathru. All rights reserved.

/// Provides an adapter for use with Firebase Functions. Provides an interface to execute server-side processing in a type-safe manner.
///
/// To use, import `package:katana_functions_firebase/katana_functions_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:cloud_functions/cloud_functions.dart";
import "package:katana_firebase/katana_firebase.dart";
import "package:katana_functions/katana_functions.dart";
import "package:katana_platform_info/katana_platform_info.dart";

export "package:katana_functions/katana_functions.dart";

part "adapter/firebase_functions_adapter.dart";
