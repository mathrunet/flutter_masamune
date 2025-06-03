// Copyright (c) 2024 mathru. All rights reserved.

/// Authentication plugin for Masamune that can implement Facebook(Meta) sign-in.
///
/// To use, import `package:masamune_auth_facebook/masamune_auth_facebook.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_auth_facebook;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";

// Package imports:
import "package:flutter_facebook_auth/flutter_facebook_auth.dart";
import "package:masamune/masamune.dart";

part "adapter/facebook_auth_masamune_adapter.dart";
part "provider/facebook_auth_query.dart";
