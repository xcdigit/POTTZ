import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * 内容：出荷确定详细 -参数
 * 作者：cuihr
 * 时间：2023/09/19
 */
class ShipmentDeterminationDetailModel extends WmsTableModel {
  factory ShipmentDeterminationDetailModel.clone(
      ShipmentDeterminationDetailModel src) {
    ShipmentDeterminationDetailModel dest =
        ShipmentDeterminationDetailModel(shipId: src.shipId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.shipDetailCustomize = src.shipDetailCustomize;
    dest.shipDetailData = src.shipDetailData;
    dest.shipData = src.shipData;
    dest.detailFlag = src.detailFlag;
    dest.loadingFlag = src.loadingFlag;

    // 自定义参数 - 终
    return dest;
  }
  // 自定义参数 - 始
  // 出荷指示ID
  int shipId = 0;
  //  出荷指示明细-定制
  Map<String, dynamic> shipDetailCustomize = {};
  //出荷指示明细弹窗内容
  Map<String, dynamic> shipDetailData;
  //出荷指示
  Map<String, dynamic> shipData;

  bool detailFlag = false;
  // 加载标记
  bool loadingFlag = true;
  // 自定义参数 - 终

  // 构造函数
  ShipmentDeterminationDetailModel({
    required this.shipId,
    this.loadingFlag = true,
    this.shipDetailData = const {},
    this.shipData = const {},
  });
}
