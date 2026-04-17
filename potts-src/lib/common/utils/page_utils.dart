import 'dart:async';

import 'package:flutter/material.dart';
import '/widget/never_overscroll_indicator.dart';

class PageUtils {

  ///Page页面的容器，做一次通用自定义
  static Widget pageContainer(widget, BuildContext context) {
    return MediaQuery(
        ///不受系统字体缩放影响
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: NeverOverScrollIndicator(
          needOverload: false,
          child: widget,
        ));
  }

  ///弹出 dialog
  static Future<T?> showWMSDialog<T>({
    required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder? builder,
  }) {
    return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return MediaQuery(
              ///不受系统字体缩放影响
              data: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first)
                  .copyWith(textScaleFactor: 1),
              child: NeverOverScrollIndicator(
                needOverload: false,
                child: new SafeArea(child: builder!(context)),
              ));
        });
  }
}
