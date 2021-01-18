// Copyright 2021 mathru. All rights reserved.

/// Package to handle NoSQL-like database in runtime.
///
/// To use, import `package:flutter_runtime_database/flutter_runtime_database.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library flutter_runtime_database;

import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:masamune_core/masamune_core.dart';
import 'package:riverpod/src/framework.dart';
import 'package:meta/meta.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
export 'package:masamune_core/masamune_core.dart';
export 'package:flutter_hooks/flutter_hooks.dart';
export 'package:riverpod/riverpod.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:hooks_riverpod/hooks_riverpod.dart';
export 'package:masamune_core/masamune_core.dart';

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

part 'core/typedef.dart';
part 'core/defaultpath.dart';

