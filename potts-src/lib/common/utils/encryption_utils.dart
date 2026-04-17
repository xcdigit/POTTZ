import 'dart:convert';

///Base64加密
class Encryption {
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  ///Base64解密
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }
}
