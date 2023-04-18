part of masamune_agora;

class AgoraUser extends ChangeNotifier {
  AgoraUser._({
    required this.number,
    String? name,
    this.isLocalUser = false,
    String? channel,
    required AgoraController controller,
    VideoRemoteState status = VideoRemoteState.Stopped,
  })  : _channel = channel,
        _name = name,
        _controller = controller,
        _status = status;

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

  VideoRemoteState get status => _status;
  VideoRemoteState _status = VideoRemoteState.Stopped;

  void _setStatus(VideoRemoteState status) {
    if (_status == status) {
      return;
    }
    _status = status;
    notifyListeners();
  }
}
