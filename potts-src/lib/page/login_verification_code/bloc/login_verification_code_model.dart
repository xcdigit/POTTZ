import 'package:flutter/material.dart';

/**
 * 内容：登录验证码-参数
 * 作者：赵士淞
 * 时间：2024/12/13
 */
class LoginVerificationCodeModel {
  // 克隆
  factory LoginVerificationCodeModel.clone(LoginVerificationCodeModel src) {
    LoginVerificationCodeModel dest = LoginVerificationCodeModel(
      rootContext: src.rootContext,
    );
    dest.userData = src.userData;
    dest.selectedLanguage = src.selectedLanguage;
    dest.languageList = src.languageList;
    dest.verifyIndex = src.verifyIndex;
    dest.verifyCode = src.verifyCode;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 用户数据
  Map<String, dynamic> userData;
  // 选中语言
  int selectedLanguage;
  // 多语言列表
  List<Map<String, dynamic>> languageList;
  // 验证指数
  int verifyIndex;
  // 验证码
  String verifyCode;

  // 构造函数
  LoginVerificationCodeModel({
    required this.rootContext,
    this.userData = const {
      'email': '',
      'authenticator_key': '',
    },
    this.selectedLanguage = 2,
    this.languageList = const [],
    this.verifyIndex = 1,
    this.verifyCode = '',
  });
}
