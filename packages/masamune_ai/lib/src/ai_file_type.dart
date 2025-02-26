part of '/masamune_ai.dart';

/// The file type of the AI.
///
/// AIのファイルタイプ。
enum AIFileType {
  /// Text file type.
  ///
  /// テキストファイルタイプ。
  txt,

  /// PNG file type.
  ///
  /// PNGファイルタイプ。
  png,

  /// JPEG file type.
  ///
  /// JPEGファイルタイプ。
  jpeg,

  /// WebP file type.
  ///
  /// WebPファイルタイプ。
  webp,

  /// MP4 video file type.
  ///
  /// MP4動画ファイルタイプ。
  mp4Video,

  /// QuickTime video file type.
  ///
  /// QuickTime動画ファイルタイプ。
  mov,

  /// MP3 audio file type.
  ///
  /// MP3音声ファイルタイプ。
  mp3,

  /// MPEG-4 audio file type.
  ///
  /// MPEG-4音声ファイルタイプ。
  mp4Audio,

  /// MPEG-4 audio file type.
  ///
  /// MPEG-4音声ファイルタイプ。
  m4a,

  /// WAV audio file type.
  ///
  /// WAV音声ファイルタイプ。
  wav,

  /// PDF file type.
  ///
  /// PDFファイルタイプ。
  pdf;

  /// The AI file type from the mime type.
  ///
  /// MIMEタイプからAIファイルタイプを取得します。
  static AIFileType? fromMimeType(String mimeType) {
    switch (mimeType) {
      case "text/plain":
        return txt;
      case "image/png":
        return png;
      case "image/jpeg":
        return jpeg;
      case "image/webp":
        return webp;
      case "video/mp4":
        return mp4Video;
      case "video/quicktime":
        return mov;
      case "audio/mpeg":
        return mp3;
      case "audio/mp4":
        return mp4Audio;
      case "audio/m4a":
        return m4a;
      case "audio/wav":
        return wav;
      case "application/pdf":
        return pdf;
      default:
        return null;
    }
  }

  /// The mime type of the AI file type.
  ///
  /// AIファイルタイプのMIMEタイプ。
  String get mimeType {
    switch (this) {
      case txt:
        return "text/plain";
      case png:
        return "image/png";
      case jpeg:
        return "image/jpeg";
      case webp:
        return "image/webp";
      case mp4Video:
        return "video/mp4";
      case mov:
        return "video/quicktime";
      case mp3:
        return "audio/mpeg";
      case mp4Audio:
        return "audio/mp4";
      case m4a:
        return "audio/m4a";
      case wav:
        return "audio/wav";
      case pdf:
        return "application/pdf";
    }
  }
}
