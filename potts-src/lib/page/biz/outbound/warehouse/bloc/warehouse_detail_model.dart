import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：納品書-参数
 * 作者：王光顺
 * 时间：2023/09/18
 */
class WarehouseDetailModel extends WmsTableModel {
  // 克隆
  factory WarehouseDetailModel.clone(WarehouseDetailModel src) {
    WarehouseDetailModel dest = WarehouseDetailModel(shipId: src.shipId);
    dest.copy(src);
    // 自定义参数 - 始
    // dest.shipId = src.shipId;
    dest.customerList = src.customerList;
    dest.customerAddressList = src.customerAddressList;
    dest.shipCustomize = src.shipCustomize;
    dest.WarehouseDetailList = src.WarehouseDetailList;
    dest.productList = src.productList;
    dest.shipDetailCustomize = src.shipDetailCustomize;

    dest.shipId = src.shipId;
    dest.shipDetail = src.shipDetail;
    dest.shipDetailvalue = src.shipDetailvalue;
    dest.customer = src.customer;
    dest.name = src.name;
    dest.nameList = src.nameList;
    dest.person = src.person;
    dest.personList = src.personList;
    dest.product = src.product;
    dest.productList = src.productList;

    dest.searchValueList = src.searchValueList;
    dest.count1 = src.count1;
    dest.count2 = src.count2;

    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 出荷指示ID
  int shipId = 0;
  List customerList = [];
  // 收件人列表
  List<Map<String, dynamic>> customerAddressList = [];
  // 出荷指示-定制
  Map<String, dynamic> shipCustomize = {};
  // 仓库列表
  List<Map<String, dynamic>> WarehouseDetailList = [];
  // 商品列表
  List<dynamic> productList = [];
  // 出荷指示明细-定制
  Map<String, dynamic> shipDetailCustomize = {};
  // 自定义参数 - 始

  // 明细页面判断
  bool detail = false;
  // 出荷明细ID
  Map<String, dynamic> shipDetail = {};
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

  int count1 = 0;
  int count2 = 0;

  // 构造函数
  WarehouseDetailModel({
    // 自定义参数 - 始
    required this.shipId,
    this.customerList = const [],
    this.customerAddressList = const [],
    this.shipCustomize = const {},
    this.WarehouseDetailList = const [],
    this.productList = const [],
    // this.shipDetailCustomize = const {},
    this.shipDetail = const {},
    this.shipDetailvalue = const {},
    this.customer = const {},
    this.name = const {},
    this.nameList = const [],
    this.person = const {},
    this.personList = const [],
    this.product = const {},
    this.searchValueList = const [],

    // 自定义参数 - 终
  });
}
