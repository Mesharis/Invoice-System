import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

import '../widgets/lang.dart';

enum LanguageEnum {
  english,
  arabic,
  Swedish,
  france,
}

extension LanguageEnumExtension on LanguageEnum {
  Locale get locale {
    switch (this) {
      case LanguageEnum.english:
        return const Locale('en', 'US');
      case LanguageEnum.arabic:
        return const Locale('ar', 'SA');
        case LanguageEnum.Swedish:
        return const Locale('sv', 'SV');
        case LanguageEnum.france:
        return const Locale('fr', 'FR');
    }
  }
}




class LocalizationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ar_SA': arSA,
    'sv_SV': svSV,
    'fr_FR': frFR,
  };
}
