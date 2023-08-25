// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library to implement Google Sign-In.
///
/// To use, import `package:masamune_auth_google/masamune_auth_google.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_auth_google;

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masamune/masamune.dart';

part 'adapter/google_auth_masamune_adapter.dart';
part 'provider/google_sign_in_auth_provider.dart';
