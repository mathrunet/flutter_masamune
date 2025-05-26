part of '/masamune_markdown.dart';

/// Configuration class for Markdown tools.
///
/// Set the label and icon for each tool using [MarkdownToolLabelConfig].
///
/// Markdownツールの設定クラス。
///
/// [MarkdownToolLabelConfig]を使用して、各ツールのラベルとアイコンを設定します。
class MarkdownToolsConfig {
  /// Configuration class for Markdown tools.
  ///
  /// Set the label and icon for each tool using [MarkdownToolLabelConfig].
  ///
  /// Markdownツールの設定クラス。
  ///
  /// [MarkdownToolLabelConfig]を使用して、各ツールのラベルとアイコンを設定します。
  const MarkdownToolsConfig({
    this.textLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "テキスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Text",
        ),
      ]),
      icon: Icons.title,
    ),
    this.h1Label = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "見出し1",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Heading 1",
        ),
      ]),
      icon: FontAwesomeIcons.heading,
    ),
    this.h2Label = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "見出し2",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Heading 2",
        ),
      ]),
      icon: FontAwesomeIcons.heading,
    ),
    this.h3Label = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "見出し3",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Heading 3",
        ),
      ]),
      icon: FontAwesomeIcons.heading,
    ),
    this.bulletedListLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "箇条書きリスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Bulleted List",
        ),
      ]),
      icon: FontAwesomeIcons.listUl,
    ),
    this.numberListLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "番号付きリスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Numbered List",
        ),
      ]),
      icon: FontAwesomeIcons.listOl,
    ),
    this.toggleListLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "チェックリスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Toggle List",
        ),
      ]),
      icon: FontAwesomeIcons.listCheck,
    ),
    this.codeLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "コード",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Code",
        ),
      ]),
      icon: FontAwesomeIcons.code,
    ),
    this.quoteLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "引用",
        ),
      ]),
      icon: FontAwesomeIcons.quoteLeft,
    ),
    this.addLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "ブロック追加",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Add Block",
        ),
      ]),
      icon: FontAwesomeIcons.plus,
    ),
    this.fontLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "スタイル変更",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Style Change",
        ),
      ]),
      icon: FontAwesomeIcons.font,
    ),
    this.mentionLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "メンション",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Mention",
        ),
      ]),
      icon: FontAwesomeIcons.at,
    ),
    this.exchangeLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "ブロックスタイル変更",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Block Style Change",
        ),
      ]),
      icon: Icons.repeat,
    ),
    this.mediaLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "メディア",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Media",
        ),
      ]),
      icon: Icons.image,
    ),
    this.undoLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "元に戻す",
        ),
      ]),
      icon: Icons.undo,
    ),
    this.redoLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "やり直し",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Redo",
        ),
      ]),
      icon: Icons.redo,
    ),
    this.indentUpLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "インデント増加",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Indent Increase",
        ),
      ]),
      icon: Icons.format_indent_increase,
    ),
    this.indentDownLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "インデント減少",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Indent Decrease",
        ),
      ]),
      icon: Icons.format_indent_decrease,
    ),
    this.fontBackLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの背景",
        ),
      ]),
      icon: Icons.arrow_back_ios,
    ),
    this.fontBoldLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの太字",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Bold",
        ),
      ]),
      icon: Icons.format_bold,
    ),
    this.fontItalicLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの斜体",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Italic",
        ),
      ]),
      icon: Icons.format_italic,
    ),
    this.fontUnderlineLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの下線",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Underline",
        ),
      ]),
      icon: Icons.format_underline,
    ),
    this.fontStrikeLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの取り消し線",
        ),
      ]),
      icon: Icons.format_strikethrough,
    ),
    this.fontLinkLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントのリンク",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Link",
        ),
      ]),
      icon: Icons.link,
    ),
    this.fontInlineCodeLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントのインラインコード",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Inline Code",
        ),
      ]),
      icon: Icons.code,
    ),
    this.copyLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "コピー",
        ),
      ]),
      icon: Icons.copy,
    ),
    this.pasteLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "貼り付け",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Paste",
        ),
      ]),
      icon: Icons.paste,
    ),
    this.cutLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "切り取り",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Cut",
        ),
      ]),
      icon: Icons.cut,
    ),
    this.closeKeyboardLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "キーボードを閉じる",
        ),
      ]),
      icon: Icons.keyboard_hide,
    ),
    this.imageFromCameraLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "カメラから\n画像を選択",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Image\nfrom Camera",
        ),
      ]),
      icon: Icons.photo_camera,
    ),
    this.imageFromLibraryLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "ライブラリから\n画像を選択",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Image\nfrom Library",
        ),
      ]),
      icon: Icons.photo_library,
    ),
    this.videoFromCameraLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "カメラから\nビデオを選択",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Video\nfrom Camera",
        ),
      ]),
      icon: Icons.video_camera_back,
    ),
    this.videoFromLibraryLabel = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "ライブラリから\nビデオを選択",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Video\nfrom Library",
        ),
      ]),
      icon: Icons.video_library,
    ),
  });

  /// Label configuration for plain text
  ///
  /// テキストのラベル設定
  final MarkdownToolLabelConfig textLabel;

  /// Label configuration for heading 1 (H1)
  ///
  /// 見出し1（H1）のラベル設定
  final MarkdownToolLabelConfig h1Label;

  /// Label configuration for heading 2 (H2)
  ///
  /// 見出し2（H2）のラベル設定
  final MarkdownToolLabelConfig h2Label;

  /// Label configuration for heading 3 (H3)
  ///
  /// 見出し3（H3）のラベル設定
  final MarkdownToolLabelConfig h3Label;

  /// Label configuration for bullet list
  ///
  /// 箇条書きリストのラベル設定
  final MarkdownToolLabelConfig bulletedListLabel;

  /// Label configuration for numbered list
  ///
  /// 番号付きリストのラベル設定
  final MarkdownToolLabelConfig numberListLabel;

  /// Label configuration for toggle list (checklist)
  ///
  /// チェックリストのラベル設定
  final MarkdownToolLabelConfig toggleListLabel;

  /// Label configuration for code block
  ///
  /// コードブロックのラベル設定
  final MarkdownToolLabelConfig codeLabel;

  /// Label configuration for blockquote
  ///
  /// 引用のラベル設定
  final MarkdownToolLabelConfig quoteLabel;

  /// Label configuration for add block tool
  ///
  /// 追加のブロックのラベル設定
  final MarkdownToolLabelConfig addLabel;

  /// Label configuration for font change tool
  ///
  /// フォント変更のラベル設定
  final MarkdownToolLabelConfig fontLabel;

  /// Label configuration for mention tool
  ///
  /// メンションのラベル設定
  final MarkdownToolLabelConfig mentionLabel;

  /// Label configuration for exchange tool
  ///
  /// スタイル変更のラベル設定
  final MarkdownToolLabelConfig exchangeLabel;

  /// Label configuration for media tool
  ///
  /// メディアのラベル設定
  final MarkdownToolLabelConfig mediaLabel;

  /// Label configuration for undo tool
  ///
  /// 元に戻すのラベル設定
  final MarkdownToolLabelConfig undoLabel;

  /// Label configuration for redo tool
  ///
  /// やり直しのラベル設定
  final MarkdownToolLabelConfig redoLabel;

  /// Label configuration for indent up tool
  ///
  /// インデントを増やすのラベル設定
  final MarkdownToolLabelConfig indentUpLabel;

  /// Label configuration for indent down tool
  ///
  /// インデントを減らすのラベル設定
  final MarkdownToolLabelConfig indentDownLabel;

  /// Label configuration for font back tool
  ///
  /// フォントの背景のラベル設定
  final MarkdownToolLabelConfig fontBackLabel;

  /// Label configuration for font bold tool
  ///
  /// フォントの太字のラベル設定
  final MarkdownToolLabelConfig fontBoldLabel;

  /// Label configuration for font italic tool
  ///
  /// フォントの斜体のラベル設定
  final MarkdownToolLabelConfig fontItalicLabel;

  /// Label configuration for font underline tool
  ///
  /// フォントの下線のラベル設定
  final MarkdownToolLabelConfig fontUnderlineLabel;

  /// Label configuration for font strike tool
  ///
  /// フォントの取り消し線のラベル設定
  final MarkdownToolLabelConfig fontStrikeLabel;

  /// Label configuration for font link tool
  ///
  /// フォントのリンクのラベル設定
  final MarkdownToolLabelConfig fontLinkLabel;

  /// Label configuration for font inline code tool
  ///
  /// フォントのインラインコードのラベル設定
  final MarkdownToolLabelConfig fontInlineCodeLabel;

  /// Label configuration for copy tool
  ///
  /// コピーのラベル設定
  final MarkdownToolLabelConfig copyLabel;

  /// Label configuration for paste tool
  ///
  /// 貼り付けのラベル設定
  final MarkdownToolLabelConfig pasteLabel;

  /// Label configuration for cut tool
  ///
  /// 切り取りのラベル設定
  final MarkdownToolLabelConfig cutLabel;

  /// Label configuration for keyboard close tool
  ///
  /// キーボードを閉じるのラベル設定
  final MarkdownToolLabelConfig closeKeyboardLabel;

  /// Label configuration for image from camera tool
  ///
  /// カメラから画像を選択するのラベル設定
  final MarkdownToolLabelConfig imageFromCameraLabel;

  /// Label configuration for image from library tool
  ///
  /// ライブラリから画像を選択するのラベル設定
  final MarkdownToolLabelConfig imageFromLibraryLabel;

  /// Label configuration for video from camera tool
  ///
  /// カメラからビデオを選択するのラベル設定
  final MarkdownToolLabelConfig videoFromCameraLabel;

  /// Label configuration for video from library tool
  ///
  /// ライブラリからビデオを選択するのラベル設定
  final MarkdownToolLabelConfig videoFromLibraryLabel;
}

/// Configuration class for Markdown tool label.
///
/// Set the label and icon for each tool using [MarkdownToolLabelConfig].
///
/// Markdownツールのラベル設定クラス。
///
/// [MarkdownToolLabelConfig]を使用して、各ツールのラベルとアイコンを設定します。
class MarkdownToolLabelConfig {
  /// Configuration class for Markdown tool label.
  ///
  /// Set the label and icon for each tool using [MarkdownToolLabelConfig].
  ///
  /// Markdownツールのラベル設定クラス。
  ///
  /// [MarkdownToolLabelConfig]を使用して、各ツールのラベルとアイコンを設定します。
  const MarkdownToolLabelConfig({
    required this.title,
    required this.icon,
  });

  /// Label for the tool.
  ///
  /// ツールのラベル。
  final LocalizedValue<String> title;

  /// Icon for the tool.
  ///
  /// ツールのアイコン。
  final IconData icon;
}
