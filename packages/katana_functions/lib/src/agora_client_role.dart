part of katana_functions;

/// Client role used by Agora.io.
///
/// Agora.ioで用いるClientの役割。
enum AgoraClientRole {
  /// Distributor.
  ///
  /// 配信者。
  broadcaster,

  /// Viewer.
  ///
  /// 視聴者。
  audience,
}
