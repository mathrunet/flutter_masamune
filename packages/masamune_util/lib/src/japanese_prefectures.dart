/// ENUM of prefectures in Japan.
///
/// 日本の都道府県のenum。
enum JapanesePrefectures {
  /// Hokkaido.
  ///
  /// 北海道。
  hokkaido,

  /// Aomori.
  ///
  /// 青森県。
  aomori,

  /// Iwate.
  ///
  /// 岩手県。
  iwate,

  /// Miyagi.
  ///
  /// 宮城県。
  miyagi,

  /// Akita.
  ///
  /// 秋田県。
  akita,

  /// Yamagata.
  ///
  /// 山形県。
  yamagata,

  /// Fukushima.
  ///
  /// 福島県。
  fukushima,

  /// Ibaraki.
  ///
  /// 茨城県。
  ibaraki,

  /// Tochigi.
  ///
  /// 栃木県。
  tochigi,

  /// Gunma.
  ///
  /// 群馬県。
  gunma,

  /// Saitama.
  ///
  /// 埼玉県。
  saitama,

  /// Chiba.
  ///
  /// 千葉県。
  chiba,

  /// Tokyo.
  ///
  /// 東京都。
  tokyo,

  /// Kanagawa.
  ///
  /// 神奈川県。
  kanagawa,

  /// Niigata.
  ///
  /// 新潟県。
  niigata,

  /// Toyama.
  ///
  /// 富山県。
  toyama,

  /// Ishikawa.
  ///
  /// 石川県。
  ishikawa,

  /// Fukui.
  ///
  /// 福井県。
  fukui,

  /// Yamanashi.
  ///
  /// 山梨県。
  yamanashi,

  /// Nagano.
  ///
  /// 長野県。
  nagano,

  /// Gifu.
  ///
  /// 岐阜県。
  gifu,

  /// Shizuoka.
  ///
  /// 静岡県。
  shizuoka,

  /// Aichi.
  ///
  /// 愛知県。
  aichi,

  /// Mie.
  ///
  /// 三重県。
  mie,

  /// Shiga.
  ///
  /// 滋賀県。
  shiga,

  /// Kyoto.
  ///
  /// 京都府。
  kyoto,

  /// Osaka.
  ///
  /// 大阪府。
  osaka,

  /// Hyogo.
  ///
  /// 兵庫県。
  hyogo,

  /// Nara.
  ///
  /// 奈良県。
  nara,

  /// Wakayama.
  ///
  /// 和歌山県。
  wakayama,

  /// Tottori.
  ///
  /// 鳥取県。
  tottori,

  /// Shimane.
  ///
  /// 島根県。
  shimane,

  /// Okayama.
  ///
  /// 岡山県。
  okayama,

  /// Hiroshima.
  ///
  /// 広島県。
  hiroshima,

  /// Yamaguchi.
  ///
  /// 山口県。
  yamaguchi,

  /// Tokushima.
  ///
  /// 徳島県。
  tokushima,

  /// Kagawa.
  ///
  /// 香川県。
  kagawa,

  /// Ehime.
  ///
  /// 愛媛県。
  ehime,

  /// Kochi.
  ///
  /// 高知県。
  kochi,

  /// Fukuoka.
  ///
  /// 福岡県。
  fukuoka,

  /// Saga.
  ///
  /// 佐賀県。
  saga,

  /// Nagasaki.
  ///
  /// 長崎県。
  nagasaki,

  /// Kumamoto.
  ///
  /// 熊本県。
  kumamoto,

  /// Oita.
  ///
  /// 大分県。
  oita,

  /// Miyazaki.
  ///
  /// 宮崎県。
  miyazaki,

  /// Kagoshima.
  ///
  /// 鹿児島県。
  kagoshima,

  /// Okinawa.
  ///
  /// 沖縄県。
  okinawa,

  /// Others.
  ///
  /// 海外。
  others;

  /// Prefectural labels.
  ///
  /// 都道府県のラベル。
  String get label {
    switch (this) {
      case JapanesePrefectures.hokkaido:
        return "北海道";
      case JapanesePrefectures.aomori:
        return "青森県";
      case JapanesePrefectures.iwate:
        return "岩手県";
      case JapanesePrefectures.miyagi:
        return "宮城県";
      case JapanesePrefectures.akita:
        return "秋田県";
      case JapanesePrefectures.yamagata:
        return "山形県";
      case JapanesePrefectures.fukushima:
        return "福島県";
      case JapanesePrefectures.ibaraki:
        return "茨城県";
      case JapanesePrefectures.tochigi:
        return "栃木県";
      case JapanesePrefectures.gunma:
        return "群馬県";
      case JapanesePrefectures.saitama:
        return "埼玉県";
      case JapanesePrefectures.chiba:
        return "千葉県";
      case JapanesePrefectures.tokyo:
        return "東京都";
      case JapanesePrefectures.kanagawa:
        return "神奈川県";
      case JapanesePrefectures.niigata:
        return "新潟県";
      case JapanesePrefectures.toyama:
        return "富山県";
      case JapanesePrefectures.ishikawa:
        return "石川県";
      case JapanesePrefectures.fukui:
        return "福井県";
      case JapanesePrefectures.yamanashi:
        return "山梨県";
      case JapanesePrefectures.nagano:
        return "長野県";
      case JapanesePrefectures.gifu:
        return "岐阜県";
      case JapanesePrefectures.shizuoka:
        return "静岡県";
      case JapanesePrefectures.aichi:
        return "愛知県";
      case JapanesePrefectures.mie:
        return "三重県";
      case JapanesePrefectures.shiga:
        return "滋賀県";
      case JapanesePrefectures.kyoto:
        return "京都府";
      case JapanesePrefectures.osaka:
        return "大阪府";
      case JapanesePrefectures.hyogo:
        return "兵庫県";
      case JapanesePrefectures.nara:
        return "奈良県";
      case JapanesePrefectures.wakayama:
        return "和歌山県";
      case JapanesePrefectures.tottori:
        return "鳥取県";
      case JapanesePrefectures.shimane:
        return "島根県";
      case JapanesePrefectures.okayama:
        return "岡山県";
      case JapanesePrefectures.hiroshima:
        return "広島県";
      case JapanesePrefectures.yamaguchi:
        return "山口県";
      case JapanesePrefectures.tokushima:
        return "徳島県";
      case JapanesePrefectures.kagawa:
        return "香川県";
      case JapanesePrefectures.ehime:
        return "愛媛県";
      case JapanesePrefectures.kochi:
        return "高知県";
      case JapanesePrefectures.fukuoka:
        return "福岡県";
      case JapanesePrefectures.saga:
        return "佐賀県";
      case JapanesePrefectures.nagasaki:
        return "長崎県";
      case JapanesePrefectures.kumamoto:
        return "熊本県";
      case JapanesePrefectures.oita:
        return "大分県";
      case JapanesePrefectures.miyazaki:
        return "宮崎県";
      case JapanesePrefectures.kagoshima:
        return "鹿児島県";
      case JapanesePrefectures.okinawa:
        return "沖縄県";
      case JapanesePrefectures.others:
        return "海外";
    }
  }
}
