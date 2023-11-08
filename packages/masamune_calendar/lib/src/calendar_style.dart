part of '/masamune_calendar.dart';

/// Specify the calendar style.
///
/// カレンダーのスタイルを指定します。
@immutable
class CalendarStyle {
  /// Specify the calendar style.
  ///
  /// カレンダーのスタイルを指定します。
  const CalendarStyle({
    this.border,
    this.daysOfWeek = const CalendarDaysOfWeekStyle(),
    this.content = const CalendarContentStyle(),
  });

  /// Table Border.
  ///
  /// テーブルボーダー。
  final TableBorder? border;

  /// Specifies the style in which the days of the week are displayed.
  ///
  /// 曜日の表示するスタイルを指定します。
  final CalendarDaysOfWeekStyle daysOfWeek;

  /// Specifies the style in which the content is displayed.
  ///
  /// コンテンツを表示するスタイルを指定します。
  final CalendarContentStyle content;
}

/// Specifies the header style of the calendar.
///
/// カレンダーのヘッダースタイルを指定します。
@immutable
class CalendarHeaderStyle {
  /// Specifies the header style of the calendar.
  ///
  /// カレンダーのヘッダースタイルを指定します。
  const CalendarHeaderStyle({
    this.leftChevronIcon,
    this.rightChevronIcon,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.decoration,
    this.margin,
    this.padding,
  });

  /// Specify the style of the left arrow icon.
  ///
  /// 左の矢印アイコンのスタイルを指定します。
  final CalendarHeaderChevronIconStyle? leftChevronIcon;

  /// Specify the style of the right arrow icon.
  ///
  /// 右の矢印アイコンのスタイルを指定します。
  final CalendarHeaderChevronIconStyle? rightChevronIcon;

  /// Header text style.
  ///
  /// ヘッダーのテキストスタイル。
  final TextStyle? textStyle;

  /// Specifies the placement of the header text.
  ///
  /// ヘッダーのテキストの配置を指定します。
  final TextAlign textAlign;

  /// Specifies header decoration.
  ///
  /// ヘッダーのデコレーションを指定します。
  final Decoration? decoration;

  /// Specifies the margin of the header.
  ///
  /// ヘッダーのマージンを指定します。
  final EdgeInsetsGeometry? margin;

  /// Specifies header padding.
  ///
  /// ヘッダーのパディングを指定します。
  final EdgeInsetsGeometry? padding;
}

/// Specify the contents of the calendar.
///
/// カレンダーのコンテンツを指定します。
@immutable
class CalendarContentStyle {
  /// Specify the contents of the calendar.
  ///
  /// カレンダーのコンテンツを指定します。
  const CalendarContentStyle({
    this.margin,
    this.padding = const EdgeInsets.all(8.0),
    this.decoration,
    this.height,
    this.highlightToday = true,
    this.highlightSelected = true,
    this.visibleOutsideDays = true,
    this.weekdayStyle,
    this.weekendStyle,
    this.holidayStyle,
    this.selectedStyle,
    this.todayStyle,
    this.outsideStyle,
    this.outsideWeekendStyle,
    this.alignment = Alignment.bottomCenter,
    this.clipBehavior = Clip.hardEdge,
    this.outsideHolidayStyle,
    this.unavailableStyle,
    this.eventDayStyle,
    this.cellPadding = const EdgeInsets.all(8.0),
    this.selectedColor,
    this.todayColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.animationTime = const Duration(milliseconds: 300),
    this.eventColor,
    this.selectedEventColor,
    this.todayEventColor,
    this.outsideEventColor,
  });

  /// Specifies the animation time of the calendar.
  ///
  /// カレンダーのアニメーション時間を指定します。
  final Duration animationTime;

  /// Specifies cell padding.
  ///
  /// セルのパディングを指定します。
  final EdgeInsetsGeometry cellPadding;

  /// Specifies the margin of the content.
  ///
  /// コンテンツのマージンを指定します。
  final EdgeInsetsGeometry? margin;

  /// Sets padding within the content.
  ///
  /// コンテンツ内のパディングを設定します。
  final EdgeInsetsGeometry padding;

  /// Specifies table decorations.
  ///
  /// テーブルのデコレーションを指定します。
  final Decoration? decoration;

  /// Specifies the height of the content.
  ///
  /// コンテンツの高さを指定します。
  final double? height;

  /// Set to true to display days other than that month in month view.
  ///
  /// 月表示のその月以外の日にちを表示する場合はtrueを設定します。
  final bool visibleOutsideDays;

  /// Specify whether to highlight today's date.
  ///
  /// 今日の日付をハイライトするかどうかを指定します。
  final bool highlightToday;

  /// Specify whether to highlight selected dates.
  ///
  /// 選択された日付をハイライトするかどうかを指定します。
  final bool highlightSelected;

  /// Specifies the color of the selected date.
  ///
  /// 選択された日付の色を指定します。
  final Color? selectedColor;

  /// Specifies the color of today's date.
  ///
  /// 本日の日付の色を指定します。
  final Color? todayColor;

  /// Specifies the color of the event.
  ///
  /// イベントの色を指定します。
  final Color? eventColor;

  /// Specifies the color of the selected event.
  ///
  /// 選択されたイベントの色を指定します。
  final Color? selectedEventColor;

  /// Specifies the color of today's event.
  ///
  /// 本日のイベントの色を指定します。
  final Color? todayEventColor;

  /// Specifies the color of events outside the displayed range.
  ///
  /// 表示された範囲外のイベントの色を指定します。
  final Color? outsideEventColor;

  /// Specifies the text style for weekdays.
  ///
  /// 平日のテキストスタイルを指定します。
  final TextStyle? weekdayStyle;

  /// Specifies the text style for the weekend.
  ///
  /// 週末のテキストスタイルを指定します。
  final TextStyle? weekendStyle;

  /// Specifies the text style of the holiday.
  ///
  /// 休日のテキストスタイルを指定します。
  final TextStyle? holidayStyle;

  /// Specifies the text style for the selected date.
  ///
  /// 選択された日付のテキストスタイルを指定します。
  final TextStyle? selectedStyle;

  /// Specifies today's text style.
  ///
  /// 本日のテキストスタイルを指定します。
  final TextStyle? todayStyle;

  /// Specifies text styles outside the displayed range.
  ///
  /// 表示された範囲外のテキストスタイルを指定します。
  final TextStyle? outsideStyle;

  /// Specifies the text style for weekends outside the displayed range.
  ///
  /// 表示された範囲外の週末のテキストスタイルを指定します。
  final TextStyle? outsideWeekendStyle;

  /// Specifies the text style for holidays outside the displayed range.
  ///
  /// 表示された範囲外の休日のテキストスタイルを指定します。
  final TextStyle? outsideHolidayStyle;

  /// Specifies the text style of the firestarter that is not available.
  ///
  /// 利用できない火付けのテキストスタイルを指定します。
  final TextStyle? unavailableStyle;

  /// Specifies the text style for the event date.
  ///
  /// イベント日のテキストスタイルを指定します。
  final TextStyle? eventDayStyle;

  /// Specifies rounded corners for borders.
  ///
  /// ボーダーの角丸を指定します。
  final BorderRadius borderRadius;

  /// Specifies cell placement.
  ///
  /// セルの配置を指定します。
  final AlignmentGeometry alignment;

  /// Specifies the clip of a cell.
  ///
  /// セルのクリップを指定します。
  final Clip clipBehavior;
}

/// Style of the day-of-week display portion of the calendar.
///
/// カレンダーの曜日表示部分のスタイル。
@immutable
class CalendarDaysOfWeekStyle {
  /// Style of the day-of-week display portion of the calendar.
  ///
  /// カレンダーの曜日表示部分のスタイル。
  const CalendarDaysOfWeekStyle({
    this.decoration,
    this.weekdayBuilder,
    this.weekendBuilder,
    this.visible = true,
    this.height = 24,
    this.weekendTextStyle,
    this.weekdayTextStyle,
  });

  /// Decoration of the day-of-week display portion of the calendar.
  ///
  /// カレンダーの曜日表示部分のデコレーション。
  final Decoration? decoration;

  /// Weekday day of the week display builder.
  ///
  /// 平日曜日の表示ビルダー。
  final Widget Function(BuildContext context, DateTime dateTime)?
      weekdayBuilder;

  /// Weekend day of the week display builder.
  ///
  /// 週末曜日の表示ビルダー。
  final Widget Function(BuildContext context, DateTime dateTime)?
      weekendBuilder;

  /// Set to true to display the week.
  ///
  /// 週を表示する場合はtrueを設定します。
  final bool visible;

  /// Height of the day-of-week display portion of the calendar.
  ///
  /// カレンダーの曜日表示部分の高さ。
  final double height;

  /// Text style for weekend day of the week display.
  ///
  /// 週末曜日の表示のテキストスタイル。
  final TextStyle? weekendTextStyle;

  /// Text style for weekday day of the week display.
  ///
  /// 平日曜日の表示のテキストスタイル。
  final TextStyle? weekdayTextStyle;
}

/// Style of the month (week) switching icons in the calendar header.
///
/// カレンダーヘッダーの月（週）切り替えアイコンのスタイル。
@immutable
class CalendarHeaderChevronIconStyle {
  /// Style of the month (week) switching icons in the calendar header.
  ///
  /// カレンダーヘッダーの月（週）切り替えアイコンのスタイル。
  const CalendarHeaderChevronIconStyle(
    this.icon, {
    this.margin,
    this.padding,
  });

  /// Month (week) switching icon in the calendar header.
  ///
  /// カレンダーヘッダーの月（週）切り替えアイコン。
  final Widget icon;

  /// Margin for month (week) switching icon in calendar header.
  ///
  /// カレンダーヘッダーの月（週）切り替えアイコンのマージン。
  final EdgeInsetsGeometry? margin;

  /// Padding of the month (week) switching icon in the calendar header.
  ///
  /// カレンダーヘッダーの月（週）切り替えアイコンのパディング。
  final EdgeInsetsGeometry? padding;
}
