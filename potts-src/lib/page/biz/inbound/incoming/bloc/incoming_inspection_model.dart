import 'package:flutter/material.dart';

import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：入荷検品-参数
 * 作者：熊草云
 * 时间：2023/09/21
 */
class IncomingInspectionModel extends WmsTableModel {
  // 克隆
  factory IncomingInspectionModel.clone(IncomingInspectionModel src) {
    IncomingInspectionModel dest =
        IncomingInspectionModel(context: src.context);

    dest.records = src.records;
    dest.total = src.total;
    // 自定义参数 - 始
    dest.receiveNo = src.receiveNo;
    dest.context = src.context;
    dest.receive = src.receive;
    dest.receiveDetail = src.receiveDetail;
    dest.receiveDetailList = src.receiveDetailList;
    dest.checkFlag = src.checkFlag;
    dest.number = src.number;
    dest.receive_no = src.receive_no;
    dest.receive_name = src.receive_name;
    dest.detail_code = src.detail_code;
    dest.detail_name = src.detail_name;
    dest.detail_product_num = src.detail_product_num;
    dest.detail_check_num = src.detail_check_num;
    dest.detail_image = src.detail_image;
    dest.qrCode1 = src.qrCode1;
    dest.qrCode2 = src.qrCode2;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  String? receiveNo;
  BuildContext context;
  Map<String, dynamic> receive = {};
  Map<String, dynamic> receiveDetail = {};
  List<dynamic> receiveDetailList = [];
  bool checkFlag = false;
  int number = 0;
  String receive_no = '';
  String receive_name = '';
  String detail_code = '';
  String detail_name = '';
  String detail_product_num;
  String detail_check_num;
  String detail_image = '';
  String? qrCode1;
  String? qrCode2;
  // 自定义参数 - 终

  // 构造函数
  IncomingInspectionModel({
    // 自定义参数 - 始
    this.receiveNo,
    required this.context,
    this.receive = const {},
    this.receiveDetail = const {},
    this.receiveDetailList = const [],
    this.checkFlag = false,
    this.number = 0,
    this.receive_no = '',
    this.receive_name = '',
    this.detail_code = '',
    this.detail_name = '',
    this.detail_product_num = '',
    this.detail_check_num = '',
    this.detail_image = '',
    this.qrCode1,
    this.qrCode2,
    // 自定义参数 - 终
  });
}
