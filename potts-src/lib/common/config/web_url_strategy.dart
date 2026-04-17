import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void configureUrl() {
  ///禁用浏览器导航栈堆
  setUrlStrategy(null);
}
