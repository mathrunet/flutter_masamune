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
              onPanUpdate: (enabled && !readOnly)
                  ? (details) => state._handlePanUpdate(details, canvasSize)
                  : null,
              onPanEnd: (enabled && !readOnly) ? state._handlePanEnd : null,
              child: CustomPaint(
                painter: _RawPainter(
                  values: state.value ?? [],
                  currentValues: controller.currentValues,
                  dragSelectionRect: controller.dragSelectionRect,
                  selectionBounds: controller.selectionBounds,
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
  PainterDragMode _dragMode = PainterDragMode.none;
  PainterResizeDirection? _resizeDirection;

  PainterTools? get _currentTool {
    return widget.controller._currentTool;
  }


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
    if (!oldWidget.initialValue.equalsTo(widget.initialValue) &&
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

  // タップ開始時。
  void _handleTapDown(TapDownDetails details, Size canvasSize) {
    final position = details.localPosition;
    final currentTool = _currentTool;
    
    // SelectPainterPrimaryToolsが選択されている場合（選択ツール）
    if (currentTool == null) {
      // 複数選択時の処理
      if (widget.controller.hasMultipleSelection) {
        final bounds = widget.controller.selectionBounds;
        if (bounds != null) {
          // リサイズハンドルのチェック
          final resizeDir = widget.controller.getResizeDirectionAt(position);
          if (resizeDir != null) {
            _resizeDirection = resizeDir;
            _dragMode = PainterDragMode.resizing;
            _dragStartPoint = position;
            _isDragging = true;
            setState(() {});
            return;
          }
          // 選択範囲内のチェック
          if (bounds.contains(position)) {
            _dragMode = PainterDragMode.moving;
            _dragStartPoint = position;
            _isDragging = true;
            setState(() {});
            return;
          }
        }
      }
      
      // 既存のオブジェクトをタップしたかチェック
      final tappedValue = widget.controller.findValueAt(position);
      if (tappedValue != null) {
        // 単一のオブジェクトを選択
        widget.controller.updateCurrentValue(tappedValue);
        _dragMode = PainterDragMode.moving;
        _dragStartPoint = position;
        _isDragging = true;
        setState(() {});
      } else {
        // 何もない場所をタップ - ドラッグ選択開始
        widget.controller.unselect();
        _dragStartPoint = position;
        _dragEndPoint = position;
        _isDragging = true;
        _dragMode = PainterDragMode.selecting;
        setState(() {});
      }
    }
    // ツールが選択されているときは新規作成
    else if (currentTool is PainterVariableInlineTools &&
        widget.controller.currentValue == null) {
      // 新しい四角形を作成
      final newValue = currentTool.create(
        color: widget.controller.adapter.defaultColor,
        width: widget.controller.adapter.defaultStrokeWidth,
        point: position,
      );
      widget.controller.updateCurrentValue(newValue);
      _dragStartPoint = position;
      _dragEndPoint = position;
      _isDragging = true;
      _dragMode = PainterDragMode.creating;
      setState(() {});
    } 
    // 単一選択時の処理（後方互換性）
    else if (widget.controller.currentValue != null) {
      final rect = widget.controller.currentValue!.rect;

      // 要素の外側をタップした場合は選択解除
      if (!_isPointInSelectionArea(position, rect)) {
        // unselect()メソッド内で値の保存も行われる
        widget.controller.unselect();
        // setState(() {});
      } else {
        // リサイズ方向を判定
        _resizeDirection = _getResizeDirection(position, rect);
        if (_resizeDirection != null) {
          _dragMode = PainterDragMode.resizing;
        } else if (rect.contains(position)) {
          _dragMode = PainterDragMode.moving;
        }
        _dragStartPoint = position;
        _isDragging = true;
        setState(() {});
      }
    }
  }

  // ドラッグ中。
  void _handlePanUpdate(DragUpdateDetails details, Size canvasSize) {
    if (!_isDragging) {
      return;
    }

    final position = details.localPosition;

    // ドラッグ選択処理
    if (_dragMode == PainterDragMode.selecting) {
      final dragStartPoint = _dragStartPoint;
      if (dragStartPoint == null) {
        return;
      }
      // ドラッグ選択矩形を更新
      final selectionRect = Rect.fromPoints(dragStartPoint, position);
      widget.controller.updateDragSelectionRect(selectionRect);
      _dragEndPoint = position;
      setState(() {});
      return;
    }
    
    // 複数選択時の処理
    if (widget.controller.hasMultipleSelection) {
      if (_dragMode == PainterDragMode.moving) {
        final delta = position - (_dragEndPoint ?? position);
        widget.controller.moveSelectedValues(delta);
      } else if (_dragMode == PainterDragMode.resizing) {
        final resizeDirection = _resizeDirection;
        if (resizeDirection != null) {
          widget.controller.resizeSelectedValues(
            currentPoint: position,
            direction: resizeDirection,
          );
        }
      }
      _dragEndPoint = position;
      setState(() {});
      return;
    }

    // 単一選択時の処理（後方互換性）
    final currentValue = widget.controller.currentValue;
    if (currentValue == null) {
      return;
    }

    // 作成処理
    if (_dragMode == PainterDragMode.creating) {
      final dragStartPoint = _dragStartPoint;
      if (dragStartPoint == null) {
        return;
      }
      final updatedValue = currentValue.updateOnCreating(
        startPoint: dragStartPoint,
        currentPoint: position,
      );
      widget.controller.updateCurrentValue(updatedValue);
      // 移動処理
    } else if (_dragMode == PainterDragMode.moving) {
      final updatedValue = currentValue.updateOnMoving(
        delta: position - (_dragEndPoint ?? position),
      );
      widget.controller.updateCurrentValue(updatedValue);
      // リサイズ処理
    } else if (_dragMode == PainterDragMode.resizing) {
      final resizeDirection = _resizeDirection;
      if (resizeDirection == null) {
        return;
      }
      final updatedValue = currentValue.updateOnResizing(
        currentPoint: position,
        direction: resizeDirection,
      );
      widget.controller.updateCurrentValue(updatedValue);
    }
    _dragEndPoint = position;

    setState(() {});
  }

  // ドラッグ終了時。
  void _handlePanEnd(DragEndDetails details) {
    // ドラッグ選択終了時の処理
    if (_dragMode == PainterDragMode.selecting) {
      // ドラッグ選択矩形をクリア
      widget.controller.dragSelectionRect = null;
    } else {
      // 編集中の値を保存
      widget.controller.saveCurrentValue();
    }

    _isDragging = false;
    _dragMode = PainterDragMode.none;
    _dragStartPoint = null;
    _dragEndPoint = null;
    _resizeDirection = null;
    setState(() {});
  }

  bool _isPointInSelectionArea(Offset point, Rect rect) {
    const selectionMargin = 10.0;
    final expandedRect = rect.inflate(selectionMargin);
    return expandedRect.contains(point);
  }

  PainterResizeDirection? _getResizeDirection(Offset point, Rect rect) {
    const handleSize = 10.0;

    // 角のハンドル
    if ((point - rect.topLeft).distance <= handleSize) {
      return PainterResizeDirection.topLeft;
    }
    if ((point - rect.topRight).distance <= handleSize) {
      return PainterResizeDirection.topRight;
    }
    if ((point - rect.bottomLeft).distance <= handleSize) {
      return PainterResizeDirection.bottomLeft;
    }
    if ((point - rect.bottomRight).distance <= handleSize) {
      return PainterResizeDirection.bottomRight;
    }

    // 辺のハンドル
    if ((point.dx - rect.left).abs() <= handleSize &&
        point.dy >= rect.top &&
        point.dy <= rect.bottom) {
      return PainterResizeDirection.left;
    }
    if ((point.dx - rect.right).abs() <= handleSize &&
        point.dy >= rect.top &&
        point.dy <= rect.bottom) {
      return PainterResizeDirection.right;
    }
    if ((point.dy - rect.top).abs() <= handleSize &&
        point.dx >= rect.left &&
        point.dx <= rect.right) {
      return PainterResizeDirection.top;
    }
    if ((point.dy - rect.bottom).abs() <= handleSize &&
        point.dx >= rect.left &&
        point.dx <= rect.right) {
      return PainterResizeDirection.bottom;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(this);
  }
}

class _RawPainter extends CustomPainter {
  _RawPainter({
    required this.values,
    required this.currentValues,
    this.dragSelectionRect,
    this.selectionBounds,
    this.dragStartPoint,
    this.dragEndPoint,
    this.isDragging = false,
  });

  final List<PaintingValue> values;
  final List<PaintingValue> currentValues;
  final Rect? dragSelectionRect;
  final Rect? selectionBounds;
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

    // 現在選択中のIDのセットを作成
    final selectedIds = currentValues.map((v) => v.id).toSet();

    // 既存の値を描画
    for (final value in values) {
      // 選択中の値はスキップ（後で描画）
      if (selectedIds.contains(value.id)) {
        continue;
      }
      _paintValue(canvas, value, false);
    }

    // 選択中の値を描画
    for (final value in currentValues) {
      _paintValue(canvas, value, true);
    }

    // ドラッグ選択矩形を描画
    if (dragSelectionRect != null) {
      final paint = Paint()
        ..color = Colors.blue.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      canvas.drawRect(dragSelectionRect!, paint);
      
      final borderPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRect(dragSelectionRect!, borderPaint);
    }

    // 複数選択時の選択範囲を描画
    if (currentValues.length > 1 && selectionBounds != null) {
      _paintSelectionBounds(canvas, selectionBounds!);
    }
  }

  void _paintValue(Canvas canvas, PaintingValue value, bool isSelected) {
    final rect = value.paint(canvas);
    if (isSelected && rect != null && currentValues.length <= 1) {
      _paintSelection(canvas, rect);
    }
  }
  
  void _paintSelectionBounds(Canvas canvas, Rect bounds) {
    // 複数選択時の境界枠を描画
    _paintSelection(canvas, bounds);
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
        !oldDelegate.currentValues.equalsTo(currentValues) ||
        oldDelegate.dragSelectionRect != dragSelectionRect ||
        oldDelegate.selectionBounds != selectionBounds ||
        oldDelegate.dragStartPoint != dragStartPoint ||
        oldDelegate.dragEndPoint != dragEndPoint ||
        oldDelegate.isDragging != isDragging;
  }
}
