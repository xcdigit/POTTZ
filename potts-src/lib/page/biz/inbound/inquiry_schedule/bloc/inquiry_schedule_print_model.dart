/**
 * 内容：入荷予定照会-打印页参数
 * 作者：穆政道
 * 时间：2023/12/20
 */
class InquirySchedulePrintModel {
  // 克隆
  factory InquirySchedulePrintModel.clone(InquirySchedulePrintModel src) {
    InquirySchedulePrintModel dest = InquirySchedulePrintModel(
      receiveIdList: src.receiveIdList,
      companyId: src.companyId,
    );
    // 自定义参数 - 始
    dest.companyCustomize = src.companyCustomize;
    dest.receiveList = src.receiveList;
    dest.receiveDetailList = src.receiveDetailList;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 入荷预定ID列表
  List receiveIdList = [];
  // 会社ID
  int companyId = 0;
  // 会社定制
  dynamic companyCustomize = {};
  // 入荷预定列表
  List<dynamic> receiveList = [];
  // 入荷预定明细列表
  List<dynamic> receiveDetailList = [];
  // 自定义参数 - 终

  // 构造函数
  InquirySchedulePrintModel({
    // 自定义参数 - 始
    required this.companyId,
    required this.receiveIdList,
    this.companyCustomize = const {},
    this.receiveList = const [],
    this.receiveDetailList = const [],
    // 自定义参数 - 终
  });
}
