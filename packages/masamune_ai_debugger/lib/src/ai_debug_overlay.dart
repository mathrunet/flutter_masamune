part of '/masamune_ai_debugger.dart';

class _AIDebugOverlay extends StatefulWidget {
  const _AIDebugOverlay({
    required this.controller,
    required this.maxScreenshots,
    required this.child,
  });

  final AIDebugController controller;
  final int maxScreenshots;
  final Widget child;

  @override
  State<_AIDebugOverlay> createState() => _AIDebugOverlayState();
}

class _AIDebugOverlayState extends State<_AIDebugOverlay>
    with WidgetsBindingObserver {
  final _boundaryKey = GlobalKey();
  final _textController = TextEditingController();
  final List<Uint8List> _screenshots = [];
  Offset _position = const Offset(16, 80);
  bool _expanded = false;
  bool _hidden = false;
  bool _sending = false;
  String? _status;
  Uint8List? _preview;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.attachCapture(_capture);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(widget.controller.resume().catchError((Object error) {
        if (mounted) setState(() => _status = error.toString());
      }));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(widget.controller.resume().catchError((Object error) {
        if (mounted) setState(() => _status = error.toString());
      }));
    } else if (state == AppLifecycleState.detached) {
      unawaited(widget.controller.end());
    } else {
      widget.controller.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(widget.controller.end());
    _textController.dispose();
    super.dispose();
  }

  Future<Uint8List?> _capture() async {
    if (!mounted) return null;
    setState(() => _hidden = true);
    await WidgetsBinding.instance.endOfFrame;
    try {
      if (!mounted) return null;
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final ratio = math.min(2.0, View.of(context).devicePixelRatio);
      final image = await boundary.toImage(pixelRatio: ratio);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      return data?.buffer.asUint8List();
    } finally {
      if (mounted) setState(() => _hidden = false);
    }
  }

  Future<void> _addScreenshot() async {
    final image = await _capture();
    if (image == null || !mounted) return;
    setState(() {
      if (_screenshots.length >= widget.maxScreenshots) {
        _screenshots.removeAt(0);
      }
      _screenshots.add(image);
    });
  }

  Future<void> _captureAndOpen() async {
    Object? captureError;
    try {
      await _addScreenshot();
    } catch (error) {
      captureError = error;
    }
    if (!mounted) return;
    setState(() {
      _expanded = true;
      if (captureError != null) {
        _status = "Screenshot failed: $captureError";
      }
    });
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() {
      _sending = true;
      _status = null;
    });
    try {
      final sessionId = await widget.controller.send(text, _screenshots);
      if (!mounted) return;
      setState(() {
        _textController.clear();
        _screenshots.clear();
        _expanded = false;
        _status = sessionId == null ? "送信しました" : "Session: $sessionId";
      });
    } catch (error) {
      if (mounted) setState(() => _status = error.toString());
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Offset _clamp(Offset value, Size area, Size item, EdgeInsets safe) => Offset(
        value.dx
            .clamp(safe.left,
                math.max(safe.left, area.width - safe.right - item.width))
            .toDouble(),
        value.dy
            .clamp(safe.top,
                math.max(safe.top, area.height - safe.bottom - item.height))
            .toDouble(),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topLeft,
      children: [
        RepaintBoundary(key: _boundaryKey, child: widget.child),
        if (!_hidden)
          LayoutBuilder(builder: (context, constraints) {
            final area = constraints.biggest;
            final safe = MediaQueryData.fromView(View.of(context)).padding;
            final availableWidth =
                math.max(160.0, area.width - safe.horizontal - 16);
            final panelWidth = math.min(360.0, availableWidth);
            final itemSize =
                _expanded ? Size(panelWidth, 300) : const Size(52, 52);
            final position = _clamp(_position, area, itemSize, safe);
            if (position != _position) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _position = position);
              });
            }
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Theme(
                data: ThemeData.dark(),
                child: Stack(children: [
                  Positioned(
                    left: position.dx,
                    top: position.dy,
                    width: itemSize.width,
                    height: itemSize.height,
                    child: GestureDetector(
                      onTap: _expanded
                          ? null
                          : () => setState(() => _expanded = true),
                      onPanUpdate: (details) => setState(() {
                        _position = _clamp(
                            _position + details.delta, area, itemSize, safe);
                      }),
                      onLongPress: _expanded ? null : _captureAndOpen,
                      child: _expanded ? _buildPanel() : _buildToggle(),
                    ),
                  ),
                  if (_preview != null) _buildPreview(),
                ]),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildToggle() => Semantics(
        label: "AI Debuggerを開く",
        button: true,
        child: Material(
          color: Colors.black.withValues(alpha: 0.55),
          shape: const CircleBorder(),
          elevation: 8,
          child: const Icon(Icons.auto_awesome, color: Colors.white70),
        ),
      );

  Widget _buildPanel() => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Material(
          color: const Color(0xE6222222),
          borderRadius: BorderRadius.circular(16),
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.auto_awesome, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                    child: Text("AI Debugger",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _expanded = false),
                  icon: const Icon(Icons.close, size: 18, semanticLabel: "閉じる"),
                ),
              ]),
              Expanded(
                child: TextField(
                  controller: _textController,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                      hintText: "AIへの指示", border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: Row(children: [
                  IconButton(
                      onPressed: _addScreenshot,
                      icon: const Icon(Icons.screenshot_monitor,
                          semanticLabel: "スクリーンショット")),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _screenshots.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Stack(children: [
                          InkWell(
                            onTap: () =>
                                setState(() => _preview = _screenshots[index]),
                            child: Image.memory(_screenshots[index],
                                width: 48, height: 48, fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 0,
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _screenshots.removeAt(index)),
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    shape: BoxShape.circle),
                                child: Icon(Icons.close, size: 14),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send, semanticLabel: "送信"),
                  ),
                ]),
              ),
              if (_status != null)
                Text(_status!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10)),
            ]),
          ),
        ),
      );

  Widget _buildPreview() => Positioned.fill(
        child: ColoredBox(
          color: Colors.black87,
          child: Stack(children: [
            Center(child: InteractiveViewer(child: Image.memory(_preview!))),
            Positioned(
              right: 12,
              top: 12,
              child: IconButton(
                  onPressed: () => setState(() => _preview = null),
                  icon: const Icon(Icons.close, semanticLabel: "プレビューを閉じる")),
            ),
          ]),
        ),
      );
}
