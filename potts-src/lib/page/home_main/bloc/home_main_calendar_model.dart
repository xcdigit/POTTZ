import 'package:flutter/cupertino.dart';

/**
 * 内容：首页营业-参数
 * 作者：赵士淞
 * 时间：2023/11/30
 */
class HomeMainCalendarModel {
  // 克隆
  factory HomeMainCalendarModel.clone(HomeMainCalendarModel src) {
    HomeMainCalendarModel dest = HomeMainCalendarModel(
      rootContext: src.rootContext,
    );
    // 自定义参数 - 始
    dest.calendarYear = src.calendarYear;
    dest.calendarMonth = src.calendarMonth;
    dest.markedDatesMap = src.markedDatesMap;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 营业年份
  int calendarYear;
  // 营业月份
  int calendarMonth;
  // 标记日期集合
  dynamic markedDatesMap;
  // 自定义参数 - 终

  // 构造函数
  HomeMainCalendarModel({
    // 自定义参数 - 始
    required this.rootContext,
    this.calendarYear = 2000,
    this.calendarMonth = 1,
    this.markedDatesMap,
    // 自定义参数 - 终
  });
}
