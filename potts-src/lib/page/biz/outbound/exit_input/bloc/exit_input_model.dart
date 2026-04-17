import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * content：出庫入力-参数
 * author：张博睿
 * date：2023/09/13
 */

class ExitInputModel extends WmsTableModel {
  factory ExitInputModel.clone(ExitInputModel src) {
    ExitInputModel dest = ExitInputModel(shipId: src.shipId);
    dest.copy(src);
    dest.companyId = src.companyId;
    dest.userId = src.userId;
    dest.shipId = src.shipId;
    dest.shipKbn = src.shipKbn;
    dest.dtbPickListId = src.dtbPickListId;
    dest.fromLocationId = src.fromLocationId;
    dest.toLocationId = src.toLocationId;
    dest.productId = src.productId;
    dest.stockId = src.stockId;
    dest.shipLineNo = src.shipLineNo;
    dest.locationCodeValue = src.locationCodeValue;
    dest.shipCodeValue = src.shipCodeValue;
    dest.customerValue = src.customerValue;
    dest.deliveryValue = src.deliveryValue;
    dest.detailsCodeValue = src.detailsCodeValue;
    dest.detailLocationCode = src.detailLocationCode;
    dest.productCodeValue = src.productCodeValue;
    dest.productNameValue = src.productNameValue;
    dest.allocationNumberValue = src.allocationNumberValue;
    dest.productImage1 = src.productImage1;
    dest.productImage2 = src.productImage2;
    dest.locationBarCode = src.locationBarCode;
    dest.productBarCode = src.productBarCode;
    dest.productCount = src.productCount;
    dest.shopBarcode = src.shopBarcode;
    dest.labelCount = src.labelCount;
    dest.loadingFlag = src.loadingFlag;
    dest.pickListData = src.pickListData;
    dest.locationInformation = src.locationInformation;
    dest.detailsInformation = src.detailsInformation;
    return dest;
  }
  // 当前用户所属会社ID
  int? companyId;
  // 当前用户ID
  int? userId;
  // 出荷ID
  int shipId = 0;
  String shipKbn = '';
  // dtb_pick_list 表主键
  int dtbPickListId = 0;
  // 元 location ID
  int fromLocationId = 0;
  // 先 location ID
  int toLocationId = 0;
  // 商品ID
  int productId = 0;
  // 商品在库ID
  int stockId = 0;
  // 出荷明細行no
  String shipLineNo = '';
  // 出庫入力- 位置编码
  String locationCodeValue = '';
  // 出庫入力- 出荷指示编码
  String shipCodeValue = '';
  // 出庫入力- 得意先
  String customerValue = '';
  // 出庫入力- 納入先
  String deliveryValue = '';
  // 出庫入力- 明細部のバーコード
  String detailsCodeValue = '';
  // 出庫入力- ロケーションコード
  String detailLocationCode = '';
  // 出庫入力- 商品コード
  String productCodeValue = '';
  // 出庫入力- 商品名
  String productNameValue = '';
  // 出庫入力- 引当数
  int allocationNumberValue = 0;
  // 出庫入力- 商品写真
  String productImage1 = '';
  String productImage2 = '';
  // 出庫入力- ロケーションのバーコード
  String locationBarCode = '';
  // 出庫入力- 商品ラベルのバーコード
  String productBarCode = '';
  // 出庫入力- 合计数
  int productCount = 0;
  // 出庫入力- 购物车码
  String shopBarcode = '';
  // ラベル発行-数量
  int labelCount = 0;
  // 加载标记
  bool loadingFlag = true;
  List<dynamic> pickListData;

  List<dynamic> locationInformation;

  List<dynamic> detailsInformation;

  ExitInputModel({
    required this.shipId,
    this.companyId,
    this.userId,
    this.shipKbn = '',
    this.dtbPickListId = 0,
    this.fromLocationId = 0,
    this.toLocationId = 0,
    this.productId = 0,
    this.stockId = 0,
    this.shipLineNo = '',
    this.locationCodeValue = '',
    this.shipCodeValue = '',
    this.customerValue = '',
    this.deliveryValue = '',
    this.detailsCodeValue = '',
    this.detailLocationCode = '',
    this.productCodeValue = '',
    this.productNameValue = '',
    this.allocationNumberValue = 0,
    this.productImage1 = '',
    this.productImage2 = '',
    this.locationBarCode = '',
    this.productBarCode = '',
    this.productCount = 0,
    this.shopBarcode = '',
    this.labelCount = 0,
    this.loadingFlag = true,
    this.pickListData = const [],
    this.locationInformation = const [],
    this.detailsInformation = const [],
  });
}
