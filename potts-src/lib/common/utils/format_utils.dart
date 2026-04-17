import 'package:intl/intl.dart';

/**
 * 格式化工具类
 * 作者：赵士淞
 * 时间：2024-12-06
 */
class FormatUtils {
  // 金额格式化
  static String amountFormat(int amount) {
    // 判断金额
    if (amount < 1000) {
      return amount.toString();
    } else {
      var numberFormat = NumberFormat('0,000');
      return numberFormat.format(amount);
    }
  }

  // 日期时间格式化
  static String dateTimeFormat(String dateTimeString) {
    // 日期时间
    DateTime dateTime = DateTime.parse(dateTimeString);
    // 定义目标格式
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    // 转换日期时间到目标格式
    return dateFormat.format(dateTime);
  }
}
