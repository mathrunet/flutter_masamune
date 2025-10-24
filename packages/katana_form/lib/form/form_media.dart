part of "/katana_form.dart";

const _kErrorTextHeight = 20.0;
const _kDefaultHeight = 196.0;

/// Form for submitting images and videos. Single media can be submitted.
///
/// A form field that allows you to select only one image or video.
/// Common design can be applied with `FormStyle`, and media selection and management can be performed using `FormController`.
///
/// 画像や動画を1つだけ選択できるフォームフィールド。
/// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用してメディアの選択と管理を行うことができます。
///
/// All media is managed by [FormMediaValue].
///
/// メディアはすべて[FormMediaValue]で管理されます。
///
/// ## Basic Usage Example 基本的な使用例
///
/// ```dart
/// FormMedia(
///   form: formController,
///   initialValue: formController.value.media.toFormMediaValue(),
///   onSaved: (value) => formController.value.copyWith(media: value.toModelImageUri()),
///   onTap: (ref) async {
///     // 画像選択
///     final picked = await picker.pickSingle();
///     final uri = picked.uri;
///     if (uri == null || uri.isEmpty) {
///       return;
///     }
///     // 選択した画像を表示
///     ref.update(uri, FormMediaType.image);
///   },
///   builder: (context, value) {
///     return Container(
///       width: 200,
///       height: 200,
///       decoration: BoxDecoration(
///         color: Colors.grey[200],
///         image: DecorationImage(
///           image: value?.toImageProvider(),
///           fit: BoxFit.cover,
///         ),
///       ),
///     );
///   },
/// );
/// ```
class FormMedia<TValue> extends FormField<FormMediaValue> {
  /// Form for submitting images and videos. Single media can be submitted.
  ///
  /// A form field that allows you to select only one image or video.
  /// Common design can be applied with `FormStyle`, and media selection and management can be performed using `FormController`.
  ///
  /// 画像や動画を1つだけ選択できるフォームフィールド。
  /// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用してメディアの選択と管理を行うことができます。
  ///
  /// All media is managed by [FormMediaValue].
  ///
  /// メディアはすべて[FormMediaValue]で管理されます。
  ///
  /// ## Basic Usage Example 基本的な使用例
  ///
  /// ```dart
  /// FormMedia(
  ///   form: formController,
  ///   initialValue: formController.value.media.toFormMediaValue(),
  ///   onSaved: (value) => formController.value.copyWith(media: value.toModelImageUri()),
  ///   onTap: (ref) async {
  ///     // 画像選択
  ///     final picked = await picker.pickSingle();
  ///     final uri = picked.uri;
  ///     if (uri == null || uri.isEmpty) {
  ///       return;
  ///     }
  ///     // 選択した画像を表示
  ///     ref.update(uri, FormMediaType.image);
  ///   },
  ///   builder: (context, value) {
  ///     return Container(
  ///       width: 200,
  ///       height: 200,
  ///       decoration: BoxDecoration(
  ///         color: Colors.grey[200],
  ///         image: DecorationImage(
  ///           image: value?.toImageProvider(),
  ///           fit: BoxFit.cover,
  ///         ),
  ///       ),
  ///     );
  ///   },
  /// );
  /// ```
  FormMedia({
    required this.onTap,
    required Widget Function(
      BuildContext context,
      FormMediaValue value,
    ) builder,
    super.key,
    this.style,
    this.onChanged,
    this.readOnly = false,
    this.form,
    this.showOverlayIcon = true,
    this.overlayColor = Colors.black38,
    this.overlayIconColor = Colors.white70,
    this.icon = Icons.add_a_photo,
    this.iconSize = 56.0,
    this.emptyErrorText,
    TValue Function(FormMediaValue value)? onSaved,
    String Function(FormMediaValue? value)? validator,
    super.initialValue,
    super.enabled,
    this.keepAlive = true,
  })  : _builder = builder,
        assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        ),
        super(
          builder: (state) {
            return const SizedBox.shrink();
          },
          onSaved: (value) {
            if (value == null) {
              return;
            }
            final res = onSaved?.call(value);
            if (res == null) {
              return;
            }
            form!.value = res;
          },
          validator: (value) {
            if (emptyErrorText.isNotEmpty && value == null) {
              return emptyErrorText;
            }
            return validator?.call(value);
          },
        );

  /// Context for forms.
  ///
  /// The widget is created outside of the widget in advance and handed over to the client.
  ///
  /// フォーム用のコンテキスト。
  ///
  /// 予めウィジェット外で作成し渡します。
  final FormController<TValue>? form;

  /// Form Style.
  ///
  /// フォームのスタイル。
  final FormStyle? style;

  /// Implement the part that actually displays the image based on [FormMediaValue].
  ///
  /// The [context] is passed the [BuildContext] and the [value] is passed the [FormMediaValue] of the media to be displayed.
  ///
  /// [FormMediaValue]を元に実際に画像を表示する部分を実装してください。
  ///
  /// [context]に[BuildContext]、[value]に表示するメディアの[FormMediaValue]が渡されます。
  final Widget Function(
    BuildContext context,
    FormMediaValue value,
  ) _builder;

  /// Describe what to do when the form is tapped.
  ///
  /// Normally, use `image_picker` or `file_picker` to display a dialog to select a file and return the media path to [FormMediaRef.update].
  ///
  /// フォームがタップされた場合の処理を記述します。
  ///
  /// 通常は`image_picker`や`file_picker`を用いてファイルを選択するダイアログを表示しメディアのパスを[FormMediaRef.update]に返すようにします。
  final void Function(FormMediaRef ref)? onTap;

  /// Additional icons or overlay icons.
  ///
  /// 追加アイコン、もしくはオーバーレイのアイコン。
  final IconData icon;

  /// Size of [icon].
  ///
  /// [icon]のサイズ。
  final double iconSize;

  /// `true` if you want to show the icon in overlay when media is selected.
  ///
  /// メディアが選択されている場合にオーバーレイでアイコンを表示する場合`true`。
  final bool showOverlayIcon;

  /// The foreground color of the overlay when the icon is displayed in an overlay when media is selected.
  ///
  /// メディアが選択されている場合にオーバーレイでアイコンを表示する場合のオーバーレイの前景色。
  final Color overlayColor;

  /// The color of the icon when the icon is displayed in an overlay when media is selected.
  ///
  /// メディアが選択されている場合にオーバーレイでアイコンを表示する場合のアイコンの色。
  final Color overlayIconColor;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(FormMediaValue? value)? onChanged;

  /// Error text. Only displayed if no characters are entered.
  ///
  /// エラーテキスト。入力された文字がない場合のみ表示されます。
  final String? emptyErrorText;

  /// If this is `true`, the form cannot be filled out and changed from its initial value.
  ///
  /// これが`true`の場合、フォームの入力が行えずに初期値から変更することができなくなります。
  final bool readOnly;

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  @override
  // ignore: library_private_types_in_public_api
  _FormMediaState<TValue> createState() => _FormMediaState<TValue>();
}

class _FormMediaState<TValue> extends FormFieldState<FormMediaValue>
    with AutomaticKeepAliveClientMixin<FormField<FormMediaValue>>
    implements FormMediaRef<TValue> {
  @override
  FormMedia<TValue> get widget => super.widget as FormMedia<TValue>;

  @override
  void update(Uri fileUri, FormMediaType type) {
    final val = FormMediaValue(type: type, uri: fileUri);
    if (value == val) {
      return;
    }
    didChange(val);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormMedia<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.form != oldWidget.form) {
      oldWidget.form?.unregister(this);
      widget.form?.register(this);
    }
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null) {
      reset();
    }
  }

  @override
  void dispose() {
    widget.form?.unregister(this);
    super.dispose();
  }

  @override
  void didChange(FormMediaValue? value) {
    widget.onChanged?.call(value);
    super.didChange(value);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FormStyleScope(
      style: widget.style,
      enabled: widget.enabled,
      child: Padding(
        padding:
            widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          children: [
            InkWell(
              mouseCursor: !widget.enabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              onTap: widget.readOnly || !widget.enabled
                  ? null
                  : () {
                      if (!widget.enabled) {
                        return;
                      }
                      widget.onTap?.call(this);
                    },
              child: _buildMedia(context),
            ),
            if (errorText.isNotEmpty)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: errorText.isNotEmpty ? _kErrorTextHeight : 0,
                child: Text(
                  errorText ?? "",
                  style: Theme.of(context).inputDecorationTheme.errorStyle,
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildCover(BuildContext context, Widget child) {
    if (!widget.showOverlayIcon) {
      return child;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        ColoredBox(
          color: widget.overlayColor,
          child: Center(
            child: Icon(
              widget.icon,
              color: widget.overlayIconColor,
              size: widget.iconSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedia(BuildContext context) {
    final height = widget.style?.height ?? _kDefaultHeight;
    final width = widget.style?.width;
    if (value != null && value!.uri.isNotEmpty) {
      return Container(
        padding: widget.style?.contentPadding,
        constraints: BoxConstraints.expand(
          width: width ?? double.infinity,
          height: errorText.isNotEmpty ? (height - _kErrorTextHeight) : height,
        ),
        child: ClipRRect(
          borderRadius: widget.style?.borderRadius ?? BorderRadius.circular(0),
          child: _buildCover(
            context,
            widget._builder(context, value!),
          ),
        ),
      );
    } else {
      return Container(
        padding: widget.style?.contentPadding,
        child: Container(
          constraints: BoxConstraints.expand(
            width: width ?? double.infinity,
            height:
                errorText.isNotEmpty ? (height - _kErrorTextHeight) : height,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.style?.borderColor ??
                  widget.style?.color ??
                  Theme.of(context).dividerColor,
              width: widget.style?.borderWidth ?? 0,
            ),
            borderRadius: widget.style?.borderRadius,
          ),
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.style?.color ?? Theme.of(context).disabledColor,
          ),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

/// Class for controlling [FormMedia].
///
/// [FormMedia]のコントロールを行うためのクラス。
abstract class FormMediaRef<TValue> {
  /// Upload the file by specifying the [fileUri] of the file.
  ///
  /// Specify whether it is an image or a video in [type].
  ///
  /// ファイルの[fileUri]を指定してアップロードを行います。
  ///
  /// [type]で画像か動画かを指定します。
  void update(Uri fileUri, FormMediaType type);
}
