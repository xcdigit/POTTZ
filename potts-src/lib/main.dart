import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
// import 'package:wms/common/config/nonweb_url_strategy.dart'
//     if (dart.library.html) 'package:wms/common/config/web_url_strategy.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app.dart';

import 'common/utils/web_utils_other.dart'
    if (dart.library.html) 'common/utils/web_utils_web.dart';
import 'page/error_page.dart';

Future<void> main() async {
  if (kIsWeb) {
    // 后退操作监听
    WebUtils.popStateListen();
  }
  // WidgetsFlutterBinding.ensureInitialized();
  // setUrlStrategy(PathUrlStrategy());

  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runZonedGuarded(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
      return ErrorPage();
    };
    // configureUrl();
    setPathUrlStrategy();

    runApp(FlutterReduxApp());

    ///屏幕刷新率和显示率不一致时的优化，必须挪动到 runApp 之后
    GestureBinding.instance.resamplingEnabled = true;
  }, (Object obj, StackTrace stack) {
    // TODO ErrorLog未处理
    // print(obj);
    // print(stack);
  });
}
