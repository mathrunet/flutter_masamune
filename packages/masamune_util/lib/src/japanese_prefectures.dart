/// ENUM of prefectures in Japan.
///
/// 日本の都道府県のenum。
enum JapanesePrefectures {
  hokkaido,
  aomori,
  iwate,
  miyagi,
  akita,
  yamagata,
  fukushima,
  ibaraki,
  tochigi,
  gunma,
  saitama,
  chiba,
  tokyo,
  kanagawa,
  niigata,
  toyama,
  ishikawa,
  fukui,
  yamanashi,
  nagano,
  gifu,
  shizuoka,
  aichi,
  mie,
  shiga,
  kyoto,
  osaka,
  hyogo,
  nara,
  wakayama,
  tottori,
  shimane,
  okayama,
  hiroshima,
  yamaguchi,
  tokushima,
  kagawa,
  ehime,
  kochi,
  fukuoka,
  saga,
  nagasaki,
  kumamoto,
  oita,
  miyazaki,
  kagoshima,
  okinawa,
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
