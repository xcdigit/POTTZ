import 'package:flutter/material.dart';

import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：入荷指示照会-参数
 * 作者：赵士淞
 * 时间：2023/09/27
 */
class InquiryScheduleDetailsModel extends WmsTableModel {
  // 克隆
  factory InquiryScheduleDetailsModel.clone(InquiryScheduleDetailsModel src) {
    InquiryScheduleDetailsModel dest = InquiryScheduleDetailsModel(
        rootContext: src.rootContext, receiveId: src.receiveId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.supplierList = src.supplierList;
    dest.productList = src.productList;
    dest.receiveCustomize = src.receiveCustomize;
    dest.receiveDetailCustomize = src.receiveDetailCustomize;
    dest.loadingFlag = src.loadingFlag;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 入荷指示ID
  int receiveId;
  // 供应商列表
  List<dynamic> supplierList = [];
  // 商品列表
  List<dynamic> productList = [];
  // 入荷指示-定制
  Map<String, dynamic> receiveCustomize = {};
  // 入荷指示明细-定制
  Map<String, dynamic> receiveDetailCustomize = {};
  // 加载标记
  bool loadingFlag = true;
  // 自定义参数 - 终

  // 构造函数
  InquiryScheduleDetailsModel({
    // 自定义参数 - 始
    required this.rootContext,
    required this.receiveId,
    this.supplierList = const [],
    this.productList = const [],
    this.receiveCustomize = const {},
    this.receiveDetailCustomize = const {},
    this.loadingFlag = true,
    // 自定义参数 - 始
  });
}
