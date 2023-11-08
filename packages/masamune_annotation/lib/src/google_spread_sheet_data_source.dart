part of '/masamune_annotation.dart';

/// Create a data source adapter based on a Google spreadsheet.
///
/// Prepare a Google Spreadsheet in advance by following the steps below.
///
/// 1. You can create your own spreadsheets from [Template for Collection](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0) or [Template for Documents Copy the spreadsheet from [Template for Collection](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=1740139650) or [Template for Documents](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=1740139650) to your Copy the spreadsheet to your Google Drive.
///     - You can copy from `File` -> `Make a copy`.
/// 2. In the copied spreadsheet, click `File` -> `Share` -> `Share with others`.
/// 3. In the `Share "(the name of the spreadsheet you created)"` window, change `General access` to `Anyone with the link`.
/// 4. Copy the URL displayed in your browser (e.g., `https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0`) and paste it into this and paste it into the [source] field of this annotation.
///
/// You can create a data model using Google Spreadsheets as the data source by annotating it with [CollectionModelPath] or [DocumentModelPath] as shown in the example below.
/// The type of data to be defined is determined by the [CollectionModelPath] or [DocumentModelPath], so please select the appropriate template to handle.
///
/// You can also explicitly update the content by changing the number of [version].
///
/// If [version] is not changed, the spreadsheet contents are cached.
///
/// Googleスプレッドシートを元にデータソースアダプターを作成します。
///
/// 事前に下記の手順でGoogleスプレッドシートの準備を行います。
///
/// 1. [Collection用のテンプレート](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0)もしくは[Documents用のテンプレート](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=1740139650)からスプレッドシートを自分のGoogleドライブにコピーします。
///     - `ファイル` -> `コピーの作成`からコピーが可能です。
/// 2. コピーしたスプレッドシート内で`ファイル` -> `共有` -> `他のユーザーと共有`をクリックします。
/// 3. `（作成したスプレッドシート名）を共有`ウィンドウ内で、`一般的なアクセス`を`リンクを知っている全員`に変更します。
/// 4. ブラウザで表示されているURL（例：`https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0`）をコピーしこのアノテーションの[source]に貼り付けます。
///
/// 下記の例のようにアノテーションを付与して[CollectionModelPath]もしくは[DocumentModelPath]を合わせて付与することでGoogleスプレッドシートをデータソースとしたデータモデルを作成することができます。
/// 定義するデータの種類は[CollectionModelPath]もしくは[DocumentModelPath]によって決定されますので扱うテンプレートは適切に選択してください。
///
/// また[version]の数を変更することにより明示的に内容を更新することができます。
///
/// [version]を変更しない場合はスプレッドシートの内容がキャッシュされます。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("category")
/// @GoogleSpreadSheetDataSource(
///   "https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0",
///   version: 1,
/// )
/// class CategoryModel with _$CategoryModel {
///   const factory CategoryModel({
///     @Default("") String name,
///     @Default("") String description,
///   }) = _CategoryModel;
///   const CategoryModel._();
///
///   factory CategoryModel.fromJson(Map<String, Object?> json) => _$CategoryModelFromJson(json);
///
///   static const document = _$CategoryModelDocumentQuery();
///
///   static const collection = _$CategoryModelCollectionQuery();
/// }
/// ```
class GoogleSpreadSheetDataSource {
  /// Create a data source adapter based on a Google spreadsheet.
  ///
  /// Prepare a Google Spreadsheet in advance by following the steps below.
  ///
  /// 1. You can create your own spreadsheets from [Template for Collection](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0) or [Template for Documents Copy the spreadsheet from [Template for Collection](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=1740139650) or [Template for Documents](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=1740139650) to your Copy the spreadsheet to your Google Drive.
  ///     - You can copy from `File` -> `Make a copy`.
  /// 2. In the copied spreadsheet, click `File` -> `Share` -> `Share with others`.
  /// 3. In the `Share "(the name of the spreadsheet you created)"` window, change `General access` to `Anyone with the link`.
  /// 4. Copy the URL displayed in your browser (e.g., `https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0`) and paste it into this and paste it into the [source] field of this annotation.
  ///
  /// You can create a data model using Google Spreadsheets as the data source by annotating it with [CollectionModelPath] or [DocumentModelPath] as shown in the example below.
  /// The type of data to be defined is determined by the [CollectionModelPath] or [DocumentModelPath], so please select the appropriate template to handle.
  ///
  /// You can also explicitly update the content by changing the number of [version].
  ///
  /// If [version] is not changed, the spreadsheet contents are cached.
  ///
  /// Googleスプレッドシートを元にデータソースアダプターを作成します。
  ///
  /// 事前に下記の手順でGoogleスプレッドシートの準備を行います。
  ///
  /// 1. [Collection用のテンプレート](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0)もしくは[Documents用のテンプレート](https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=1740139650)からスプレッドシートを自分のGoogleドライブにコピーします。
  ///     - `ファイル` -> `コピーの作成`からコピーが可能です。
  /// 2. コピーしたスプレッドシート内で`ファイル` -> `共有` -> `他のユーザーと共有`をクリックします。
  /// 3. `（作成したスプレッドシート名）を共有`ウィンドウ内で、`一般的なアクセス`を`リンクを知っている全員`に変更します。
  /// 4. ブラウザで表示されているURL（例：`https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0`）をコピーしこのアノテーションの[source]に貼り付けます。
  ///
  /// 下記の例のようにアノテーションを付与して[CollectionModelPath]もしくは[DocumentModelPath]を合わせて付与することでGoogleスプレッドシートをデータソースとしたデータモデルを作成することができます。
  /// 定義するデータの種類は[CollectionModelPath]もしくは[DocumentModelPath]によって決定されますので扱うテンプレートは適切に選択してください。
  ///
  /// また[version]の数を変更することにより明示的に内容を更新することができます。
  ///
  /// [version]を変更しない場合はスプレッドシートの内容がキャッシュされます。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @CollectionModelPath("category")
  /// @GoogleSpreadSheetDataSource(
  ///   "https://docs.google.com/spreadsheets/d/1bfNX8clPH9PFOcfFIStNCGNGjeCKwGv-24iChSJn8yM/edit#gid=0",
  ///   version: 1,
  /// )
  /// class CategoryModel with _$CategoryModel {
  ///   const factory CategoryModel({
  ///     @Default("") String name,
  ///     @Default("") String description,
  ///   }) = _CategoryModel;
  ///   const CategoryModel._();
  ///
  ///   factory CategoryModel.fromJson(Map<String, Object?> json) => _$CategoryModelFromJson(json);
  ///
  ///   static const document = _$CategoryModelDocumentQuery();
  ///
  ///   static const collection = _$CategoryModelCollectionQuery();
  /// }
  /// ```
  const GoogleSpreadSheetDataSource(
    this.source, {
    required this.version,
    this.idKey = "id",
    this.direct = false,
    this.direction = GoogleSpreadSheetDataSourceDirection.horizontal,
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
  final String source;

  /// Google Spreadsheet Version.
  ///
  /// This can be changed to update the data.
  ///
  /// Googleスプレッドシートのバージョン。
  ///
  /// これを変更することによりデータに更新することができます。
  final int version;

  /// Key for ID.
  ///
  /// ID用のキー。
  final String idKey;

  /// `true` if you want to download directly from the URL when the app is launched.
  ///
  /// If `false`, build_runner will embed CSV data into the source code.
  ///
  /// アプリ起動時に直接URLからダウンロードする場合は`true`。
  ///
  /// `false`にするとbuild_runnerにてCSVデータをソースコードに埋め込みます。
  final bool direct;

  /// Orientation for using data source for documents at [GoogleSpreadSheetDataSource].
  ///
  /// [GoogleSpreadSheetDataSource]にてドキュメント用のデータソースを利用する場合の向き。
  final GoogleSpreadSheetDataSourceDirection direction;
}

/// Orientation for using data source for documents at [GoogleSpreadSheetDataSource].
///
/// [GoogleSpreadSheetDataSource]にてドキュメント用のデータソースを利用する場合の向き。
enum GoogleSpreadSheetDataSourceDirection {
  /// Horizontal.
  ///
  /// 横向き。
  horizontal,

  /// Vertical.
  ///
  /// 縦向き。
  vertical;
}
