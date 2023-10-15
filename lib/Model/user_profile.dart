import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import '../widgets/language.dart';

class UserProfile {
  static final shared = UserProfile();
  final _box = GetStorage();
  LanguageEnum? language;

  Future<LanguageEnum?> getLanguage() async {
    try {
      LanguageEnum? lang = _box.read('language') == null
          ? null
          : LanguageEnum.values[_box.read('language')];

      language = lang;

      return lang;
    } catch (e) {
      return null;
    }
  }
  setLanguage({required LanguageEnum lang}) async {
    try {
      await _box.write('language', lang.index);
    } catch (e) {
      log(e.toString());
    }
  }
}
