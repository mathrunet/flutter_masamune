part of "cer.dart";

/// If the *.cer is over 300 days old, it will output an Exception to prompt for an update.
///
/// *.cerが300日を過ぎている場合アップデートを促すExceptionを出力します。Lefthookなどに組み込んで下さい。
class CerCheckCliCommand extends CliCommand {
  /// If the *.cer is over 300 days old, it will output an Exception to prompt for an update.
  ///
  /// *.cerが300日を過ぎている場合アップデートを促すExceptionを出力します。Lefthookなどに組み込んで下さい。
  const CerCheckCliCommand();

  @override
  String get description =>
      "If the *.cer is over 300 days old, it will output an Exception to prompt for an update. *.cerが300日を過ぎている場合アップデートを促すExceptionを出力します。Lefthookなどに組み込んで下さい。";

  @override
  Future<void> exec(ExecContext context) async {
    final regExp = RegExp(r".cer$");
    final cer = await find(Directory("ios"), regExp);
    if (cer == null) {
      throw Exception(
        "Could not find the cer file in the IOS folder. First create a `CertificateSigningRequest.certSigningRequest` from `katana app csr` and download it from https://mathru.notion.site/AppStoreConnect-ID-f516ff1a767146f69acd6780fbcf20fe to download the cer file to your IOS folder.",
      );
    }
    final dateTime = await cer.lastModified();
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 300) {
      throw Exception(
        "Cer file is too old. Please update it from https://mathru.notion.site/AppStoreConnect-ID-f516ff1a767146f69acd6780fbcf20fe",
      );
    }
  }
}
