part of "/masamune_painter.dart";

/// Change layer name modal.
///
/// A modal for changing the name of a layer.
///
/// レイヤー名変更モーダル。
///
/// レイヤーの名前を変更するためのモーダル。
class ChangeLayerNameModal extends Modal {
  /// Change layer name modal.
  ///
  /// A modal for changing the name of a layer.
  ///
  /// レイヤー名変更モーダル。
  ///
  /// レイヤーの名前を変更するためのモーダル。
  const ChangeLayerNameModal({
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.style,
  });

  /// Style.
  ///
  /// スタイル。
  final FormStyle? style;

  /// Initial value.
  ///
  /// 初期値。
  final String? initialValue;

  /// Hint text.
  ///
  /// ヒントテキスト。
  final String? hintText;

  /// On changed.
  ///
  /// 変更時のコールバック。
  final void Function(String name)? onChanged;

  @override
  Widget build(BuildContext context, ModalRef ref) {
    return Row(
      children: [
        Expanded(
          child: FormTextField(
            autofocus: true,
            hintText: hintText,
            initialValue: initialValue,
            style: style ??
                const FormStyle(
                  borderStyle: FormInputBorderStyle.none,
                ),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              onChanged?.call(value);
            },
          ),
        ),
        16.sx,
        IconButton(
          onPressed: () {
            ref.close();
          },
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }
}
