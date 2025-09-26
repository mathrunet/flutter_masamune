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
  /// If [scrollable] is `true`, the canvas can be zoomed with pinch gestures and panned with two-finger drag.
  ///
  /// [minScale] and [maxScale] control the zoom range when [scrollable] is `true`.
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
  ///
  /// [scrollable]が`true`の場合、ピンチジェスチャーでキャンバスのズームと、2本指ドラッグでパンが可能になります。
  ///
  /// [minScale]と[maxScale]は[scrollable]が`true`の時のズーム範囲を制御します。
  FormPainterField({
    required this.controller,
    super.key,
    this.keepAlive = true,
    bool expands = false,
    this.scrollable = true,
    this.minScale = 0.1,
    this.maxScale = 5.0,
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

            // CustomPaintウィジェット
            Widget paintWidget = CustomPaint(
              painter: _RawPainter(
                values: state.value ?? [],
                currentValues: controller.currentValues,
                dragSelectionRect: controller.dragSelectionRect,
                selectionBounds: controller.selectionBounds,
                dragStartPoint: state._dragStartPoint,
                dragEndPoint: state._dragEndPoint,
                isDragging: state._isDragging,
                actualCanvasSize: controller.canvasSize,
              ),
              size: canvasSize,
            );

            // GestureDetectorでスケールとドラッグを処理
            Widget child = GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (enabled && !readOnly)
                  ? (details) {
                      final transformedPosition =
                          state._transformPosition(details.localPosition);
                      state._handledOnDragStart(
                          transformedPosition, canvasSize);
                    }
                  : null,
              onTapUp: (enabled && !readOnly)
                  ? (details) {
                      final transformedPosition =
                          state._transformPosition(details.localPosition);
                      state._handledOnDragEnd(transformedPosition, canvasSize);
                    }
                  : null,
              onScaleStart:
                  (enabled && !readOnly) ? state._handledOnScaleStart : null,
              onScaleUpdate:
                  (enabled && !readOnly) ? state._handledOnScaleUpdate : null,
              onScaleEnd:
                  (enabled && !readOnly) ? state._handledOnScaleEnd : null,
              child: Transform(
                transform: state._transformMatrix,
                child: paintWidget,
              ),
            );

            final backgroundColor =
                style?.backgroundColor ?? Colors.grey.shade300;
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

  /// Minimum scale for pinch zoom.
  ///
  /// ピンチズームの最小倍率。
  final double minScale;

  /// Maximum scale for pinch zoom.
  ///
  /// ピンチズームの最大倍率。
  final double maxScale;

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

  /// If `true`, the canvas can be zoomed with pinch gestures and panned with two-finger drag.
  ///
  /// [minScale] and [maxScale] control the zoom range when [scrollable] is `true`.
  ///
  /// ピンチジェスチャーでキャンバスのズームと、2本指ドラッグでパンが可能かどうか。
  ///
  /// [minScale]と[maxScale]は[scrollable]が`true`の時のズーム範囲を制御します。
  final bool scrollable;

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

  // 変換行列とスケール/パン管理
  Matrix4 _transformMatrix = Matrix4.identity();
  double _currentScale = 1.0;
  Offset _currentOffset = Offset.zero;

  // スケール操作用の変数
  double _baseScale = 1.0;
  Offset _startFocalPoint = Offset.zero;
  bool _isScaling = false;

  // ドラッグ操作用の変数
  Offset? _dragStartPoint;
  Offset? _dragEndPoint;
  bool _isDragging = false;
  bool _isDragStarted = false;
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

  // スケール開始時
  void _handledOnScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
    _startFocalPoint = details.focalPoint - _currentOffset;
    _isScaling = details.pointerCount > 1;

    if (!_isScaling) {
      // シングルタッチの場合は描画操作開始
      final transformedPosition = _transformPosition(details.localFocalPoint);
      _handledOnDragStart(transformedPosition, widget.controller.canvasSize);
    }
  }

  // スケール更新時
  void _handledOnScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount > 1 && widget.scrollable) {
      _isScaling = true;
      // ピンチズームとパン
      final newScale = (_baseScale * details.scale).clamp(
        widget.minScale,
        widget.maxScale,
      );

      // スケールが変わった場合、焦点を中心にズーム
      final focalPointInWidget = details.focalPoint;

      // パンの計算：現在のフォーカル点と開始時のフォーカル点の差分
      final newOffset = focalPointInWidget - _startFocalPoint * details.scale;

      _currentScale = newScale;
      _currentOffset = newOffset;
      _updateTransformMatrix();
      setState(() {});
    } else if (!_isScaling) {
      // シングルタッチドラッグ
      final transformedPosition = _transformPosition(details.localFocalPoint);

      // パンモードの場合は、2本指パンと同じ方法で処理
      if (_dragMode == PainterDragMode.panning) {
        final focalPointInWidget = details.focalPoint;
        final newOffset = focalPointInWidget - _startFocalPoint;
        _currentOffset = newOffset;
        _updateTransformMatrix();
        setState(() {});
      } else {
        _handledOnDragging(transformedPosition, widget.controller.canvasSize);
      }
    }
  }

  // スケール終了時
  void _handledOnScaleEnd(ScaleEndDetails details) {
    if (!_isScaling) {
      // シングルタッチの場合は描画操作終了
      const lastPosition = Offset.zero; // 最後の位置は利用可能でない
      _handledOnDragEnd(lastPosition, widget.controller.canvasSize);
    }
    _isScaling = false;
  }

  // ドラッグ開始時。
  void _handledOnDragStart(Offset position, Size canvasSize) {
    final currentTool = _currentTool;

    // 複数選択時の処理
    if (widget.controller.hasMultipleSelection) {
      final bounds = widget.controller.selectionBounds;
      if (bounds != null) {
        if (_editingStart(
          position: position,
          rect: bounds,
        )) {
          return;
        }
      }
      _selectingStartWithSelectingTool(
        position: position,
      );
      // 選択されている場合
    } else if (widget.controller.currentValues.isNotEmpty) {
      final currentValue = widget.controller.currentValues.first;
      final rect = currentValue.rect;
      if (_editingStart(
        position: position,
        rect: rect,
      )) {
        return;
      }
      _selectingStartWithSelectingTool(
        position: position,
      );
      // 選択ツールが選択されているときは選択開始
    } else if (currentTool is SelectPainterPrimaryTools) {
      _selectingStartWithSelectingTool(
        position: position,
      );
    } else if (currentTool == null) {
      _selectingStartWithoutTool(
        position: position,
      );
      // ツールが選択されているときは新規作成
    } else if (currentTool is PainterVariableInlineTools &&
        widget.controller.currentValues.isEmpty) {
      _creatingStart(
        position: position,
        currentTool: currentTool,
      );
    }
  }

  // ドラッグ中。
  void _handledOnDragging(Offset position, Size canvasSize) {
    _isDragStarted = true;
    if (!_isDragging) {
      _handledOnDragStart(position, canvasSize);
      return;
    }

    // パンモード時の処理はonScaleUpdateで行うため、ここでは何もしない
    if (_dragMode == PainterDragMode.panning) {
      return;
    }

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

    if (widget.controller.currentValues.isEmpty) {
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
    } else {
      final currentValue = widget.controller.currentValues.first;

      // 作成処理
      if (_dragMode == PainterDragMode.creating) {
        final dragStartPoint = _dragStartPoint;
        if (dragStartPoint == null) {
          return;
        }
        final updatedEndPoint = currentValue._getMinimumSizeOffsetOnCreating(
          dragStartPoint,
          position,
        );
        final updatedValue = currentValue.updateOnCreating(
          startPoint: dragStartPoint,
          currentPoint: updatedEndPoint,
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
        final updatedPoint = currentValue._getMinimumSizeOffsetOnResizing(
          position,
          resizeDirection,
        );
        final updatedValue = currentValue.updateOnResizing(
          currentPoint: position,
          direction: resizeDirection,
          startPoint: updatedPoint.startPoint,
          endPoint: updatedPoint.endPoint,
        );
        widget.controller.updateCurrentValue(updatedValue);
      }
    }
    _dragEndPoint = position;

    setState(() {});
  }

  // ドラッグ終了時。
  void _handledOnDragEnd(Offset position, Size canvasSize) {
    // パンモード終了時の処理
    if (_dragMode == PainterDragMode.panning) {
      // パンモードの場合は特別な処理はなし
    } else if (_dragMode == PainterDragMode.selecting) {
      // ドラッグ選択終了時の処理
      // ドラッグ選択矩形をクリア
      widget.controller.dragSelectionRect = null;
      if (!_isDragStarted) {
        widget.controller._currentTool = null;
      }
    } else if (_dragMode == PainterDragMode.creating) {
      // 作成中の場合はドラッグが行われていないと保存しない
      if (_isDragStarted) {
        widget.controller.saveCurrentValue(saveToHistory: true);
      }
    } else if (_dragMode == PainterDragMode.moving ||
        _dragMode == PainterDragMode.resizing) {
      // 移動・リサイズ完了時は値と履歴を保存
      if (_isDragStarted) {
        widget.controller.saveCurrentValue(saveToHistory: true);
      }
    } else {
      // その他の編集中の値を保存（履歴保存なし）
      widget.controller.saveCurrentValue();
    }

    _isDragging = false;
    _isDragStarted = false;
    _dragMode = PainterDragMode.none;
    _dragStartPoint = null;
    _dragEndPoint = null;
    _resizeDirection = null;
    setState(() {});
  }

  bool _isPointInSelectionArea(Offset point, Rect rect) {
    const selectionMargin = 16.0;
    final expandedRect = rect.inflate(selectionMargin);
    return expandedRect.contains(point);
  }

  PainterResizeDirection? _getResizeDirection(Offset point, Rect rect) {
    const handleSize = 16.0;
    const extraMargin = 16.0;

    // 角のハンドル
    if ((point - rect.topLeft).distance <= handleSize + extraMargin) {
      return PainterResizeDirection.topLeft;
    }
    if ((point - rect.topRight).distance <= handleSize + extraMargin) {
      return PainterResizeDirection.topRight;
    }
    if ((point - rect.bottomLeft).distance <= handleSize + extraMargin) {
      return PainterResizeDirection.bottomLeft;
    }
    if ((point - rect.bottomRight).distance <= handleSize + extraMargin) {
      return PainterResizeDirection.bottomRight;
    }

    // 辺のハンドル
    if ((point.dx - rect.left).abs() <= handleSize + extraMargin &&
        point.dy >= rect.top - extraMargin &&
        point.dy <= rect.bottom + extraMargin) {
      return PainterResizeDirection.left;
    }
    if ((point.dx - rect.right).abs() <= handleSize + extraMargin &&
        point.dy >= rect.top - extraMargin &&
        point.dy <= rect.bottom + extraMargin) {
      return PainterResizeDirection.right;
    }
    if ((point.dy - rect.top).abs() <= handleSize + extraMargin &&
        point.dx >= rect.left - extraMargin &&
        point.dx <= rect.right + extraMargin) {
      return PainterResizeDirection.top;
    }
    if ((point.dy - rect.bottom).abs() <= handleSize + extraMargin &&
        point.dx >= rect.left - extraMargin &&
        point.dx <= rect.right + extraMargin) {
      return PainterResizeDirection.bottom;
    }

    return null;
  }

  // 変換行列を考慮した座標変換
  Offset _transformPosition(Offset localPosition) {
    final invertedMatrix = Matrix4.inverted(_transformMatrix);
    final vector = Vector3(localPosition.dx, localPosition.dy, 0);
    final transformed = invertedMatrix.transform3(vector);
    return Offset(transformed.x, transformed.y);
  }

  // 変換行列を更新
  void _updateTransformMatrix() {
    _transformMatrix = Matrix4.identity();
    _transformMatrix.translateByDouble(
        _currentOffset.dx, _currentOffset.dy, 0.0, 1.0);
    _transformMatrix.scaleByDouble(_currentScale, _currentScale, 1.0, 1.0);
  }

  bool _editingStart({
    required Offset position,
    required Rect rect,
  }) {
    final resizeDir = _getResizeDirection(position, rect);
    if (resizeDir != null) {
      _resizeDirection = resizeDir;
      _dragMode = PainterDragMode.resizing;
      _dragStartPoint = position;
      _isDragging = true;
      setState(() {});
      return true;
      // 選択範囲内のチェック（マージンを考慮）
      // 選択範囲内であれば、その位置に他のオブジェクトがあっても移動モードにする
    } else if (_isPointInSelectionArea(position, rect)) {
      _dragMode = PainterDragMode.moving;
      _dragStartPoint = position;
      _dragEndPoint = position;
      _isDragging = true;
      setState(() {});
      return true;
    }
    return false;
  }

  void _selectingStartWithSelectingTool({
    required Offset position,
  }) {
    // 既存のオブジェクトをタップしたかチェック
    final tappedValue = widget.controller.findValueAt(position);
    // 単一のオブジェクトを選択
    if (tappedValue != null) {
      widget.controller.updateCurrentValue(tappedValue);
      _dragMode = PainterDragMode.moving;
      _dragStartPoint = position;
      _dragEndPoint = position;
      _isDragging = true;
      setState(() {});
    } else {
      // 何もない場所をタップ、または複数選択中で選択範囲外をタップ - ドラッグ選択開始
      widget.controller.unselect();
      _dragStartPoint = position;
      _dragEndPoint = position;
      _isDragging = true;
      _dragMode = PainterDragMode.selecting;
      setState(() {});
    }
  }

  void _selectingStartWithoutTool({
    required Offset position,
  }) {
    // 既存のオブジェクトをタップしたかチェック
    final tappedValue = widget.controller.findValueAt(position);
    // 単一のオブジェクトを選択
    if (tappedValue == null) {
      // 何もない場所をタップした場合はパンモードを開始
      _dragMode = PainterDragMode.panning;
      _dragStartPoint = position;
      _isDragging = true;
      setState(() {});
      return;
    }
    // ツールが無い場合は選択ツールを設定
    widget.controller._currentTool ??= const SelectPainterPrimaryTools();
    widget.controller.updateCurrentValue(tappedValue);
    _dragMode = PainterDragMode.moving;
    _dragStartPoint = position;
    _dragEndPoint = position;
    _isDragging = true;
    setState(() {});
  }

  void _creatingStart({
    required Offset position,
    required PainterVariableInlineTools currentTool,
  }) {
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
    required this.actualCanvasSize,
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
  final Size actualCanvasSize;

  @override
  void paint(Canvas canvas, Size size) {
    // キャンバス領域を白で塗りつぶす
    final canvasRect =
        Rect.fromLTWH(0, 0, actualCanvasSize.width, actualCanvasSize.height);
    if (canvasRect.width > 0 && canvasRect.height > 0) {
      canvas.drawRect(
        canvasRect,
        Paint()..color = Colors.white,
      );

      // キャンバスの境界線を描画
      canvas.drawRect(
        canvasRect,
        Paint()
          ..color = Colors.grey.shade600
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }

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
    const handleSize = 16.0;
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
        oldDelegate.isDragging != isDragging ||
        oldDelegate.actualCanvasSize != actualCanvasSize;
  }
}
