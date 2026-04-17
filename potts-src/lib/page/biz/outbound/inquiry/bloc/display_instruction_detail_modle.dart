import 'package:flutter/material.dart';

import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：出荷指示照会-参数
 * 作者：熊草云
 * 时间：2023/09/07
 */
class DisplayInstructionDetailModel extends WmsTableModel {
  // 克隆
  factory DisplayInstructionDetailModel.clone(
      DisplayInstructionDetailModel src) {
    DisplayInstructionDetailModel dest =
        DisplayInstructionDetailModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.context = src.context;
    dest.shipId = src.shipId;
    dest.shipDetail = src.shipDetail;
    dest.shipDetailvalue = src.shipDetailvalue;
    dest.sum = src.sum;
    dest.count = src.count;
    dest.deleteSuccess = src.deleteSuccess;
    dest.reFlag = src.reFlag;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext context;
  // 出荷id
  int shipId = 0;
  // 明细页面判断
  bool detail = false;
  // 出荷明细ID
  Map<String, dynamic> shipDetail = {};
  // 明细数据行
  Map<String, dynamic> shipDetailvalue = {};
  // 小计总和
  // 赵士淞 - 测试修复 2023/11/17 - 始
  double sum = 0;
  // 赵士淞 - 测试修复 2023/11/17 - 终
  int count = 0;
  bool deleteSuccess = false;
  int reFlag = 0;
  // 担当者列表
  // 构造函数
  DisplayInstructionDetailModel({
    // 自定义参数 - 始
    required this.context,
    this.shipId = 0,
    this.shipDetail = const {},
    this.shipDetailvalue = const {},
    this.sum = 0,
    this.count = 0,
    this.deleteSuccess = false,
    this.reFlag = 0,
    // 自定义参数 - 终
  });
}
