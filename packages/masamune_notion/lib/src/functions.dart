part of masamune_notion;

TextStyle? annotationToTextStyle(
  BuildContext context,
  DynamicMap annotations, {
  double? fontSize,
  bool bold = false,
}) {
  if (annotations.isEmpty) {
    return null;
  }
  final color = annotations.get("color", "");
  if (annotations.get("code", false)) {
    return TextStyle(
      color:
          notionColor(context, color, defaultColor: context.theme.primaryColor),
      backgroundColor: notionBackgroundColor(
        context,
        color,
        defaultColor: context.theme.surfaceColor,
      ),
      fontSize: fontSize,
      fontWeight: bold || annotations.get("bold", false)
          ? FontWeight.bold
          : FontWeight.normal,
      fontStyle: annotations.get("italic", false)
          ? FontStyle.italic
          : FontStyle.normal,
      decoration: annotations.get("underline", false)
          ? TextDecoration.underline
          : (annotations.get("strikethrough", false)
              ? TextDecoration.lineThrough
              : TextDecoration.none),
    );
  } else {
    return TextStyle(
      color: notionColor(context, color),
      backgroundColor: notionBackgroundColor(context, color),
      fontSize: fontSize,
      fontWeight: bold || annotations.get("bold", false)
          ? FontWeight.bold
          : FontWeight.normal,
      fontStyle: annotations.get("italic", false)
          ? FontStyle.italic
          : FontStyle.normal,
      decoration: annotations.get("underline", false)
          ? TextDecoration.underline
          : (annotations.get("strikethrough", false)
              ? TextDecoration.lineThrough
              : TextDecoration.none),
    );
  }
}

Color notionColor(
  BuildContext context,
  String colorCode, {
  Color? defaultColor,
}) {
  switch (colorCode) {
    case "gray":
      return Colors.grey;
    case "brown":
      return Colors.brown;
    case "orange":
      return Colors.orange;
    case "yellow":
      return Colors.yellow;
    case "green":
      return Colors.green;
    case "blue":
      return Colors.blue;
    case "purple":
      return Colors.purple;
    case "pink":
      return Colors.pink;
    case "red":
      return Colors.red;
    case "gray_background":
    case "brown_background":
    case "orange_background":
    case "yellow_background":
    case "green_background":
    case "blue_background":
    case "purple_background":
    case "pink_background":
    case "red_background":
      return Colors.white;
    default:
      return defaultColor ?? context.theme.textColor;
  }
}

Color? notionBackgroundColor(
  BuildContext context,
  String colorCode, {
  Color? defaultColor,
}) {
  switch (colorCode) {
    case "gray":
    case "brown":
    case "orange":
    case "yellow":
    case "green":
    case "blue":
    case "purple":
    case "pink":
    case "red":
      return defaultColor;
    case "gray_background":
      return Colors.grey;
    case "brown_background":
      return Colors.brown;
    case "orange_background":
      return Colors.orange;
    case "yellow_background":
      return Colors.yellow;
    case "green_background":
      return Colors.green;
    case "blue_background":
      return Colors.blue;
    case "purple_background":
      return Colors.purple;
    case "pink_background":
      return Colors.pink;
    case "red_background":
      return Colors.red;
    default:
      return defaultColor;
  }
}
