part of katana_ui;

const kCardHeight = 196.0;

/// A widget for displaying an image or text over a card widget.
///
/// Use in conjunction with [ListTile].
///
/// カードウィジェットの上に画像やテキストを重ねて表示するためのウィジェット。
///
/// [ListTile]と併用して使ってください。
class CardTile extends StatelessWidget {
  /// A widget for displaying an image or text over a card widget.
  ///
  /// Use in conjunction with [ListTile].
  ///
  /// カードウィジェットの上に画像やテキストを重ねて表示するためのウィジェット。
  ///
  /// [ListTile]と併用して使ってください。
  const CardTile({
    super.key,
    this.onTap,
    this.width,
    this.height = kCardHeight,
    this.image,
    this.backgroundColor,
    this.shadowColor,
    this.elevation,
    this.shape,
    this.margin,
    this.fit = BoxFit.cover,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.textColor,
    this.contentPadding,
    this.featureColor,
  });

  /// A callback that is called when the card is tapped.
  ///
  /// カードがタップされたときに呼び出されるコールバック。
  final VoidCallback? onTap;

  /// The width of the card.
  ///
  /// カードの横幅。
  final double? width;

  /// The height of the card.
  ///
  /// カードの縦幅。
  final double height;

  /// The image to display.
  ///
  /// 表示する画像。
  final ImageProvider? image;

  /// The background color of the card.
  ///
  /// カードの背景色。
  final Color? backgroundColor;

  /// The shadow color of the card.
  ///
  /// カードの影の色。
  final Color? shadowColor;

  /// The z-coordinate at which to place this card.
  ///
  /// このカードを配置するz座標。
  final double? elevation;

  /// The shape of the card.
  ///
  /// カードの形状。
  final ShapeBorder? shape;

  /// Whether to paint the [shape] border in front of the [ListTile].
  ///
  /// The default value is true. If false, the border will be painted behind the [ListTile].
  ///
  /// [shape]の境界線を[ListTile]の前に描画するかどうか。
  ///
  /// デフォルト値はtrueです。falseの場合、境界線は[ListTile]の後ろに描画されます。
  final bool borderOnForeground = true;

  /// The margin around the card.
  ///
  /// カードの周囲のマージン。
  final EdgeInsetsGeometry? margin;

  /// How to inscribe the image into the space allocated during layout.
  ///
  /// レイアウト中に割り当てられたスペースに画像を配置する方法。
  final BoxFit fit;

  /// The widget to display before the title.
  ///
  /// タイトルの前に表示するウィジェット。
  final Widget? leading;

  /// The primary content of the list item.
  ///
  /// リストアイテムの主要なコンテンツ。
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// タイトルの下に表示される追加のコンテンツ。
  final Widget? subtitle;

  /// The widget to display after the title.
  ///
  /// タイトルの後に表示するウィジェット。
  final Widget? trailing;

  /// Whether the title and subtitle should be displayed on one line or two lines.
  ///
  /// タイトルとサブタイトルを1行または2行で表示するかどうか。
  final bool isThreeLine = false;

  /// The color to use for icons and text in the list tile.
  ///
  /// リストタイルのアイコンとテキストに使用する色。
  final Color? iconColor;

  /// The color to use for the text in the list tile.
  ///
  /// リストタイルのテキストに使用する色。
  final Color? textColor;

  /// The padding around the [ListTile] content.
  ///
  /// [ListTile]コンテンツの周囲のパディング。
  final EdgeInsetsGeometry? contentPadding;

  /// Background color of the Feature image.
  ///
  /// Feature画像の背景色。
  final Color? featureColor;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        this.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final textColor = this.textColor ?? Theme.of(context).colorScheme.onSurface;
    final iconColor = this.iconColor ?? Theme.of(context).colorScheme.onSurface;

    return Container(
      width: width,
      height: height,
      padding: margin,
      child: Card(
        color: featureColor ?? backgroundColor,
        shadowColor: shadowColor,
        elevation: elevation,
        surfaceTintColor: featureColor ?? backgroundColor,
        shape: shape,
        margin: EdgeInsets.zero,
        borderOnForeground: borderOnForeground,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (image != null)
                Expanded(
                  child: Ink.image(
                    image: image!,
                    fit: fit,
                  ),
                ),
              ListTile(
                title: title,
                mouseCursor: SystemMouseCursors.click,
                subtitle: subtitle,
                leading: leading,
                trailing: trailing,
                isThreeLine: isThreeLine,
                contentPadding: contentPadding,
                iconColor: iconColor,
                textColor: textColor,
                tileColor: backgroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
