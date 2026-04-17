import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'default_localizations.dart';

/**
 * 多语言代理
 * Created by yaozc
 * Date: 2023-07-01
 */
class WMSLocalizationsDelegate extends LocalizationsDelegate<WMSLocalizations> {

  WMSLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    ///支持中文和英语
    return true;
  }

  ///根据locale，创建一个对象用于提供当前locale下的文本显示
  @override
  Future<WMSLocalizations> load(Locale locale) {
    return new SynchronousFuture<WMSLocalizations>(new WMSLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<WMSLocalizations> old) {
    return false;
  }

  ///全局静态的代理
  static LocalizationsDelegate<WMSLocalizations> delegate = new WMSLocalizationsDelegate();
}
