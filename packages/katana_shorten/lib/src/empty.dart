part of katana_shorten;

/// Creates a box that will become as small as its parent allows.
///
/// 親が許す限り小さくなるボックスを作成します。
class Empty extends SizedBox {
  const Empty({Key? key, Widget? child}) : super.shrink(key: key, child: child);
}
