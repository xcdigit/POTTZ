import 'package:wms/widget/table/bloc/wms_table_model.dart';

import '../../../../../common/config/config.dart';
/**
 * 内容：棚卸データ出力 - model
 * 作者：王光顺
 * 时间：2023/09/19
 */

class InventoryOutputModel extends WmsTableModel {
  factory InventoryOutputModel.clone(InventoryOutputModel src) {
    InventoryOutputModel dest = InventoryOutputModel(companyId: src.companyId);
    dest.copy(src);
    dest.startDate = src.startDate;
    dest.num1 = src.num1;
    dest.num2 = src.num2;
    dest.loadingFlag = src.loadingFlag;
    dest.currentIndex = src.currentIndex;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    return dest;
  }

  int companyId;
  String? startDate;
  int num1;
  int num2;
  bool loadingFlag;
  int currentIndex;
  //排序字段
  String sortCol = 'start_date';
  // 升降排序
  bool ascendingFlg = false;

  InventoryOutputModel({
    required this.companyId,
    this.startDate = '',
    this.num1 = Config.NUMBER_ZERO,
    this.num2 = Config.NUMBER_ZERO,
    this.loadingFlag = true,
    this.currentIndex = Config.NUMBER_ZERO,
    this.sortCol = 'start_date',
    this.ascendingFlg = false,
  });
}
