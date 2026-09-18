part of "/masamune_handover.dart";

/// Widget that switches the application UI according to the current [HandoverConfig].
///
/// Placed automatically by [HandoverMasamuneAdapter.onBuildApp]. Displays a full-screen maintenance page in [HandoverMode.maintenance] and an announcement banner in [HandoverMode.announce].
///
/// 現在の[HandoverConfig]に応じてアプリケーションUIを切り替えるウィジェット。
///
/// [HandoverMasamuneAdapter.onBuildApp]によって自動的に配置されます。[HandoverMode.maintenance]では全画面メンテナンスページ、[HandoverMode.announce]では告知バナーを表示します。
class HandoverGate extends StatefulWidget {
  /// Widget that switches the application UI according to the current [HandoverConfig].
  ///
  /// 現在の[HandoverConfig]に応じてアプリケーションUIを切り替えるウィジェット。
  const HandoverGate({
    required this.adapter,
    required this.child,
    super.key,
  });

  /// The adapter that holds the current configuration.
  ///
  /// 現在の設定を保持するアダプター。
  final HandoverMasamuneAdapter adapter;

  /// The application widget.
  ///
  /// アプリケーションウィジェット。
  final Widget child;

  @override
  State<HandoverGate> createState() => _HandoverGateState();
}

class _HandoverGateState extends State<HandoverGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && widget.adapter.recheckOnResume) {
      unawaited(widget.adapter.reload());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HandoverConfig>(
      valueListenable: widget.adapter.config,
      builder: (context, config, _) {
        switch (config.mode) {
          case HandoverMode.maintenance:
            return _wrapOverlay(
              widget.adapter.maintenanceBuilder?.call(context, config) ??
                  HandoverMaintenance(config: config),
            );
          case HandoverMode.announce:
            return Stack(
              textDirection: TextDirection.ltr,
              children: [
                widget.child,
                _wrapOverlay(
                  Align(
                    alignment: Alignment.topCenter,
                    child:
                        widget.adapter.announceBuilder?.call(context, config) ??
                            HandoverAnnounceBanner(config: config),
                  ),
                ),
              ],
            );
          case HandoverMode.readonly:
          case HandoverMode.normal:
            return widget.child;
        }
      },
    );
  }

  Widget _wrapOverlay(Widget child) {
    // The overlay is placed outside of MaterialApp,
    // so Directionality and MediaQuery must be provided here.
    // オーバーレイはMaterialAppの外側に配置されるため、
    // DirectionalityとMediaQueryをここで提供する必要がある。
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery.fromView(
        view: View.of(context),
        child: child,
      ),
    );
  }
}

/// Default full-screen maintenance page.
///
/// デフォルトの全画面メンテナンスページ。
class HandoverMaintenance extends StatelessWidget {
  /// Default full-screen maintenance page.
  ///
  /// デフォルトの全画面メンテナンスページ。
  const HandoverMaintenance({
    required this.config,
    super.key,
  });

  /// The currently active configuration.
  ///
  /// 現在有効な設定。
  final HandoverConfig config;

  @override
  Widget build(BuildContext context) {
    final locale = View.of(context).platformDispatcher.locale;
    final message = config.messageFor(locale);
    final estimatedEndAt = config.estimatedEndAt;
    return ColoredBox(
      color: const Color(0xFF212121),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.build_circle_outlined,
                size: 64,
                color: Color(0xFFBDBDBD),
              ),
              const SizedBox(height: 24),
              Text(
                message.isEmpty ? "Under maintenance" : message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 16,
                ),
              ),
              if (estimatedEndAt != null) ...[
                const SizedBox(height: 16),
                Text(
                  estimatedEndAt.toLocal().toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Default announcement banner displayed at the top of the application.
///
/// アプリケーション上部に表示されるデフォルトの告知バナー。
class HandoverAnnounceBanner extends StatefulWidget {
  /// Default announcement banner displayed at the top of the application.
  ///
  /// アプリケーション上部に表示されるデフォルトの告知バナー。
  const HandoverAnnounceBanner({
    required this.config,
    super.key,
  });

  /// The currently active configuration.
  ///
  /// 現在有効な設定。
  final HandoverConfig config;

  @override
  State<HandoverAnnounceBanner> createState() => _HandoverAnnounceBannerState();
}

class _HandoverAnnounceBannerState extends State<HandoverAnnounceBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) {
      return const SizedBox.shrink();
    }
    final locale = View.of(context).platformDispatcher.locale;
    final message = widget.config.messageFor(locale);
    if (message.isEmpty) {
      return const SizedBox.shrink();
    }
    final padding = MediaQuery.paddingOf(context);
    return Material(
      color: const Color(0xE6212121),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, padding.top + 8, 8, 8),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 20,
              color: Color(0xFFEEEEEE),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 13,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 20,
                color: Color(0xFFEEEEEE),
              ),
              onPressed: () {
                setState(() {
                  _dismissed = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
