import 'package:flutter/material.dart';
import '../../../../../common/config/config.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：棚卸照会-参数
 * 作者：熊草云
 * 时间：2023/10/07
 */
class InventoryQueryModel extends WmsTableModel {
  // 克隆
  factory InventoryQueryModel.clone(InventoryQueryModel src) {
    InventoryQueryModel dest = InventoryQueryModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.context = src.context;
    dest.warehouseList = src.warehouseList;
    dest.queryStartDate = src.queryStartDate;
    dest.queryOverDate = src.queryOverDate;
    dest.queryWarehouseValue = src.queryWarehouseValue;
    dest.queryWarehouseId = src.queryWarehouseId;
    dest.queryConfirmFlg = src.queryConfirmFlg;
    dest.sum1 = src.sum1;
    dest.sum2 = src.sum2;
    dest.sum3 = src.sum3;
    dest.loadingFlag = src.loadingFlag;
    dest.tableTabIndex = src.tableTabIndex;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext context;
  // 仓库列表
  List warehouseList = [];
  // 检索开始日期
  String queryStartDate = '';
  // 检索结束日期
  String queryOverDate = '';
  // 检索仓库值
  String queryWarehouseValue = '';
  // 检索仓库ID
  int queryWarehouseId = Config.NUMBER_NEGATIVE;
  // 检索确认标记
  List queryConfirmFlg = ['2'];
  // Tab1数量
  int sum1 = 0;
  // Tab2数量
  int sum2 = 0;
  // Tab3数量
  int sum3 = 0;
  // 加载标记
  bool loadingFlag = true;
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  //排序字段
  String sortCol = 'start_date';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  InventoryQueryModel({
    // 自定义参数 - 始
    required this.context,
    this.warehouseList = const [],
    this.queryStartDate = '',
    this.queryOverDate = '',
    this.queryWarehouseValue = '',
    this.queryWarehouseId = Config.NUMBER_NEGATIVE,
    this.queryConfirmFlg = const ['2'],
    this.sum1 = 0,
    this.sum2 = 0,
    this.sum3 = 0,
    this.loadingFlag = true,
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.sortCol = 'start_date',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
