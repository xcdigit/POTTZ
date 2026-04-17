import 'package:flutter/material.dart';

import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：商品情报-参数
 * 作者：赵士淞
 * 时间：2024/10/28
 */
class ProductInformationModel extends WmsTableModel {
  // 克隆
  factory ProductInformationModel.clone(ProductInformationModel src) {
    ProductInformationModel dest = ProductInformationModel(
      rootContext: src.rootContext,
      productCodeOrJanCd: src.productCodeOrJanCd,
    );
    dest.copy(src);
    dest.roleId = src.roleId;
    dest.productInfo = src.productInfo;
    dest.image1Network = src.image1Network;
    dest.shipmentNumber = src.shipmentNumber;
    dest.unshippedNumber = src.unshippedNumber;
    dest.shipmentNumberToday = src.shipmentNumberToday;
    dest.unshippedNumberToday = src.unshippedNumberToday;
    dest.unoutboundNumber = src.unoutboundNumber;
    dest.unpickingNumber = src.unpickingNumber;
    dest.expectedNumber = src.expectedNumber;
    dest.unexpectedNumber = src.unexpectedNumber;
    dest.expectedNumberToday = src.expectedNumberToday;
    dest.unexpectedNumberToday = src.unexpectedNumberToday;
    dest.uncheckedNumber = src.uncheckedNumber;
    dest.unlistedNumber = src.unlistedNumber;
    dest.shipmentTopFive = src.shipmentTopFive;
    dest.entranceTopFive = src.entranceTopFive;
    dest.shipmentMonth = src.shipmentMonth;
    dest.entranceMonth = src.entranceMonth;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 商品编码/JANCD
  String productCodeOrJanCd;
  // 角色ID
  int roleId;
  // 商品情报
  Map<String, dynamic> productInfo;
  // 写真1展示路径
  String image1Network;
  // 出荷指示済数
  int shipmentNumber;
  // 未出荷数
  int unshippedNumber;
  // 本日出荷指示数
  int shipmentNumberToday;
  // 本日未出荷数
  int unshippedNumberToday;
  // 未出庫数
  int unoutboundNumber;
  // 未ピッキング数
  int unpickingNumber;
  // 入荷予定数
  int expectedNumber;
  // 未入荷数
  int unexpectedNumber;
  // 本日入荷予定数
  int expectedNumberToday;
  // 本日未入荷数
  int unexpectedNumberToday;
  // 未検品数
  int uncheckedNumber;
  // 未入庫数
  int unlistedNumber;
  // 出荷先（上位５社）
  List<dynamic> shipmentTopFive;
  // 入荷元（上位５社）
  List<dynamic> entranceTopFive;
  // 出荷数（月単位）
  List<dynamic> shipmentMonth;
  // 入荷数（月単位）
  List<dynamic> entranceMonth;

  // 构造函数
  ProductInformationModel({
    required this.rootContext,
    required this.productCodeOrJanCd,
    this.roleId = 0,
    this.productInfo = const {
      'id': '',
      'code': '',
      'name': '',
      'name_short': '',
      'jan_cd': '',
      'category_l': '',
      'category_m': '',
      'category_s': '',
      'size': '',
      'packing_type': '',
      'packing_num': '',
      'image1': '',
      'image2': '',
      'company_note1': '',
      'company_note2': '',
      'notice_note1': '',
      'notice_note2': '',
      'company_id': '',
      'company_name': ''
    },
    this.image1Network = '',
    this.shipmentNumber = 0,
    this.unshippedNumber = 0,
    this.shipmentNumberToday = 0,
    this.unshippedNumberToday = 0,
    this.unoutboundNumber = 0,
    this.unpickingNumber = 0,
    this.expectedNumber = 0,
    this.unexpectedNumber = 0,
    this.expectedNumberToday = 0,
    this.unexpectedNumberToday = 0,
    this.uncheckedNumber = 0,
    this.unlistedNumber = 0,
    this.shipmentTopFive = const [],
    this.entranceTopFive = const [],
    this.shipmentMonth = const [],
    this.entranceMonth = const [],
  });
}
