part of "/katana_localization_annotation.dart";

/// Annotation for automatic creation of multilingualization codes based on Google spreadsheets.
///
/// Prepare a Google Spreadsheet in advance by following the steps below.
///
/// 1. You can find the spreadsheet from [template here](https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit?usp=sharing) on your Copy it to your Google Drive.
///     - You can copy from `File` -> `Make a copy`.
/// 2. In the copied spreadsheet, click `File` -> `Share` -> `Share with others`.
/// 3. In the `Share "(the name of the spreadsheet you created)"` window, change `General access` to `Anyone with the link`.
/// 4. Copy the URL displayed in your browser (e.g., `https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808`) and paste it into this and paste it into the [url] field of this annotation.
///
/// You can use the functionality for multilingualization by creating a class that inherits from `_$AppLocalize` with annotations as shown in the example below.
///
/// You can also explicitly update the translation by changing the number of [version].
///
/// If [version] is not changed, the spreadsheet contents are cached.
///
/// Googleスプレッドシートを元に多言語化コードを自動作成するためのアノテーションです。
///
/// 事前に下記の手順でGoogleスプレッドシートの準備を行います。
///
/// 1. [こちらのテンプレート](https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit?usp=sharing)からスプレッドシートを自分のGoogleドライブにコピーします。
///     - `ファイル` -> `コピーの作成`からコピーが可能です。
/// 2. コピーしたスプレッドシート内で`ファイル` -> `共有` -> `他のユーザーと共有`をクリックします。
/// 3. `（作成したスプレッドシート名）を共有`ウィンドウ内で、`一般的なアクセス`を`リンクを知っている全員`に変更します。
/// 4. ブラウザで表示されているURL（例：`https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808`）をコピーしこのアノテーションの[url]に貼り付けます。
///
/// 下記の例のようにアノテーションを付与して`_$AppLocalize`を継承したクラスを作成することで多言語化用の機能を利用することができます。
///
/// また[version]の数を変更することにより明示的に翻訳内容を更新することができます。
///
/// [version]を変更しない場合はスプレッドシートの内容がキャッシュされます。
///
/// ```dart
/// @GoogleSpreadSheetLocalize(
///   "https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808",
///   version: 1,
/// )
/// class AppLocalize extends _$AppLocalize {
/// }
///
/// final l = AppLocalize();
/// ```
class GoogleSpreadSheetLocalize {
  /// Annotation for automatic creation of multilingualization codes based on Google spreadsheets.
  ///
  /// Prepare a Google Spreadsheet in advance by following the steps below.
  ///
  /// 1. You can find the spreadsheet from [template here](https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit?usp=sharing) on your Copy it to your Google Drive.
  ///     - You can copy from `File` -> `Make a copy`.
  /// 2. In the copied spreadsheet, click `File` -> `Share` -> `Share with others`.
  /// 3. In the `Share "(the name of the spreadsheet you created)"` window, change `General access` to `Anyone with the link`.
  /// 4. Copy the URL displayed in your browser (e.g., `https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808`) and paste it into this and paste it into the [url] field of this annotation.
  ///
  /// You can use the functionality for multilingualization by creating a class that inherits from `_$AppLocalize` with annotations as shown in the example below.
  ///
  /// You can also explicitly update the translation by changing the number of [version].
  ///
  /// If [version] is not changed, the spreadsheet contents are cached.
  ///
  /// Googleスプレッドシートを元に多言語化コードを自動作成するためのアノテーションです。
  ///
  /// 事前に下記の手順でGoogleスプレッドシートの準備を行います。
  ///
  /// 1. [こちらのテンプレート](https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit?usp=sharing)からスプレッドシートを自分のGoogleドライブにコピーします。
  ///     - `ファイル` -> `コピーの作成`からコピーが可能です。
  /// 2. コピーしたスプレッドシート内で`ファイル` -> `共有` -> `他のユーザーと共有`をクリックします。
  /// 3. `（作成したスプレッドシート名）を共有`ウィンドウ内で、`一般的なアクセス`を`リンクを知っている全員`に変更します。
  /// 4. ブラウザで表示されているURL（例：`https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808`）をコピーしこのアノテーションの[url]に貼り付けます。
  ///
  /// 下記の例のようにアノテーションを付与して`_$AppLocalize`を継承したクラスを作成することで多言語化用の機能を利用することができます。
  ///
  /// また[version]の数を変更することにより明示的に翻訳内容を更新することができます。
  ///
  /// [version]を変更しない場合はスプレッドシートの内容がキャッシュされます。
  ///
  /// ```dart
  /// @GoogleSpreadSheetLocalize(
  ///   "https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808",
  ///   version: 1,
  /// )
  /// class AppLocalize extends _$AppLocalize {
  /// }
  ///
  /// final l = AppLocalize();
  /// ```
  const GoogleSpreadSheetLocalize(
    this.url, {
    required this.version,
  });

  /// Google Spreadsheet URL.
  ///
  /// Paste the URL as it appears in your browser.
  ///
  /// Example: `https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808`
  ///
  /// GoogleスプレッドシートのURL。
  ///
  /// ブラウザ上で表示しているURLをそのまま貼り付けてください。
  ///
  /// 例：`https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808`
  final String url;

  /// Google Spreadsheet Version.
  ///
  /// This can be changed to update to the new translation.
  ///
  /// Googleスプレッドシートのバージョン。
  ///
  /// これを変更することにより新しい翻訳に更新することができます。
  final int version;
}
