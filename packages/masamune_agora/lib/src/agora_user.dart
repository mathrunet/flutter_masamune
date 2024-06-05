part of '/masamune_agora.dart';

/// Class that holds information on the currently connected user.
///
/// Set the user number issued by Agora.io in [number] and the user name specified here in [name].
///
/// [isLocalUser] sets whether the user is your own user or not.
///
/// Set the name of the currently connected channel in [channel].
///
/// Set the current connection status in [status].
///
/// 現在接続しているユーザーの情報を保持するクラス。
///
/// [number]にAgora.ioから発行されたユーザー番号、[name]にこちらで指定したユーザー名を設定します。
///
/// [isLocalUser]は自分自身のユーザーかどうかを設定します。
///
/// [channel]には現在接続しているチャンネル名を設定します。
///
/// [status]には現在の接続状態を設定します。
class AgoraUser extends ChangeNotifier {
  AgoraUser._({
    required this.number,
    String? name,
    this.isLocalUser = false,
    String? channel,
    required AgoraController controller,
    RemoteVideoState status = RemoteVideoState.remoteVideoStateStopped,
  })  : _channel = channel,
        _name = name,
        _controller = controller,
        _status = status;

  final AgoraController _controller;

  /// User number issued by Agora.io.
  ///
  /// Agora.ioから発行されたユーザー番号。
  final int number;

  /// Whether you are your own user or not.
  ///
  /// If `true`, it is your own user.
  ///
  /// 自分自身のユーザーかどうか。
  ///
  /// `true`の場合、自分自身のユーザーです。
  final bool isLocalUser;

  /// Name of the currently connected channel.
  ///
  /// 現在接続しているチャンネル名。
  String? get channel => _channel;
  String? _channel;

  void _setChannel(String channel) {
    if (_channel == channel) {
      return;
    }
    _channel = channel;
    notifyListeners();
  }

  /// User Name.
  ///
  /// ユーザー名。
  String? get name => _name;
  String? _name;

  void _setName(String name) {
    if (_name == name) {
      return;
    }
    _name = name;
    notifyListeners();
  }

  /// Current connection status.
  ///
  /// 現在の接続状態。
  RemoteVideoState get status => _status;
  RemoteVideoState _status = RemoteVideoState.remoteVideoStateStopped;

  void _setStatus(RemoteVideoState status) {
    if (_status == status) {
      return;
    }
    _status = status;
    notifyListeners();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode =>
      number.hashCode ^
      isLocalUser.hashCode ^
      channel.hashCode ^
      name.hashCode ^
      status.hashCode;
}
