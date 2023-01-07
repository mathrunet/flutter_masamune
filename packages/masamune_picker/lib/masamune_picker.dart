// Copyright 2023 mathru. All rights reserved.

/// Base package for retrieving files such as images and videos from terminal storage, cameras, etc.
///
/// To use, import `package:masamune_picker/masamune_picker.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_picker;

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:masamune/masamune.dart';

export 'package:masamune/masamune.dart';

part 'adapter/file_picker_adapter.dart';

part 'src/picker.dart';
part 'src/picker_file_type.dart';
part 'src/picker_value.dart';
part 'src/picker_adapter.dart';
part 'storage/storage.dart';
