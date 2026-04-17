/**
 * check工具类
 * 作者：muzd
 * 时间：2024-08-24
 */
class CheckUtils {
  //略称A~Z
  static bool check_AZ4(dynamic checkItem) {
    if (RegExp(r'^[A-Z]{1,4}$').hasMatch(checkItem)) {
      return false;
    } else {
      return true;
    }
  }

  //半角英数
  static bool check_Half_Alphanumeric(dynamic checkItem) {
    if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(checkItem)) {
      return false;
    } else {
      return true;
    }
  }

  //半角英数 6到50位
  static bool check_Half_Alphanumeric_6_50(dynamic checkItem) {
    if (RegExp(r'^[a-zA-Z0-9]{6,50}$').hasMatch(checkItem)) {
      return false;
    } else {
      return true;
    }
  }

  //半角英数記号
  static bool check_Half_Alphanumeric_Symbol(dynamic checkItem) {
    if (RegExp(r"^[a-zA-Z0-9!@#%^&*()\-+=,.?':;/<>_]+$").hasMatch(checkItem)) {
      return false;
    } else {
      return true;
    }
  }

  //半角数字
  static bool check_Half_Number(dynamic checkItem) {
    if (RegExp(r'^[0-9]+$').hasMatch(checkItem.toString())) {
      return false;
    } else {
      return true;
    }
  }

  //10位内半角数字
  static bool check_Half_Number_In_10(dynamic checkItem) {
    if (RegExp(r'^[0-9]{0,9}$').hasMatch(checkItem.toString())) {
      return false;
    } else {
      return true;
    }
  }

  //3位内半角数字
  static bool check_Half_Number_In_3(dynamic checkItem) {
    if (RegExp(r'^[0-9]{0,3}$').hasMatch(checkItem.toString())) {
      return false;
    } else {
      return true;
    }
  }

  //13位半角数字
  static bool check_Half_Number_13(dynamic checkItem) {
    if (RegExp(r'^[0-9]{13}$').hasMatch(checkItem.toString())) {
      return false;
    } else {
      return true;
    }
  }

  //6位半角数字
  static bool check_Half_Number_6(dynamic checkItem) {
    if (RegExp(r'^[0-9]{6}$').hasMatch(checkItem.toString())) {
      return false;
    } else {
      return true;
    }
  }

  //半角数字和ハイフン
  static bool check_Half_Number_Hyphen(dynamic checkItem) {
    if (RegExp(r'^[\d-]+$').hasMatch(checkItem)) {
      return false;
    } else {
      return true;
    }
  }

  //EMAIL
  static bool check_Email(dynamic checkItem) {
    if (RegExp(r'\w[-\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\.)+[A-Za-z]{2,14}')
        .hasMatch(checkItem)) {
      return false;
    } else {
      return true;
    }
  }

  //カナ
  static bool check_Kana(dynamic checkItem) {
    // 2025.01.16前验证：r'^[ァ-ンー　]+$'
    if (RegExp(r"^[ｦ-ﾟa-zA-Z0-9!@#%^&*()\-+=,.?':;/<>_]+$")
        .hasMatch(checkItem)) {
      return false;
    } else {
      return true;
    }
  }

  //密码
  static bool check_Password(dynamic checkItem) {
    if (RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$').hasMatch(checkItem)) {
      return false;
    } else {
      return true;
    }
  }

  // 邮编
  static bool check_Postal(dynamic checkItem) {
    if (RegExp(r'^[0-9]{3}-[0-9]{4}$').hasMatch(checkItem)) {
      return false;
    } else {
      return true;
    }
  }
}
