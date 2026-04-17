import 'package:flutter/cupertino.dart';

import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：入荷确定详细 -参数
 * 作者：cuihr
 * 时间：2023/09/28
 */
class IncomeConfirmationDetailModel extends WmsTableModel {
  factory IncomeConfirmationDetailModel.clone(
      IncomeConfirmationDetailModel src) {
    IncomeConfirmationDetailModel dest = IncomeConfirmationDetailModel(
        rootBuildContext: src.rootBuildContext, receiveId: src.receiveId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.receiveDetailCustomize = src.receiveDetailCustomize;
    dest.receiveData = src.receiveData;
    dest.receiveDetailData = src.receiveDetailData;
    dest.loadingFlag = src.loadingFlag;
    // dest.shipData = src.shipData;
    // 自定义参数 - 终
    return dest;
  }
  // 自定义参数 - 始
  // 入荷指示ID
  int receiveId = 0;
  //  入荷指示明细-定制
  Map<String, dynamic> receiveDetailCustomize = {};
  // //入荷指示明细弹窗内容
  Map<String, dynamic> receiveDetailData;
  // //入荷指示
  Map<String, dynamic> receiveData;
  // 加载标记
  bool loadingFlag = true;

  BuildContext rootBuildContext;
  // // 自定义参数 - 终

  // 构造函数
  IncomeConfirmationDetailModel({
    required this.rootBuildContext,
    required this.receiveId,
    this.loadingFlag = true,
    this.receiveData = const {},
    this.receiveDetailData = const {},
    // this.shipData = const {},
  });
}
