// Copyright (c) 2024 mathru. All rights reserved.

/// Define annotations to use the Katana router builder. Build with katana_router_builder using this annotation.
///
/// To use, import `package:katana_router_annotation/katana_router_annotation.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_router_annotation;

export 'package:katana/katana.dart';
export 'package:meta/meta.dart' show UseResult, useResult;

part 'src/page_path.dart';
part 'src/page_param.dart';
part 'src/app_route.dart';
part 'src/page_query.dart';
part 'src/query_param.dart';
