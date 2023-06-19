// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library to implement Facebook Sign-In.
///
/// To use, import `package:masamune_auth_facebook/masamune_auth_facebook.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_auth_facebook;

import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:masamune/masamune.dart';

part 'adapter/facebook_auth_masamune_adapter.dart';
part 'provider/facebook_sign_in_auth_provider.dart';
