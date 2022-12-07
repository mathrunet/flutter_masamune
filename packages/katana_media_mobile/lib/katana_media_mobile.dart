// Copyright 2023 mathru. All rights reserved.

/// Mobile plugin for katana_media. Base package for retrieving files such as images and videos from terminal storage, cameras, etc.
///
/// To use, import `package:katana_media_mobile/katana_media_mobile.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_media_mobile;

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:katana/katana.dart';
import 'package:katana_media/katana_media.dart';

part 'adapter/mobile_image_picker_media_adapter.dart';
