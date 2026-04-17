import 'package:flutter/widgets.dart';

import '../../../../../common/config/config.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：在庫照会-参数
 * 作者：赵士淞
 * 时间：2023/10/08
 */
class InventoryInquiryModel extends WmsTableModel {
  // 克隆
  factory InventoryInquiryModel.clone(InventoryInquiryModel src) {
    InventoryInquiryModel dest =
        InventoryInquiryModel(rootContext: src.rootContext);
    dest.copy(src);
    dest.queryButtonFlag = src.queryButtonFlag;
    dest.searchProductCode = src.searchProductCode;
    dest.searchProductName = src.searchProductName;
    dest.searchLocationLocCd = src.searchLocationLocCd;
    dest.searchYearMonth = src.searchYearMonth;
    dest.queryProductCode = src.queryProductCode;
    dest.queryProductName = src.queryProductName;
    dest.queryLocationLocCd = src.queryLocationLocCd;
    dest.queryYearMonth = src.queryYearMonth;
    dest.locationList = src.locationList;
    dest.tableTabIndex = src.tableTabIndex;
    dest.num = src.num;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 检索按钮标记
  bool queryButtonFlag = false;
  // 查询：商品コード
  String searchProductCode = '';
  // 查询：商品名
  String searchProductName = '';
  // 查询：ロケーションコード
  String searchLocationLocCd = '';
  // 查询：年月
  String searchYearMonth = '';
  // 检索：商品コード
  String queryProductCode = '';
  // 检索：商品名
  String queryProductName = '';
  // 检索：ロケーションコード
  String queryLocationLocCd = '';
  // 检索：年月
  String queryYearMonth = '';
  // 位置列表
  List<dynamic> locationList = [];
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  // 数据总数
  int num = 0;
  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'product_code';
  // 升降排序
  bool ascendingFlg = false;

  // 构造函数
  InventoryInquiryModel({
    required this.rootContext,
    this.queryButtonFlag = false,
    this.searchProductCode = '',
    this.searchProductName = '',
    this.searchLocationLocCd = '',
    this.searchYearMonth = '',
    this.queryProductCode = '',
    this.queryProductName = '',
    this.queryLocationLocCd = '',
    this.queryYearMonth = '',
    this.locationList = const [],
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.num = 0,
    this.loadingFlag = true,
    this.sortCol = 'product_code',
    this.ascendingFlg = false,
  });
}
