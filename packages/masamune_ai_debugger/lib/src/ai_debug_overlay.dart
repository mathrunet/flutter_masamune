part of '/masamune_ai_debugger.dart';

enum _AIDebugRequestType {
  bugFix,
  requirementsEdit,
}

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
  final _modelTimeoutController = TextEditingController();
  final _indicatorTimeoutController = TextEditingController();
  late final void Function(String kind, String sessionId)
      _incidentSessionCreated = _showIncidentSessionCreated;
  late final String? Function() _widgetTreeCapture = _captureWidgetTree;
  final List<Uint8List> _screenshots = [];
  Offset _position = const Offset(16, 80);
  bool _expanded = false;
  bool _hidden = false;
  bool _sending = false;
  bool _settingsOpen = false;
  _AIDebugRequestType _requestType = _AIDebugRequestType.bugFix;
  String? _status;
  String? _incidentNotification;
  String? _settingsError;
  Uint8List? _preview;
  Timer? _incidentNotificationTimer;
  late AIDebugSettings _settings;
  late AIDebugSettings _draftSettings;

  @override
  void initState() {
    super.initState();
    _settings = widget.controller.settings;
    _draftSettings = _settings;
    _settingsError = null;
    WidgetsBinding.instance.addObserver(this);
    widget.controller.attachCapture(_capture);
    widget.controller._attachWidgetTree(_widgetTreeCapture);
    widget.controller._attachIncidentSessionCreated(_incidentSessionCreated);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(widget.controller.loadSettings().then((settings) {
        if (mounted) setState(() => _settings = settings);
      }));
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
    widget.controller._detachIncidentSessionCreated(_incidentSessionCreated);
    widget.controller._detachWidgetTree(_widgetTreeCapture);
    _incidentNotificationTimer?.cancel();
    unawaited(widget.controller.end());
    _textController.dispose();
    _modelTimeoutController.dispose();
    _indicatorTimeoutController.dispose();
    super.dispose();
  }

  void _showIncidentSessionCreated(String kind, String _) {
    if (!mounted) return;
    _incidentNotificationTimer?.cancel();
    setState(() {
      _incidentNotification = kind == "performance"
          ? "処理時間のしきい値超過を検出し、AIセッションを作成しました"
          : "想定外エラーを検出し、AIセッションを作成しました";
    });
    _incidentNotificationTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _incidentNotification = null);
    });
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

  String? _captureWidgetTree() {
    final root = _boundaryKey.currentContext as Element?;
    if (root == null) return null;
    final buffer = StringBuffer();
    var nodes = 0;
    var truncated = false;

    void visit(Element element, int depth) {
      if (nodes >= 300 || depth > 14 || buffer.length >= 16000) {
        truncated = true;
        return;
      }
      nodes += 1;
      buffer
        ..write(List.filled(depth, "  ").join())
        ..writeln(element.widget.runtimeType);
      element.visitChildren((child) => visit(child, depth + 1));
    }

    root.visitChildren((child) => visit(child, 0));
    if (truncated) buffer.writeln("... [TRUNCATED]");
    final result = buffer.toString().trimRight();
    return result.isEmpty ? null : result;
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
    final instruction = _buildInstruction(text);
    setState(() {
      _sending = true;
      _status = null;
    });
    try {
      final sessionId = await widget.controller.send(
        instruction,
        _screenshots,
        model: _settings.manualModel,
        permissionMode: _settings.manualPermissionMode,
      );
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

  String _buildInstruction(String text) {
    if (_requestType == _AIDebugRequestType.bugFix) return text;
    const command = "/dev:kiwame:edit";
    final firstCommand = RegExp(r"^/\S+").firstMatch(text)?.group(0);
    if (firstCommand == command) return text;
    return "$command\n\n$text";
  }

  Future<void> _persistSettings(AIDebugSettings settings) async {
    setState(() => _settings = settings);
    try {
      await widget.controller.updateSettings(settings);
    } catch (error) {
      if (mounted) setState(() => _status = "設定の保存に失敗しました: $error");
    }
  }

  void _cycleManualMode() {
    final values = AIDebugPermissionMode.values;
    final index = values.indexOf(_settings.manualPermissionMode);
    unawaited(_persistSettings(_settings.copyWith(
      manualPermissionMode: values[(index + 1) % values.length],
    )));
  }

  void _cycleRequestType() => setState(() {
        _requestType = _requestType == _AIDebugRequestType.bugFix
            ? _AIDebugRequestType.requirementsEdit
            : _AIDebugRequestType.bugFix;
      });

  void _cycleManualModel() {
    const values = [
      AIDebugModel.mythos,
      AIDebugModel.opus,
      AIDebugModel.sonnet,
      AIDebugModel.haiku,
    ];
    final index = values.indexOf(_settings.manualModel);
    unawaited(_persistSettings(_settings.copyWith(
      manualModel: values[(index + 1) % values.length],
    )));
  }

  void _openSettings() {
    _draftSettings = _settings;
    _modelTimeoutController.text = _settings.modelLoadTimeout.inMilliseconds /
                1000 ==
            _settings.modelLoadTimeout.inSeconds
        ? _settings.modelLoadTimeout.inSeconds.toString()
        : (_settings.modelLoadTimeout.inMilliseconds / 1000).toStringAsFixed(1);
    _indicatorTimeoutController
        .text = _settings.indicatorTimeout.inMilliseconds / 1000 ==
            _settings.indicatorTimeout.inSeconds
        ? _settings.indicatorTimeout.inSeconds.toString()
        : (_settings.indicatorTimeout.inMilliseconds / 1000).toStringAsFixed(1);
    setState(() => _settingsOpen = true);
  }

  Future<void> _saveSettings() async {
    final modelSeconds = double.tryParse(_modelTimeoutController.text.trim());
    final indicatorSeconds =
        double.tryParse(_indicatorTimeoutController.text.trim());
    if (modelSeconds == null ||
        indicatorSeconds == null ||
        modelSeconds <= 0 ||
        indicatorSeconds <= 0 ||
        modelSeconds > 86400 ||
        indicatorSeconds > 86400) {
      setState(
        () => _settingsError = "0より大きく86400以下の秒数を入力してください",
      );
      return;
    }
    final settings = _draftSettings.copyWith(
      modelLoadTimeout: Duration(milliseconds: (modelSeconds * 1000).round()),
      indicatorTimeout:
          Duration(milliseconds: (indicatorSeconds * 1000).round()),
    );
    setState(() => _settingsOpen = false);
    await _persistSettings(settings);
  }

  MaterialColor _modelColor(AIDebugModel model) => switch (model) {
        AIDebugModel.mythos => Colors.red,
        AIDebugModel.opus => Colors.purple,
        AIDebugModel.sonnet => Colors.orange,
        AIDebugModel.haiku => Colors.green,
      };

  IconData _modelIcon(AIDebugModel model) => switch (model) {
        AIDebugModel.mythos => Icons.workspace_premium,
        AIDebugModel.opus => Icons.star,
        AIDebugModel.sonnet => Icons.bolt,
        AIDebugModel.haiku => Icons.air,
      };

  String _modelLabel(AIDebugModel model) => switch (model) {
        AIDebugModel.mythos => "Mythos",
        AIDebugModel.opus => "Opus",
        AIDebugModel.sonnet => "Sonnet",
        AIDebugModel.haiku => "Haiku",
      };

  MaterialColor _modeColor(AIDebugPermissionMode mode) =>
      mode == AIDebugPermissionMode.plan ? Colors.blue : Colors.orange;

  IconData _modeIcon(AIDebugPermissionMode mode) =>
      mode == AIDebugPermissionMode.plan ? Icons.assignment : Icons.bolt;

  String _modeLabel(AIDebugPermissionMode mode) =>
      mode == AIDebugPermissionMode.plan ? "Plan" : "bypassPermissions";

  MaterialColor get _requestTypeColor =>
      _requestType == _AIDebugRequestType.bugFix ? Colors.red : Colors.teal;

  IconData get _requestTypeIcon => _requestType == _AIDebugRequestType.bugFix
      ? Icons.bug_report
      : Icons.edit_note;

  String get _requestTypeLabel =>
      _requestType == _AIDebugRequestType.bugFix ? "不具合修正" : "要件修正";

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
                  if (_incidentNotification != null)
                    _buildIncidentNotification(safe),
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
                  if (_settingsOpen) _buildSettingsDialog(),
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

  Widget _buildIncidentNotification(EdgeInsets safe) => Positioned(
        top: safe.top + 12,
        left: 16,
        right: 16,
        child: IgnorePointer(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Semantics(
                liveRegion: true,
                label: _incidentNotification,
                child: Material(
                  color: const Color(0xF02A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  elevation: 12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.lightGreenAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            _incidentNotification!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                    visualDensity: VisualDensity.compact,
                    tooltip: "AI Debugger設定",
                    onPressed: _sending ? null : _openSettings,
                    icon: const Icon(Icons.settings, semanticLabel: "設定"),
                  ),
                  _buildCompactSelector(
                    tooltip: "送信種別: $_requestTypeLabel",
                    semanticLabel: _requestTypeLabel,
                    color: _requestTypeColor,
                    icon: _requestTypeIcon,
                    onPressed: _sending ? null : _cycleRequestType,
                  ),
                  _buildCompactSelector(
                    tooltip:
                        "Mode: ${_modeLabel(_settings.manualPermissionMode)}",
                    semanticLabel:
                        "Mode ${_modeLabel(_settings.manualPermissionMode)}",
                    color: _modeColor(_settings.manualPermissionMode),
                    icon: _modeIcon(_settings.manualPermissionMode),
                    onPressed: _sending ? null : _cycleManualMode,
                  ),
                  _buildCompactSelector(
                    tooltip: "Model: ${_modelLabel(_settings.manualModel)}",
                    semanticLabel:
                        "Model ${_modelLabel(_settings.manualModel)}",
                    color: _modelColor(_settings.manualModel),
                    icon: _modelIcon(_settings.manualModel),
                    onPressed: _sending ? null : _cycleManualModel,
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

  Widget _buildCompactSelector({
    required String tooltip,
    required String semanticLabel,
    required MaterialColor color,
    required IconData icon,
    required VoidCallback? onPressed,
  }) =>
      Tooltip(
        message: tooltip,
        child: Semantics(
          label: semanticLabel,
          button: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  border: Border.all(color: color.withValues(alpha: 0.75)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color.shade300, size: 19),
              ),
            ),
          ),
        ),
      );

  Widget _buildSettingsDialog() => Positioned.fill(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: ColoredBox(
            color: Colors.black.withValues(alpha: 0.58),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 360, maxHeight: 560),
                child: Material(
                  color: const Color(0xF0222222),
                  borderRadius: BorderRadius.circular(16),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          const Icon(Icons.settings, size: 19),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "AI Debugger設定",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () =>
                                setState(() => _settingsOpen = false),
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              semanticLabel: "設定を閉じる",
                            ),
                          ),
                        ]),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildSettingsSection(
                                  title: "エラー時",
                                  model: _draftSettings.errorModel,
                                  mode: _draftSettings.errorPermissionMode,
                                  onModelChanged: (value) => setState(() {
                                    _draftSettings = _draftSettings.copyWith(
                                        errorModel: value);
                                  }),
                                  onModeChanged: (value) => setState(() {
                                    _draftSettings = _draftSettings.copyWith(
                                      errorPermissionMode: value,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 14),
                                _buildSettingsSection(
                                  title: "計測超過時",
                                  model: _draftSettings.performanceModel,
                                  mode:
                                      _draftSettings.performancePermissionMode,
                                  onModelChanged: (value) => setState(() {
                                    _draftSettings = _draftSettings.copyWith(
                                      performanceModel: value,
                                    );
                                  }),
                                  onModeChanged: (value) => setState(() {
                                    _draftSettings = _draftSettings.copyWith(
                                      performancePermissionMode: value,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  "超過判定時間（秒）",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Row(children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _modelTimeoutController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: "モデル読込",
                                        suffixText: "秒",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _indicatorTimeoutController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: "インジケーター",
                                        suffixText: "秒",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ]),
                                if (_settingsError != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    _settingsError!,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  setState(() => _settingsOpen = false),
                              child: const Text("キャンセル"),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: _saveSettings,
                              child: const Text("保存"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildSettingsSection({
    required String title,
    required AIDebugModel model,
    required AIDebugPermissionMode mode,
    required ValueChanged<AIDebugModel> onModelChanged,
    required ValueChanged<AIDebugPermissionMode> onModeChanged,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: AIDebugModel.values.map((value) {
              final color = _modelColor(value);
              final selected = value == model;
              return ChoiceChip(
                selected: selected,
                showCheckmark: false,
                avatar: Icon(
                  _modelIcon(value),
                  size: 16,
                  color: selected ? color.shade200 : color.shade300,
                ),
                label: Text(_modelLabel(value)),
                selectedColor: color.withValues(alpha: 0.28),
                side: BorderSide(color: color.withValues(alpha: 0.65)),
                onSelected: (_) => onModelChanged(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: AIDebugPermissionMode.values.map((value) {
              final color = _modeColor(value);
              final selected = value == mode;
              return ChoiceChip(
                selected: selected,
                showCheckmark: false,
                avatar: Icon(
                  _modeIcon(value),
                  size: 16,
                  color: selected ? color.shade200 : color.shade300,
                ),
                label: Text(_modeLabel(value)),
                selectedColor: color.withValues(alpha: 0.28),
                side: BorderSide(color: color.withValues(alpha: 0.65)),
                onSelected: (_) => onModeChanged(value),
              );
            }).toList(),
          ),
        ],
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
