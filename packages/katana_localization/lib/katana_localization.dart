// Copyright 2023 mathru. All rights reserved.

/// A multilingual package that automatically creates code that can retrieve data from Google spreadsheets and write type-safe code with method chaining.
///
/// To use, import `package:katana_localization/katana_localization.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_localization;

// Dart imports:

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
// import 'package:flutter_localizations/flutter_localizations.dart';

export 'package:flutter/foundation.dart' show SynchronousFuture;
export 'package:flutter/widgets.dart' show Locale, LocalizationsDelegate;
// export 'package:flutter_localizations/flutter_localizations.dart'
//     show GlobalMaterialLocalizations;
export 'package:katana/katana.dart';
export 'package:katana_localization_annotation/katana_localization_annotation.dart';

part 'src/app_localize_base.dart';
part 'src/localize_scope.dart';
