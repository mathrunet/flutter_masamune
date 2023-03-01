part of katana_responsive;

/// [Container] Responsive container that can be used as a replacement for [Container].
///
/// You can build a responsive grid layout by returning a list of [ResponsiveRow] in [children].
///
/// Arguments of [Container] can be passed as is.
/// The [alignment] is [Alignment.center] by default, which means that there will always be left and right margins when the maximum width is specified by [type].
///
/// [Container]代わりとして利用可能なレスポンシブ対応のコンテナです。
///
/// [children]で[ResponsiveRow]のリストを返すことで、レスポンシブ対応のグリッドレイアウトを構築できます。
///
/// [Container]の引数をそのまま渡すことができます。
/// [alignment]はデフォルトで[Alignment.center]になっており、[type]によって最大の横幅が指定されているときは常に左右に余白が出るようになっています。
///
/// ```dart
/// class GridPage extends StatelessWidget {
///   const GridPage({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: const Text("Grid"),
///       ),
///       body: ResponsiveBuilder(
///         builder: (context) => [
///           ResponsiveRow(
///             children: [
///               ResponsiveCol(
///                 lg: 12,
///                 child: Container(
///                   color: Colors.red,
///                   height: 100,
///                 ),
///               ),
///             ],
///           ),
///           ResponsiveRow(
///             children: [
///               ResponsiveCol(
///                 sm: 6,
///                 child: Container(
///                   color: Colors.green,
///                   height: 100,
///                 ),
///               ),
///               ResponsiveCol(
///                 sm: 6,
///                 child: Container(
///                   color: Colors.blue,
///                   height: 100,
///                 ),
///               ),
///             ],
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
class ResponsiveListView extends StatelessWidget {
  /// [Container] Responsive container that can be used as a replacement for [Container].
  ///
  /// You can build a responsive grid layout by returning a list of [ResponsiveRow] in [children].
  ///
  /// Arguments of [Container] can be passed as is.
  /// The [alignment] is [Alignment.center] by default, which means that there will always be left and right margins when the maximum width is specified by [type].
  ///
  /// [Container]代わりとして利用可能なレスポンシブ対応のコンテナです。
  ///
  /// [children]で[ResponsiveRow]のリストを返すことで、レスポンシブ対応のグリッドレイアウトを構築できます。
  ///
  /// [Container]の引数をそのまま渡すことができます。
  /// [alignment]はデフォルトで[Alignment.center]になっており、[type]によって最大の横幅が指定されているときは常に左右に余白が出るようになっています。
  ///
  /// ```dart
  /// class GridPage extends StatelessWidget {
  ///   const GridPage({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(
  ///         title: const Text("Grid"),
  ///       ),
  ///       body: ResponsiveBuilder(
  ///         builder: (context) => [
  ///           ResponsiveRow(
  ///             children: [
  ///               ResponsiveCol(
  ///                 lg: 12,
  ///                 child: Container(
  ///                   color: Colors.red,
  ///                   height: 100,
  ///                 ),
  ///               ),
  ///             ],
  ///           ),
  ///           ResponsiveRow(
  ///             children: [
  ///               ResponsiveCol(
  ///                 sm: 6,
  ///                 child: Container(
  ///                   color: Colors.green,
  ///                   height: 100,
  ///                 ),
  ///               ),
  ///               ResponsiveCol(
  ///                 sm: 6,
  ///                 child: Container(
  ///                   color: Colors.blue,
  ///                   height: 100,
  ///                 ),
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const ResponsiveListView({
    super.key,
    this.type,
    this.alignment = Alignment.center,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    required this.children,
    this.clipBehavior = Clip.hardEdge,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.primary,
    this.physics,
    this.controller,
    this.restorationId,
  });

  /// Describes the type of a ResponsiveContainer
  ///
  /// レスポンシブコンテナの型を記述します
  final ResponsiveContainerType? type;

  /// This value holds the alignment to be used by the container.
  ///
  /// この値はコンテナに使用される配置を保持します。
  final AlignmentGeometry alignment;

  /// Defines where to place the widget with respect to its parent.
  ///
  /// 親要素に対してウィジェットを配置する位置を定義します。
  final EdgeInsetsGeometry? padding;

  /// Sets the background color of the container.
  ///
  /// If [decoration] is specified, set the background color within [decoration].
  ///
  /// コンテナの背景色を設定します。
  ///
  /// [decoration]が指定されている場合は、[decoration]内で背景色を設定してください。
  final Color? color;

  /// Sets the container background decoration.
  ///
  /// コンテナの背景の装飾を設定します。
  final Decoration? decoration;

  /// Sets the decorations to be drawn before the container's [children].
  ///
  /// コンテナの[children]より前に描画される装飾を設定します。
  final Decoration? foregroundDecoration;

  /// Sets the width of the container.
  ///
  /// Takes precedence over [type] and [constraints].
  ///
  /// コンテナの横幅を設定します。
  ///
  /// [type]や[constraints]より優先されます。
  final double? width;

  /// Sets the height of the container.
  ///
  /// Takes precedence over [type] and [constraints].
  ///
  /// コンテナの縦幅を設定します。
  ///
  /// [type]や[constraints]より優先されます。
  final double? height;

  /// Sets size constraints for containers.
  ///
  /// If [type] is set, it takes precedence.
  ///
  /// コンテナのサイズ制約を設定します。
  ///
  /// [type]が設定されている場合はそれが優先されます。
  final BoxConstraints? constraints;

  /// Sets the margin of the container.
  ///
  /// コンテナのマージンを設定します。
  final EdgeInsetsGeometry? margin;

  /// The transformation matrix to apply before painting the container.
  ///
  /// コンテナの描画前に適用する変換行列。
  final Matrix4? transform;

  /// The alignment of the origin, relative to the size of the container, if [transform] is specified.
  ///
  /// When [transform] is null, the value of this property is ignored.
  ///
  /// [transform]が指定されている場合、コンテナのサイズに対する原点の配置を設定します。
  ///
  /// [transform]がnullの場合、このプロパティの値は無視されます。
  ///
  /// See also:
  ///
  ///  * [Transform.alignment], which is set by this property.
  final AlignmentGeometry? transformAlignment;

  /// Builder for specifying the inside of a container.
  ///
  /// A list of [ResponsiveRow] should be returned.
  ///
  /// コンテナの内部を指定するためのビルダー。
  ///
  /// [ResponsiveRow]のリストを返す必要があります。
  final List<ResponsiveRow> children;

  /// The clip behavior when [Container.decoration] is not null.
  ///
  /// Defaults to [Clip.none]. Must be [Clip.none] if [decoration] is null.
  ///
  /// If a clip is to be applied, the [Decoration.getClipPath] method
  /// for the provided decoration must return a clip path. (This is not
  /// supported by all decorations; the default implementation of that
  /// method throws an [UnsupportedError].)
  ///
  /// [Container.decoration]がnullでない場合のクリップの振る舞い。
  ///
  /// デフォルトは[Clip.none]です。[decoration]がnullの場合は[Clip.none]である必要があります。
  ///
  /// クリップを適用する場合、提供された装飾の[Decoration.getClipPath]メソッドはクリップパスを返す必要があります。
  /// (これはすべての装飾に対応していません。そのメソッドのデフォルト実装は[UnsupportedError]をスローします。)
  final Clip clipBehavior;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  ///
  /// スクロールビューがスクロールする軸。
  ///
  /// デフォルトは[Axis.vertical]です。
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// Defaults to `false`.
  ///
  /// スクロールビューが読み取り方向でスクロールするかどうか。
  ///
  /// デフォルトは`false`です。
  final bool reverse;

  /// {@macro flutter.widgets.scroll_view.primary}
  final bool? primary;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// The controller for the scroll position.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control the initial scroll position (see [ScrollController.initialScrollOffset]), to read the current scroll position (see [ScrollController.offset]), or to change the current scroll position (see [ScrollController.animateTo]).
  ///
  /// If a [ScrollController] is not specified, then there will be no way to control the scroll position from the outside, which means, for example, that actions that affect the scroll position, such as a tap on a [FloatingActionButton], will not work.
  ///
  /// If a [ScrollController] is specified, then at least one of the [primary], [center], or [anchor] arguments must not be null.
  ///
  /// If a [ScrollController] is specified, then the [physics] property must not be null.
  ///
  /// [ScrollController]はスクロール位置のコントローラーです。
  ///
  /// [ScrollController]は複数の目的で使用されます。初期スクロール位置を制御するために使用できます(詳細は[ScrollController.initialScrollOffset]を参照してください)。現在のスクロール位置を読み取るために使用できます(詳細は[ScrollController.offset]を参照してください)。現在のスクロール位置を変更するために使用できます(詳細は[ScrollController.animateTo]を参照してください)。
  ///
  /// [ScrollController]が指定されていない場合、外部からスクロール位置を制御する方法がなくなります。つまり、[FloatingActionButton]をタップするなどのスクロール位置に影響を与えるアクションが機能しなくなります。
  ///
  /// [ScrollController]が指定されている場合、[primary]、[center]、または[anchor]の引数の少なくとも1つはnullであってはなりません。
  ///
  /// [ScrollController]が指定されている場合、[physics]プロパティはnullであってはなりません。
  final ScrollController? controller;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// The keyboard dismiss behavior for a scrollable widget.
  ///
  /// Defaults to [ScrollViewKeyboardDismissBehavior.manual].
  ///
  /// スクロール可能なウィジェットのキーボードを閉じる振る舞い。
  ///
  /// デフォルトは[ScrollViewKeyboardDismissBehavior.manual]です。
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      primary: primary,
      physics: physics,
      controller: controller,
      dragStartBehavior: dragStartBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      clipBehavior: clipBehavior,
      child: Align(
        alignment: alignment,
        child: Container(
          constraints: constraints?.copyWith(maxWidth: type?.width(context)) ??
              BoxConstraints(
                maxWidth: type?.width(context) ?? double.infinity,
              ),
          padding: padding,
          color: color,
          decoration: decoration,
          foregroundDecoration: foregroundDecoration,
          width: width,
          height: height,
          margin: margin,
          transform: transform,
          transformAlignment: transformAlignment,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              );
            },
          ),
        ),
      ),
    );
  }
}
