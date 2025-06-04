// Copyright (c) 2024 mathru. All rights reserved.

/// Authentication plugin for Masamune that can implement Apple sign-in on Firebase.
///
/// To use, import `package:masamune_auth_apple_firebase/masamune_auth_apple_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_auth_apple_firebase;

// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:firebase_auth/firebase_auth.dart" hide AuthProvider;
import "package:katana_auth_firebase/katana_auth_firebase.dart";
import "package:masamune/masamune.dart";

import "package:firebase_auth/firebase_auth.dart" as firebase_auth
    show AuthProvider;

part "adapter/firebase_apple_auth_masamune_adapter.dart";
part "provider/firebase_apple_auth_query.dart";
