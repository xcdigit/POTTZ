import 'package:flutter/material.dart';

import '../../../../common/config/config.dart';

/**
 * 内容：法人管理-参数
 * 作者：赵士淞
 * 时间：2024/06/25
 */
class CorporateManagementModel {
  // 克隆
  factory CorporateManagementModel.clone(CorporateManagementModel src) {
    CorporateManagementModel dest = CorporateManagementModel(
        rootContext: src.rootContext, currentMenuIndex: src.currentMenuIndex);
    dest.detailPageSign = src.detailPageSign;
    dest.userList = src.userList;
    dest.searchContent = src.searchContent;
    dest.userTypeList = src.userTypeList;
    dest.searchUserTypeIndex = src.searchUserTypeIndex;
    dest.selectUserIndex = src.selectUserIndex;
    dest.currentTabIndex = src.currentTabIndex;
    dest.role2UserNumber = src.role2UserNumber;
    dest.role2UserMaxNumber = src.role2UserMaxNumber;
    dest.spaceUsageNumber = src.spaceUsageNumber;
    dest.spaceMaxNumber = src.spaceMaxNumber;
    dest.role3UserNumber = src.role3UserNumber;
    dest.role3UserMaxNumber = src.role3UserMaxNumber;
    dest.applicationTmpData = src.applicationTmpData;
    dest.dialogTempValue1 = src.dialogTempValue1;
    dest.dialogTempValue2 = src.dialogTempValue2;
    dest.dialogTempValue3 = src.dialogTempValue3;
    dest.companyName = src.companyName;
    dest.personCharge = src.personCharge;
    dest.emailAddress = src.emailAddress;
    dest.phoneNumber = src.phoneNumber;
    dest.campaignCode = src.campaignCode;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 当前菜单下标
  int currentMenuIndex;
  // 详情页面标记
  int detailPageSign;
  // 用户列表
  List<dynamic> userList;
  // 搜索内容
  String searchContent;
  // 用户类型列表
  List<dynamic> userTypeList;
  // 搜索用户类型下标
  int searchUserTypeIndex;
  // 选中用户下标
  int selectUserIndex;
  // 当前标签下标
  int currentTabIndex;
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
  // 角色3用户最大数量
  int role3UserMaxNumber;
  // 临时申请数据
  Map<String, dynamic> applicationTmpData;
  // 弹窗临时值
  String dialogTempValue1;
  String dialogTempValue2;
  String dialogTempValue3;
  // 公司名称
  String companyName;
  // 联系人姓名
  String personCharge;
  // 电子邮件地址
  String emailAddress;
  // 电话号码
  String phoneNumber;
  // 活动代码
  String campaignCode;

  // 构造函数
  CorporateManagementModel({
    required this.rootContext,
    required this.currentMenuIndex,
    this.detailPageSign = Config.NUMBER_NEGATIVE,
    this.userList = const [],
    this.searchContent = '',
    this.userTypeList = const [
      {
        'index': Config.NUMBER_ZERO,
        'title': '新着順',
      },
      {
        'index': Config.NUMBER_ONE,
        'title': '古い順',
      }
    ],
    this.searchUserTypeIndex = Config.NUMBER_NEGATIVE,
    this.selectUserIndex = Config.NUMBER_NEGATIVE,
    this.currentTabIndex = Config.NUMBER_ZERO,
    this.role2UserNumber = Config.NUMBER_ZERO,
    this.role2UserMaxNumber = Config.NUMBER_THREE,
    this.spaceUsageNumber = 0.0,
    this.spaceMaxNumber = 0.0,
    this.role3UserNumber = Config.NUMBER_ZERO,
    this.role3UserMaxNumber = Config.NUMBER_THREE,
    this.applicationTmpData = const {},
    this.dialogTempValue1 = '',
    this.dialogTempValue2 = '',
    this.dialogTempValue3 = '',
    this.companyName = '',
    this.personCharge = '',
    this.emailAddress = '',
    this.phoneNumber = '',
    this.campaignCode = '',
  });
}
