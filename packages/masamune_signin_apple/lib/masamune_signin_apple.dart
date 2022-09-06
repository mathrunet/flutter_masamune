// Copyright 2022 mathru. All rights reserved.

/// Masamune apple signin framework library.
///
/// To use, import `package:masamune_signin_apple/masamune_signin_apple.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_signin_apple;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:masamune_firebase/masamune_firebase.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

export 'package:masamune_firebase/masamune_firebase.dart';

part 'adapter/apple_sign_in_adapter.dart';
part 'src/apple_auth.dart';
