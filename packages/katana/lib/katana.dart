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
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

export 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;
export 'package:intl/intl.dart' show DateFormat;
export 'package:meta/meta.dart' show Immutable, Required;
export 'package:sprintf/sprintf.dart' show sprintf;

part 'extension/date_time_extensions.dart';
part 'extension/date_time_iterable_extensions.dart';
part 'extension/double_extensions.dart';
part 'extension/double_iterable_extensions.dart';
part 'extension/duration_extensions.dart';
part 'extension/int_extensions.dart';
part 'extension/int_iterable_extensions.dart';
part 'extension/iterable_extensions.dart';
part 'extension/iterable_of_iterable_extensions.dart';
part 'extension/json_extensions.dart';
part 'extension/list_extensions.dart';
part 'extension/map_extensions.dart';
part 'extension/nullable_double_extensions.dart';
part 'extension/nullable_double_iterable_extensions.dart';
part 'extension/nullable_int_extensions.dart';
part 'extension/nullable_int_iterable_extensions.dart';
part 'extension/nullable_iterable_extensions.dart';
part 'extension/nullable_list_extensions.dart';
part 'extension/nullable_map_extensions.dart';
part 'extension/nullable_num_extensions.dart';
part 'extension/nullable_object_extensions.dart';
part 'extension/nullable_set_extensions.dart';
part 'extension/nullable_string_extensions.dart';
part 'extension/nullable_value_iterable_extensions.dart';
part 'extension/random_extensions.dart';
part 'extension/set_extensions.dart';
part 'extension/string_extensions.dart';
part "src/api.dart";
part "src/const.dart";
part "src/functions.dart";
part "src/typedef.dart";
