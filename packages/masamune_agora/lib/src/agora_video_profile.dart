part of "/masamune_agora.dart";

/// Defines the video profiles available in Agora.
///
/// This enum provides predefined video configurations with different resolutions and frame rates.
/// Each profile defines specific width, height, and frame rate combinations optimized for different use cases.
///
/// Agoraで利用可能なビデオプロファイルを定義します。
///
/// このenumは異なる解像度とフレームレートを持つ事前定義されたビデオ設定を提供します。
/// 各プロファイルは異なる用途に最適化された特定の幅、高さ、フレームレートの組み合わせを定義します。
enum AgoraVideoProfile {
  /// 160x120 resolution at 15fps - Ultra low quality for minimal bandwidth usage
  ///
  /// 160x120解像度、15fps - 最小帯域幅使用のための超低品質
  size160x120Rate15,

  /// 120x120 resolution at 15fps - Square format, ultra low quality
  ///
  /// 120x120解像度、15fps - 正方形フォーマット、超低品質
  size120x120Rate15,

  /// 320x180 resolution at 15fps - Low quality widescreen format
  ///
  /// 320x180解像度、15fps - 低品質ワイドスクリーンフォーマット
  size320x180Rate15,

  /// 180x180 resolution at 15fps - Square format, low quality
  ///
  /// 180x180解像度、15fps - 正方形フォーマット、低品質
  size180x180Rate15,

  /// 240x180 resolution at 15fps - Low quality with slightly better width
  ///
  /// 240x180解像度、15fps - わずかに幅の広い低品質
  size240x180Rate15,

  /// 320x240 resolution at 15fps - Standard low quality format
  ///
  /// 320x240解像度、15fps - 標準的な低品質フォーマット
  size320x240Rate15,

  /// 240x240 resolution at 15fps - Square format, standard low quality
  ///
  /// 240x240解像度、15fps - 正方形フォーマット、標準的な低品質
  size240x240Rate15,

  /// 424x240 resolution at 15fps - Wide low quality format
  ///
  /// 424x240解像度、15fps - ワイド低品質フォーマット
  size424x240Rate15,

  /// 640x360 resolution at 15fps - Standard definition quality
  ///
  /// 640x360解像度、15fps - 標準解像度品質
  size640x360Rate15,

  /// 360x360 resolution at 15fps - Square format, standard definition
  ///
  /// 360x360解像度、15fps - 正方形フォーマット、標準解像度
  size360x360Rate15,

  /// 640x360 resolution at 30fps - Standard definition with higher frame rate
  ///
  /// 640x360解像度、30fps - より高いフレームレートの標準解像度
  size640x360Rate30,

  /// 360x360 resolution at 30fps - Square format with higher frame rate
  ///
  /// 360x360解像度、30fps - より高いフレームレートの正方形フォーマット
  size360x360Rate30,

  /// 480x360 resolution at 15fps - Enhanced standard definition
  ///
  /// 480x360解像度、15fps - 強化された標準解像度
  size480x360Rate15,

  /// 480x360 resolution at 30fps - Enhanced standard definition with higher frame rate
  /// 480x360解像度、30fps - より高いフレームレートの強化された標準解像度
  size480x360Rate30,

  /// 640x480 resolution at 15fps - VGA quality
  ///
  /// 640x480解像度、15fps - VGA品質
  size640x480Rate15,

  /// 480x480 resolution at 15fps - Square VGA quality
  ///
  /// 480x480解像度、15fps - 正方形VGA品質
  size480x480Rate15,

  /// 640x480 resolution at 30fps - VGA quality with higher frame rate
  ///
  /// 640x480解像度、30fps - より高いフレームレートのVGA品質
  size640x480Rate30,

  /// 480x480 resolution at 30fps - Square VGA with higher frame rate
  ///
  /// 480x480解像度、30fps - より高いフレームレートの正方形VGA
  size480x480Rate30,

  /// 848x480 resolution at 15fps - Wide VGA quality
  ///
  /// 848x480解像度、15fps - ワイドVGA品質
  size848x480Rate15,

  /// 848x480 resolution at 30fps - Wide VGA with higher frame rate
  ///
  /// 848x480解像度、30fps - より高いフレームレートのワイドVGA
  size848x480Rate30,

  /// 640x480 resolution at 10fps - VGA quality with lower frame rate for bandwidth saving
  ///
  /// 640x480解像度、10fps - 帯域幅節約のための低フレームレートVGA品質
  size640x480Rate10,

  /// 1280x720 resolution at 15fps - HD quality
  ///
  /// 1280x720解像度、15fps - HD品質
  size1280x720Rate15,

  /// 1280x720 resolution at 30fps - HD quality with standard frame rate
  ///
  /// 1280x720解像度、30fps - 標準フレームレートのHD品質
  size1280x720Rate30,

  /// 960x720 resolution at 15fps - Enhanced HD quality
  ///
  /// 960x720解像度、15fps - 強化されたHD品質
  size960x720Rate15,

  /// 960x720 resolution at 30fps - Enhanced HD with standard frame rate
  ///
  /// 960x720解像度、30fps - 標準フレームレートの強化されたHD
  size960x720Rate30,

  /// 1920x1080 resolution at 15fps - Full HD quality
  ///
  /// 1920x1080解像度、15fps - フルHD品質
  size1920x1080Rate15,

  /// 1920x1080 resolution at 30fps - Full HD with standard frame rate
  ///
  /// 1920x1080解像度、30fps - 標準フレームレートのフルHD
  size1920x1080Rate30,

  /// 1920x1080 resolution at 60fps - Full HD with high frame rate for smooth video
  ///
  /// 1920x1080解像度、60fps - スムーズなビデオのための高フレームレートのフルHD
  size1920x1080Rate60;

  /// Get [VideoDimensions] in portrait mode.
  ///
  /// Returns the video dimensions when the device is in portrait orientation.
  /// The width and height values are swapped compared to landscape mode.
  ///
  /// 縦画面時の[VideoDimensions]を取得します。
  ///
  /// デバイスが縦向きの場合のビデオサイズを返します。
  /// 横画面モードと比較して幅と高さの値が入れ替わります。
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
  /// Returns the video dimensions when the device is in landscape orientation.
  /// This represents the native resolution format for most video profiles.
  ///
  /// 横画面時の[VideoDimensions]を取得します。
  ///
  /// デバイスが横向きの場合のビデオサイズを返します。
  /// これはほとんどのビデオプロファイルのネイティブ解像度フォーマットを表します。
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
  /// Returns the frames per second (FPS) for the video profile.
  /// Higher frame rates provide smoother video but require more bandwidth.
  /// Common values are 10, 15, 30, and 60 FPS.
  ///
  /// フレームレートを取得します。
  ///
  /// ビデオプロファイルの1秒あたりのフレーム数（FPS）を返します。
  /// 高いフレームレートはより滑らかなビデオを提供しますが、より多くの帯域幅が必要です。
  /// 一般的な値は10、15、30、60 FPSです。
  int get frameRate {
    switch (this) {
      case AgoraVideoProfile.size640x480Rate10:
        return 10; // Low frame rate for bandwidth conservation
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
        return 15; // Standard frame rate for most video calls
      case AgoraVideoProfile.size640x360Rate30:
      case AgoraVideoProfile.size360x360Rate30:
      case AgoraVideoProfile.size480x360Rate30:
      case AgoraVideoProfile.size640x480Rate30:
      case AgoraVideoProfile.size480x480Rate30:
      case AgoraVideoProfile.size848x480Rate30:
      case AgoraVideoProfile.size1280x720Rate30:
      case AgoraVideoProfile.size960x720Rate30:
      case AgoraVideoProfile.size1920x1080Rate30:
        return 30; // Higher frame rate for smoother video
      case AgoraVideoProfile.size1920x1080Rate60:
        return 60; // High frame rate for premium video quality
    }
  }

  /// Get the bit rate (kbps).
  ///
  /// Returns the recommended bitrate in kilobits per second for the video profile.
  /// The bit rate varies depending on the [channelProfile] as different use cases
  /// have different quality requirements.
  ///
  /// ビットレート(kbps)を取得します。
  ///
  /// ビデオプロファイルに対する推奨ビットレートをキロビット毎秒で返します。
  /// [channelProfile]によって、ビットレートが変わります。異なる用途では
  /// 異なる品質要件があるためです。
  ///
  /// コミュニケーションプロファイルはリアルタイム相互作用を最適化するために
  /// より低いビットレートを使用し、ブロードキャストプロファイルはより良い
  /// ビデオ品質のためにより高いビットレートを使用します。
  int bitrate(ChannelProfileType channelProfile) {
    switch (channelProfile) {
      // Communication profiles - optimized for real-time interaction
      // コミュニケーションプロファイル - リアルタイム相互作用に最適化
      case ChannelProfileType.channelProfileCommunication:
      case ChannelProfileType.channelProfileCommunication1v1:
        switch (this) {
          case AgoraVideoProfile.size160x120Rate15:
            return 65; // Ultra low bandwidth usage
          case AgoraVideoProfile.size120x120Rate15:
            return 50; // Minimal bandwidth for square format
          case AgoraVideoProfile.size320x180Rate15:
            return 140; // Low quality widescreen
          case AgoraVideoProfile.size180x180Rate15:
            return 100; // Low quality square format
          case AgoraVideoProfile.size240x180Rate15:
            return 120; // Slightly enhanced low quality
          case AgoraVideoProfile.size320x240Rate15:
            return 200; // Standard low quality
          case AgoraVideoProfile.size240x240Rate15:
            return 140; // Square standard quality
          case AgoraVideoProfile.size424x240Rate15:
            return 220; // Wide standard quality
          case AgoraVideoProfile.size640x360Rate15:
            return 400; // Standard definition
          case AgoraVideoProfile.size360x360Rate15:
            return 260; // Square standard definition
          case AgoraVideoProfile.size640x360Rate30:
            return 600; // Enhanced standard definition
          case AgoraVideoProfile.size360x360Rate30:
            return 400; // Square enhanced standard definition
          case AgoraVideoProfile.size480x360Rate15:
            return 320; // Enhanced standard resolution
          case AgoraVideoProfile.size480x360Rate30:
            return 490; // Higher frame rate enhanced standard
          case AgoraVideoProfile.size640x480Rate10:
            return 400; // VGA with low frame rate
          case AgoraVideoProfile.size640x480Rate15:
            return 500; // Standard VGA quality
          case AgoraVideoProfile.size640x480Rate30:
            return 750; // High frame rate VGA
          case AgoraVideoProfile.size480x480Rate15:
            return 400; // Square VGA quality
          case AgoraVideoProfile.size480x480Rate30:
            return 600; // Square high frame rate VGA
          case AgoraVideoProfile.size848x480Rate15:
            return 610; // Wide VGA quality
          case AgoraVideoProfile.size848x480Rate30:
            return 930; // Wide high frame rate VGA
          case AgoraVideoProfile.size1280x720Rate15:
            return 1130; // HD quality
          case AgoraVideoProfile.size1280x720Rate30:
            return 1710; // Standard HD
          case AgoraVideoProfile.size960x720Rate15:
            return 910; // Enhanced HD
          case AgoraVideoProfile.size960x720Rate30:
            return 1380; // Enhanced standard HD
          case AgoraVideoProfile.size1920x1080Rate15:
            return 2080; // Full HD quality
          case AgoraVideoProfile.size1920x1080Rate30:
            return 3150; // Standard Full HD
          case AgoraVideoProfile.size1920x1080Rate60:
            return 4780; // High frame rate Full HD
        }

      // Broadcasting profiles - optimized for video quality and audience viewing
      // ブロードキャストプロファイル - ビデオ品質と視聴者体験に最適化
      case ChannelProfileType.channelProfileGame:
      case ChannelProfileType.channelProfileCloudGaming:
      case ChannelProfileType.channelProfileLiveBroadcasting:
        switch (this) {
          case AgoraVideoProfile.size160x120Rate15:
            return 130; // Enhanced ultra low quality for broadcasting
          case AgoraVideoProfile.size120x120Rate15:
            return 100; // Enhanced minimal quality for broadcasting
          case AgoraVideoProfile.size320x180Rate15:
            return 280; // Enhanced low quality widescreen
          case AgoraVideoProfile.size180x180Rate15:
            return 200; // Enhanced low quality square
          case AgoraVideoProfile.size240x180Rate15:
            return 240; // Enhanced standard low quality
          case AgoraVideoProfile.size320x240Rate15:
            return 400; // Enhanced standard quality
          case AgoraVideoProfile.size240x240Rate15:
            return 280; // Enhanced square standard
          case AgoraVideoProfile.size424x240Rate15:
            return 440; // Enhanced wide standard
          case AgoraVideoProfile.size640x360Rate15:
            return 800; // Enhanced standard definition
          case AgoraVideoProfile.size360x360Rate15:
            return 520; // Enhanced square standard definition
          case AgoraVideoProfile.size640x360Rate30:
            return 1200; // Premium standard definition
          case AgoraVideoProfile.size360x360Rate30:
            return 800; // Premium square standard definition
          case AgoraVideoProfile.size480x360Rate15:
            return 640; // Enhanced standard resolution
          case AgoraVideoProfile.size480x360Rate30:
            return 980; // Premium standard resolution
          case AgoraVideoProfile.size640x480Rate10:
            return 800; // Enhanced VGA with low frame rate
          case AgoraVideoProfile.size640x480Rate15:
            return 1000; // Enhanced VGA quality
          case AgoraVideoProfile.size640x480Rate30:
            return 1500; // Premium VGA quality
          case AgoraVideoProfile.size480x480Rate15:
            return 800; // Enhanced square VGA
          case AgoraVideoProfile.size480x480Rate30:
            return 1200; // Premium square VGA
          case AgoraVideoProfile.size848x480Rate15:
            return 1220; // Enhanced wide VGA
          case AgoraVideoProfile.size848x480Rate30:
            return 1860; // Premium wide VGA
          case AgoraVideoProfile.size1280x720Rate15:
            return 2080; // Enhanced HD quality
          case AgoraVideoProfile.size1280x720Rate30:
            return 3150; // Premium HD quality
          case AgoraVideoProfile.size960x720Rate15:
            return 1800; // Enhanced custom HD
          case AgoraVideoProfile.size960x720Rate30:
            return 2640; // Premium custom HD
          case AgoraVideoProfile.size1920x1080Rate15:
            return 4160; // Enhanced Full HD
          case AgoraVideoProfile.size1920x1080Rate30:
            return 6300; // Premium Full HD
          case AgoraVideoProfile.size1920x1080Rate60:
            return 6500; // Ultra premium Full HD
        }
    }
  }
}
