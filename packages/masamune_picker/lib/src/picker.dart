part of masamune_picker;

/// Provides a file picker function.
///
/// The file picker function defined in [MasamunePickerAdapter] is available.
///
/// By default, a [FilePickerAdapter] is used, which can utilize the functionality of the `file_picker` package.
///
/// You can pick up a single file with [pickSingle] and multiple files with [pickMultiple].
///
/// With [pickCamera], you can start the mobile camera and pick up the media files you have taken.
/// (Compatible adapters only)
///
/// ファイルピッカー機能を提供します。
///
/// [MasamunePickerAdapter]で定義されたファイルピッカー機能を利用可能です。
///
/// デフォルトの場合、`file_picker`パッケージの機能を利用できる[FilePickerAdapter]が使用されます。
///
/// [pickSingle]で単数のファイルをピックアップでき、[pickMultiple]で複数ファイルをピックアップできます。
///
/// [pickCamera]でモバイルのカメラを起動し撮影したメディアファイルをピックアップすることができます。
/// （対応アダプターのみ）
class Picker extends ChangeNotifier {
  /// Provides a file picker function.
  ///
  /// The file picker function defined in [MasamunePickerAdapter] is available.
  ///
  /// By default, a [FilePickerAdapter] is used, which can utilize the functionality of the `file_picker` package.
  ///
  /// You can pick up a single file with [pickSingle] and multiple files with [pickMultiple].
  ///
  /// With [pickCamera], you can start the mobile camera and pick up the media files you have taken.
  /// (Compatible adapters only)
  ///
  /// ファイルピッカー機能を提供します。
  ///
  /// [MasamunePickerAdapter]で定義されたファイルピッカー機能を利用可能です。
  ///
  /// デフォルトの場合、`file_picker`パッケージの機能を利用できる[FilePickerAdapter]が使用されます。
  ///
  /// [pickSingle]で単数のファイルをピックアップでき、[pickMultiple]で複数ファイルをピックアップできます。
  ///
  /// [pickCamera]でモバイルのカメラを起動し撮影したメディアファイルをピックアップすることができます。
  /// （対応アダプターのみ）
  Picker({MasamunePickerAdapter? adapter}) : _adapter = adapter;

  /// [MasamunePickerAdapter] to be used.
  ///
  /// If not specified, [MasamunePickerAdapter.primary] is used.
  ///
  /// 使用する[MasamunePickerAdapter]。
  ///
  /// 指定されない場合は[MasamunePickerAdapter.primary]が利用されます。
  MasamunePickerAdapter get adapter {
    return _adapter ?? MasamunePickerAdapter.primary;
  }

  final MasamunePickerAdapter? _adapter;

  /// It is possible to wait while the file is being picked up.
  ///
  /// ファイルをピックアップしている間待つことが可能です。
  Future<void>? get future => _completer?.future;

  Completer<void>? _completer;

  /// Pick up a single file.
  ///
  /// It is possible to specify the title of the file dialog to be picked up with [dialogTitle].
  ///
  /// You can restrict the type of file by specifying [type].
  ///
  /// 単一のファイルをピックアップします。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルを指定することが可能です。
  ///
  /// [type]を指定するとファイルの種類を制限することができます。
  Future<PickerValue> pickSingle({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    try {
      _completer = Completer();
      final res = await adapter.pickSingle(
        dialogTitle: dialogTitle,
        type: type,
      );
      notifyListeners();
      _completer?.complete();
      _completer = null;
      return res;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Pick up multiple files.
  ///
  /// It is possible to specify the title of the file dialog to be picked up with [dialogTitle].
  ///
  /// You can restrict the type of file by specifying [type].
  ///
  /// 複数のファイルをピックアップします。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルを指定することが可能です。
  ///
  /// [type]を指定するとファイルの種類を制限することができます。
  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    try {
      _completer = Completer();
      final res = await adapter.pickMultiple(
        dialogTitle: dialogTitle,
        type: type,
      );
      notifyListeners();
      _completer?.complete();
      _completer = null;
      return res;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Start the camera and pick up the captured media file.
  ///
  /// It is possible to specify the title of the file dialog to be picked up with [dialogTitle].
  ///
  /// You can restrict the type of file by specifying [type].
  ///
  /// カメラを起動し、撮影したメディアファイルをピックアップします。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルを指定することが可能です。
  ///
  /// [type]を指定するとファイルの種類を制限することができます。
  Future<PickerValue> pickCamera({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    try {
      _completer = Completer();
      final res = await adapter.pickCamera(
        dialogTitle: dialogTitle,
        type: type,
      );
      notifyListeners();
      _completer?.complete();
      _completer = null;
      return res;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }
}
