import 'package:wms/model/location.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * content：在庫移動照会-参数
 * author：张博睿
 * date：2023/09/07
 */

class InventoryTransferInquiryModel extends WmsTableModel {
  factory InventoryTransferInquiryModel.clone(
      InventoryTransferInquiryModel src) {
    InventoryTransferInquiryModel dest =
        InventoryTransferInquiryModel(companyId: src.companyId);
    dest.copy(src);
    dest.searchValueMap = src.searchValueMap;
    // 商品code
    dest.productCode = src.productCode;
    // 商品名
    dest.productName = src.productName;
    // 移動日付
    dest.adjustDate = src.adjustDate;
    dest.loadingFlag = src.loadingFlag;
    dest.conditionList = src.conditionList;
    dest.moveBeforeLocationList = src.moveBeforeLocationList;
    dest.moveAfterLocationList = src.moveAfterLocationList;
    dest.locationAfter = src.locationAfter;
    dest.locationBefore = src.locationBefore;
    dest.queryFromLocCode = src.queryFromLocCode;
    dest.queryToLocCode = src.queryToLocCode;
    dest.companyId = src.companyId;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    return dest;
  }
  // 当前用户所属会社ID
  int? companyId;
  // 商品ID
  String productCode = '';
  // 检索条件 商品名
  String productName = '';
  // 检索条件 移動日付
  String adjustDate = '';
  bool loadingFlag = true;
  List conditionList = [];
  // 移动前位置
  Location locationBefore = Location.empty();
  // 移动后位置
  Location locationAfter = Location.empty();
  // 检索条件
  String queryFromLocCode = '';
  String queryToLocCode = '';
  // 移动前仓库位置列表
  List moveBeforeLocationList = [];
  // 移动后仓库位置列表
  List moveAfterLocationList = [];
  // 下拉框value值列表
  Map<String, dynamic> searchValueMap = {};

  //排序字段
  String sortCol = 'code';
  // 升降排序
  bool ascendingFlg = false;

  InventoryTransferInquiryModel({
    required this.companyId,
    this.productCode = '',
    this.productName = '',
    this.adjustDate = '',
    this.loadingFlag = true,
    this.conditionList = const [],
    // 移动前仓库位置列表
    this.moveBeforeLocationList = const [],
    // 移动后仓库位置列表
    this.moveAfterLocationList = const [],
    this.queryFromLocCode = '',
    this.queryToLocCode = '',
    // 下拉框value值列表
    this.searchValueMap = const {},
    this.sortCol = 'code',
    this.ascendingFlg = false,
  });
}
