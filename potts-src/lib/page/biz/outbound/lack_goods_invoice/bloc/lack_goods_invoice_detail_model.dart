import 'package:flutter/widgets.dart';

import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：欠品伝票照会-参数
 * 作者：熊草云
 * 时间：2023/09/18
 */
class LackGoodsInvoiceDetailModel extends WmsTableModel {
  // 克隆
  factory LackGoodsInvoiceDetailModel.clone(LackGoodsInvoiceDetailModel src) {
    LackGoodsInvoiceDetailModel dest =
        LackGoodsInvoiceDetailModel(shipno: src.shipno, context: src.context);

    dest.copy(src);
    // 自定义参数 - 始
    dest.context = src.context;
    // 商品列表
    dest.shipno = src.shipno;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext context;
  int shipno = 0;
  // 自定义参数 - 终

  // 构造函数
  LackGoodsInvoiceDetailModel({
    // 自定义参数 - 始
    required this.context,
    this.shipno = 0,
    // 自定义参数 - 终
  });
}
