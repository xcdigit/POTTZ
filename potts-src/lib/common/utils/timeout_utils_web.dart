import 'dart:async';
import 'dart:html';

/**
 * 超时工具类
 * 作者：赵士淞
 * 时间：2024-08-30
 */
class TimeoutUtils {
  // 定义计时器
  static late Timer timer;
  // 定义时间
  static int timeLeft = 30 * 60;

  // 初始化
  static void init() {
    // 开始计时
    startTimer();

    // 鼠标移动事件
    document.onMouseMove.listen((event) {
      // 重置时间
      timeLeft = 30 * 60;
    });

    // 键盘按下事件
    document.onKeyDown.listen((event) {
      // 重置时间
      timeLeft = 30 * 60;
    });
  }

  // 开始计时
  static void startTimer() {
    // 计时器
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // 时间减少
      timeLeft--;
      // 判断时间
      if (timeLeft <= 0) {
        // 时间到，跳转到登录页面
        window.location.href = '/login';
        // 取消计时器
        timer.cancel();
      }
    });
  }
}
