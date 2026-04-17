// forbidden_utils

/**
 * 禁用工具类
 * 作者：赵士淞
 * 时间：2024-08-19
 */
class ForbiddenUtils {
  // 禁用文言列表
  static List<String> forbiddenTextList = [
    "女子供",
  ];

  // 检查文本
  static String checkText(String text) {
    // 全空格和回车check
    text = checkALLSpaceAndBreak(text);
    // 检查合法字符
    text = checkLegalCharacters(text);
    // 检查长文本是否包含字符串列表中的任何内容
    text = containsAny(text);
    return text;
  }

  // 全空格和回车check
  static String checkALLSpaceAndBreak(String text) {
    RegExp regExp = RegExp(r'^[\s\n]+$');
    if (regExp.hasMatch(text)) {
      return '';
    } else {
      return text;
    }
  }

  // 检查合法字符
  static String checkLegalCharacters(String text) {
    // 构建正则表达式
    // 日文半角假名范围：[ぁ-ゞｦ-ﾟ]
    // 中文范围：[\u4e00-\u9fa5]
    // 英文范围：[a-zA-Z]
    // 数字范围：[0-9]
    // 日文全角数字：[\uFF10-\uFF19]
    // 日文全角范围：[\u3040-\u309f\u30a0-\u30ff]
    // 标点符号：[!@#%^&*()\-+=,.?:;/<>_]
    // 空白字符：[\s]
    String regex =
        '[^ぁ-ゞｦ-ﾟ\\u4e00-\\u9fa5a-zA-Z0-9\\u3040-\\u309f\\u30a0-\\u30ff\\uFF10-\\uFF19!@#%^&*()\\-+=,.?:;/<>_\\s"\\\$\'~|`\\\{\\\}\\\[\\\]￥]';
    // 使用正则表达式替换所有不匹配的字符串为空字符串
    return text.replaceAllMapped(
        RegExp(regex, caseSensitive: false), (match) => '');
  }

  // 检查长文本是否包含字符串列表中的任何内容
  static String containsAny(String text) {
    bool checkFlag =
        forbiddenTextList.any((forbiddenText) => text.contains(forbiddenText));
    if (checkFlag) {
      return removeAll(text);
    } else {
      return text;
    }
  }

  // 删除长文本中含字符串列表中的所有内容
  static String removeAll(String text) {
    // 将字符串列表转换为正则表达式的或条件
    final regexPattern = forbiddenTextList
        .map((forbiddenText) => RegExp.escape(forbiddenText))
        .join('|');
    final regex = RegExp(regexPattern, multiLine: true, caseSensitive: false);
    // 使用正则表达式替换所有匹配的字符串为空字符串
    return text.replaceAll(regex, '');
  }
}
