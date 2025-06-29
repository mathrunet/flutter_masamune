// Copyright (c) 2025 mathru. All rights reserved.

/// The base part of the package for type-safe use of retrieving and storing Shared Preferences values, defining data in a Freezed-like fashion.
///
/// To use, import `package:katana_prefs/katana_prefs.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Flutter imports:
import "package:flutter/widgets.dart";

export "dart:async" show Completer;

export "package:katana/katana.dart";
export "package:katana_prefs_annotation/katana_prefs_annotation.dart";
export "package:shared_preferences/shared_preferences.dart"
    show SharedPreferences;

part "src/prefs_base.dart";
