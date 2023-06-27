part of masamune_mail;

/// [MasamuneAdapter] for configuring the mail function.
///
/// メール機能を設定するための[MasamuneAdapter]。
class MailMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for configuring the mail function.
  ///
  /// メール機能を設定するための[MasamuneAdapter]。
  const MailMasamuneAdapter();

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<MailMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
