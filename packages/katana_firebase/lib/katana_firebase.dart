// Copyright 2022 mathru. All rights reserved.

/// This package contains utility classes such as the Masamune package.
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
import 'package:katana_flutter/katana_flutter.dart';

export "package:firebase_core/firebase_core.dart" show FirebaseOptions;
export 'package:katana_flutter/katana_flutter.dart';

part "firebase/firebase_core.dart";
