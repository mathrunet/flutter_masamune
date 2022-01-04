part of masamune_calendar;

/// Style class for header.
@immutable
class HeaderStyle {
  /// Style class for header.
  const HeaderStyle({
    this.centerHeaderTitle = false,
    this.formatButtonVisible = true,
    this.formatButtonShowsNext = true,
    this.titleTextBuilder,
    this.titleTextStyle = const TextStyle(fontSize: 17.0),
    this.formatButtonTextStyle = const TextStyle(),
    this.formatButtonDecoration = const BoxDecoration(
      border: Border(
          top: BorderSide(),
          bottom: BorderSide(),
          left: BorderSide(),
          right: BorderSide()),
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    this.headerMargin,
    this.headerPadding = const EdgeInsets.symmetric(vertical: 8.0),
    this.formatButtonPadding =
        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
    this.leftChevronPadding = const EdgeInsets.all(12.0),
    this.rightChevronPadding = const EdgeInsets.all(12.0),
    this.leftChevronMargin = const EdgeInsets.symmetric(horizontal: 8.0),
    this.rightChevronMargin = const EdgeInsets.symmetric(horizontal: 8.0),
    this.leftChevronIcon = const Icon(Icons.chevron_left),
    this.rightChevronIcon = const Icon(Icons.chevron_right),
    this.showLeftChevron = true,
    this.showRightChevron = true,
    this.decoration = const BoxDecoration(),
  });

  /// If you want to center the header title, use `True`.
  final bool centerHeaderTitle;

  /// If you want to show the calendar format switching button `True`.
  final bool formatButtonVisible;

  /// If you want to show the next calendar format switch button `True`.
  final bool formatButtonShowsNext;

  /// Builder for title text.
  final TextBuilder? titleTextBuilder;

  /// Style for title text.
  final TextStyle titleTextStyle;

  /// Text style of the format switching button.
  final TextStyle formatButtonTextStyle;

  /// Decoration of the format switching button.
  final Decoration formatButtonDecoration;

  /// Header padding.
  final EdgeInsetsGeometry headerPadding;

  /// Header margin.
  final EdgeInsetsGeometry? headerMargin;

  /// Padding for the format switch button.
  final EdgeInsetsGeometry formatButtonPadding;

  /// Padding for the back to previous icon.
  final EdgeInsetsGeometry leftChevronPadding;

  /// Padding of the icon to proceed next.
  final EdgeInsetsGeometry rightChevronPadding;

  /// Margin of the previous back icon.
  final EdgeInsetsGeometry leftChevronMargin;

  /// Margin of the icon to proceed next.
  final EdgeInsetsGeometry rightChevronMargin;

  /// Back to previous icon.
  final Icon leftChevronIcon;

  /// Next icon.
  final Icon rightChevronIcon;

  /// `True` if you want to show the previous icon.
  final bool showLeftChevron;

  /// If you want to show the next icon, use `True`.
  final bool showRightChevron;

  /// Decoration.
  final BoxDecoration decoration;
}
