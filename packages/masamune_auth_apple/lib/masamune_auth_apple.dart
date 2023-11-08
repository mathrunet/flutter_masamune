// Copyright 2023 mathru. All rights reserved.

/// Authentication plugin for Masamune that can implement Apple sign-in, works only on IOS.
///
/// To use, import `package:masamune_auth_apple/masamune_auth_apple.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_auth_apple;

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'adapter/apple_auth_masamune_adapter.dart';
part 'provider/apple_sign_in_auth_provider.dart';
