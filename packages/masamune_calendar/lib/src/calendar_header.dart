part of masamune_calendar;

/// Build the calendar header.
///
/// You can update the header based on the controller date by passing [controller].
///
/// You can create a custom header by passing [titleBuilder].
///
/// You can specify the header style by passing [style].
///
/// By passing [onTap], you can specify the process to be performed when the header is tapped.
///
/// カレンダーのヘッダーを構築します。
///
/// [controller]を渡すことでコントローラーの日付を元にヘッダーを更新できます。
///
/// [titleBuilder]を渡すことでカスタムのヘッダーを作成できます。
///
/// [style]を渡すことでヘッダーのスタイルを指定できます。
///
/// [onTap]を渡すことでヘッダーをタップした際の処理を指定できます。
@immutable
class CalendarHeader extends StatefulWidget {
  /// Build the calendar header.
  ///
  /// You can update the header based on the controller date by passing [controller].
  ///
  /// You can create a custom header by passing [titleBuilder].
  ///
  /// You can specify the header style by passing [style].
  ///
  /// By passing [onTap], you can specify the process to be performed when the header is tapped.
  ///
  /// カレンダーのヘッダーを構築します。
  ///
  /// [controller]を渡すことでコントローラーの日付を元にヘッダーを更新できます。
  ///
  /// [titleBuilder]を渡すことでカスタムのヘッダーを作成できます。
  ///
  /// [style]を渡すことでヘッダーのスタイルを指定できます。
  ///
  /// [onTap]を渡すことでヘッダーをタップした際の処理を指定できます。
  const CalendarHeader({
    super.key,
    required this.controller,
    this.style = const CalendarHeaderStyle(),
    this.onTap,
    this.titleBuilder,
  });

  /// You can specify a calendar controller.
  ///
  /// You can update the header based on the controller's date.
  ///
  /// カレンダーのコントローラーを指定できます。
  ///
  /// コントローラーの日付を元にヘッダーを更新できます。
  final CalendarController controller;

  /// Specifies the style of the calendar header.
  ///
  /// カレンダーヘッダーのスタイルを指定します。
  final CalendarHeaderStyle style;

  /// You can specify what happens when the header is tapped.
  ///
  /// ヘッダーをタップした際の処理を指定できます。
  final VoidCallback? onTap;

  /// You can create a custom header by passing this on.
  ///
  /// The style of the header is passed to [style]. The date currently in focus is passed to [focusedDate].
  ///
  /// これを渡すことでカスタムのヘッダーを作成できます。
  ///
  /// [style]にヘッダーのスタイル。[focusedDate]に現在フォーカスされている日付が渡されます。
  final Widget Function(BuildContext context, CalendarHeaderStyle style,
      DateTime focusedDate)? titleBuilder;

  @override
  State<StatefulWidget> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  @override
  void initState() {
    super.initState();
    widget.controller._addListener(
      _selectNext,
      _selectPrev,
      _selectDay,
    );
  }

  @override
  void didUpdateWidget(covariant CalendarHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller._removeListener(
        _selectNext,
        _selectPrev,
        _selectDay,
      );
      widget.controller._addListener(
        _selectNext,
        _selectPrev,
        _selectDay,
      );
    }
  }

  void _selectNext() {
    setState(() {});
  }

  void _selectPrev() {
    setState(() {});
  }

  void _selectDay(DateTime dateTime) {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller._removeListener(
      _selectNext,
      _selectPrev,
      _selectDay,
    );
  }

  @override
  Widget build(BuildContext context) {
    final focusedDay = widget.controller.focusedDay;
    final children = [
      if (widget.style.leftChevronIcon != null)
        _CalendarChevronIconButton(
          icon: widget.style.leftChevronIcon!.icon,
          onTap: widget.controller.prev,
          margin: widget.style.leftChevronIcon?.margin ?? EdgeInsets.zero,
          padding: widget.style.leftChevronIcon?.padding ?? EdgeInsets.zero,
        )
      else
        const Empty(),
      Expanded(
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.titleBuilder?.call(context, widget.style, focusedDay) ??
              Text(
                focusedDay.yyyyMMdd(),
                style: widget.style.textStyle,
                textAlign: widget.style.textAlign,
              ),
        ),
      ),
      if (widget.style.rightChevronIcon != null)
        _CalendarChevronIconButton(
          icon: widget.style.rightChevronIcon!.icon,
          onTap: widget.controller.next,
          margin: widget.style.rightChevronIcon?.margin ?? EdgeInsets.zero,
          padding: widget.style.rightChevronIcon?.padding ?? EdgeInsets.zero,
        )
      else
        const Empty()
    ];

    return Container(
      decoration: widget.style.decoration,
      margin: widget.style.margin,
      padding: widget.style.padding,
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }
}
