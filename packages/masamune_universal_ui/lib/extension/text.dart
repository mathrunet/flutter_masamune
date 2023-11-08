part of '/masamune_universal_ui.dart';

const int _kColorDefault = 0xFF000000;

/// Extension methods for [Text].
///
/// [Text]の拡張メソッドです。
extension UniversalUITextExtensions on Text {
  /// Create a new [Text] by copying the contents of [Text].
  ///
  /// [Text]の内容をコピーして新しい[Text]を作成します。
  Text copyWith({
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) {
    return Text(
      data ?? this.data ?? "",
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      selectionColor: selectionColor ?? this.selectionColor,
    );
  }

  /// Change the style of [Text] to [style].
  ///
  /// [Text]のスタイルを[style]に変更します。
  Text withStyle(TextStyle? style) {
    return copyWith(
      style: (this.style ?? const TextStyle()).copyWith(
        background: style?.background,
        backgroundColor: style?.backgroundColor,
        color: style?.color,
        debugLabel: style?.debugLabel,
        decoration: style?.decoration,
        decorationColor: style?.decorationColor,
        decorationStyle: style?.decorationStyle,
        decorationThickness: style?.decorationThickness,
        fontFamily: style?.fontFamily,
        fontFamilyFallback: style?.fontFamilyFallback,
        fontFeatures: style?.fontFeatures,
        fontSize: style?.fontSize,
        fontStyle: style?.fontStyle,
        fontWeight: style?.fontWeight,
        foreground: style?.foreground,
        height: style?.height,
        inherit: style?.inherit,
        letterSpacing: style?.letterSpacing,
        locale: style?.locale,
        shadows: style?.shadows,
        textBaseline: style?.textBaseline,
        wordSpacing: style?.wordSpacing,
      ),
    );
  }

  /// Change [Text.textScaleFactor] to [scaleFactor].
  ///
  /// [Text.textScaleFactor]を[scaleFactor]に変更します。
  Text textScale(double scaleFactor) => copyWith(textScaleFactor: scaleFactor);

  /// Bold [Text].
  ///
  /// [Text]を太字にします。
  Text bold() => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
        ),
      );

  /// Italicize [Text].
  ///
  /// [Text]を斜体にします。
  Text italic() => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontStyle: FontStyle.italic,
        ),
      );

  /// Underline [Text].
  ///
  /// [Text]にアンダーラインを付与します。
  Text underLine() => copyWith(
      style: (style ?? const TextStyle())
          .copyWith(decoration: TextDecoration.underline));

  /// Change the font weight of [Text] to [fontWeight].
  ///
  /// [Text]の文字の太さを[fontWeight]に変更します。
  Text fontWeight(FontWeight fontWeight) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontWeight: fontWeight,
        ),
      );

  /// Change the text size of [Text] to [size].
  ///
  /// [Text]の文字の大きさを[size]に変更します。
  Text fontSize(double size) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontSize: size,
        ),
      );

  /// Change the font of [Text] to [font].
  ///
  /// [Text]のフォントを[font]に変更します。
  Text fontFamily(String font) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontFamily: font,
        ),
      );

  /// Set the width between characters in [Text] to [space].
  ///
  /// [Text]の文字の間の幅を[space]に設定します。
  Text letterSpacing(double space) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          letterSpacing: space,
        ),
      );

  /// Set the width between words in [Text] to [space].
  ///
  /// [Text]の単語の間の幅を[space]に設定します。
  Text wordSpacing(double space) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          wordSpacing: space,
        ),
      );

  /// Adds a shadow set by [color], [blurRadius], and [offset] to [Text].
  ///
  /// [Text]に[color]と[blurRadius]、[offset]で設定した影を付与します。
  Text textShadow({
    Color color = const Color(_kColorDefault),
    double blurRadius = 0.0,
    Offset offset = Offset.zero,
  }) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        shadows: [
          Shadow(
            color: color,
            blurRadius: blurRadius,
            offset: offset,
          ),
        ],
      ),
    );
  }

  /// Change the text color of [Text] to [color].
  ///
  /// [Text]の文字色を[color]に変更します。
  Text color(Color color) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          color: color,
        ),
      );

  /// Set [Text] alignment to [align].
  ///
  /// [Text]の配置を[align]に設定します。
  Text textAlign(TextAlign align) => copyWith(textAlign: align);

  /// Change the direction of [Text] to [direction].
  ///
  /// [Text]の方向を[direction]に変更します。
  Text textDirection(TextDirection direction) =>
      copyWith(textDirection: direction);

  /// Change the [Text] baseline setting to [textBaseline].
  ///
  /// [Text]のベースライン設定を[textBaseline]に変更します。
  Text textBaseline(TextBaseline textBaseline) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          textBaseline: textBaseline,
        ),
      );
}
