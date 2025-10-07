// part of "/masamune_markdown.dart";

// const _kToolbarHeight = kToolbarHeight;
// const _kLinkDialogHeight = _kToolbarHeight * 2;
// const _kMentionDialogSpaceHeight = _kToolbarHeight + 24.0;
// const _kMinChangeSize = 16.0;
// const _kBlockMenuToggleDuration = Duration(milliseconds: 200);

// /// Markdown toolbar.
// ///
// /// Pass the [MarkdownController] and the same controller to [FormMarkdownField].
// ///
// /// By specifying [mentionBuilder], a list of mentions can be displayed.
// ///
// /// You can use block styles for `h1`, `h2`, `h3`, and quotes and code blocks.
// /// You can insert image and video media.
// /// You can use font styles such as `bold`, `italic`, `underline`, `strike`, `link`, `code`.
// ///
// /// Markdown用のツールバー。
// ///
// /// [MarkdownController]を渡し同じコントローラーを[FormMarkdownField]に渡してください。
// ///
// /// [mentionBuilder]を指定することでメンションのリストを表示することができます。
// ///
// /// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
// /// 画像や映像のメディアを挿入することができます。
// /// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
// class FormMarkdownToolbar extends StatefulWidget {
//   /// Markdown toolbar.
//   ///
//   /// Pass the [MarkdownController] and the same controller to [FormMarkdownField].
//   ///
//   /// By specifying [mentionBuilder], a list of mentions can be displayed.
//   ///
//   /// You can use block styles for `h1`, `h2`, `h3`, and quotes and code blocks.
//   /// You can insert image and video media.
//   /// You can use font styles such as `bold`, `italic`, `underline`, `strike`, `link`, `code`.
//   ///
//   /// Markdown用のツールバー。
//   ///
//   /// [MarkdownController]を渡し同じコントローラーを[FormMarkdownField]に渡してください。
//   ///
//   /// [mentionBuilder]を指定することでメンションのリストを表示することができます。
//   ///
//   /// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
//   /// 画像や映像のメディアを挿入することができます。
//   /// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
//   const FormMarkdownToolbar({
//     required this.controller,
//     this.primaryTools,
//     this.secondaryTools,
//     super.key,
//     this.style,
//     this.mentionHintText,
//     this.mentionBuilder,
//     this.linkTitleHintText,
//     this.linkLinkHintText,
//   }) : assert(
//           (mentionBuilder == null && mentionHintText == null) ||
//               mentionBuilder != null,
//           "MentionHintText is required when using [mentionBuilder].",
//         );

//   /// Primary tools for the toolbar.
//   ///
//   /// ツールバーのプライマリーツール。
//   final List<MarkdownPrimaryTools>? primaryTools;

//   /// Secondary tools for the toolbar.
//   ///
//   /// ツールバーのセカンダリーツール。
//   final List<MarkdownSecondaryTools>? secondaryTools;

//   /// [MarkdownController] for the toolbar.
//   ///
//   /// Pass the same one to [FormMarkdownField].
//   ///
//   /// ツールバー用の[MarkdownController]。
//   ///
//   /// 同じものを[FormMarkdownField]に渡します。
//   final MarkdownController controller;

//   /// Style of the toolbar.
//   ///
//   /// ツールバーのスタイル。
//   final FormStyle? style;

//   /// Hint text for the mention.
//   ///
//   /// メンションのヒントテキスト。
//   final String? mentionHintText;

//   /// Hint text for the link title.
//   ///
//   /// リンクタイトルのヒントテキスト。
//   final String? linkTitleHintText;

//   /// Hint text for the link link.
//   ///
//   /// リンクリンクのヒントテキスト。
//   final String? linkLinkHintText;

//   /// Builder for the mentions.
//   ///
//   /// メンションのビルダー。
//   final List<MarkdownMention> Function(BuildContext context)? mentionBuilder;

//   @override
//   State<FormMarkdownToolbar> createState() => _FormMarkdownToolbarState();
// }

// class _FormMarkdownToolbarState extends State<FormMarkdownToolbar>
//     implements MarkdownToolRef {
//   bool _isKeyboardHidden = false;
//   bool _showBlockMenu = false;
//   double _blockMenuHeight = 0;
//   double _lastBottomInset = 0;
//   Duration? _blockMenuToggleDuration;
//   double? _prevBottomInset;

//   _LinkSetting? _linkSetting;
//   _MentionSetting? _mentionSetting;

//   final ClipboardMonitor _clipboardMonitor = ClipboardMonitor();

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_handleControllerStateOnChanged);
//     _clipboardMonitor.monitorClipboard(true, _handledClipboardStateOnChanged);
//   }

//   @override
//   void dispose() {
//     _clipboardMonitor.monitorClipboard(false, _handledClipboardStateOnChanged);
//     widget.controller.removeListener(_handleControllerStateOnChanged);
//     _linkSetting?.cancel();
//     _mentionSetting?.cancel();
//     super.dispose();
//   }

//   void _handledOnKeyboardStateChanged() {
//     final currentBottomInset = context.mediaQuery.viewInsets.bottom;
//     if (_prevBottomInset == currentBottomInset) {
//       return;
//     }
//     _prevBottomInset = currentBottomInset;
//     final isKeyboardShowing =
//         _lastBottomInset + _kMinChangeSize < currentBottomInset;
//     if (currentBottomInset > 0) {
//       if (_isKeyboardHidden && _lastBottomInset == 0) {
//         _isKeyboardHidden = false;
//       }
//       _blockMenuToggleDuration = null;
//     }
//     _lastBottomInset = currentBottomInset;
//     if (!_isKeyboardHidden && _blockMenuHeight < currentBottomInset) {
//       _blockMenuHeight = currentBottomInset;
//     }
//     if (isKeyboardShowing) {
//       if (_showBlockMenu) {
//         _showBlockMenu = false;
//       }
//     }
//   }

//   @override
//   MarkdownTools? get currentTool => _currentTool;
//   MarkdownTools? _currentTool;

//   @override
//   bool get canPaste => _clipboardMonitor.canPaste;

//   @override
//   bool get isKeyboardShowing =>
//       _showBlockMenu || context.mediaQuery.viewInsets.bottom > 0;

//   @override
//   FormMarkdownFieldState? get lastState => widget.controller.lastState;

//   @override
//   QuillController? get lastController => widget.controller.lastController;

//   @override
//   FocusNode? get lastFocusNode => widget.controller.lastFocusNode;

//   @override
//   FormMarkdownFieldState? get focuedState {
//     return widget.controller.focuedState;
//   }

//   @override
//   QuillController? get focusedController {
//     return widget.controller.focusedController;
//   }

//   @override
//   FocusNode? get focusedFocusNode {
//     return widget.controller.focusedFocusNode;
//   }

//   @override
//   TextSelection? get focusedSelection {
//     return widget.controller.focusedSelection;
//   }

//   @override
//   bool get isTextSelected {
//     final selection = focusedSelection;
//     if (selection == null) {
//       return false;
//     }
//     return selection.isValid && !selection.isCollapsed;
//   }

//   @override
//   List<MarkdownMention> Function(BuildContext context)? get mentionBuilder =>
//       widget.mentionBuilder;

//   @override
//   void toggleMode(MarkdownPrimaryTools tool) {
//     setState(() {
//       if (tool == _currentTool) {
//         if (_showBlockMenu) {
//           if (_blockMenuToggleDuration != null) {
//             _blockMenuHeight = 0;
//             _blockMenuToggleDuration = _kBlockMenuToggleDuration;
//           }
//           _showBlockMenu = false;
//           SystemChannels.textInput.invokeMethod("TextInput.show");
//           widget.controller.focusLastField();
//         } else {
//           if (tool.hideKeyboardOnSelected) {
//             if (_blockMenuHeight == 0) {
//               _blockMenuHeight = context.mediaQuery.size.height / 3.0;
//               _blockMenuToggleDuration = _kBlockMenuToggleDuration;
//             }
//             _showBlockMenu = true;
//             SystemChannels.textInput.invokeMethod("TextInput.hide");
//           }
//         }
//         _currentTool = tool;
//       } else {
//         if (_showBlockMenu) {
//           if (!tool.hideKeyboardOnSelected) {
//             if (_blockMenuToggleDuration != null) {
//               _blockMenuHeight = 0;
//               _blockMenuToggleDuration = _kBlockMenuToggleDuration;
//             }
//             _showBlockMenu = false;
//             SystemChannels.textInput.invokeMethod("TextInput.show");
//             widget.controller.focusLastField();
//           }
//         } else {
//           if (tool.hideKeyboardOnSelected) {
//             _showBlockMenu = true;
//             SystemChannels.textInput.invokeMethod("TextInput.hide");
//             if (_blockMenuHeight == 0) {
//               _blockMenuHeight = context.mediaQuery.size.height / 3.0;
//               _blockMenuToggleDuration = _kBlockMenuToggleDuration;
//             }
//           }
//         }
//         if (tool is MentionMarkdownPrimaryTools) {
//           _mentionSetting = _MentionSetting(
//             controller: focusedController!,
//           );
//           _mentionSetting!.focusNode.requestFocus();
//         }
//         if (_currentTool is MentionMarkdownPrimaryTools) {
//           _mentionSetting?.cancel();
//           _mentionSetting = null;
//         }
//         _currentTool = tool;
//       }
//     });
//   }

//   @override
//   void toggleLinkDialog() {
//     if (_linkSetting != null) {
//       setState(() {
//         _linkSetting = null;
//       });
//     } else {
//       final controller = focusedController;
//       if (controller == null) {
//         return;
//       }
//       setState(() {
//         _linkSetting = _LinkSetting(controller: controller);
//         _linkSetting?.focusNode.requestFocus();
//       });
//     }
//   }

//   @override
//   void deleteMode() {
//     setState(() {
//       if (_currentTool is MentionMarkdownPrimaryTools) {
//         _mentionSetting?.cancel();
//         _mentionSetting = null;
//       }
//       if (_blockMenuToggleDuration != null) {
//         _blockMenuHeight = 0;
//         _blockMenuToggleDuration = _kBlockMenuToggleDuration;
//       }
//       _currentTool = null;
//       _showBlockMenu = false;
//       SystemChannels.textInput.invokeMethod("TextInput.show");
//     });
//   }

//   @override
//   void closeKeyboard() {
//     setState(() {
//       _isKeyboardHidden = true;
//       _showBlockMenu = false;
//       _blockMenuHeight = 0;
//       focuedState?._effectiveFocusNode.unfocus();
//       SystemChannels.textInput.invokeMethod("TextInput.hide");
//     });
//   }

//   @override
//   bool activeAttribute(Attribute attribute) {
//     final selection = focusedSelection;
//     if (selection == null) {
//       return false;
//     }
//     return focusedController
//             ?.getSelectionStyle()
//             .values
//             .any((e) => e.key == attribute.key) ??
//         false;
//   }

//   @override
//   void insertImage(Uri uri) {
//     widget.controller.insertImage(uri);
//   }

//   @override
//   void insertVideo(Uri uri) {
//     widget.controller.insertVideo(uri);
//   }

//   void _handleControllerStateOnChanged() {
//     if ((isTextSelected && _currentTool is! FontMarkdownPrimaryTools) ||
//         (!isTextSelected && _currentTool is FontMarkdownPrimaryTools)) {
//       if (isTextSelected) {
//         toggleMode(const FontMarkdownPrimaryTools());
//       } else {
//         deleteMode();
//       }
//       if (!isTextSelected) {
//         setState(() {
//           _linkSetting = null;
//         });
//       }
//     }
//     if (_currentTool is MentionMarkdownPrimaryTools &&
//         _showBlockMenu &&
//         (focuedState?.cursorInLink ?? false)) {
//       toggleMode(const MentionMarkdownPrimaryTools());
//     }
//   }

//   void _handledClipboardStateOnChanged() {
//     setState(() {});
//   }

//   Iterable<Widget> _buildPrimaryTools(BuildContext context, ThemeData theme) {
//     final primaryTools =
//         widget.primaryTools ?? widget.controller.adapter.defaultPrimaryTools;
//     return primaryTools.mapAndRemoveEmpty((e) {
//       if (!e.shown(context, this)) {
//         return null;
//       }
//       if (!e.enabled(context, this) || !e.actived(context, this)) {
//         return IconButton(
//           onPressed: null,
//           icon: e.icon(context, this),
//         );
//       } else {
//         final controller = focuedState?._controller;
//         if (e is MentionMarkdownPrimaryTools && controller != null) {
//           if (_currentTool == e && _showBlockMenu) {
//             return ListenableBuilder(
//                 listenable: controller,
//                 builder: (context, child) {
//                   return IconButton.filled(
//                     style: IconButton.styleFrom(
//                       backgroundColor: widget.style?.activeBackgroundColor ??
//                           theme.colorTheme?.primary ??
//                           theme.colorScheme.primary,
//                       foregroundColor: widget.style?.activeColor ??
//                           theme.colorTheme?.onPrimary ??
//                           theme.colorScheme.onPrimary,
//                     ),
//                     onPressed: (focuedState?.cursorInLink ?? false)
//                         ? null
//                         : () {
//                             e.onTap(context, this);
//                           },
//                     icon: e.icon(context, this),
//                   );
//                 });
//           } else {
//             return ListenableBuilder(
//               listenable: controller,
//               builder: (context, child) {
//                 return IconButton(
//                   onPressed: (focuedState?.cursorInLink ?? false)
//                       ? null
//                       : () {
//                           e.onTap(context, this);
//                         },
//                   icon: e.icon(context, this),
//                 );
//               },
//             );
//           }
//         } else {
//           if (_currentTool == e && _showBlockMenu) {
//             return IconButton.filled(
//               style: IconButton.styleFrom(
//                 backgroundColor: widget.style?.activeBackgroundColor ??
//                     theme.colorTheme?.primary ??
//                     theme.colorScheme.primary,
//                 foregroundColor: widget.style?.activeColor ??
//                     theme.colorTheme?.onPrimary ??
//                     theme.colorScheme.onPrimary,
//               ),
//               onPressed: () {
//                 e.onTap(context, this);
//               },
//               icon: e.icon(context, this),
//             );
//           } else {
//             return IconButton(
//               onPressed: () {
//                 e.onTap(context, this);
//               },
//               icon: e.icon(context, this),
//             );
//           }
//         }
//       }
//     });
//   }

//   Iterable<Widget> _buildSecondaryTools(BuildContext context, ThemeData theme) {
//     final secondaryTools = widget.secondaryTools ??
//         widget.controller.adapter.defaultSecondaryTools;
//     final subMenu = secondaryTools.mapAndRemoveEmpty((e) {
//       if (e.shown(context, this)) {
//         return IconButton(
//           onPressed: () {
//             e.onTap(context, this);
//           },
//           icon: e.icon(context, this),
//         );
//       }
//       return null;
//     });
//     if (subMenu.isNotEmpty) {
//       return [
//         VerticalDivider(
//           width: 1,
//           color: (widget.style?.borderColor ?? theme.colorScheme.outline)
//               .withAlpha(128),
//         ),
//         ...subMenu,
//       ];
//     }
//     return [];
//   }

//   Iterable<Widget> _buildInlineTools(
//     BuildContext context,
//     ThemeData theme,
//     List<MarkdownInlineTools> tools,
//   ) {
//     return tools.map((e) {
//       if (e.actived(context, this)) {
//         return IconButton.filled(
//           style: IconButton.styleFrom(
//             backgroundColor: widget.style?.activeBackgroundColor ??
//                 theme.colorTheme?.primary ??
//                 theme.colorScheme.primary,
//             foregroundColor: widget.style?.activeColor ??
//                 theme.colorTheme?.onPrimary ??
//                 theme.colorScheme.onPrimary,
//           ),
//           onPressed: () {
//             e.onDeactive(context, this);
//           },
//           icon: e.icon(context, this),
//         );
//       } else {
//         return IconButton(
//           onPressed: () {
//             e.onActive(context, this);
//           },
//           icon: e.icon(context, this),
//         );
//       }
//     });
//   }

//   Widget _buildLinkDialog(BuildContext context, ThemeData theme) {
//     return Positioned(
//       left: 0,
//       right: 0,
//       bottom: _blockMenuHeight,
//       child: Container(
//         color: widget.style?.backgroundColor ?? theme.colorTheme?.background,
//         height: _kLinkDialogHeight,
//         width: double.infinity,
//         padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.title),
//                 16.sx,
//                 Expanded(
//                   child: FormTextField(
//                     initialValue: _linkSetting?.link.text,
//                     hintText: widget.linkTitleHintText,
//                     style: FormStyle(
//                       borderStyle: FormInputBorderStyle.outline,
//                       backgroundColor: widget.style?.subBackgroundColor ??
//                           widget.style?.backgroundColor ??
//                           theme.colorTheme?.surface,
//                     ),
//                     onChanged: (value) {
//                       if (value == null) {
//                         return;
//                       }
//                       _linkSetting?.link = QuillTextLink(
//                         value.trim(),
//                         _linkSetting?.link.link?.trim(),
//                       );
//                     },
//                   ),
//                 ),
//                 8.sx,
//                 IconButton(
//                   onPressed: () {
//                     _linkSetting?.cancel();
//                     _linkSetting = null;
//                   },
//                   icon: const Icon(Icons.cancel_outlined),
//                 ),
//               ],
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.link),
//                 16.sx,
//                 Expanded(
//                   child: FormTextField(
//                     focusNode: _linkSetting?.focusNode,
//                     initialValue: _linkSetting?.link.link,
//                     hintText: widget.linkLinkHintText,
//                     style: FormStyle(
//                       borderStyle: FormInputBorderStyle.outline,
//                       backgroundColor: widget.style?.subBackgroundColor ??
//                           widget.style?.backgroundColor ??
//                           theme.colorTheme?.surface,
//                     ),
//                     onChanged: (value) {
//                       _linkSetting?.link = QuillTextLink(
//                         _linkSetting?.link.text.trim() ?? "",
//                         value?.trim(),
//                       );
//                     },
//                   ),
//                 ),
//                 8.sx,
//                 IconButton(
//                   onPressed: () {
//                     _linkSetting?.submit();
//                     setState(() {
//                       _linkSetting = null;
//                     });
//                   },
//                   icon: const Icon(Icons.check_circle),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMentionDialog(BuildContext context, ThemeData theme) {
//     final height = context.mediaQuery.size.height -
//         _blockMenuHeight -
//         _kToolbarHeight -
//         _kMentionDialogSpaceHeight -
//         context.mediaQuery.viewPadding.bottom -
//         context.mediaQuery.viewPadding.top;

//     return Positioned(
//       left: 0,
//       right: 0,
//       bottom: _blockMenuToggleDuration != null ? 0 : _blockMenuHeight,
//       child: Container(
//         clipBehavior: Clip.hardEdge,
//         decoration: BoxDecoration(
//           color: widget.style?.backgroundColor ?? theme.colorTheme?.background,
//         ),
//         height: height,
//         width: double.infinity,
//         child: Column(
//           children: [
//             Expanded(
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   border: Border(
//                     top: BorderSide(
//                       color: (widget.style?.borderColor ??
//                               theme.colorTheme?.outline ??
//                               theme.colorScheme.outline)
//                           .withAlpha(128),
//                     ),
//                     bottom: BorderSide(
//                       color: (widget.style?.borderColor ??
//                               theme.colorTheme?.outline ??
//                               theme.colorScheme.outline)
//                           .withAlpha(128),
//                     ),
//                   ),
//                 ),
//                 child: ListenableBuilder(
//                     listenable: _mentionSetting!.controller,
//                     builder: (context, child) {
//                       final search = _mentionSetting!.textEditingController.text
//                           .toLowerCase();
//                       final mentions =
//                           widget.mentionBuilder?.call(context).where((e) {
//                                 if (search.isEmpty) {
//                                   return true;
//                                 }
//                                 return e.name.toLowerCase().contains(search) ||
//                                     e.id.toLowerCase().contains(search);
//                               }).toList() ??
//                               [];
//                       return ListView.builder(
//                         itemCount: mentions.length,
//                         padding: EdgeInsets.fromLTRB(
//                           0,
//                           16,
//                           0,
//                           16 + context.mediaQuery.viewPadding.bottom,
//                         ),
//                         itemBuilder: (context, index) {
//                           final mention = mentions[index];
//                           return GestureDetector(
//                             onTap: () async {
//                               _mentionSetting?.focusNode.unfocus();
//                               final controller = _mentionSetting!.controller;
//                               controller.insertMention(mention);
//                               deleteMode();
//                               await widget.controller.focusLastField();
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   SizedBox(
//                                     width: 32,
//                                     height: 32,
//                                     child: CircleAvatar(
//                                       backgroundImage: mention.avatar,
//                                       backgroundColor:
//                                           widget.style?.borderColor ??
//                                               theme.colorScheme.outline,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Text(
//                                       mention.name.trim().trimString("@"),
//                                       style: theme.textTheme.titleMedium,
//                                     ),
//                                   ),
//                                   Text(
//                                     "@${mention.id.trim().trimString("@")}",
//                                     textAlign: TextAlign.end,
//                                     style: theme.textTheme.bodyMedium
//                                         ?.withColor(widget.style?.subColor ??
//                                             theme.disabledColor),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     onPressed: () async {
//                       _mentionSetting?.focusNode.unfocus();
//                       deleteMode();
//                       await widget.controller.focusLastField();
//                     },
//                     icon: const Icon(Icons.arrow_back_ios),
//                   ),
//                   Expanded(
//                     child: FormTextField(
//                       focusNode: _mentionSetting!.focusNode,
//                       controller: _mentionSetting!.textEditingController,
//                       hintText: widget.mentionHintText,
//                       style: FormStyle(
//                         borderStyle: FormInputBorderStyle.outline,
//                         borderRadius: BorderRadius.circular(32),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 4,
//                         ),
//                         backgroundColor: widget.style?.subBackgroundColor ??
//                             widget.style?.backgroundColor ??
//                             theme.colorTheme?.surface,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBlockTools(
//     BuildContext context,
//     ThemeData theme,
//     List<MarkdownBlockTools> tools,
//   ) {
//     return Positioned(
//       left: 0,
//       right: 0,
//       bottom: 0,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               color: (widget.style?.borderColor ??
//                       theme.colorTheme?.outline ??
//                       theme.colorScheme.outline)
//                   .withAlpha(128),
//             ),
//           ),
//         ),
//         height: _blockMenuHeight,
//         width: double.infinity,
//         child: GridView.extent(
//           maxCrossAxisExtent: 240,
//           mainAxisSpacing: 8,
//           crossAxisSpacing: 8,
//           childAspectRatio: 3,
//           padding: EdgeInsets.fromLTRB(
//             16,
//             16,
//             16,
//             16 + context.mediaQuery.viewPadding.bottom,
//           ),
//           children: [
//             ...tools.map((e) {
//               return InkWell(
//                 onTap: () {
//                   e.onTap(context, this);
//                 },
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     color: widget.style?.subBackgroundColor ??
//                         widget.style?.backgroundColor ??
//                         theme.colorScheme.surface,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Center(
//                           child: e.icon(context, this),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: DefaultTextStyle(
//                           style:
//                               theme.textTheme.labelMedium ?? const TextStyle(),
//                           child: e.label(context, this),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     _handledOnKeyboardStateChanged();
//     final theme = Theme.of(context);
//     var height = _blockMenuHeight;
//     if (_linkSetting != null) {
//       height += _kLinkDialogHeight;
//     } else if (_currentTool is MentionMarkdownPrimaryTools) {
//       height += context.mediaQuery.size.height -
//           _blockMenuHeight -
//           _kToolbarHeight -
//           _kMentionDialogSpaceHeight -
//           context.mediaQuery.viewPadding.bottom -
//           context.mediaQuery.viewPadding.top;
//       if (_blockMenuToggleDuration != null) {
//         height -= _blockMenuHeight;
//       }
//     } else {
//       height += _kToolbarHeight;
//     }

//     final inlineTools = _currentTool is MarkdownPrimaryTools
//         ? (_currentTool as MarkdownPrimaryTools).inlineTools
//         : null;
//     final blockTools = _currentTool is MarkdownPrimaryTools
//         ? (_currentTool as MarkdownPrimaryTools).blockTools
//         : null;

//     return IconTheme(
//       data: IconThemeData(
//         color: widget.style?.color ?? theme.colorTheme?.onBackground,
//       ),
//       child: DefaultTextStyle(
//         style: theme.textTheme.bodyMedium?.copyWith(
//               color: widget.style?.color ?? theme.colorTheme?.onBackground,
//             ) ??
//             TextStyle(
//               color: widget.style?.color ?? theme.colorTheme?.onBackground,
//             ),
//         child: AnimatedContainer(
//           duration: _blockMenuToggleDuration ?? Duration.zero,
//           curve: Curves.easeInOut,
//           color: widget.style?.backgroundColor ?? theme.colorTheme?.background,
//           height: height,
//           child: Stack(
//             children: [
//               if (blockTools != null) ...[
//                 _buildBlockTools(context, theme, blockTools),
//               ],
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 top: 0,
//                 child: Container(
//                   color: widget.style?.backgroundColor ??
//                       theme.colorTheme?.background,
//                   height: _kToolbarHeight,
//                   width: double.infinity,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Expanded(
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               if (!(focuedState?._selectInMentionLink ??
//                                       false) &&
//                                   inlineTools != null) ...[
//                                 ..._buildInlineTools(
//                                     context, theme, inlineTools),
//                               ] else ...[
//                                 ..._buildPrimaryTools(context, theme),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ),
//                       ..._buildSecondaryTools(context, theme),
//                     ],
//                   ),
//                 ),
//               ),
//               if (_currentTool is MentionMarkdownPrimaryTools) ...[
//                 _buildMentionDialog(context, theme),
//               ] else if (_linkSetting != null) ...[
//                 _buildLinkDialog(context, theme),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// A reference class for Markdown tools.
// ///
// /// マークダウンのツールの参照クラス。
// abstract class MarkdownToolRef {
//   const MarkdownToolRef._();

//   /// Toggle the mode.
//   ///
//   /// モードを切り替えます。
//   void toggleMode(MarkdownPrimaryTools tool);

//   /// Delete the mode.
//   ///
//   /// モードを削除します。
//   void deleteMode();

//   /// Close the keyboard.
//   ///
//   /// キーボードを閉じます。
//   void closeKeyboard();

//   /// Get the last state.
//   ///
//   /// 最後にフォーカスした状態を取得します。
//   FormMarkdownFieldState? get lastState;

//   /// Get the last controller.
//   ///
//   /// 最後にフォーカスしたコントローラーを取得します。
//   QuillController? get lastController;

//   /// Get the last focus node.
//   ///
//   /// 最後にフォーカスしたフォーカスノードを取得します。
//   FocusNode? get lastFocusNode;

//   /// Get the focused state.
//   ///
//   /// フォーカスされている状態を取得します。
//   FormMarkdownFieldState? get focuedState;

//   /// Get the controller.
//   ///
//   /// コントローラーを取得します。
//   QuillController? get focusedController;

//   /// Get the focused focus node.
//   ///
//   /// フォーカスされているフォーカスノードを取得します。
//   FocusNode? get focusedFocusNode;

//   /// Get the focused selection.
//   ///
//   /// フォーカスされている選択範囲を取得します。
//   TextSelection? get focusedSelection;

//   /// Check if the text is selected.
//   ///
//   /// テキストが選択されているかどうかを確認します。
//   bool get isTextSelected;

//   /// Check if the attribute is active.
//   ///
//   /// 属性がアクティブかどうかを確認します。
//   bool activeAttribute(Attribute attribute);

//   /// Get the current mode.
//   ///
//   /// 現在のモードを取得します。
//   MarkdownTools? get currentTool;

//   /// Check if the keyboard should be shown.
//   ///
//   /// キーボードが表示されているかどうかを確認します。
//   bool get isKeyboardShowing;

//   /// Check if the clipboard can be pasted.
//   ///
//   /// クリップボードに貼り付け可能かどうかを確認します。
//   bool get canPaste;

//   /// Open the link dialog.
//   ///
//   /// リンクダイアログを開きます。
//   void toggleLinkDialog();

//   /// Get the mention builder.
//   ///
//   /// メンションビルダーを取得します。
//   List<MarkdownMention> Function(BuildContext context)? get mentionBuilder;

//   /// Insert image.
//   ///
//   /// 画像を挿入します。
//   void insertImage(Uri uri);

//   /// Insert video.
//   ///
//   /// ビデオを挿入します。
//   void insertVideo(Uri uri);
// }

// class _LinkSetting {
//   _LinkSetting({
//     required this.controller,
//   }) {
//     link = QuillTextLink.prepare(controller);
//   }

//   final QuillController controller;
//   late QuillTextLink link;
//   final FocusNode focusNode = FocusNode();

//   void submit() {
//     if (link.link.isEmpty) {
//       final index = controller.selection.start;
//       final length = controller.selection.end - index;
//       controller
//         ..replaceText(index, length, link.text, null)
//         ..removeFormatSelection(Attribute.link);
//     } else {
//       link.submit(controller);
//     }
//   }

//   void cancel() {
//     focusNode.dispose();
//   }
// }

// class _MentionSetting {
//   _MentionSetting({
//     required this.controller,
//   });

//   final QuillController controller;
//   final TextEditingController textEditingController = TextEditingController();
//   final FocusNode focusNode = FocusNode();

//   void cancel() {
//     textEditingController.dispose();
//     focusNode.dispose();
//   }
// }
