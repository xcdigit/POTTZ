import 'package:flutter/material.dart';
import 'wms_string_base.dart';
import 'wms_string_jp.dart';
import 'wms_string_en.dart';
import 'wms_string_zh.dart';
import 'wms_string_tw.dart';

///自定义多语言实现
class WMSLocalizations {
  final Locale locale;

  WMSLocalizations(this.locale);

  ///根据不同 locale.languageCode 加载不同语言对应
  ///GSYStringEn和GSYStringZh都继承了GSYStringBase
  static Map<String, WMSStringBase> _localizedValues = {
    // 赵士淞 - 始
    'ja_JA': new WMSStringJp(),
    'en_US': new WMSStringEn(),
    'zh_CH': new WMSStringZh(),
    'zh_TW': new WMSStringTw(),
    // 赵士淞 - 终
  };

  WMSStringBase? get currentLocalized {
    // 赵士淞 - 始
    if (_localizedValues
        .containsKey(locale.languageCode + '_' + locale.countryCode!)) {
      return _localizedValues[locale.languageCode + '_' + locale.countryCode!];
    }
    return _localizedValues["ja_JA"];
    // 赵士淞 - 终
  }

  ///通过 Localizations 加载当前的 WMSLocalizations
  ///获取对应的 GSYStringBase
  static WMSLocalizations? of(BuildContext context) {
    return Localizations.of(context, WMSLocalizations);
  }

  ///通过 Localizations 加载当前的 WMSLocalizations
  ///获取对应的 GSYStringBase
  static WMSStringBase? i18n(BuildContext context) {
    return (Localizations.of(context, WMSLocalizations) as WMSLocalizations)
        .currentLocalized;
  }
}
