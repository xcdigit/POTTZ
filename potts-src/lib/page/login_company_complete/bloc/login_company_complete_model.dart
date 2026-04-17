import 'package:flutter/material.dart';

/**
 * 内容：登录公司完整性-参数
 * 作者：赵士淞
 * 时间：2024/12/16
 */
class LoginCompanyCompleteModel {
  // 克隆
  factory LoginCompanyCompleteModel.clone(LoginCompanyCompleteModel src) {
    LoginCompanyCompleteModel dest = LoginCompanyCompleteModel(
      rootContext: src.rootContext,
    );
    dest.selectedLanguage = src.selectedLanguage;
    dest.languageList = src.languageList;
    dest.companyData = src.companyData;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 选中语言
  int selectedLanguage;
  // 多语言列表
  List<Map<String, dynamic>> languageList;
  // 公司数据
  Map<String, dynamic> companyData;

  // 构造函数
  LoginCompanyCompleteModel({
    required this.rootContext,
    this.selectedLanguage = 2,
    this.languageList = const [],
    this.companyData = const {},
  });
}
