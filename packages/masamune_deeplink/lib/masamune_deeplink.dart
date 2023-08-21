// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library to handle Deeplink. Launch the application from the URL to launch the internal page.
///
/// To use, import `package:masamune_deeplink/masamune_deeplink.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_deeplink;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:masamune/masamune.dart';

import 'package:uni_links/uni_links.dart';

part 'adapter/deeplink_masamune_adapter.dart';
part 'src/deep_link.dart';
