// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune package that allows for displaying and editing Markdown.
///
/// To use, import `package:masamune_markdown/masamune_markdown.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_markdown;

// Flutter imports:
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:flutter_quill/flutter_quill.dart";
import "package:flutter_quill/quill_delta.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import 'package:markdown/markdown.dart' as md;
import "package:markdown_quill/markdown_quill.dart";
import "package:masamune/masamune.dart";

part "adapter/markdown_masamune_adapter.dart";

part "src/tools/markdown_tools_exchnage.dart";
part "src/tools/markdown_tools_main.dart";
part "src/tools/markdown_tools_add.dart";
part "src/tools/markdown_tools_font.dart";
part "src/tools/markdown_tools_sub.dart";
part "src/tools/markdown_tools_media.dart";

part "src/extensions.dart";
part "src/form_markdown_field.dart";
part "src/markdown_controller.dart";
part "src/form_markdown_toolbar.dart";
part "src/markdown_tools_config.dart";
part "src/markdown_mention.dart";
part "src/markdown.dart";
