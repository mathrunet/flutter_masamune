// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element, unused_element_parameter

part of "/katana_form.dart";

abstract class _PickerLocalizationsBase {
  final Locale? locale;
  const _PickerLocalizationsBase(this.locale);
  Object? getItem(String key);
  String? get cancelText => getItem("cancelText") as String;
  String? get confirmText => getItem("confirmText") as String;
  List? get ampm => getItem("ampm") as List;
  List? get months => getItem("months") as List;
  List? get monthsLong => getItem("monthsLong") as List;
}

class _PickerLocalizations extends _PickerLocalizationsBase {
  static const _PickerLocalizations _static = _PickerLocalizations(null);
  const _PickerLocalizations(super.locale);

  @override
  Object? getItem(String key) {
    Map? localData;
    if (locale != null) {
      localData = localizedValues[locale!.languageCode];
    }
    if (localData == null) {
      return localizedValues["en"]![key];
    }
    return localData[key];
  }

  static _PickerLocalizations of(BuildContext context) {
    return Localizations.of<_PickerLocalizations>(
            context, _PickerLocalizations) ??
        _static;
  }

  static registerCustomLanguage(String name,
      {String? cancelText,
      String? confirmText,
      List<String>? ampm,
      List<String>? months,
      List<String>? monthsLong}) {
    if (name.isEmpty) {
      return;
    }
    if (ampm != null && ampm.length != 2) {
      throw Exception("ampm array length must be 2");
    }
    if (months != null && months.length != 12) {
      throw Exception("months array length must be 12");
    }
    if (monthsLong != null && monthsLong.length != 12) {
      throw Exception("monthsLong array length must be 12");
    }
    if (!languages.contains(name)) {
      languages.add(name);
    }
    final _defaultValue = localizedValues["en"]!;
    final data = {
      "cancelText": cancelText ?? _defaultValue["cancelText"] as String,
      "confirmText": cancelText ?? _defaultValue["confirmText"] as String,
      "ampm": ampm ?? _defaultValue["ampm"] as List,
    };
    if (months != null) {
      data["months"] = months;
    }
    if (monthsLong != null) {
      data["monthsLong"] = monthsLong;
    }
    localizedValues[name] = data;
  }

  /// Language Support
  static const List<String> languages = [
    "en",
    "ja",
    "zh",
    "ko",
    "it",
    "ar",
    "fr",
    "es",
    "tr",
    "ro"
  ];

  /// Language Values
  static const Map<String, Map<String, Object>> localizedValues = {
    "en": {
      "cancelText": "Cancel",
      "confirmText": "Confirm",
      "ampm": ["AM", "PM"],
    },
    "ja": {
      "cancelText": "キャンセル",
      "confirmText": "完了",
      "ampm": ["午前", "午後"],
    },
    "zh": {
      "cancelText": "取消",
      "confirmText": "确定",
      "ampm": ["上午", "下午"],
    },
    "ko": {
      "cancelText": "취소",
      "confirmText": "확인",
      "ampm": ["오전", "오후"],
    },
    "it": {
      "cancelText": "Annulla",
      "confirmText": "Conferma",
      "ampm": ["AM", "PM"],
    },
    "ar": {
      "cancelText": "إلغاء الأمر",
      "confirmText": "تأكيد",
      "ampm": ["صباحاً", "مساءً"],
    },
    "fr": {
      "cancelText": "Annuler",
      "confirmText": "Confirmer",
      "ampm": ["Matin", "Après-midi"],
    },
    "es": {
      "cancelText": "Cancelar",
      "confirmText": "Confirmar",
      "ampm": ["AM", "PM"],
    },
    "tr": {
      "cancelText": "İptal",
      "confirmText": "Onay",
      "ampm": ["ÖÖ", "ÖS"],
      "months": [
        "Oca",
        "Şub",
        "Mar",
        "Nis",
        "May",
        "Haz",
        "Tem",
        "Ağu",
        "Eyl",
        "Eki",
        "Kas",
        "Ara"
      ],
      "monthsLong": [
        "Ocak",
        "Şubat",
        "Mart",
        "Nisan",
        "Mayıs",
        "Haziran",
        "Temmuz",
        "Ağustos",
        "Eylül",
        "Ekim",
        "Kasım",
        "Aralık"
      ],
    },
    "ro": {
      "cancelText": "Anulează",
      "confirmText": "Confirmă",
      "ampm": ["AM", "PM"],
      "months": [
        "Ian",
        "Feb",
        "Mart",
        "Apr",
        "Mai",
        "Iun",
        "Iul",
        "Aug",
        "Sept",
        "Oct",
        "Nov",
        "Dec",
      ],
      "monthsLong": [
        "Ianuarie",
        "Februarie",
        "Martie",
        "Aprilie",
        "Mai",
        "Iunie",
        "Iulie",
        "August",
        "Septembrie",
        "Octombrie",
        "Noiembrie",
        "Decembrie",
      ],
    }
  };
}

class _PickerLocalizationsDelegate
    extends LocalizationsDelegate<_PickerLocalizations> {
  const _PickerLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      _PickerLocalizations.languages.contains(locale.languageCode);

  @override
  Future<_PickerLocalizations> load(Locale locale) {
    return SynchronousFuture<_PickerLocalizations>(
        _PickerLocalizations(locale));
  }

  @override
  bool shouldReload(_PickerLocalizationsDelegate old) => false;
}
