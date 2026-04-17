import 'package:flutter/material.dart';

import '../../../../../common/config/config.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：棚卸照会明细-参数
 * 作者：熊草云
 * 时间：2023/10/07
 * 作者：赵士淞
 * 时间：2023/10/26
 */
class InventoryQueryDetailModel extends WmsTableModel {
  // 克隆
  factory InventoryQueryDetailModel.clone(InventoryQueryDetailModel src) {
    InventoryQueryDetailModel dest = InventoryQueryDetailModel(
        rootContext: src.rootContext, detailId: src.detailId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.inventoryInfo = src.inventoryInfo;
    dest.queryButtonFlag = src.queryButtonFlag;
    dest.locationList = src.locationList;
    dest.searchLocationLocCd = src.searchLocationLocCd;
    dest.searchProductCode = src.searchProductCode;
    dest.searchProductName = src.searchProductName;
    dest.searchDetailDiffKbn = src.searchDetailDiffKbn;
    dest.searchDetailEndKbn = src.searchDetailEndKbn;
    dest.queryLocationLocCd = src.queryLocationLocCd;
    dest.queryProductCode = src.queryProductCode;
    dest.queryProductName = src.queryProductName;
    dest.queryDetailDiffKbn = src.queryDetailDiffKbn;
    dest.queryDetailEndKbn = src.queryDetailEndKbn;
    dest.tableTabIndex = src.tableTabIndex;
    dest.loadingFlag = src.loadingFlag;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 明细ID
  int detailId;
  // 棚卸信息
  dynamic inventoryInfo = {
    'id': '',
    'warehouse_id': '',
    'warehouse_name': '',
    'start_date': '',
    'confirm_date': '',
    'confirm_flg': '',
    'total_real_num': 0,
    'total_logic_num': 0,
    'total_diff_num': 0,
    'total_all_logic_num': 0,
    'progress': 0,
    'confirm_name': '',
  };
  // 检索按钮标记
  bool queryButtonFlag = false;
  // 位置列表
  List locationList = [];
  // 查询：位置代码
  String searchLocationLocCd = '';
  // 查询：商品代码
  String searchProductCode = '';
  // 查询：商品名称
  String searchProductName = '';
  // 查询：差異チェック
  String searchDetailDiffKbn = '';
  // 查询：完了チェック
  String searchDetailEndKbn = '';
  // 检索：位置代码
  String queryLocationLocCd = '';
  // 检索：商品代码
  String queryProductCode = '';
  // 检索：商品名称
  String queryProductName = '';
  // 检索：差異チェック
  String queryDetailDiffKbn = '';
  // 检索：完了チェック
  String queryDetailEndKbn = '';
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  // 加载标记
  bool loadingFlag = true;
  // 自定义参数 - 终

  // 构造函数
  InventoryQueryDetailModel({
    // 自定义参数 - 始
    required this.rootContext,
    required this.detailId,
    this.inventoryInfo = const {
      'id': '',
      'warehouse_id': '',
      'warehouse_name': '',
      'start_date': '',
      'confirm_date': '',
      'confirm_flg': '',
      'total_real_num': 0,
      'total_logic_num': 0,
      'total_diff_num': 0,
      'total_all_logic_num': 0,
      'progress': 0,
      'confirm_name': '',
    },
    this.queryButtonFlag = false,
    this.locationList = const [],
    this.searchLocationLocCd = '',
    this.searchProductCode = '',
    this.searchProductName = '',
    this.searchDetailDiffKbn = '',
    this.searchDetailEndKbn = '',
    this.queryLocationLocCd = '',
    this.queryProductCode = '',
    this.queryProductName = '',
    this.queryDetailDiffKbn = '',
    this.queryDetailEndKbn = '',
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.loadingFlag = true,
    // 自定义参数 - 终
  });
}
