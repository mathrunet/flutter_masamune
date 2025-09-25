part of "/masamune_painter.dart";

/// A widget for a drawing field in forms.
///
/// You can draw freely and save the layer data.
///
/// You must pass a [PainterController] to [controller].
///
/// Only the raw layer data is saved in this field. To output as image data, use [PainterController.renderImage].
///
/// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
///
/// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
///
/// Enter the initial value given by [FormController.value] in [initialValue].
///
/// Each time the content is changed, [onChanged] is executed.
///
/// If [enabled] is `false`, the drawing area is deactivated.
///
/// If [readOnly] is set to `true`, the activation is displayed, but the drawing area cannot be changed.
///
/// フォーム用の描画フィールド用のウィジェット。
///
/// 自由に描画を行いそのレイヤーデータを保存することができます。
///
/// [controller]に必ず[PainterController]を渡してください。
///
/// このフィールドで保存されるのはあくまでレイヤーのRawデータです。画像データとして出力する場合は[PainterController.renderImage]を使用してください。
///
/// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
///
/// [form]に[FormController]を渡した場合、一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
///
/// [initialValue]に[FormController.value]から与えられた初期値を入力します。
///
/// 内容が変更される度[onChanged]が実行されます。
///
/// [FormController.validate]が実行された場合、バリデーションとデータの保存を行ないます。
///
/// [enabled]が`false`になると描画エリアが非有効化されます。
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、描画エリアが変更できなくなります。
class FormPainterField<TValue> extends FormField<List<PaintingValue>> {
  /// A widget for a drawing field in forms.
  ///
  /// You can draw freely and save the layer data.
  ///
  /// You must pass a [PainterController] to [controller].
  ///
  /// Only the raw layer data is saved in this field. To output as image data, use [PainterController.renderImage].
  ///
  /// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
  ///
  /// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
  ///
  /// Enter the initial value given by [FormController.value] in [initialValue].
  ///
  /// Each time the content is changed, [onChanged] is executed.
  ///
  /// If [enabled] is `false`, the drawing area is deactivated.
  ///
  /// If [readOnly] is set to `true`, the activation is displayed, but the drawing area cannot be changed.
  ///
  /// フォーム用の描画フィールド用のウィジェット。
  ///
  /// 自由に描画を行いそのレイヤーデータを保存することができます。
  ///
  /// [controller]に必ず[PainterController]を渡してください。
  ///
  /// このフィールドで保存されるのはあくまでレイヤーのRawデータです。画像データとして出力する場合は[PainterController.renderImage]を使用してください。
  ///
  /// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
  ///
  /// [form]に[FormController]を渡した場合、一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
  ///
  /// [initialValue]に[FormController.value]から与えられた初期値を入力します。
  ///
  /// 内容が変更される度[onChanged]が実行されます。
  ///
  /// [FormController.validate]が実行された場合、バリデーションとデータの保存を行ないます。
  ///
  /// [enabled]が`false`になると描画エリアが非有効化されます。
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、描画エリアが変更できなくなります。
  FormPainterField({
    required this.controller,
    super.key,
    this.keepAlive = true,
    bool expands = false,
    bool scrollable = true,
    this.form,
    this.style,
    super.enabled = true,
    List<PaintingValue>? initialValue,
    this.readOnly = false,
    this.onChanged,
    TValue Function(List<PaintingValue> value)? onSaved,
  })  : assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        ),
        super(
          initialValue: initialValue ?? [],
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
          autovalidateMode: AutovalidateMode.disabled,
          builder: (FormFieldState<List<PaintingValue>> field) {
            final state = field as FormPainterFieldState<TValue>;
            final canvasSize = controller.canvasSize;

            // GestureDetectorでラップしてドラッグ操作を可能にする
            Widget child = GestureDetector(
              onTapDown: (enabled && !readOnly)
                  ? (details) => state._handleTapDown(details, canvasSize)
                  : null,
              onPanStart: (enabled && !readOnly)
                  ? (details) => state._handlePanStart(details, canvasSize)
                  : null,
              onPanUpdate: (enabled && !readOnly)
                  ? (details) => state._handlePanUpdate(details, canvasSize)
                  : null,
              onPanEnd: (enabled && !readOnly) ? state._handlePanEnd : null,
              child: CustomPaint(
                painter: _RawPainter(
                  values: state.value ?? [],
                  currentValue: controller._currentValue,
                  dragStartPoint: state._dragStartPoint,
                  dragEndPoint: state._dragEndPoint,
                  isDragging: state._isDragging,
                ),
                size: canvasSize,
              ),
            );

            if (scrollable) {
              child = InteractiveViewer(child: child);
            }

            final backgroundColor = style?.backgroundColor ?? kWhiteColor;
            final padding = style?.padding ?? EdgeInsets.zero;
            final contentPadding = style?.contentPadding ?? EdgeInsets.zero;

            return FormContainer(
              form: form,
              style: style?.copyWith(
                      backgroundColor: backgroundColor,
                      padding: padding,
                      contentPadding: contentPadding) ??
                  FormStyle(
                    backgroundColor: backgroundColor,
                    padding: padding,
                    contentPadding: contentPadding,
                  ),
              enabled: enabled,
              alignment: style?.alignment ?? Alignment.topLeft,
              contentPadding: style?.contentPadding ?? EdgeInsets.zero,
              child: child,
            );
          },
        );

  /// Form Style.
  ///
  /// フォームのスタイル。
  final FormStyle? style;

  /// If `true`, the form is not destroyed when scrolling.
  ///
  /// `true`の場合、スクロール時にフォームが破棄されません。
  final bool keepAlive;

  /// Context for forms.
  ///
  /// The widget is created outside of the widget in advance and handed over to the client.
  ///
  /// フォーム用のコンテキスト。
  ///
  /// 予めウィジェット外で作成し渡します。
  final FormController<TValue>? form;

  /// If this is `true`, the form cannot be filled out and changed from its initial value.
  ///
  /// これが`true`の場合、フォームの入力が行えずに初期値から変更することができなくなります。
  final bool readOnly;

  /// Controller for painter forms.
  ///
  /// 描画フォーム用のコントローラー。
  final PainterController controller;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(List<PaintingValue>? value)? onChanged;

  @override
  FormFieldState<List<PaintingValue>> createState() =>
      FormPainterFieldState<TValue>();
}

/// State for FormPainterField.
///
/// フォーム用のMarkdownテキストフィールド用のステート。
class FormPainterFieldState<TValue> extends FormFieldState<List<PaintingValue>>
    with AutomaticKeepAliveClientMixin<FormField<List<PaintingValue>>> {
  @override
  List<PaintingValue>? get value => widget.controller.value;

  @override
  FormPainterField<TValue> get widget =>
      super.widget as FormPainterField<TValue>;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  // ドラッグ操作用の変数
  Offset? _dragStartPoint;
  Offset? _dragEndPoint;
  bool _isDragging = false;
  _DragMode _dragMode = _DragMode.none;
  _ResizeDirection? _resizeDirection;

  @override
  void initState() {
    super.initState();
    widget.controller._registerState(this);
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(FormPainterField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller._unregisterState(this);
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller._registerState(this);
      widget.controller.addListener(_handleControllerChanged);
    }
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
    widget.controller._unregisterState(this);
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    setState(() {});
  }

  @override
  void reset() {
    widget.controller.clear();
    widget.controller._values.addAll(widget.initialValue ?? []);
    super.reset();
  }

  void _handleTapDown(TapDownDetails details, Size canvasSize) {
    final position = details.localPosition;

    // 現在のツールがRectangleShapeで、currentValueがnullの場合のみ新規作成
    if (widget.controller._currentTool is RectangleShapePainterInlineTools &&
        widget.controller._currentValue == null) {
      // 新しい四角形を作成
      final tool =
          widget.controller._currentTool as RectangleShapePainterInlineTools;
      final newValue = tool.create(
        color: widget.controller.adapter.defaultColor,
        width: widget.controller.adapter.defaultStrokeWidth,
        point: position,
      );
      widget.controller._currentValue = newValue;
      _dragStartPoint = position;
      _dragEndPoint = position;
      _isDragging = true;
      _dragMode = _DragMode.creating;
      setState(() {});
    } else if (widget.controller._currentValue != null) {
      // 既存の要素の選択や編集
      final currentValue = widget.controller._currentValue;
      if (currentValue is RectanglePaintingValue) {
        final rect = _getRectFromValue(currentValue);

        // 要素の外側をタップした場合は選択解除
        if (!_isPointInSelectionArea(position, rect)) {
          widget.controller._currentValue = null;
          setState(() {});
        } else {
          // リサイズ方向を判定
          _resizeDirection = _getResizeDirection(position, rect);
          if (_resizeDirection != null) {
            _dragMode = _DragMode.resizing;
          } else if (rect.contains(position)) {
            _dragMode = _DragMode.moving;
          }
          _dragStartPoint = position;
          _isDragging = true;
          setState(() {});
        }
      }
    }
  }

  void _handlePanStart(DragStartDetails details, Size canvasSize) {
    // タップダウンで処理済みなので、特に追加処理なし
  }

  void _handlePanUpdate(DragUpdateDetails details, Size canvasSize) {
    if (!_isDragging) {
      return;
    }

    final position = details.localPosition;

    if (_dragMode == _DragMode.creating) {
      // 新規作成中の四角形をアップデート
      if (widget.controller._currentValue is RectanglePaintingValue) {
        final currentValue =
            widget.controller._currentValue as RectanglePaintingValue;
        widget.controller._currentValue = RectanglePaintingValue(
          id: currentValue.id,
          color: currentValue.color,
          width: currentValue.width,
          start: _dragStartPoint!,
          end: position,
        );
      }
    } else if (_dragMode == _DragMode.moving &&
        widget.controller._currentValue != null) {
      // 要素を移動
      if (widget.controller._currentValue is RectanglePaintingValue) {
        final currentValue =
            widget.controller._currentValue as RectanglePaintingValue;
        final delta = position - (_dragEndPoint ?? position);
        widget.controller._currentValue = RectanglePaintingValue(
          id: currentValue.id,
          color: currentValue.color,
          width: currentValue.width,
          start: currentValue.start + delta,
          end: currentValue.end + delta,
        );
      }
    } else if (_dragMode == _DragMode.resizing &&
        widget.controller._currentValue != null) {
      // リサイズ処理
      if (widget.controller._currentValue is RectanglePaintingValue) {
        final currentValue =
            widget.controller._currentValue as RectanglePaintingValue;
        final newValue =
            _getResizedValue(currentValue, position, _resizeDirection!);
        widget.controller._currentValue = newValue;
      }
    }
    _dragEndPoint = position;

    setState(() {});
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_dragMode == _DragMode.creating &&
        widget.controller._currentValue != null) {
      // 新規作成を確定
      final currentValue = widget.controller._currentValue!;

      // すでに存在するIDの場合は更新、そうでなければ追加
      final existingIndex =
          widget.controller._values.indexWhere((v) => v.id == currentValue.id);
      if (existingIndex >= 0) {
        widget.controller._values[existingIndex] = currentValue;
      } else {
        widget.controller._values.add(currentValue);
      }

      // currentValueは選択状態のままにする
      setState(() {});
    }

    _isDragging = false;
    _dragMode = _DragMode.none;
    _dragStartPoint = null;
    _dragEndPoint = null;
    _resizeDirection = null;
    setState(() {});
  }

  Rect _getRectFromValue(RectanglePaintingValue value) {
    return Rect.fromPoints(value.start, value.end);
  }

  bool _isPointInSelectionArea(Offset point, Rect rect) {
    const selectionMargin = 10.0;
    final expandedRect = rect.inflate(selectionMargin);
    return expandedRect.contains(point);
  }

  _ResizeDirection? _getResizeDirection(Offset point, Rect rect) {
    const handleSize = 10.0;

    // 角のハンドル
    if ((point - rect.topLeft).distance <= handleSize) {
      return _ResizeDirection.topLeft;
    }
    if ((point - rect.topRight).distance <= handleSize) {
      return _ResizeDirection.topRight;
    }
    if ((point - rect.bottomLeft).distance <= handleSize) {
      return _ResizeDirection.bottomLeft;
    }
    if ((point - rect.bottomRight).distance <= handleSize) {
      return _ResizeDirection.bottomRight;
    }

    // 辺のハンドル
    if ((point.dx - rect.left).abs() <= handleSize &&
        point.dy >= rect.top &&
        point.dy <= rect.bottom) {
      return _ResizeDirection.left;
    }
    if ((point.dx - rect.right).abs() <= handleSize &&
        point.dy >= rect.top &&
        point.dy <= rect.bottom) {
      return _ResizeDirection.right;
    }
    if ((point.dy - rect.top).abs() <= handleSize &&
        point.dx >= rect.left &&
        point.dx <= rect.right) {
      return _ResizeDirection.top;
    }
    if ((point.dy - rect.bottom).abs() <= handleSize &&
        point.dx >= rect.left &&
        point.dx <= rect.right) {
      return _ResizeDirection.bottom;
    }

    return null;
  }

  RectanglePaintingValue _getResizedValue(
    RectanglePaintingValue value,
    Offset newPoint,
    _ResizeDirection direction,
  ) {
    Offset newStart = value.start;
    Offset newEnd = value.end;

    switch (direction) {
      case _ResizeDirection.topLeft:
        // 右下を固定点として、左上をドラッグ
        final currentRect = _getRectFromValue(value);
        final aspectRatio = currentRect.width / currentRect.height;
        final fixedPoint = Offset(currentRect.right, currentRect.bottom);
        final newWidth = (fixedPoint.dx - newPoint.dx).abs();
        final newHeight = newWidth / aspectRatio;
        newStart = Offset(
          fixedPoint.dx - newWidth,
          fixedPoint.dy - newHeight,
        );
        newEnd = fixedPoint;
        break;
      case _ResizeDirection.topRight:
        // 左下を固定点として、右上をドラッグ
        final currentRect = _getRectFromValue(value);
        final aspectRatio = currentRect.width / currentRect.height;
        final fixedPoint = Offset(currentRect.left, currentRect.bottom);
        final newWidth = (newPoint.dx - fixedPoint.dx).abs();
        final newHeight = newWidth / aspectRatio;
        newStart = fixedPoint;
        newEnd = Offset(
          fixedPoint.dx + newWidth,
          fixedPoint.dy - newHeight,
        );
        break;
      case _ResizeDirection.bottomLeft:
        // 右上を固定点として、左下をドラッグ
        final currentRect = _getRectFromValue(value);
        final aspectRatio = currentRect.width / currentRect.height;
        final fixedPoint = Offset(currentRect.right, currentRect.top);
        final newWidth = (fixedPoint.dx - newPoint.dx).abs();
        final newHeight = newWidth / aspectRatio;
        newStart = Offset(
          fixedPoint.dx - newWidth,
          fixedPoint.dy,
        );
        newEnd = Offset(
          fixedPoint.dx,
          fixedPoint.dy + newHeight,
        );
        break;
      case _ResizeDirection.bottomRight:
        // 左上を固定点として、右下をドラッグ
        final currentRect = _getRectFromValue(value);
        final aspectRatio = currentRect.width / currentRect.height;
        final fixedPoint = Offset(currentRect.left, currentRect.top);
        final newWidth = (newPoint.dx - fixedPoint.dx).abs();
        final newHeight = newWidth / aspectRatio;
        newStart = fixedPoint;
        newEnd = Offset(
          fixedPoint.dx + newWidth,
          fixedPoint.dy + newHeight,
        );
        break;
      case _ResizeDirection.left:
        // 左辺をドラッグ（右辺は固定）
        final currentRect = _getRectFromValue(value);
        newStart = Offset(newPoint.dx, currentRect.top);
        newEnd = Offset(currentRect.right, currentRect.bottom);
        break;
      case _ResizeDirection.right:
        // 右辺をドラッグ（左辺は固定）
        final currentRect = _getRectFromValue(value);
        newStart = Offset(currentRect.left, currentRect.top);
        newEnd = Offset(newPoint.dx, currentRect.bottom);
        break;
      case _ResizeDirection.top:
        // 上辺をドラッグ（下辺は固定）
        final currentRect = _getRectFromValue(value);
        newStart = Offset(currentRect.left, newPoint.dy);
        newEnd = Offset(currentRect.right, currentRect.bottom);
        break;
      case _ResizeDirection.bottom:
        // 下辺をドラッグ（上辺は固定）
        final currentRect = _getRectFromValue(value);
        newStart = Offset(currentRect.left, currentRect.top);
        newEnd = Offset(currentRect.right, newPoint.dy);
        break;
    }

    return RectanglePaintingValue(
      id: value.id,
      color: value.color,
      width: value.width,
      start: newStart,
      end: newEnd,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(this);
  }
}

// ドラッグモードの列挙型
enum _DragMode {
  none,
  creating,
  moving,
  resizing,
}

// リサイズ方向の列挙型
enum _ResizeDirection {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  left,
  right,
  top,
  bottom,
}

class _RawPainter extends CustomPainter {
  _RawPainter({
    required this.values,
    this.currentValue,
    this.dragStartPoint,
    this.dragEndPoint,
    this.isDragging = false,
  });

  final List<PaintingValue> values;
  final PaintingValue? currentValue;
  final Offset? dragStartPoint;
  final Offset? dragEndPoint;
  final bool isDragging;

  @override
  void paint(Canvas canvas, Size size) {
    // 背景を白で塗りつぶす
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // 既存の値を描画
    for (final value in values) {
      // currentValueと同じIDの場合はスキップ（後で描画）
      if (currentValue != null && value.id == currentValue!.id) {
        continue;
      }
      _paintValue(canvas, value, false);
    }

    // currentValueを描画（選択状態または作成中）
    if (currentValue != null) {
      _paintValue(canvas, currentValue!, true);
    }
  }

  void _paintValue(Canvas canvas, PaintingValue value, bool isSelected) {
    if (value is RectanglePaintingValue) {
      final rect = Rect.fromPoints(value.start, value.end);

      // 四角形を描画
      final paint = Paint()
        ..color = value.color
        ..strokeWidth = value.width
        ..style = value.filled ? PaintingStyle.fill : PaintingStyle.stroke;

      canvas.drawRect(rect, paint);

      // 選択状態の場合は選択枠を描画
      if (isSelected) {
        _paintSelection(canvas, rect);
      }
    }
    // 他の図形タイプもここに追加可能
  }

  void _paintSelection(Canvas canvas, Rect rect) {
    // 選択枠を描画
    final selectionPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 点線風の選択枠
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    final path = Path();

    // 上辺
    double x = rect.left;
    while (x < rect.right) {
      path.moveTo(x, rect.top);
      path.lineTo(math.min(x + dashWidth, rect.right), rect.top);
      x += dashWidth + dashSpace;
    }

    // 右辺
    double y = rect.top;
    while (y < rect.bottom) {
      path.moveTo(rect.right, y);
      path.lineTo(rect.right, math.min(y + dashWidth, rect.bottom));
      y += dashWidth + dashSpace;
    }

    // 下辺
    x = rect.right;
    while (x > rect.left) {
      path.moveTo(x, rect.bottom);
      path.lineTo(math.max(x - dashWidth, rect.left), rect.bottom);
      x -= dashWidth + dashSpace;
    }

    // 左辺
    y = rect.bottom;
    while (y > rect.top) {
      path.moveTo(rect.left, y);
      path.lineTo(rect.left, math.max(y - dashWidth, rect.top));
      y -= dashWidth + dashSpace;
    }

    canvas.drawPath(path, selectionPaint);

    // リサイズハンドルを描画
    const handleSize = 8.0;
    final handlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // 角のハンドル
    canvas.drawCircle(rect.topLeft, handleSize / 2, handlePaint);
    canvas.drawCircle(rect.topRight, handleSize / 2, handlePaint);
    canvas.drawCircle(rect.bottomLeft, handleSize / 2, handlePaint);
    canvas.drawCircle(rect.bottomRight, handleSize / 2, handlePaint);

    // 辺の中央のハンドル
    canvas.drawCircle(
        Offset(rect.center.dx, rect.top), handleSize / 2, handlePaint);
    canvas.drawCircle(
        Offset(rect.center.dx, rect.bottom), handleSize / 2, handlePaint);
    canvas.drawCircle(
        Offset(rect.left, rect.center.dy), handleSize / 2, handlePaint);
    canvas.drawCircle(
        Offset(rect.right, rect.center.dy), handleSize / 2, handlePaint);
  }

  @override
  bool shouldRepaint(_RawPainter oldDelegate) {
    return oldDelegate.values.length != values.length ||
        !oldDelegate.values.equalsTo(values) ||
        oldDelegate.currentValue != currentValue ||
        oldDelegate.dragStartPoint != dragStartPoint ||
        oldDelegate.dragEndPoint != dragEndPoint ||
        oldDelegate.isDragging != isDragging;
  }
}
