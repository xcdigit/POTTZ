/**
 * 内容：納品書-打印页参数
 * 作者：王光顺
 * 时间：2023/09/18
 * 作者：赵士淞
 * 时间：2023/10/30
 */
class WarehouseSettlementModel {
  // 克隆
  factory WarehouseSettlementModel.clone(WarehouseSettlementModel src) {
    WarehouseSettlementModel dest = WarehouseSettlementModel(
      shipIdList: src.shipIdList,
      companyId: src.companyId,
    );
    // 自定义参数 - 始
    dest.companyCustomize = src.companyCustomize;
    dest.shipList = src.shipList;
    dest.shipDetailList = src.shipDetailList;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 出荷指示ID列表
  List shipIdList = [];
  // 会社ID
  int companyId = 0;
  // 会社定制
  dynamic companyCustomize = {};
  // 出荷指示列表
  List<dynamic> shipList = [];
  // 出荷指示明细列表
  List<dynamic> shipDetailList = [];
  // 自定义参数 - 终

  // 构造函数
  WarehouseSettlementModel({
    // 自定义参数 - 始
    required this.shipIdList,
    required this.companyId,
    this.companyCustomize = const {},
    this.shipList = const [],
    this.shipDetailList = const [],
    // 自定义参数 - 终
  });
}
