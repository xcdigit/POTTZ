import 'package:flutter/material.dart';

import '../../../../common/config/config.dart';

/**
 * 内容：账户-参数
 * 作者：赵士淞
 * 时间：2023/09/18
 */
class AccountModel {
  // 克隆
  factory AccountModel.clone(AccountModel src) {
    AccountModel dest = AccountModel(rootContext: src.rootContext);
    dest.switchFlag = src.switchFlag;
    dest.locationFlag = src.locationFlag;
    dest.locationIndex = src.locationIndex;
    dest.languageList = src.languageList;
    dest.manageList = src.manageList;
    dest.planData = src.planData;
    dest.userCustomize = src.userCustomize;
    dest.avatarTooltipShow = src.avatarTooltipShow;
    dest.avatarNetwork = src.avatarNetwork;
    dest.tempValue = src.tempValue;
    dest.role2UserNumber = src.role2UserNumber;
    dest.role2UserMaxNumber = src.role2UserMaxNumber;
    dest.spaceUsageNumber = src.spaceUsageNumber;
    dest.spaceMaxNumber = src.spaceMaxNumber;
    dest.role3UserNumber = src.role3UserNumber;
    dest.dialogTempValue1 = src.dialogTempValue1;
    dest.dialogTempValue2 = src.dialogTempValue2;
    dest.dialogTempValue3 = src.dialogTempValue3;
    dest.cancelData = src.cancelData;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 切换标记
  bool switchFlag = false;
  // 位置标记
  bool locationFlag = false;
  // 位置下标
  int locationIndex = Config.NUMBER_ZERO;
  // 多语言列表
  List<Map<String, dynamic>> languageList = [];
  // 支付列表
  List<Map<String, dynamic>> manageList = [];
  // 计划数据
  Map<String, dynamic> planData = {};
  // 用户-定制
  Map<String, dynamic> userCustomize = {};
  // 头像提示文本显示
  bool avatarTooltipShow = false;
  // 头像线上路径
  String avatarNetwork = '';
  // 临时值
  dynamic tempValue;
  // 角色2用户数量
  int role2UserNumber;
  // 角色2用户最大数量
  int role2UserMaxNumber;
  // 空间使用数量
  double spaceUsageNumber;
  // 空间最大数量
  double spaceMaxNumber;
  // 角色3用户数量
  int role3UserNumber;
  // 弹窗临时值
  String dialogTempValue1;
  String dialogTempValue2;
  String dialogTempValue3;
  // 解约数据
  Map<String, dynamic> cancelData = {};

  // 构造函数
  AccountModel({
    required this.rootContext,
    this.switchFlag = false,
    this.locationFlag = false,
    this.locationIndex = Config.NUMBER_ZERO,
    this.languageList = const [],
    this.manageList = const [],
    this.planData = const {},
    this.userCustomize = const {},
    this.avatarTooltipShow = false,
    this.avatarNetwork = '',
    this.tempValue,
    this.role2UserNumber = Config.NUMBER_ZERO,
    this.role2UserMaxNumber = Config.NUMBER_THREE,
    this.spaceUsageNumber = 0.0,
    this.spaceMaxNumber = 0.0,
    this.role3UserNumber = Config.NUMBER_ZERO,
    this.dialogTempValue1 = '',
    this.dialogTempValue2 = '',
    this.dialogTempValue3 = '',
    this.cancelData = const {},
  });
}
