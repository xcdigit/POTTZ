import 'package:flutter/material.dart';

import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：受払照会-参数
 * 作者：熊草云
 * 时间：2023/09/22
 */
class RevenueAndExpenditureModel extends WmsTableModel {
  // 克隆
  factory RevenueAndExpenditureModel.clone(RevenueAndExpenditureModel src) {
    RevenueAndExpenditureModel dest =
        RevenueAndExpenditureModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.context = src.context;
    dest.warehouse = src.warehouse;
    dest.warehouseList = src.warehouseList;
    dest.action = src.action;
    dest.actionList = src.actionList;
    dest.searchwarehouse = src.searchwarehouse;
    dest.searchaction = src.searchaction;
    dest.searchproductName = src.searchproductName;
    dest.searchdate = src.searchdate;
    dest.conditionList = src.conditionList;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext context;
  Map<String, dynamic> warehouse = {};
  List warehouseList = [];
  Map<String, dynamic> action = {};
  List actionList = [];
  // 检索条件参数
  String? searchwarehouse;
  String? searchaction;
  String? searchproductName;
  String? searchdate;
  // 检索条件集合
  List<String> conditionList = [];
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'id';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  RevenueAndExpenditureModel({
    // 自定义参数 - 始
    required this.context,
    this.warehouse = const {},
    this.warehouseList = const [],
    this.action = const {},
    this.actionList = const [],
    this.searchwarehouse,
    this.searchaction,
    this.searchproductName,
    this.searchdate,
    this.conditionList = const [],
    this.loadingFlag = true,
    this.sortCol = 'id',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
