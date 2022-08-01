// Copyright 2022 mathru. All rights reserved.

/// Masamune facebook signin framework library.
///
/// To use, import `package:masamune_signin_facebook/masamune_signin_facebook.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_signin_facebook;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as fb;
import 'package:masamune_firebase/masamune_firebase.dart';
export 'package:masamune/masamune.dart';
export 'package:masamune_firebase/masamune_firebase.dart';

part 'src/facebook_auth.dart';
part 'adapter/facebook_sign_in_adapter.dart';
