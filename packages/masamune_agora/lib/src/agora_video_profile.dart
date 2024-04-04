part of '/masamune_agora.dart';

/// Defines the video profiles available in Agora.
///
/// Agoraで利用可能なビデオプロファイルを定義します。
enum AgoraVideoProfile {
  size160x120Rate15,
  size120x120Rate15,
  size320x180Rate15,
  size180x180Rate15,
  size240x180Rate15,
  size320x240Rate15,
  size240x240Rate15,
  size424x240Rate15,
  size640x360Rate15,
  size360x360Rate15,
  size640x360Rate30,
  size360x360Rate30,
  size480x360Rate15,
  size480x360Rate30,
  size640x480Rate15,
  size480x480Rate15,
  size640x480Rate30,
  size480x480Rate30,
  size848x480Rate15,
  size848x480Rate30,
  size640x480Rate10,
  size1280x720Rate15,
  size1280x720Rate30,
  size960x720Rate15,
  size960x720Rate30,
  size1920x1080Rate15,
  size1920x1080Rate30,
  size1920x1080Rate60;

  /// Get [VideoDimensions] in portrait mode.
  ///
  /// 縦画面時の[VideoDimensions]を取得します。
  VideoDimensions get portrait {
    switch (this) {
      case AgoraVideoProfile.size160x120Rate15:
        return const VideoDimensions(width: 120, height: 160);
      case AgoraVideoProfile.size120x120Rate15:
        return const VideoDimensions(width: 120, height: 120);
      case AgoraVideoProfile.size320x180Rate15:
        return const VideoDimensions(width: 180, height: 320);
      case AgoraVideoProfile.size180x180Rate15:
        return const VideoDimensions(width: 180, height: 180);
      case AgoraVideoProfile.size240x180Rate15:
        return const VideoDimensions(width: 180, height: 240);
      case AgoraVideoProfile.size320x240Rate15:
        return const VideoDimensions(width: 240, height: 320);
      case AgoraVideoProfile.size240x240Rate15:
        return const VideoDimensions(width: 240, height: 240);
      case AgoraVideoProfile.size424x240Rate15:
        return const VideoDimensions(width: 240, height: 424);
      case AgoraVideoProfile.size640x360Rate15:
      case AgoraVideoProfile.size640x360Rate30:
        return const VideoDimensions(width: 360, height: 640);
      case AgoraVideoProfile.size360x360Rate15:
      case AgoraVideoProfile.size360x360Rate30:
        return const VideoDimensions(width: 360, height: 360);
      case AgoraVideoProfile.size480x360Rate15:
      case AgoraVideoProfile.size480x360Rate30:
        return const VideoDimensions(width: 360, height: 480);
      case AgoraVideoProfile.size640x480Rate10:
      case AgoraVideoProfile.size640x480Rate15:
      case AgoraVideoProfile.size640x480Rate30:
        return const VideoDimensions(width: 480, height: 640);
      case AgoraVideoProfile.size480x480Rate15:
      case AgoraVideoProfile.size480x480Rate30:
        return const VideoDimensions(width: 480, height: 480);
      case AgoraVideoProfile.size848x480Rate15:
      case AgoraVideoProfile.size848x480Rate30:
        return const VideoDimensions(width: 480, height: 848);
      case AgoraVideoProfile.size1280x720Rate15:
      case AgoraVideoProfile.size1280x720Rate30:
        return const VideoDimensions(width: 720, height: 1280);
      case AgoraVideoProfile.size960x720Rate15:
      case AgoraVideoProfile.size960x720Rate30:
        return const VideoDimensions(width: 720, height: 960);
      case AgoraVideoProfile.size1920x1080Rate15:
      case AgoraVideoProfile.size1920x1080Rate30:
      case AgoraVideoProfile.size1920x1080Rate60:
        return const VideoDimensions(width: 1080, height: 1920);
    }
  }

  /// Get [VideoDimensions] in landscape mode.
  ///
  /// 横画面時の[VideoDimensions]を取得します。
  VideoDimensions get landscape {
    switch (this) {
      case AgoraVideoProfile.size160x120Rate15:
        return const VideoDimensions(width: 160, height: 120);
      case AgoraVideoProfile.size120x120Rate15:
        return const VideoDimensions(width: 120, height: 120);
      case AgoraVideoProfile.size320x180Rate15:
        return const VideoDimensions(width: 320, height: 180);
      case AgoraVideoProfile.size180x180Rate15:
        return const VideoDimensions(width: 180, height: 180);
      case AgoraVideoProfile.size240x180Rate15:
        return const VideoDimensions(width: 240, height: 180);
      case AgoraVideoProfile.size320x240Rate15:
        return const VideoDimensions(width: 320, height: 240);
      case AgoraVideoProfile.size240x240Rate15:
        return const VideoDimensions(width: 240, height: 240);
      case AgoraVideoProfile.size424x240Rate15:
        return const VideoDimensions(width: 424, height: 240);
      case AgoraVideoProfile.size640x360Rate15:
      case AgoraVideoProfile.size640x360Rate30:
        return const VideoDimensions(width: 640, height: 360);
      case AgoraVideoProfile.size360x360Rate15:
      case AgoraVideoProfile.size360x360Rate30:
        return const VideoDimensions(width: 360, height: 360);
      case AgoraVideoProfile.size480x360Rate15:
      case AgoraVideoProfile.size480x360Rate30:
        return const VideoDimensions(width: 480, height: 360);
      case AgoraVideoProfile.size640x480Rate10:
      case AgoraVideoProfile.size640x480Rate15:
      case AgoraVideoProfile.size640x480Rate30:
        return const VideoDimensions(width: 640, height: 480);
      case AgoraVideoProfile.size480x480Rate15:
      case AgoraVideoProfile.size480x480Rate30:
        return const VideoDimensions(width: 480, height: 480);
      case AgoraVideoProfile.size848x480Rate15:
      case AgoraVideoProfile.size848x480Rate30:
        return const VideoDimensions(width: 848, height: 480);
      case AgoraVideoProfile.size1280x720Rate15:
      case AgoraVideoProfile.size1280x720Rate30:
        return const VideoDimensions(width: 1280, height: 720);
      case AgoraVideoProfile.size960x720Rate15:
      case AgoraVideoProfile.size960x720Rate30:
        return const VideoDimensions(width: 960, height: 720);
      case AgoraVideoProfile.size1920x1080Rate15:
      case AgoraVideoProfile.size1920x1080Rate30:
      case AgoraVideoProfile.size1920x1080Rate60:
        return const VideoDimensions(width: 1920, height: 1080);
    }
  }

  /// Get frame rate.
  ///
  /// フレームレートを取得します。
  int get frameRate {
    switch (this) {
      case AgoraVideoProfile.size640x480Rate10:
        return 10;
      case AgoraVideoProfile.size160x120Rate15:
      case AgoraVideoProfile.size120x120Rate15:
      case AgoraVideoProfile.size320x180Rate15:
      case AgoraVideoProfile.size180x180Rate15:
      case AgoraVideoProfile.size240x180Rate15:
      case AgoraVideoProfile.size320x240Rate15:
      case AgoraVideoProfile.size240x240Rate15:
      case AgoraVideoProfile.size424x240Rate15:
      case AgoraVideoProfile.size640x360Rate15:
      case AgoraVideoProfile.size360x360Rate15:
      case AgoraVideoProfile.size480x360Rate15:
      case AgoraVideoProfile.size640x480Rate15:
      case AgoraVideoProfile.size480x480Rate15:
      case AgoraVideoProfile.size848x480Rate15:
      case AgoraVideoProfile.size960x720Rate15:
      case AgoraVideoProfile.size1280x720Rate15:
      case AgoraVideoProfile.size1920x1080Rate15:
        return 15;
      case AgoraVideoProfile.size640x360Rate30:
      case AgoraVideoProfile.size360x360Rate30:
      case AgoraVideoProfile.size480x360Rate30:
      case AgoraVideoProfile.size640x480Rate30:
      case AgoraVideoProfile.size480x480Rate30:
      case AgoraVideoProfile.size848x480Rate30:
      case AgoraVideoProfile.size1280x720Rate30:
      case AgoraVideoProfile.size960x720Rate30:
      case AgoraVideoProfile.size1920x1080Rate30:
        return 30;
      case AgoraVideoProfile.size1920x1080Rate60:
        return 60;
    }
  }

  /// Get the bit rate (kbps).
  ///
  /// The bit rate varies depending on the [channelProfile].
  ///
  /// ビットレート(kbps)を取得します。
  ///
  /// [channelProfile]によって、ビットレートが変わります。
  int bitrate(ChannelProfileType channelProfile) {
    switch (channelProfile) {
      case ChannelProfileType.channelProfileCommunication:
      case ChannelProfileType.channelProfileCommunication1v1:
        switch (this) {
          case AgoraVideoProfile.size160x120Rate15:
            return 65;
          case AgoraVideoProfile.size120x120Rate15:
            return 50;
          case AgoraVideoProfile.size320x180Rate15:
            return 140;
          case AgoraVideoProfile.size180x180Rate15:
            return 100;
          case AgoraVideoProfile.size240x180Rate15:
            return 120;
          case AgoraVideoProfile.size320x240Rate15:
            return 200;
          case AgoraVideoProfile.size240x240Rate15:
            return 140;
          case AgoraVideoProfile.size424x240Rate15:
            return 220;
          case AgoraVideoProfile.size640x360Rate15:
            return 400;
          case AgoraVideoProfile.size360x360Rate15:
            return 260;
          case AgoraVideoProfile.size640x360Rate30:
            return 600;
          case AgoraVideoProfile.size360x360Rate30:
            return 400;
          case AgoraVideoProfile.size480x360Rate15:
            return 320;
          case AgoraVideoProfile.size480x360Rate30:
            return 490;
          case AgoraVideoProfile.size640x480Rate10:
            return 400;
          case AgoraVideoProfile.size640x480Rate15:
            return 500;
          case AgoraVideoProfile.size640x480Rate30:
            return 750;
          case AgoraVideoProfile.size480x480Rate15:
            return 400;
          case AgoraVideoProfile.size480x480Rate30:
            return 600;
          case AgoraVideoProfile.size848x480Rate15:
            return 610;
          case AgoraVideoProfile.size848x480Rate30:
            return 930;
          case AgoraVideoProfile.size1280x720Rate15:
            return 1130;
          case AgoraVideoProfile.size1280x720Rate30:
            return 1710;
          case AgoraVideoProfile.size960x720Rate15:
            return 910;
          case AgoraVideoProfile.size960x720Rate30:
            return 1380;
          case AgoraVideoProfile.size1920x1080Rate15:
            return 2080;
          case AgoraVideoProfile.size1920x1080Rate30:
            return 3150;
          case AgoraVideoProfile.size1920x1080Rate60:
            return 4780;
        }
      case ChannelProfileType.channelProfileGame:
      case ChannelProfileType.channelProfileCloudGaming:
      case ChannelProfileType.channelProfileLiveBroadcasting:
        switch (this) {
          case AgoraVideoProfile.size160x120Rate15:
            return 130;
          case AgoraVideoProfile.size120x120Rate15:
            return 100;
          case AgoraVideoProfile.size320x180Rate15:
            return 280;
          case AgoraVideoProfile.size180x180Rate15:
            return 200;
          case AgoraVideoProfile.size240x180Rate15:
            return 240;
          case AgoraVideoProfile.size320x240Rate15:
            return 400;
          case AgoraVideoProfile.size240x240Rate15:
            return 280;
          case AgoraVideoProfile.size424x240Rate15:
            return 440;
          case AgoraVideoProfile.size640x360Rate15:
            return 800;
          case AgoraVideoProfile.size360x360Rate15:
            return 520;
          case AgoraVideoProfile.size640x360Rate30:
            return 1200;
          case AgoraVideoProfile.size360x360Rate30:
            return 800;
          case AgoraVideoProfile.size480x360Rate15:
            return 640;
          case AgoraVideoProfile.size480x360Rate30:
            return 980;
          case AgoraVideoProfile.size640x480Rate10:
            return 800;
          case AgoraVideoProfile.size640x480Rate15:
            return 1000;
          case AgoraVideoProfile.size640x480Rate30:
            return 1500;
          case AgoraVideoProfile.size480x480Rate15:
            return 800;
          case AgoraVideoProfile.size480x480Rate30:
            return 1200;
          case AgoraVideoProfile.size848x480Rate15:
            return 1220;
          case AgoraVideoProfile.size848x480Rate30:
            return 1860;
          case AgoraVideoProfile.size1280x720Rate15:
            return 2080;
          case AgoraVideoProfile.size1280x720Rate30:
            return 3150;
          case AgoraVideoProfile.size960x720Rate15:
            return 1800;
          case AgoraVideoProfile.size960x720Rate30:
            return 2640;
          case AgoraVideoProfile.size1920x1080Rate15:
            return 4160;
          case AgoraVideoProfile.size1920x1080Rate30:
            return 6300;
          case AgoraVideoProfile.size1920x1080Rate60:
            return 6500;
        }
    }
  }
}
