import 'package:flutter/cupertino.dart';

import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：納品書-参数
 * 作者：王光顺
 * 时间：2023/09/18
 */
class WarehouseModel extends WmsTableModel {
  // 克隆
  factory WarehouseModel.clone(WarehouseModel src) {
    WarehouseModel dest =
        WarehouseModel(companyId: src.companyId, context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.customerList = src.customerList;

    dest.shipCustomize = src.shipCustomize;
    dest.warehouseList = src.warehouseList;
    dest.productList = src.productList;
    dest.shipDetailCustomize = src.shipDetailCustomize;

    dest.shipId = src.shipId;

    dest.shipDetailvalue = src.shipDetailvalue;
    dest.customer = src.customer;
    dest.name = src.name;
    dest.nameList = src.nameList;
    dest.person = src.person;
    dest.personList = src.personList;
    dest.product = src.product;
    dest.productList = src.productList;
    dest.shipDetailCustomize = src.shipDetailCustomize;
    dest.searchValueList = src.searchValueList;
    dest.count1 = src.count1;
    dest.count2 = src.count2;
    dest.count = src.count;
    dest.conditionLabelList = src.conditionLabelList;
    dest.currentIndex = src.currentIndex;
    dest.searchData = src.searchData;
    dest.keyword = src.keyword;
    dest.companyId = src.companyId;
    dest.context = src.context;
    dest.pdfKbn = src.pdfKbn;
    dest.loadingFlag = src.loadingFlag;
    dest.loadingFirst = src.loadingFirst;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext context;
  // 出荷指示ID
  int shipId = 0;
  List customerList = [];
  int companyId = 0;
  // 出荷指示-定制
  Map<String, dynamic> shipCustomize = {};
  // 仓库列表
  List<Map<String, dynamic>> warehouseList = [];
  // 商品列表
  List<dynamic> productList = [];
  // 出荷指示明细-定制
  Map<String, dynamic> shipDetailCustomize = {};
  // 自定义参数 - 始

  // 明细页面判断
  bool detail = false;

  // 明细数据行
  Map<String, dynamic> shipDetailvalue = {};
  // 得意先列表
  Map<String, dynamic> customer = {};
  // 纳入先列表
  Map<String, dynamic> name = {};
  List nameList = [];
  // 商品列表
  Map<String, dynamic> product = {};
  // 担当者列表
  Map<String, dynamic> person = {};
  List personList = [];

  // 自定义参数 - 终
  List searchValueList = [];

  //检索条件
  List<String> conditionLabelList = [];

  //pdfKbn的查询状态
  List<String> pdfKbn = [];

  int count = 0;
  int count1 = 0;
  int count2 = 0;

  //当前下标
  int currentIndex = 0;

  // 跳转参数
  Map<String, dynamic> shipDate = {};

  //检索1的条件
  String searchData = '';

  //检索2的条件
  String keyword = '';
  // loading加载
  bool loadingFlag = true;
  // loading首次加载
  bool loadingFirst = false;
  //排序字段
  String sortCol = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;
  //复选框

  // 构造函数
  WarehouseModel({
    // 自定义参数 - 始
    // required this.shipId,
    required this.companyId,
    required this.context,
    this.customerList = const [],
    this.shipCustomize = const {},
    this.warehouseList = const [],
    this.productList = const [],
    this.shipDetailCustomize = const {},
    this.shipId = 0,
    this.shipDetailvalue = const {},
    this.nameList = const [],
    this.personList = const [],
    this.searchValueList = const [],
    this.shipDate = const {},
    this.loadingFlag = true,
    this.loadingFirst = false,
    this.sortCol = 'rcv_sch_date',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
