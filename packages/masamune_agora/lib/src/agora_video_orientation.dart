part of masamune_agora;

enum AgoraVideoOrientation {
  landscape,

  portrait;

  VideoOutputOrientationMode toVideoOutputOrientationMode() {
    switch (this) {
      case AgoraVideoOrientation.landscape:
        return VideoOutputOrientationMode.FixedLandscape;
      case AgoraVideoOrientation.portrait:
        return VideoOutputOrientationMode.FixedPortrait;
    }
  }
}
