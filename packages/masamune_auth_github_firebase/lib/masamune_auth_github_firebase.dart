// Copyright (c) 2025 mathru. All rights reserved.

/// Authentication plugin for Masamune that can implement Github sign-in on Firebase.
///
/// To use, import `package:masamune_auth_github_firebase/masamune_auth_github_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:firebase_auth/firebase_auth.dart" hide AuthProvider;
import "package:katana_auth_firebase/katana_auth_firebase.dart";
import "package:masamune/masamune.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:firebase_auth/firebase_auth.dart" as firebase_auth
    show AuthProvider;

part "actions/github_auth_action.dart";
part "adapter/firebase_github_auth_masamune_adapter.dart";
part "provider/firebase_github_auth_query.dart";
part "src/github_auth_scope.dart";
