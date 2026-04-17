import 'package:flutter/widgets.dart';

import '../../../../../common/config/config.dart';
import '../../../../../model/ship.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：欠品伝票照会-参数
 * 作者：熊草云
 * 时间：2023/09/18
 */
class LackGoodsInvoiceModel extends WmsTableModel {
  // 克隆
  factory LackGoodsInvoiceModel.clone(LackGoodsInvoiceModel src) {
    LackGoodsInvoiceModel dest = LackGoodsInvoiceModel(context: src.context);

    dest.copy(src);
    // 自定义参数 - 始
    // 商品列表
    dest.shipno = src.shipno;
    dest.shipnoList = src.shipnoList;
    dest.product = src.product;
    dest.productList = src.productList;
    dest.shipCustomize = src.shipCustomize;
    dest.shipState = src.shipState;
    dest.storeList = src.storeList;
    dest.searchList = src.searchList;
    dest.context = src.context;
    dest.searchFlag = src.searchFlag;
    dest.tab1 = src.tab1;
    dest.tab2 = src.tab2;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol1 = src.sortCol1;
    dest.ascendingFlg1 = src.ascendingFlg1;
    dest.sortCol2 = src.sortCol2;
    dest.ascendingFlg2 = src.ascendingFlg2;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext context;
  Map searchList = {};
  String? shipno;
  List shipnoList = [];
  String? product;
  List productList = [];
  // 出荷指示条件-定制
  Map<String, dynamic> shipCustomize = {};

  // 出荷指示
  Ship ship = Ship.empty();

  DateTime? rcvSchDate;
// 一览状态
  int shipState = Config.NUMBER_ZERO;
  // 商品明细
  Map<String, dynamic> storeList;
  // 欠品flag
  int searchFlag = Config.NUMBER_ZERO;
  // tab
  int tab1 = 0;
  int tab2 = 0;
  //
  bool loadingFlag = true;
  //排序字段
  String sortCol1 = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg1 = false;
  //排序字段
  String sortCol2 = 'code';
  // 升降排序
  bool ascendingFlg2 = false;
  // 自定义参数 - 终

  // 构造函数
  LackGoodsInvoiceModel({
    // 自定义参数 - 始
    required this.context,
    this.searchList = const {},
    this.shipCustomize = const {},
    this.shipno,
    this.shipnoList = const [],
    this.product,
    this.productList = const [],
    this.shipState = Config.NUMBER_ZERO,
    this.storeList = const {},
    this.searchFlag = Config.NUMBER_ZERO,
    this.tab1 = 0,
    this.tab2 = 0,
    this.loadingFlag = true,
    this.sortCol1 = 'rcv_sch_date',
    this.ascendingFlg1 = false,
    this.sortCol2 = 'code',
    this.ascendingFlg2 = false,
    // 自定义参数 - 终
  });
}
