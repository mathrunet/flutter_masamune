// Copyright 2022 mathru. All rights reserved.

/// This package contains utility classes such as the Masamune package.
///
/// To use, import `package:katana_flutter/katana_flutter.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_flutter;

import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:katana/katana.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'config/others/others.dart'
    if (dart.library.io) 'config/mobile/mobile.dart'
    if (dart.library.js) 'config/others/others.dart'
    if (dart.library.html) 'config/others/others.dart';

export 'package:connectivity_plus/connectivity_plus.dart'
    show ConnectivityResult;
export 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
export 'package:katana/katana.dart';

export 'config/others/others.dart'
    if (dart.library.io) 'config/mobile/mobile.dart'
    if (dart.library.js) 'config/others/others.dart'
    if (dart.library.html) 'config/others/others.dart';

part 'enum/ages.dart';
part 'enum/gender.dart';
part "localize/localize.dart";
part "prefs/prefs.dart";
part "src/extensions.dart";
part "src/functions.dart";
