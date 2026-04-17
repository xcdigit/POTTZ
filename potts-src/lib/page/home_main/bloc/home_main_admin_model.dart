import 'package:flutter/material.dart';

/**
 * 内容：首页（管理员）-参数
 * 作者：赵士淞
 * 时间：2024/06/25
 */
class HomeMainAdminModel {
  // 克隆
  factory HomeMainAdminModel.clone(HomeMainAdminModel src) {
    HomeMainAdminModel dest = HomeMainAdminModel(rootContext: src.rootContext);
    // 自定义参数 - 始
    dest.sales30DaysList = src.sales30DaysList;
    dest.sales3MonthsList = src.sales3MonthsList;
    dest.salesToday = src.salesToday;
    dest.registrationsToday = src.registrationsToday;
    dest.terminationsToday = src.terminationsToday;
    dest.viewersToday = src.viewersToday;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 30日销售额列表
  List<dynamic> sales30DaysList;
  // 3月销售额列表
  List<dynamic> sales3MonthsList;
  // 今日销售额
  int salesToday;
  // 今日注册数
  int registrationsToday;
  // 今日解约数
  int terminationsToday;
  // 今天阅览数
  int viewersToday;
  // 自定义参数 - 终

  // 构造函数
  HomeMainAdminModel({
    // 自定义参数 - 始
    required this.rootContext,
    this.sales30DaysList = const [],
    this.sales3MonthsList = const [],
    this.salesToday = 0,
    this.registrationsToday = 0,
    this.terminationsToday = 0,
    this.viewersToday = 0,
    // 自定义参数 - 终
  });
}
