// Copyright 2022 mathru. All rights reserved.

/// This package contains utility classes such as the Masamune package.
///
/// To use, import `package:katana/katana.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

export 'package:sprintf/sprintf.dart' show sprintf;

part "src/const.dart";
part "src/extensions.dart";
part "src/functions.dart";
part "src/typedef.dart";
