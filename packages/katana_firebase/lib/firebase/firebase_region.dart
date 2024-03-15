part of "/katana_firebase.dart";

/// Specify the Firebase region.
///
/// Firebaseのリージョンを指定します。
enum FirebaseRegion {
  /// Taiwan.
  ///
  /// 台湾。
  asiaEast1,

  /// Hong Kong.
  ///
  /// 香港。
  asiaEast2,

  /// Tokyo.
  ///
  /// 東京。
  asiaNortheast1,

  /// Osaka.
  ///
  /// 大阪。
  asiaNortheast2,

  /// Seoul.
  ///
  /// ソウル。
  asiaNortheast3,

  /// Singapore.
  ///
  /// シンガポール。
  asiaSoutheast1,

  /// Jakarta.
  ///
  /// ジャカルタ。
  asiaSoutheast2,

  /// Mumbai.
  ///
  /// ムンバイ。
  asiaSouth1,

  /// Finland.
  ///
  /// フィンランド。
  europeNorth1,

  /// Warsaw.
  ///
  /// ワルシャワ。
  europeCentral2,

  /// Belgium.
  ///
  /// ベルギー。
  europeWest1,

  /// London.
  ///
  /// ロンドン。
  europeWest2,

  /// Frankfurt.
  ///
  /// フランクフルト。
  europeWest3,

  /// Zürich.
  ///
  /// チューリッヒ。
  europeWest6,

  /// Iowa.
  ///
  /// アイオワ。
  usCentral1,

  /// South Carolina.
  ///
  /// 南カロライナ。
  usEast1,

  /// North Virginia.
  ///
  /// 北バージニア。
  usEast4,

  /// Oregon.
  ///
  /// オレゴン。
  usWest1,

  /// Los Angeles.
  ///
  /// ロサンゼルス。
  usWest2,

  /// Salt Lake City.
  ///
  /// ソルトレイクシティ。
  usWest3,

  /// Las Vegas.
  ///
  /// ラスベガス。
  usWest4,

  /// Sydney.
  ///
  /// シドニー。
  australiaSoutheast1,

  /// Melbourne.
  ///
  /// メルボルン。
  australiaSoutheast2,

  /// Montréal.
  ///
  /// モントリオール。
  northamericaNortheast1,

  /// Toronto.
  ///
  /// トロント。
  northamericaNortheast2,

  /// São Paulo.
  ///
  /// サンパウロ。
  southamericaEast1,

  /// Santiago, Chile.
  ///
  /// サンティアゴ、チリ。
  southamericaWest1;

  /// Get the actual value.
  ///
  /// 実際の値を取得します。
  String get value {
    switch (this) {
      case FirebaseRegion.asiaEast1:
        return "asia-east1";
      case FirebaseRegion.asiaEast2:
        return "asia-east2";
      case FirebaseRegion.asiaNortheast1:
        return "asia-northeast1";
      case FirebaseRegion.asiaNortheast2:
        return "asia-northeast2";
      case FirebaseRegion.europeNorth1:
        return "europe-north1";
      case FirebaseRegion.europeWest1:
        return "europe-west1";
      case FirebaseRegion.europeWest2:
        return "europe-west2";
      case FirebaseRegion.usCentral1:
        return "us-central1";
      case FirebaseRegion.usEast1:
        return "us-east1";
      case FirebaseRegion.usEast4:
        return "us-east4";
      case FirebaseRegion.usWest1:
        return "us-west1";
      case FirebaseRegion.asiaNortheast3:
        return "asia-northeast3";
      case FirebaseRegion.asiaSoutheast1:
        return "asia-southeast1";
      case FirebaseRegion.asiaSoutheast2:
        return "asia-southeast2";
      case FirebaseRegion.asiaSouth1:
        return "asia-south1";
      case FirebaseRegion.australiaSoutheast1:
        return "australia-southeast1";
      case FirebaseRegion.australiaSoutheast2:
        return "australia-southeast2";
      case FirebaseRegion.europeCentral2:
        return "europe-central2";
      case FirebaseRegion.europeWest3:
        return "europe-west3";
      case FirebaseRegion.europeWest6:
        return "europe-west6";
      case FirebaseRegion.northamericaNortheast1:
        return "northamerica-northeast1";
      case FirebaseRegion.northamericaNortheast2:
        return "northamerica-northeast2";
      case FirebaseRegion.southamericaEast1:
        return "southamerica-east1";
      case FirebaseRegion.southamericaWest1:
        return "southamerica-west1";
      case FirebaseRegion.usWest2:
        return "us-west2";
      case FirebaseRegion.usWest3:
        return "us-west3";
      case FirebaseRegion.usWest4:
        return "us-west4";
    }
  }
}
