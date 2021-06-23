part of masamune_calendar;

class HeaderStyle {
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

  final bool centerHeaderTitle;

  final bool formatButtonVisible;

  final bool formatButtonShowsNext;

  final TextBuilder? titleTextBuilder;

  final TextStyle titleTextStyle;

  final TextStyle formatButtonTextStyle;

  final Decoration formatButtonDecoration;

  final EdgeInsetsGeometry headerPadding;

  final EdgeInsetsGeometry? headerMargin;

  final EdgeInsetsGeometry formatButtonPadding;

  final EdgeInsetsGeometry leftChevronPadding;

  final EdgeInsetsGeometry rightChevronPadding;

  final EdgeInsetsGeometry leftChevronMargin;

  final EdgeInsetsGeometry rightChevronMargin;

  final Icon leftChevronIcon;

  final Icon rightChevronIcon;

  final bool showLeftChevron;
  final bool showRightChevron;

  final BoxDecoration decoration;
}
