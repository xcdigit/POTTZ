/**
 * 内容：共通文件工具类
 * 作者：赵士淞
 * 时间：2023/09/13
 */
class WMSCommonFileUtils {
  // 获取完整文件名
  static String getCompleteFileName(String fileName, String fileType) {
    // 当前日期时间
    DateTime now = DateTime.now();
    // 当前年份
    int year = now.year;
    // 当前月份
    int month = now.month;
    // 当前日期
    int day = now.day;
    // 当前小时
    int hour = now.hour;
    // 当前分钟
    int minute = now.minute;
    // 当前秒数
    int second = now.second;

    return fileName +
        '_' +
        year.toString() +
        '_' +
        (month < 10 ? '0' + month.toString() : month.toString()) +
        '_' +
        (day < 10 ? '0' + day.toString() : day.toString()) +
        '_' +
        (hour < 10 ? '0' + hour.toString() : hour.toString()) +
        '_' +
        (minute < 10 ? '0' + minute.toString() : minute.toString()) +
        '_' +
        (second < 10 ? '0' + second.toString() : second.toString()) +
        fileType;
  }

  // 获取图片文件名
  static String getImageFileName(String fileType) {
    // 当前日期时间
    DateTime now = DateTime.now();
    // 当前年份
    int year = now.year;
    // 当前月份
    int month = now.month;
    // 当前日期
    int day = now.day;
    // 当前小时
    int hour = now.hour;
    // 当前分钟
    int minute = now.minute;
    // 当前秒数
    int second = now.second;
    // 当前毫秒数
    int millisecond = now.millisecond;

    return year.toString() +
        '_' +
        (month < 10 ? '0' + month.toString() : month.toString()) +
        '_' +
        (day < 10 ? '0' + day.toString() : day.toString()) +
        '_' +
        (hour < 10 ? '0' + hour.toString() : hour.toString()) +
        '_' +
        (minute < 10 ? '0' + minute.toString() : minute.toString()) +
        '_' +
        (second < 10 ? '0' + second.toString() : second.toString()) +
        '_' +
        (millisecond < 10
            ? '0' + millisecond.toString()
            : millisecond.toString()) +
        fileType;
  }

  // 获取图片质量（根据传入的图片字节长度，返回指定的图片质量）
  static int getImageQuality(int length) {
    print("压缩前图片的大小：${convertImageSize(length)}");
    // 图片质量指数
    int quality = 100;
    // 1 兆
    int m = 1024 * 1024;
    // 判断图片大小
    if (length < 0.5 * m) {
      // 图片质量指数
      quality = 70;
      print("图片小于 0.5 兆，质量设置为 70");
    } else if (length >= 0.5 * m && length < 1 * m) {
      // 图片质量指数
      quality = 60;
      print("图片大于 0.5 兆小于 1 兆，质量设置为 60");
    } else if (length >= 1 * m && length < 2 * m) {
      // 图片质量指数
      quality = 50;
      print("图片大于 1 兆小于 2 兆，质量设置为 50");
    } else if (length >= 2 * m && length < 3 * m) {
      // 图片质量指数
      quality = 40;
      print("图片大于 2 兆小于 3 兆，质量设置为 40");
    } else if (length >= 3 * m && length < 4 * m) {
      // 图片质量指数
      quality = 30;
      print("图片大于 3 兆小于 4 兆，质量设置为 30");
    } else {
      // 图片质量指数
      quality = 20;
      print("图片大于 4 兆，质量设置为 20");
    }

    return quality;
  }

  // 转换图片大小（根据传入的字节长度，转换成相应的 M 和 KB）
  static String convertImageSize(int length) {
    // 转换后大小
    String res = "";
    // 单位
    final int unit = 1024;
    // 1 兆
    final int m = unit * unit;
    // 如果小于 1 兆，显示 KB
    if (length < 1 * m) {
      // 转换后大小
      res = (length / unit).toStringAsFixed(0) + " KB";
    }
    // 如果大于 1 兆，显示 MB，并保留一位小数
    if (length >= 1 * m) {
      // 转换后大小
      res = (length / m).toStringAsFixed(1) + " MB";
    }

    return res;
  }
}
