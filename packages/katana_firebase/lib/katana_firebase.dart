// Copyright 2023 mathru. All rights reserved.

/// Base package to handle firebase with Katana package. It performs initialization and other tasks.
///
/// To use, import `package:katana_firebase/katana_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_firebase;

import 'dart:async';

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/foundation.dart';

export "package:firebase_core/firebase_core.dart" show FirebaseOptions;

part "firebase/firebase_core.dart";
