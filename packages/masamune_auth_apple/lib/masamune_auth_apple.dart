// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library to implement Apple Sign-In.
///
/// To use, import `package:masamune_auth_apple/masamune_auth_apple.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_auth_apple;

import 'package:flutter/widgets.dart';
import 'package:masamune/masamune.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'adapter/apple_auth_masamune_adapter.dart';
part 'provider/apple_sign_in_auth_provider.dart';
