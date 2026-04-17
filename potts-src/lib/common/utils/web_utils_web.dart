import 'dart:html';

/**
 * Web端工具类
 * 作者：赵士淞
 * 时间：2025-01-17
 */
class WebUtils {
  // 后退操作监听
  static void popStateListen() {
    // 监听后退操作
    window.onPopState.listen((event) {
      window.history.go(1);
    });
  }
}
