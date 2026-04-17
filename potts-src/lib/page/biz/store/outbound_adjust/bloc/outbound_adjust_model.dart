import 'package:wms/model/location.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * content：在庫調整入力-参数
 * author：张博睿
 * date：2023/09/07
 */

class OutboundAdjustModel extends WmsTableModel {
  factory OutboundAdjustModel.clone(OutboundAdjustModel src) {
    OutboundAdjustModel dest =
        OutboundAdjustModel(companyId: src.companyId, userId: src.userId);
    dest.copy(src);
    dest.companyId = src.companyId;
    dest.userId = src.userId;
    dest.data = src.data;
    dest.location = src.location;
    dest.locationList = src.locationList;
    dest.locationId = src.locationId;
    dest.productId = src.productId;
    dest.stock = src.stock;
    dest.lockStock = src.lockStock;
    dest.stockStore = src.stockStore;
    dest.lockStockStore = src.lockStockStore;
    dest.adjustStock = src.adjustStock;
    dest.afterAdjustNumber = src.afterAdjustNumber;
    dest.afterReason = src.afterReason;
    dest.data = src.data;
    dest.data1 = src.data1;
    dest.data2 = src.data2;
    dest.pageFlag = src.pageFlag;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    return dest;
  }
  // 当前用户所属会社ID
  int? companyId;
  int? userId;
  dynamic data;
  Location location = Location.empty();
  List locationList = [];
  // ロケーションid
  int locationId = 0;
  // 商品Id
  int productId = 0;
  // 在库数
  int stock = 0;
  // lock数
  int lockStock = 0;
  // 在库数(在库表)
  int stockStore = 0;
  // lock数(在库表)
  int lockStockStore = 0;
  // 调整数(在库表)
  int adjustStock = 0;
  // 调整后数量
  String afterAdjustNumber = '';
  // 调整理由
  String afterReason = '';
  // 检索条件-商品code
  String data1 = '';
  // 检索条件-商品名
  String data2 = '';

  int pageFlag = 0;

  bool loadingFlag = true;
  //排序字段
  String sortCol = 'code';
  // 升降排序
  bool ascendingFlg = false;

  OutboundAdjustModel({
    required this.companyId,
    required this.userId,
    this.data,
    this.locationList = const [],
    this.locationId = 0,
    this.productId = 0,
    this.stock = 0,
    this.lockStock = 0,
    this.stockStore = 0,
    this.lockStockStore = 0,
    this.adjustStock = 0,
    this.afterAdjustNumber = '',
    this.afterReason = '',
    this.data1 = '',
    this.data2 = '',
    this.pageFlag = 0,
    this.loadingFlag = true,
    this.sortCol = 'code',
    this.ascendingFlg = false,
  });
}
