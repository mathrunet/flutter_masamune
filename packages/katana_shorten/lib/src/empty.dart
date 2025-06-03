part of "/katana_shorten.dart";

/// Creates a box that will become as small as its parent allows.
///
/// 親が許す限り小さくなるボックスを作成します。
class Empty extends SizedBox {
  const Empty({super.key, super.child}) : super.shrink();
}
