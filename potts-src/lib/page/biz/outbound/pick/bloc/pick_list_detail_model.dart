import '../../../../../model/ship.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：ピッキングリスト(シングル)-参数
 * 作者：王光顺
 * 时间：2023/09/07
 */
class PickListDetailModel extends WmsTableModel {
  // 克隆
  factory PickListDetailModel.clone(PickListDetailModel src) {
    PickListDetailModel dest = PickListDetailModel(shipId: src.shipId);
    dest.records = src.records;
    dest.total = src.total;

    // 自定义参数 - 始
    dest.shipId = src.shipId;
    dest.shipDetailCustomize = src.shipDetailCustomize;
    dest.shipCustomize = src.shipCustomize;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  int shipId = 0;

  // 出荷指示明细-定制
  Map<String, dynamic> shipDetailCustomize = {};

  // 出荷指示明细(明细上方出荷数据)-定制
  Map<String, dynamic> shipCustomize = {};

  // 出荷指示
  Ship ship = Ship.empty();
  // 自定义参数 - 终

  // 构造函数
  PickListDetailModel({
    // 自定义参数 - 始
    required this.shipId,
    // this.shipDetailCustomize = const {},
    // 自定义参数 - 终
  });
}
