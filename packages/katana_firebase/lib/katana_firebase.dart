// Copyright 2023 mathru. All rights reserved.

/// Base package to handle firebase with Katana package. It performs initialization and other tasks.
///
/// To use, import `package:katana_firebase/katana_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/foundation.dart";

// Package imports:
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";

export "package:firebase_core/firebase_core.dart" show FirebaseOptions;

part "firebase/firebase_core.dart";
part "firebase/firebase_region.dart";
