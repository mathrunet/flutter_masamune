// Copyright 2021 mathru. All rights reserved.

/// Package to handle NoSQL-like database in runtime.
/// A framework that includes routing functions.
///
/// To use, import `package:masamune/masamune.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:masamune_core/masamune_core.dart';
import 'package:riverpod/src/framework.dart';
import 'package:meta/meta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
export 'package:masamune_core/masamune_core.dart';
export 'package:flutter_hooks/flutter_hooks.dart';
export 'package:riverpod/riverpod.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:hooks_riverpod/hooks_riverpod.dart';
export 'package:masamune_localize/masamune_localize.dart';

part 'provider/providerbase.dart';
part 'provider/pathprovider.dart';
part 'provider/datafieldprovider.dart';
part 'provider/runtimedocumentprovider.dart';
part 'provider/runtimecollectionprovider.dart';
part 'provider/localdocumentprovider.dart';
part 'provider/localcollectionprovider.dart';

part 'component/uimaterialapp.dart';
part 'component/uipage.dart';
part 'component/extensions.dart';
part 'component/uiwidget.dart';
part 'component/uiinternalpage.dart';
part 'component/uipagedatamixin.dart';

part 'core/typedef.dart';
part 'core/defaultpath.dart';

part 'route/dataconfig.dart';
part 'route/extensions.dart';
part 'route/routeconfig.dart';
part 'route/uipageroute.dart';
part 'route/routequery.dart';
part 'route/uirouteobserver.dart';

part 'theme/themecolor.dart';
part 'theme/widgettheme.dart';
