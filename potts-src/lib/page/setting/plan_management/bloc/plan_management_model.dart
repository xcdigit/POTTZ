import 'package:flutter/material.dart';

import '../../../../common/config/config.dart';

/**
 * 内容：计划管理-参数
 * 作者：赵士淞
 * 时间：2024/06/27
 */
class PlanManagementModel {
  // 克隆
  factory PlanManagementModel.clone(PlanManagementModel src) {
    PlanManagementModel dest = PlanManagementModel(
        rootContext: src.rootContext, currentMenuIndex: src.currentMenuIndex);
    dest.planList = src.planList;
    dest.selectPlanIndex = src.selectPlanIndex;
    dest.selectPlan = src.selectPlan;
    dest.selectPlanName = src.selectPlanName;
    dest.detailPageSign = src.detailPageSign;
    dest.dialogTempValue = src.dialogTempValue;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 当前菜单下标
  int currentMenuIndex;
  // 计划列表
  List<Map<String, dynamic>> planList;
  // 选中计划下标
  int selectPlanIndex;
  // 选中计划
  Map<String, dynamic> selectPlan;
  // 选中计划名称
  String selectPlanName;
  // 详情页面标记
  int detailPageSign;
  // 弹窗临时值
  String dialogTempValue;

  // 构造函数
  PlanManagementModel({
    required this.rootContext,
    required this.currentMenuIndex,
    this.planList = const [],
    this.selectPlanIndex = Config.NUMBER_NEGATIVE,
    this.selectPlan = const {},
    this.selectPlanName = '',
    this.detailPageSign = Config.NUMBER_NEGATIVE,
    this.dialogTempValue = '',
  });
}
