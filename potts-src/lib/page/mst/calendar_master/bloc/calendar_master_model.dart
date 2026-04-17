import 'package:flutter/cupertino.dart';

import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 営業日マスタ-参数
 * 作者：赵士淞
 * 时间：2023/11/29
 */
class CalendarMasterModel extends WmsTableModel {
  // 克隆
  factory CalendarMasterModel.clone(CalendarMasterModel src) {
    CalendarMasterModel dest =
        CalendarMasterModel(rootContext: src.rootContext);
    dest.copy(src);
    // 自定义参数 - 始
    dest.loadingFlag = src.loadingFlag;
    dest.calendarCustomize = src.calendarCustomize;
    dest.selectedId = src.selectedId;
    dest.formDisable = src.formDisable;
    dest.queryButtonFlag = src.queryButtonFlag;
    dest.searchCalendarDate = src.searchCalendarDate;
    dest.searchCalendarType = src.searchCalendarType;
    dest.queryCalendarDate = src.queryCalendarDate;
    dest.queryCalendarType = src.queryCalendarType;
    dest.spCalendarId = src.spCalendarId;
    dest.spCalendarFlag = src.spCalendarFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 加载标记
  bool loadingFlag = true;
  // 营业-定制
  Map<String, dynamic> calendarCustomize = {
    'id': '',
    'calendar_date': '',
    'calendar_type': '',
    'note': '',
  };
  // 选中ID
  int selectedId = Config.NUMBER_NEGATIVE;
  // 表单禁用
  bool formDisable = false;
  // 检索按钮标记
  bool queryButtonFlag = false;
  // 查询：营业日
  String searchCalendarDate = '';
  // 查询：营业类型
  String searchCalendarType = '';
  // 检索：营业日
  String queryCalendarDate = '';
  // 检索：营业类型
  String queryCalendarType = '';
  // SP营业ID
  int spCalendarId = Config.NUMBER_NEGATIVE;
  // SP营业标记
  int spCalendarFlag = Config.NUMBER_NEGATIVE;
  //排序字段
  String sortCol = 'id';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  CalendarMasterModel({
    // 自定义参数 - 始
    required this.rootContext,
    this.loadingFlag = true,
    this.calendarCustomize = const {
      'id': '',
      'calendar_date': '',
      'calendar_type': '',
      'note': '',
    },
    this.selectedId = Config.NUMBER_NEGATIVE,
    this.formDisable = false,
    this.queryButtonFlag = false,
    this.searchCalendarDate = '',
    this.searchCalendarType = '',
    this.queryCalendarDate = '',
    this.queryCalendarType = '',
    this.spCalendarId = Config.NUMBER_NEGATIVE,
    this.spCalendarFlag = Config.NUMBER_NEGATIVE,
    this.sortCol = 'id',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
