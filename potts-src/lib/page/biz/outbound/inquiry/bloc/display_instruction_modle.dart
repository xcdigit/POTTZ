import 'package:flutter/widgets.dart';

import '../../../../../common/config/config.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：出荷指示照会-参数
 * 作者：熊草云
 * 时间：2023/09/07
 */
class DisplayInstructionModel extends WmsTableModel {
  // 克隆
  factory DisplayInstructionModel.clone(DisplayInstructionModel src) {
    DisplayInstructionModel dest =
        DisplayInstructionModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.context = src.context;
    dest.tabCount1 = src.tabCount1;
    dest.tabCount2 = src.tabCount2;
    dest.tabCount3 = src.tabCount3;
    dest.tabCount4 = src.tabCount4;
    dest.tabCount5 = src.tabCount5;
    dest.shipId = src.shipId;
    dest.shipDetail = src.shipDetail;
    dest.shipDetailvalue = src.shipDetailvalue;
    dest.customer = src.customer;
    dest.customerList = src.customerList;
    dest.name = src.name;
    dest.nameList = src.nameList;
    dest.person = src.person;
    dest.personList = src.personList;
    dest.product = src.product;
    dest.productList = src.productList;
    dest.shipDetailCustomize = src.shipDetailCustomize;
    dest.searchValueList = src.searchValueList;
    dest.printValueList = src.printValueList;
    dest.deleteList = src.deleteList;
    // 检索条件参数
    dest.csvKbn = src.csvKbn;
    dest.orderNo = src.orderNo;
    dest.shipNo = src.shipNo;
    dest.customerName = src.customerName;
    dest.rcvSchDate1 = src.rcvSchDate1;
    dest.rcvSchDate2 = src.cusRevDate2;
    dest.consignee = src.consignee;
    dest.cusRevDate1 = src.cusRevDate1;
    dest.cusRevDate2 = src.cusRevDate2;
    dest.head = src.head;
    dest.importerrorFlg = src.importerrorFlg;
    dest.productName = src.productName;
    // 检索框数据
    dest.sreachFlag = src.sreachFlag;
    dest.keyword = src.keyword;
    // Tab 状态
    dest.shipStateList = src.shipStateList;
    dest.flag = src.flag;
    dest.tabState = src.tabState;
    //
    dest.searchdataList = src.searchdataList;
    dest.reservationFlag = src.reservationFlag;
    dest.reservationState = src.reservationState;
    dest.reservationLimitFlag = src.reservationLimitFlag;
    dest.loadingFlag = src.loadingFlag;
    dest.reservationID = dest.reservationID;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext context;
  int tabCount1 = 0;
  int tabCount2 = 0;
  int tabCount3 = 0;
  int tabCount4 = 0;
  int tabCount5 = 0;
  // 出荷id
  int shipId = 0;
  // 明细页面判断
  bool detail = false;
  // 出荷明细ID
  Map<String, dynamic> shipDetail = {};
  // 明细数据行
  Map<String, dynamic> shipDetailvalue = {};
  // 得意先列表
  Map<String, dynamic> customer = {};
  List customerList = [];
  // 纳入先列表
  Map<String, dynamic> name = {};
  List nameList = [];
  // 商品列表
  Map<String, dynamic> product = {};
  List productList = [];
  // 担当者列表
  Map<String, dynamic> person = {};
  List personList = [];
  // 出荷指示明细-定制
  Map<String, dynamic> shipDetailCustomize = {};
  // 自定义参数 - 终
  List searchValueList = [];
  // 印刷数据
  List<Map<String, dynamic>> printValueList = [];
  Map<String, dynamic> deleteList = {};
  // 检索条件参数
  List<String>? csvKbn;
  String? orderNo;
  String? shipNo;
  String? customerName;
  String? rcvSchDate1;
  String? rcvSchDate2;
  String? consignee;
  String? cusRevDate1;
  String? cusRevDate2;
  String? head;
  String? importerrorFlg;
  String? productName;
  // 检索框参数
  bool sreachFlag = false;
  String? keyword;
  // tab状态
  List<String>? shipStateList;
  bool flag = true;
  int tabState = Config.NUMBER_ZERO;
  //
  List<String> searchdataList = [];
  // 引当状态
  bool reservationFlag = false;
  bool reservationState = false;
  int reservationLimitFlag = 0;
  bool loadingFlag = true;
  String? reservationID;
  //排序字段
  String sortCol = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;
  // 构造函数
  DisplayInstructionModel({
    // 自定义参数 - 始
    required this.context,
    this.tabCount1 = 0,
    this.tabCount2 = 0,
    this.tabCount3 = 0,
    this.tabCount4 = 0,
    this.tabCount5 = 0,
    this.shipId = 0,
    this.shipDetail = const {},
    this.shipDetailvalue = const {},
    this.customer = const {},
    this.customerList = const [],
    this.name = const {},
    this.nameList = const [],
    this.person = const {},
    this.personList = const [],
    this.product = const {},
    this.productList = const [],
    this.shipDetailCustomize = const {},
    this.searchValueList = const [],
    this.printValueList = const [],
    this.deleteList = const {},
    // 检索条件参数
    this.csvKbn,
    this.orderNo,
    this.shipNo,
    this.customerName,
    this.rcvSchDate1,
    this.rcvSchDate2,
    this.consignee,
    this.cusRevDate1,
    this.cusRevDate2,
    this.head,
    this.importerrorFlg,
    this.productName,
    // 检索框参数
    this.sreachFlag = false,
    this.keyword,
    // Tab 状态
    this.shipStateList,
    this.flag = true,
    this.tabState = Config.NUMBER_ZERO,
    //
    this.searchdataList = const [],
    // 引当
    this.reservationFlag = false,
    this.reservationState = false,
    this.reservationLimitFlag = 0,
    this.loadingFlag = true,
    this.reservationID,
    this.sortCol = 'rcv_sch_date',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
