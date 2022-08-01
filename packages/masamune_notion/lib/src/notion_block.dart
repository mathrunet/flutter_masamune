part of masamune_notion;

@immutable
class NotionBlock extends StatefulWidget {
  const NotionBlock(
    this.block, {
    this.builder,
    this.depth = 0,
  });

  final NotionBlockDocumentModel block;
  final Widget? Function(BuildContext context, NotionBlockDocumentModel block)?
      builder;
  final int depth;

  @override
  State<StatefulWidget> createState() => _NotionBlockState();

  static Text plainText(
    BuildContext context,
    List<DynamicMap> texts, {
    double? fontSize,
    bool bold = false,
  }) {
    return Text(
      texts.fold("", (initialValue, element) {
        return "$initialValue${element.get("plain_text", "")}";
      }),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  static RichText richText(
    BuildContext context,
    List<DynamicMap> texts, {
    double? fontSize,
    bool bold = false,
  }) {
    return RichText(
      text: TextSpan(
        children: texts.mapAndRemoveEmpty((item) {
          final type = item.get("type", "");
          switch (type) {
            case "mention":
              final content = item.get("plain_text", "");
              final link = item.get("href", "");
              return TextSpan(
                style: annotationToTextStyle(
                  context,
                  item.getAsMap("annotations"),
                  fontSize: fontSize,
                  bold: bold,
                ),
                recognizer: link.isNotEmpty
                    ? (TapGestureRecognizer()
                      ..onTap = () => context.navigator
                          .pushNamed(NotionCore._onOpenInternalPath(link)))
                    : null,
                text: content,
              );
            default:
              final content = item.getAsMap("text").get("content", "");
              final link = item
                  .getAsMap("text")
                  .getAsMap("link")
                  .get("url", nullOfString);
              return TextSpan(
                style: annotationToTextStyle(
                  context,
                  item.getAsMap("annotations"),
                  fontSize: fontSize,
                  bold: bold,
                ),
                recognizer: link.isNotEmpty
                    ? (TapGestureRecognizer()..onTap = () => openURL(link!))
                    : null,
                text: content,
              );
          }
        }),
      ),
    );
  }
}

class _NotionBlockState extends State<NotionBlock> {
  NotionBlockDocumentModel get block => widget.block;
  static const double _indentWidth = 16.0;

  @override
  void initState() {
    super.initState();
    block.loadChildrenOnce();
    block.addListener(_handledOnUpdate);
  }

  @override
  void didUpdateWidget(covariant NotionBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.block != oldWidget.block) {
      oldWidget.block.removeListener(_handledOnUpdate);
      widget.block.addListener(_handledOnUpdate);
      widget.block.loadChildrenOnce();
    }
  }

  @override
  void dispose() {
    super.dispose();
    block.removeListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (block.hasChildren) {
      if (block.children == null) {
        return Center(
          child: context.theme.widget.loadingIndicator?.call(context, null) ??
              const CircularProgressIndicator(),
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Space.height(4),
          _build(context),
          LoadingBuilder(
            futures: [
              block.children?.loading,
            ],
            builder: (context) {
              return Indent(
                padding: const EdgeInsets.only(left: _indentWidth, top: 4),
                children: block.children!.map((e) {
                  return NotionBlock(e, depth: widget.depth + 1);
                }).toList(),
              );
            },
          ),
          const Space.height(4),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: _build(context),
      );
    }
  }

  Widget _build(BuildContext context) {
    final res = widget.builder?.call(context, block);
    final theme = NotionBlockTheme.of(context);
    if (res != null) {
      return res;
    }
    final tmp = theme?.data?.get(block.type)?.call(block);
    if (tmp != null) {
      return tmp;
    }
    switch (block.type) {
      case "divider":
        return const Divid();
      case "bulleted_list_item":
        final data = block.rawData;
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _indentWidth,
              child: Icon(
                Icons.circle,
                size: 12,
                color: context.theme.textColorOnSurface,
              ),
            ),
            Flexible(
              child: NotionBlock.richText(
                context,
                data.getAsList<DynamicMap>("text"),
                fontSize: context.theme.textBodyMedium.fontSize,
              ),
            )
          ],
        );
      case "numbered_list_item":
        final data = block.rawData;
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _indentWidth,
              child: Text(
                "${block.index}.",
                style: TextStyle(
                  fontSize: context.theme.textBodyMedium.fontSize,
                ),
              ),
            ),
            const Space.width(8),
            Flexible(
              child: NotionBlock.richText(
                context,
                data.getAsList<DynamicMap>("text"),
                fontSize: context.theme.textBodyMedium.fontSize,
              ),
            )
          ],
        );
      case "heading_1":
        final data = block.rawData;
        return NotionBlock.richText(
          context,
          data.getAsList<DynamicMap>("text"),
          bold: true,
          fontSize: context.theme.textHeadlineLarge.fontSize,
        );
      case "heading_2":
        final data = block.rawData;
        return NotionBlock.richText(
          context,
          data.getAsList<DynamicMap>("text"),
          bold: true,
          fontSize: context.theme.textHeadlineMedium.fontSize,
        );
      case "heading_3":
        final data = block.rawData;
        return NotionBlock.richText(
          context,
          data.getAsList<DynamicMap>("text"),
          bold: true,
          fontSize: context.theme.textHeadlineSmall.fontSize,
        );
      case "paragraph":
        final data = block.rawData;
        final texts = data.getAsList<DynamicMap>("text");
        if (texts.length == 1) {
          final first = texts.first;
          if (first.get("type", "") == "mention") {
            final content = first.get("plain_text", "");
            final link = first.get("href", "");
            return InkWell(
              onTap: () {
                context.navigator
                    .pushNamed(NotionCore._onOpenInternalPath(link));
              },
              child: Container(
                decoration: DefaultBoxDecoration(
                  color: context.theme.dividerColor,
                  radius: 4.0,
                  width: 1,
                ),
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 96),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: context.theme.textTitleLarge.fontSize,
                  ),
                ),
              ),
            );
          }
        }
        return NotionBlock.richText(
          context,
          texts,
          fontSize: context.theme.textBodyMedium.fontSize,
        );
      case "code":
        final data = block.rawData;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: context.theme.surfaceColor,
          ),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: NotionBlock.richText(
              context,
              data.getAsList<DynamicMap>("text"),
              fontSize: context.theme.textBodyMedium.fontSize,
            ),
          ),
        );
    }
    return const Empty();
  }
}

class NotionBlockTheme extends InheritedWidget {
  const NotionBlockTheme({
    this.data,
    required Widget child,
  }) : super(child: child);

  final NotionBlockThemeData? data;

  /// Get NotionBlockTheme.
  ///
  /// You can check the current Notion block theme setting.
  static NotionBlockTheme? of(BuildContext context) {
    final notionBlock =
        context.getElementForInheritedWidgetOfExactType<NotionBlockTheme>();
    final widget = notionBlock?.widget;
    return widget as NotionBlockTheme?;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

@immutable
class NotionBlockThemeData {
  const NotionBlockThemeData({
    this.builder = const {},
  });

  final Map<String, Widget Function(NotionBlockDocumentModel block)> builder;

  Widget Function(NotionBlockDocumentModel block)? get(String id) {
    return builder[id];
  }

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => builder.hashCode;

  /// Copy the NotionBlockThemeData.
  NotionBlockThemeData copyWith({
    Map<String, Widget Function(NotionBlockDocumentModel block)>? builder,
  }) {
    return NotionBlockThemeData(
      builder: builder ?? this.builder,
    );
  }
}
