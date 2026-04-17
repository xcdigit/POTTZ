import 'package:bot_toast/bot_toast.dart';

/**
 * 内容：共通BLOC工具
 * 作者：赵士淞
 * 时间：2023/09/06
 */
class WMSCommonBlocUtils {
  // 番号补充
  static String numberSupplement(int number, int digit) {
    // 番号字符串
    String numberString = number.toString();
    // 补充位数
    int supplementDigit = digit - numberString.length;
    // 补充
    String supplement = '';
    // 判断补充位数
    if (supplementDigit > 0) {
      // 循环补充位数
      for (int i = 0; i < supplementDigit; i++) {
        // 补充
        supplement += '0';
      }
    }
    // 返回
    return supplement + number.toString();
  }

  // 提示消息提示
  static void tipTextToast(String text) {
    // 消息提示
    BotToast.showText(
      text: text,
    );
  }

  // 提示消息提示
  static void tipTextTwoSecondToast(String text) {
    // 消息提示
    BotToast.showText(text: text, duration: Duration(seconds: 2)); // 显示时长
  }

  // 成功消息提示
  static void successTextToast(String text) {
    // 消息提示
    BotToast.showText(
      text: text,
    );
  }

  // 失败消息提示
  static void errorTextToast(String text) {
    // 消息提示
    BotToast.showText(
      text: text,
      duration: null,
      clickClose: true,
    );
  }
}
