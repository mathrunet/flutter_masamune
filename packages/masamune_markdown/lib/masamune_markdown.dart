// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune package that allows for displaying and editing Markdown.
///
/// To use, import `package:masamune_markdown/masamune_markdown.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Flutter imports:
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:flutter_quill/flutter_quill.dart";
import "package:flutter_quill/quill_delta.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:markdown/markdown.dart" as md;
import "package:markdown_quill/markdown_quill.dart";
import "package:masamune/masamune.dart";

part "adapter/markdown_masamune_adapter.dart";

part "src/extensions.dart";
part "src/form_markdown_field.dart";
part "src/markdown_controller.dart";
part "src/form_markdown_toolbar.dart";
part "src/markdown_mention.dart";
part "src/markdown.dart";
part "src/markdown_style.dart";
part "src/markdown_vertical_spacing.dart";
part "src/markdown_tools.dart";
part "src/embed/markdown_image_embed.dart";

part "tools/primary/add_markdown_primary_tools.dart";
part "tools/primary/mention_markdown_primary_tools.dart";
part "tools/primary/media_markdown_primary_tools.dart";
part "tools/primary/exchange_markdown_primary_tools.dart";
part "tools/primary/font_markdown_primary_tools.dart";
part "tools/primary/undo_markdown_primary_tools.dart";
part "tools/primary/redo_markdown_primary_tools.dart";
part "tools/primary/indent_up_markdown_primary_tools.dart";
part "tools/primary/indent_down_markdown_primary_tools.dart";

part "tools/secondary/copy_markdown_secondary_tools.dart";
part "tools/secondary/cut_markdown_secondary_tools.dart";
part "tools/secondary/paste_markdown_secondary_tools.dart";
part "tools/secondary/close_markdown_secondary_tools.dart";

part "tools/block/add/text_add_markdown_block_tools.dart";
part "tools/block/add/headline_1_add_markdown_block_tools.dart";
part "tools/block/add/headline_2_add_markdown_block_tools.dart";
part "tools/block/add/headline_3_add_markdown_block_tools.dart";
part "tools/block/add/bulleted_list_add_markdown_block_tools.dart";
part "tools/block/add/number_list_add_markdown_block_tools.dart";
part "tools/block/add/toggle_list_add_markdown_block_tools.dart";
part "tools/block/add/code_add_markdown_block_tools.dart";
part "tools/block/add/quote_add_markdown_block_tools.dart";
part "tools/block/exchange/bulleted_list_exchange_markdown_block_tools.dart";
part "tools/block/exchange/code_exchange_markdown_block_tools.dart";
part "tools/block/exchange/headline_1_exchange_markdown_block_tools.dart";
part "tools/block/exchange/headline_2_exchange_markdown_block_tools.dart";
part "tools/block/exchange/headline_3_exchange_markdown_block_tools.dart";
part "tools/block/exchange/number_list_exchange_markdown_block_tools.dart";
part "tools/block/exchange/quote_exchange_markdown_block_tools.dart";
part "tools/block/exchange/text_exchange_markdown_block_tools.dart";
part "tools/block/exchange/toggle_list_exchange_markdown_block_tools.dart";
part "tools/block/media/image_from_camera_media_markdown_block_tools.dart";
part "tools/block/media/image_from_library_media_markdown_block_tools.dart";
part "tools/block/media/video_from_camera_media_markdown_block_tools.dart";
part "tools/block/media/video_from_library_media_markdown_block_tools.dart";

part "tools/inline/font/back_font_markdown_inline_tools.dart";
part "tools/inline/font/bold_font_markdown_inline_tools.dart";
part "tools/inline/font/italic_font_markdown_inline_tools.dart";
part "tools/inline/font/underline_font_markdown_inline_tools.dart";
part "tools/inline/font/strike_font_markdown_inline_tools.dart";
part "tools/inline/font/link_font_markdown_inline_tools.dart";
part "tools/inline/font/code_font_markdown_inline_tools.dart";

part "src/new_editor/form_markdown_field_2.dart";
part "src/new_editor/markdown_controller_2.dart";
