import 'package:flutter/material.dart';

/**
 * 内容：续费-参数
 * 作者：赵士淞
 * 时间：2025/01/10
 */
class LoginRenewalModel {
  // 克隆
  factory LoginRenewalModel.clone(LoginRenewalModel src) {
    LoginRenewalModel dest = LoginRenewalModel(
      rootContext: src.rootContext,
      pageFlag: src.pageFlag,
    );
    dest.selectedLanguage = src.selectedLanguage;
    dest.languageList = src.languageList;
    dest.selectedStep = src.selectedStep;
    dest.emailAddress = src.emailAddress;
    dest.password = src.password;
    dest.campaignCode = src.campaignCode;
    dest.planList = src.planList;
    dest.role3UserNumber = src.role3UserNumber;
    dest.campaignData = src.campaignData;
    dest.userData = src.userData;
    dest.companyPlanData = src.companyPlanData;
    dest.canRenewal = src.canRenewal;
    dest.canChangeYearly = src.canChangeYearly;
    dest.verifyIndex = src.verifyIndex;
    dest.verifyCode = src.verifyCode;
    dest.selectedShipping = src.selectedShipping;
    dest.selectedEntry = src.selectedEntry;
    dest.selectedInventory = src.selectedInventory;
    dest.selectedPlanId = src.selectedPlanId;
    dest.selectedPlanAmount = src.selectedPlanAmount;
    dest.selectedAccountIndex = src.selectedAccountIndex;
    dest.selectedAccountAmount = src.selectedAccountAmount;
    dest.addAccountNumber = src.addAccountNumber;
    dest.selectedSupplyIndex = src.selectedSupplyIndex;
    dest.selectedSupplyAmount = src.selectedSupplyAmount;
    dest.selectedCycleIndex = src.selectedCycleIndex;
    dest.totalInitialAmount = src.totalInitialAmount;
    dest.totalModuleAmount = src.totalModuleAmount;
    dest.totalAccountAmount = src.totalAccountAmount;
    dest.totalSumAmount = src.totalSumAmount;
    dest.discountInitialAmount = src.discountInitialAmount;
    dest.discountModuleAmount = src.discountModuleAmount;
    dest.discountPlanAmount = src.discountPlanAmount;
    dest.discountAccountAmount = src.discountAccountAmount;
    dest.discountSupplyAmount = src.discountSupplyAmount;
    dest.discountSumAmount = src.discountSumAmount;
    dest.selectedExchangeAct = src.selectedExchangeAct;
    dest.selectedPrivacyPolicy = src.selectedPrivacyPolicy;
    dest.companyPlanOrderData = src.companyPlanOrderData;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 页面标识
  String pageFlag;
  // 选中语言
  int selectedLanguage;
  // 多语言列表
  List<Map<String, dynamic>> languageList;
  // 选中步骤
  int selectedStep;
  // 电子邮件地址
  String emailAddress;
  // 密码
  String password;
  // 活动代码
  String campaignCode;
  // 计划列表
  List<dynamic> planList;
  // 角色3用户数量
  int role3UserNumber;
  // 活动信息
  Map<String, dynamic> campaignData;
  // 用户情报
  Map<String, dynamic> userData;
  // 会社计划情报
  Map<String, dynamic> companyPlanData;
  // 能否续费
  bool canRenewal;
  // 能否改变年度项
  bool canChangeYearly;
  // 验证指数
  int verifyIndex;
  // 验证码
  String verifyCode;
  // 选中出荷管理
  bool selectedShipping;
  // 选中入荷管理
  bool selectedEntry;
  // 选中在库管理
  bool selectedInventory;
  // 选中计划ID
  int selectedPlanId;
  // 选中计划金额
  int selectedPlanAmount;
  // 选中账户指数
  int selectedAccountIndex;
  // 选中账户金额
  int selectedAccountAmount;
  // 添加账户数量
  int addAccountNumber;
  // 选中补充指数
  int selectedSupplyIndex;
  // 选中补充金额
  int selectedSupplyAmount;
  // 选中周期指数
  int selectedCycleIndex;
  // 合计初期金额
  int totalInitialAmount;
  // 合计模块金额
  int totalModuleAmount;
  // 合计账户金额
  int totalAccountAmount;
  // 合计总金额
  int totalSumAmount;
  // 折扣初期金额
  int discountInitialAmount;
  // 折扣模块金额
  int discountModuleAmount;
  // 折扣计划金额
  int discountPlanAmount;
  // 折扣账户金额
  int discountAccountAmount;
  // 折扣补充金额
  int discountSupplyAmount;
  // 折扣总金额
  int discountSumAmount;
  // 选中交易法
  bool selectedExchangeAct;
  // 选中隐私协议
  bool selectedPrivacyPolicy;
  // 会社计划订单情报
  Map<String, dynamic> companyPlanOrderData;

  // 构造函数
  LoginRenewalModel({
    required this.rootContext,
    required this.pageFlag,
    this.selectedLanguage = 2,
    this.languageList = const [],
    this.selectedStep = 1,
    this.emailAddress = '',
    this.password = '',
    this.campaignCode = '',
    this.planList = const [],
    this.role3UserNumber = 0,
    this.campaignData = const {},
    this.userData = const {},
    this.companyPlanData = const {},
    this.canRenewal = false,
    this.canChangeYearly = false,
    this.verifyIndex = 1,
    this.verifyCode = '',
    this.selectedShipping = false,
    this.selectedEntry = false,
    this.selectedInventory = false,
    this.selectedPlanId = 0,
    this.selectedPlanAmount = 0,
    this.selectedAccountIndex = 1,
    this.selectedAccountAmount = 0,
    this.addAccountNumber = 1,
    this.selectedSupplyIndex = 1,
    this.selectedSupplyAmount = 0,
    this.selectedCycleIndex = 1,
    this.totalInitialAmount = 0,
    this.totalModuleAmount = 0,
    this.totalAccountAmount = 0,
    this.totalSumAmount = 0,
    this.discountInitialAmount = 0,
    this.discountModuleAmount = 0,
    this.discountPlanAmount = 0,
    this.discountAccountAmount = 0,
    this.discountSupplyAmount = 0,
    this.discountSumAmount = 0,
    this.selectedExchangeAct = false,
    this.selectedPrivacyPolicy = false,
    this.companyPlanOrderData = const {},
  });
}
