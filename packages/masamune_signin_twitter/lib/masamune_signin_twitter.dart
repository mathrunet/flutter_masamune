// Copyright 2022 mathru. All rights reserved.

/// Masamune twitter signin framework library.
///
/// To use, import `package:masamune_signin_twitter/masamune_signin_twitter.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_signin_twitter;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:masamune_firebase/masamune_firebase.dart';
import 'package:twitter_login/twitter_login.dart';

export 'package:masamune_firebase/masamune_firebase.dart';

part 'src/twitter_auth.dart';
part 'adapter/twitter_sign_in_adapter.dart';
