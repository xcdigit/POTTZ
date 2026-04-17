import 'package:flutter/material.dart';

import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：出荷確定データ出力-参数
 * 作者：熊草云
 * 时间：2023/09/20
 */
class ShipmentConfirmationExportModel extends WmsTableModel {
  // 克隆
  factory ShipmentConfirmationExportModel.clone(
      ShipmentConfirmationExportModel src) {
    ShipmentConfirmationExportModel dest =
        ShipmentConfirmationExportModel(context: src.context);

    dest.copy(src);
    // 自定义参数 - 始
    dest.context = src.context;
    dest.searchDate = src.searchDate;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext context;
  String searchDate = '';
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  ShipmentConfirmationExportModel({
    required this.context,
    this.searchDate = '',
    this.loadingFlag = true,
    this.sortCol = 'rcv_sch_date',
    this.ascendingFlg = false,
  });
}
