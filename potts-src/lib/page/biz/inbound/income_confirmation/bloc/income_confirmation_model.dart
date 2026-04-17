import 'package:flutter/cupertino.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * 内容：入荷确定-参数
 * 作者：cuihr
 * 时间：2023/09/27
 */
class IncomeConfirmationModel extends WmsTableModel {
  factory IncomeConfirmationModel.clone(IncomeConfirmationModel src) {
    IncomeConfirmationModel dest = IncomeConfirmationModel(
      rootBuildContext: src.rootBuildContext,
      companyId: src.companyId,
      rcvSchDate: src.rcvSchDate,
    );
    dest.copy(src);
    // dest.companyId = src.companyId;
    // 自定义参数 - 始
    dest.count = src.count;
    dest.count1 = src.count1;
    dest.count2 = src.count2;
    dest.rcvSchDate = src.rcvSchDate;
    dest.currentIndex = src.currentIndex;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext rootBuildContext;
  //会社id
  int? companyId;
  //tab未确定个数
  int count1 = 0;
  //tab已确定个数
  int count2 = 0;
  //一览个数
  int count = 0;
  //入荷确定 入荷予定日 当前时间
  String rcvSchDate = '';

  int currentIndex = 0;
  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  IncomeConfirmationModel({
    // 自定义参数 - 始
    required this.rootBuildContext,
    required this.companyId,
    required this.rcvSchDate,
    this.loadingFlag = true,
    this.sortCol = 'rcv_sch_date',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
