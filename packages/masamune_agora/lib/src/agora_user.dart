part of masamune_agora;

class AgoraUser extends ChangeNotifier {
  AgoraUser._({
    required this.number,
    String? name,
    this.isLocalUser = false,
    String? channel,
    required AgoraController controller,
  })  : _channel = channel,
        _name = name,
        _controller = controller;

  final int number;
  final bool isLocalUser;
  final AgoraController _controller;

  String? get channel => _channel;
  String? _channel;

  void _setChannel(String channel) {
    if (_channel == channel) {
      return;
    }
    _channel = channel;
    notifyListeners();
  }

  String? get name => _name;
  String? _name;

  void _setName(String name) {
    if (_name == name) {
      return;
    }
    _name = name;
    notifyListeners();
  }

  VideoRemoteState get remoteState => _remoteState;
  VideoRemoteState _remoteState = VideoRemoteState.Stopped;

  void _setRemoteState(VideoRemoteState remoteState) {
    if (_remoteState == remoteState) {
      return;
    }
    _remoteState = remoteState;
    notifyListeners();
  }
}
