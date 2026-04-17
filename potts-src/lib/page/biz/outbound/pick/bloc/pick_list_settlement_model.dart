/**
 * 内容：ピッキングリスト(シングル)-打印页参数
 * 作者：赵士淞
 * 时间：2023/12/20
 */
class PickListSettlementModel {
  // 克隆
  factory PickListSettlementModel.clone(PickListSettlementModel src) {
    PickListSettlementModel dest = PickListSettlementModel(
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
  PickListSettlementModel({
    // 自定义参数 - 始
    required this.shipIdList,
    required this.companyId,
    this.companyCustomize = const {},
    this.shipList = const [],
    this.shipDetailList = const [],
    // 自定义参数 - 终
  });
}
