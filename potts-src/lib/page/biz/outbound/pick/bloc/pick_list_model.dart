import 'package:flutter/material.dart';

import '../../../../../model/ship.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：ピッキングリスト(シングル)-参数
 * 作者：王光顺
 * 时间：2023/09/07
 */
class PickListModel extends WmsTableModel {
  // 克隆
  factory PickListModel.clone(PickListModel src) {
    // 赵士淞 - 测试修复 2023/11/16 - 始
    PickListModel dest = PickListModel(rootContext: src.rootContext);
    // 赵士淞 - 测试修复 2023/11/16 - 终
    // dest.records = src.records;
    // dest.total = src.total;
    dest.copy(src);
    // 自定义参数 - 始
    dest.customerList = src.customerList;
    dest.customerAddressList = src.customerAddressList;
    dest.warehouseList = src.warehouseList;
    dest.productList = src.productList;
    dest.shipDetailCustomize = src.shipDetailCustomize;
    dest.time = src.time;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }
  //总条数
  int num = 0;

  // 自定义参数 - 始
  // 赵士淞 - 测试修复 2023/11/16 - 始
  // 上下文
  BuildContext rootContext;
  // 赵士淞 - 测试修复 2023/11/16 - 终
  // 客户列表
  List<Map<String, dynamic>> customerList = [];
  // 收件人列表
  List<Map<String, dynamic>> customerAddressList = [];
  // 仓库列表
  List<Map<String, dynamic>> warehouseList = [];
  // 商品列表
  List<Map<String, dynamic>> productList = [];
  // 出荷指示明细-定制
  Map<String, dynamic> shipDetailCustomize = {};

  // 出荷指示
  Ship ship = Ship.empty();

  String time =
      DateTime.now().toIso8601String().substring(0, 10).replaceAll('-', '/');

  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  PickListModel({
    // 自定义参数 - 始
    // 赵士淞 - 测试修复 2023/11/16 - 始
    required this.rootContext,
    // 赵士淞 - 测试修复 2023/11/16 - 终
    this.customerList = const [],
    this.customerAddressList = const [],
    this.warehouseList = const [],
    this.productList = const [],
    // this.shipDetailCustomize = const {},
    this.loadingFlag = true,
    this.sortCol = 'rcv_sch_date',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
