import 'package:flutter/cupertino.dart';

import '../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：出荷指示照会-参数
 * 作者：luxy
 * 时间：2023/10/10
 */
class HomeMainShipModel extends WmsTableModel {
  // 克隆
  factory HomeMainShipModel.clone(HomeMainShipModel src) {
    HomeMainShipModel dest = HomeMainShipModel(rootContext: src.rootContext);
    dest.shipList = src.shipList;
    dest.dayTotalCount = src.dayTotalCount;
    dest.dayWaitShipmentCount = src.dayWaitShipmentCount;
    dest.dayWaitCount = src.dayWaitCount;
    dest.dayWorkCount = src.dayWorkCount;
    dest.dayShippedCount = src.dayShippedCount;
    dest.SHIP_KBN_ASSIGN_FAIL = src.SHIP_KBN_ASSIGN_FAIL;
    dest.SHIP_KBN_WAIT_ASSIGN = src.SHIP_KBN_WAIT_ASSIGN;
    dest.SHIP_KBN_WAIT_OUTBOUND = src.SHIP_KBN_WAIT_OUTBOUND;
    dest.SHIP_KBN_IS_BEING_OUTBOUND = src.SHIP_KBN_IS_BEING_OUTBOUND;
    dest.SHIP_KBN_WAIT_INSPECT = src.SHIP_KBN_WAIT_INSPECT;
    dest.SHIP_KBN_WAIT_PACKAGING = src.SHIP_KBN_WAIT_PACKAGING;
    dest.SHIP_KBN_WAIT_SHIPMENT_CONFIRM = src.SHIP_KBN_WAIT_SHIPMENT_CONFIRM;
    dest.SHIP_KBN_SHIPPED = src.SHIP_KBN_SHIPPED;
    dest.copy(src);

    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  List<dynamic> shipList = [];
  int dayTotalCount;
  //引当待ち
  int dayWaitShipmentCount;
  //出荷待ち
  int dayWaitCount;
  //出荷作業中
  int dayWorkCount;
  //出荷済み
  int dayShippedCount;
  // 出荷状態
  // 引当失敗
  String SHIP_KBN_ASSIGN_FAIL = '引当失敗';
  // 引当待ち
  String SHIP_KBN_WAIT_ASSIGN = '引当待ち';
  // 出庫待ち
  String SHIP_KBN_WAIT_OUTBOUND = '出庫待ち';
  // 出庫中
  String SHIP_KBN_IS_BEING_OUTBOUND = '出庫中';
  // 検品待ち
  String SHIP_KBN_WAIT_INSPECT = '検品待ち';
  // 梱包待ち
  String SHIP_KBN_WAIT_PACKAGING = '梱包待ち';
  // 出荷確定待ち
  String SHIP_KBN_WAIT_SHIPMENT_CONFIRM = '出荷確定待ち';
  // 出荷済み
  String SHIP_KBN_SHIPPED = '出荷済み';

  // 构造函数
  HomeMainShipModel({
    required this.rootContext,
    this.shipList = const [],
    this.dayTotalCount = 0,
    this.dayWaitShipmentCount = 0,
    this.dayWaitCount = 0,
    this.dayWorkCount = 0,
    this.dayShippedCount = 0,
    this.SHIP_KBN_ASSIGN_FAIL = '引当失敗',
    this.SHIP_KBN_WAIT_ASSIGN = '引当待ち',
    this.SHIP_KBN_WAIT_OUTBOUND = '出庫待ち',
    this.SHIP_KBN_IS_BEING_OUTBOUND = '出庫中',
    this.SHIP_KBN_WAIT_INSPECT = '検品待ち',
    this.SHIP_KBN_WAIT_PACKAGING = '梱包待ち',
    this.SHIP_KBN_WAIT_SHIPMENT_CONFIRM = '出荷確定待ち',
    this.SHIP_KBN_SHIPPED = '出荷済み',
  });
}
