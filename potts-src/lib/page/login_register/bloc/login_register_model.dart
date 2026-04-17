import 'package:flutter/material.dart';

/**
 * 内容：申込 -参数
 * 作者：cuihr
 * 时间：2023/12/06
 */
class LoginRegisterModel {
  factory LoginRegisterModel.copy(LoginRegisterModel src) {
    LoginRegisterModel dest = LoginRegisterModel(src.context);

    dest.selectedLanguage = src.selectedLanguage;
    dest.languageFormList = src.languageFormList;
    dest.languageList = src.languageList;
    dest.useTypeTableList = src.useTypeTableList;
    dest.formInfo = src.formInfo;
    dest.image1Network = src.image1Network;
    dest.selected = src.selected;
    dest.appTmpMap = src.appTmpMap;
    dest.superAdminEmail = src.superAdminEmail;

    return dest;
  }
  BuildContext context;
  // 右上角多语言列表
  List<Map<String, dynamic>> languageList = [];
  //多语言列表
  List<Map<String, dynamic>> languageFormList = [];
  // 表单数据
  Map<String, dynamic> formInfo = {};
  // 課金管理列表
  List<Map<String, dynamic>> useTypeTableList = [];
  // 选中语言
  int selectedLanguage = 2;
  //写真1展示路径
  String image1Network;
  //选中表格数据
  Map<String, dynamic> appTmpMap = {};

  //超级管理员邮箱
  String superAdminEmail = '';

  String selected = '';
  LoginRegisterModel(
    this.context, {
    this.languageList = const [],
    this.languageFormList = const [],
    this.useTypeTableList = const [],
    this.formInfo = const {},
    this.appTmpMap = const {},
    this.selectedLanguage = 2,
    this.image1Network = '',
    this.selected = '',
    this.superAdminEmail = '',
  });
}
