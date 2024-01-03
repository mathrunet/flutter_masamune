// Copyright (c) 2024 mathru. All rights reserved.

/// Define annotations to use the masamune builder. Build with masamune_builder using this annotation.
///
/// To use, import `package:masamune_annotation/masamune_annotation.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_annotation;

export 'package:katana/katana.dart';
export 'package:meta/meta.dart' show UseResult, useResult;

part 'src/document_model_path.dart';
part 'src/collection_model_path.dart';
part 'src/controller.dart';
part 'src/controller_group.dart';
part 'src/form_value.dart';
part 'src/ref_param.dart';
part 'src/search_param.dart';
part 'src/json_param.dart';
part 'src/google_spread_sheet_data_source.dart';
