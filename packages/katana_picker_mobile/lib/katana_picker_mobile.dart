// Copyright 2023 mathru. All rights reserved.

/// Mobile plugin for katana_picker. Base package for retrieving files such as images and videos from terminal storage, cameras, etc.
///
/// To use, import `package:katana_picker_mobile/katana_picker_mobile.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_picker_mobile;

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:katana_picker/katana_picker.dart';

export 'package:katana_picker/katana_picker.dart';

part 'adapter/mobile_image_picker_media_adapter.dart';
