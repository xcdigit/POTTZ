import '../../../../../common/config/config.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：在庫照会弹窗-参数
 * 作者：赵士淞
 * 时间：2023/11/07
 */
class InventoryInquiryDialogModel extends WmsTableModel {
  // 克隆
  factory InventoryInquiryDialogModel.clone(InventoryInquiryDialogModel src) {
    InventoryInquiryDialogModel dest = InventoryInquiryDialogModel();
    dest.copy(src);
    dest.storeId = src.storeId;
    dest.productId = src.productId;
    return dest;
  }

  // 库存ID
  int storeId = Config.NUMBER_NEGATIVE;
  // 商品ID
  int productId = Config.NUMBER_NEGATIVE;

  // 构造函数
  InventoryInquiryDialogModel({
    this.storeId = Config.NUMBER_NEGATIVE,
    this.productId = Config.NUMBER_NEGATIVE,
  });
}
