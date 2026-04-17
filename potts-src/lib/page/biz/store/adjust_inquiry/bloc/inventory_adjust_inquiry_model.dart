import 'package:wms/model/location.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * content：在庫調整照会-参数
 * author：张博睿
 * date：2023/09/07
 */

class InventoryAdjustInquiryModel extends WmsTableModel {
  factory InventoryAdjustInquiryModel.clone(InventoryAdjustInquiryModel src) {
    InventoryAdjustInquiryModel dest =
        InventoryAdjustInquiryModel(companyId: src.companyId);
    dest.copy(src);
    dest.searchValueMap = src.searchValueMap;
    dest.productCode = src.productCode;
    dest.productName = src.productName;
    dest.adjustDate = src.adjustDate;
    dest.conditionList = src.conditionList;
    dest.loadingFlag = src.loadingFlag;
    dest.moveBeforeLocationList = src.moveBeforeLocationList;
    dest.locationBefore = src.locationBefore;
    dest.queryLocCode = src.queryLocCode;
    dest.companyId = src.companyId;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    return dest;
  }
  // 当前用户所属会社ID
  int? companyId;
  // 商品code
  String productCode = '';
  // 商品name
  String productName = '';
  // 調整日付
  String adjustDate = '';
  List conditionList = [];
  // 移动前位置
  Location locationBefore = Location.empty();
  String queryLocCode = '';
  // 画面加载标识
  bool loadingFlag = true;
  // 移动前仓库位置列表
  List moveBeforeLocationList = [];
  // 下拉框value值列表
  Map<String, dynamic> searchValueMap = {};
  //排序字段
  String sortCol = 'code';
  // 升降排序
  bool ascendingFlg = false;

  InventoryAdjustInquiryModel({
    // 当前用户所属会社ID
    required this.companyId,
    // 商品code
    this.productCode = '',
    // 商品name
    this.productName = '',
    // 商品code
    this.adjustDate = '',
    this.queryLocCode = '',
    this.loadingFlag = true,
    this.conditionList = const [],
    // 移动前仓库位置列表
    this.moveBeforeLocationList = const [],
    // 下拉框value值列表
    this.searchValueMap = const {},
    this.sortCol = 'code',
    this.ascendingFlg = false,
  });
}
