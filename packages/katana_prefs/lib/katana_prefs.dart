// Copyright 2023 mathru. All rights reserved.

/// The base part of the package for type-safe use of retrieving and storing Shared Preferences values, defining data in a Freezed-like fashion.
///
/// To use, import `package:katana_prefs/katana_prefs.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_prefs;

export 'dart:async' show Completer;

export 'package:katana/katana.dart';
export 'package:katana_prefs_annotation/katana_prefs_annotation.dart';
export 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
