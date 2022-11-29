// Copyright 2023 mathru. All rights reserved.

/// Base package to facilitate switching between Local and Firebase authentication implementations.
///
/// To use, import `package:katana_auth/katana_auth.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_auth;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katana/katana.dart';

part 'adapter/runtime_auth_adapter.dart';

part 'provider/anonymously_auth_provider.dart';
part 'provider/email_and_password_auth_provider.dart';
part 'provider/email_link_auth_provider.dart';
part 'provider/sms_auth_provider.dart';
part 'provider/sns_auth_provider.dart';

part 'src/auth_adapter.dart';
part 'src/authentication.dart';
part 'src/auth_provider.dart';
part 'src/auth_database.dart';
