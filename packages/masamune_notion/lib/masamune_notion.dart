// Copyright 2022 mathru. All rights reserved.

/// Masamune notion framework library.
///
/// To use, import `package:masamune_notion/masamune_notion.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_notion;

import 'dart:async';
import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/gestures.dart';

import 'package:masamune_firebase/masamune_firebase.dart';

export 'package:masamune_firebase/masamune_firebase.dart';

part 'src/notion_core.dart';
part 'src/notion_property.dart';
part 'src/notion_page_collection_model.dart';
part 'src/notion_page_document_model.dart';
part 'src/notion_block_collection_model.dart';
part 'src/notion_block_document_model.dart';
part 'src/notion_block.dart';
part 'src/functions.dart';
part 'src/notion_query.dart';
