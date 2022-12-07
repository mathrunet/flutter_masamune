// Copyright 2023 mathru. All rights reserved.

/// Base package for retrieving files such as images and videos from terminal storage, cameras, etc.
///
/// To use, import `package:katana_media/katana_media.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_media;

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:katana/katana.dart';

part 'adapter/file_picker_media_adapter.dart';

part 'src/media.dart';
part 'src/media_type.dart';
part 'src/media_value.dart';
part 'src/media_adapter.dart';
