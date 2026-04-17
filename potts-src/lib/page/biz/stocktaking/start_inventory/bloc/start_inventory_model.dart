import 'package:flutter/material.dart';

import '../../../../../common/config/config.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：棚卸開始-参数
 * 作者：熊草云
 * 时间：2023/09/25
 */
class StartInventoryModel extends WmsTableModel {
  // 克隆
  factory StartInventoryModel.clone(StartInventoryModel src) {
    StartInventoryModel dest = StartInventoryModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.context = src.context;
    dest.warehouseList = src.warehouseList;
    dest.queryWarehouseValue = src.queryWarehouseValue;
    dest.queryWarehouseId = src.queryWarehouseId;
    dest.queryDateTime = src.queryDateTime;
    dest.loadingFlag = src.loadingFlag;
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
  // 检索仓库值
  String queryWarehouseValue = '';
  // 检索仓库ID
  int queryWarehouseId = Config.NUMBER_NEGATIVE;
  // 检索时间
  String queryDateTime = '';
  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'id';
  // 升降排序
  bool ascendingFlg = true;
  // 自定义参数 - 终

  // 构造函数
  StartInventoryModel({
    // 自定义参数 - 始
    required this.context,
    this.warehouseList = const [],
    this.queryWarehouseValue = '',
    this.queryWarehouseId = Config.NUMBER_NEGATIVE,
    this.queryDateTime = '',
    this.loadingFlag = true,
    this.sortCol = 'id',
    this.ascendingFlg = true,
    // 自定义参数 - 终
  });
}
