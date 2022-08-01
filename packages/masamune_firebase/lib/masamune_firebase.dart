// Copyright 2022 mathru. All rights reserved.

/// Masamune firebase framework library.
///
/// To use, import `package:masamune_firebase/masamune_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_firebase;

import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_model_notifier/firebase_model_notifier.dart';
import 'package:flutter/services.dart';
import 'package:masamune/masamune.dart';

import 'storage/others/others.dart'
    if (dart.library.io) 'storage/mobile/mobile.dart'
    if (dart.library.js) 'storage/web/web.dart'
    if (dart.library.html) 'storage/web/web.dart';

export "package:firebase_auth/firebase_auth.dart" show ActionCodeSettings;
export 'package:firebase_model_notifier/firebase_model_notifier.dart';
export 'package:masamune/masamune.dart';
export "package:model_notifier/model_notifier.dart";

export 'dynamic_links/others/others.dart'
    if (dart.library.io) 'dynamic_links/mobile/mobile.dart'
    if (dart.library.js) 'dynamic_links/web/web.dart'
    if (dart.library.html) 'dynamic_links/web/web.dart';
export 'storage/others/others.dart'
    if (dart.library.io) 'storage/mobile/mobile.dart'
    if (dart.library.js) 'storage/web/web.dart'
    if (dart.library.html) 'storage/web/web.dart';

part 'adapter/anonymous_sign_in_adapter.dart';
part 'adapter/firebase_analytics_adapter.dart';
part 'adapter/firebase_model_adapter.dart';
part 'analytics/firebase_analytics_core.dart';
part 'auth/anonymously_auth.dart';
part 'auth/auth_provider_options.dart';
part 'auth/email_and_password_auth.dart';
part 'auth/firebase_auth_core.dart';
part 'auth/firebase_auth_model.dart';
part 'auth/functions.dart';
part 'auth/sms_auth.dart';
part 'dynamic_links/firebase_dynamic_links_options.dart';
part 'src/anonymous_auth.dart';
part 'src/extensions.dart';
part 'provider/firebase_functions_collection_provider.dart';
part 'provider/firebase_functions_document_provider.dart';
part 'provider/firebase_functions_provider.dart';
part 'provider/firestore_collection_provider.dart';
part 'provider/firestore_document_provider.dart';
part 'provider/firestore_searchable_collection_provider.dart';
