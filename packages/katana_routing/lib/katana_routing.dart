// Copyright 2022 mathru. All rights reserved.

/// Package that improvement of routing.
///
/// To use, import `package:katana_routing/katana_routing.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_routing;

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katana_flutter/katana_flutter.dart';

export 'package:flutter/material.dart' hide Listener;
export 'package:flutter_riverpod/flutter_riverpod.dart'
    show
        WidgetRef,
        ProviderBase,
        ChangeNotifierProvider,
        ChangeNotifierProviderFamily,
        AutoDisposeChangeNotifierProvider,
        AutoDisposeChangeNotifierProviderFamily,
        Provider,
        AutoDisposeProvider,
        ProviderFamily,
        AutoDisposeProviderFamily;
export 'package:google_fonts/google_fonts.dart' show GoogleFonts;
export 'package:katana_flutter/katana_flutter.dart';

part 'page/internal_page_scoped_widget.dart';
part 'page/page_scoped_widget.dart';
part "src/functions.dart";
part "src/gradient_color.dart";
part "src/design_type.dart";
part "src/extensions.dart";
part "src/navigator.dart";
part "src/route_config.dart";
part "src/route_query.dart";
part "src/image_theme.dart";
part 'src/scoped.dart';
part 'src/scoped_value.dart';
part 'src/app_theme.dart';
part "src/ui_material_app.dart";
part "src/ui_modal_route.dart";
part "src/ui_page_route.dart";
part "src/widget_theme.dart";
