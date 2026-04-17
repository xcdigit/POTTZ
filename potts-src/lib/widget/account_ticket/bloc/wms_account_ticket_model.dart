import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../common/config/config.dart';

/**
 * 内容：账票组件-参数
 * 作者：赵士淞
 * 时间：2023/12/26
 */
class WMSAccountTicketModel {
  // 克隆
  factory WMSAccountTicketModel.clone(WMSAccountTicketModel src) {
    WMSAccountTicketModel dest = WMSAccountTicketModel(
      rootContext: src.rootContext,
      companyId: src.companyId,
      formKbn: src.formKbn,
      idList: src.idList,
    );
    // 自定义参数 - 始
    dest.tableOneData = src.tableOneData;
    dest.tableTwoList = src.tableTwoList;
    dest.tableThreeList = src.tableThreeList;
    dest.formData = src.formData;
    dest.formDetailList = src.formDetailList;
    dest.fieldsOneList = src.fieldsOneList;
    dest.fieldsTwoList = src.fieldsTwoList;
    dest.fieldsThreeList = src.fieldsThreeList;
    dest.editableRegionsNumber = src.editableRegionsNumber;
    dest.contentSummaryList = src.contentSummaryList;
    dest.tableHeadersList = src.tableHeadersList;
    dest.tableHeadersTextList = src.tableHeadersTextList;
    dest.columnWidthsList = src.columnWidthsList;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 会社ID
  int companyId;
  // 账票区分
  String formKbn;
  // ID列表
  List<int> idList;
  // 表一数据
  Map<String, dynamic> tableOneData;
  // 表二列表
  List<dynamic> tableTwoList;
  // 表三列表
  List<dynamic> tableThreeList;
  // 账票数据
  Map<String, dynamic> formData;
  // 账票明细列表
  List<dynamic> formDetailList;
  // 字段一列表
  List<Map<String, dynamic>> fieldsOneList;
  // 字段二列表
  List<Map<String, dynamic>> fieldsTwoList;
  // 字段三列表
  List<Map<String, dynamic>> fieldsThreeList;
  // 可编辑区域数量
  int editableRegionsNumber;
  // 内容汇总列表
  List<List<List<dynamic>>> contentSummaryList;
  // 表头列表
  List<String> tableHeadersList;
  // 表头文本列表
  List<String> tableHeadersTextList;
  // 列宽列表
  Map<int, pw.TableColumnWidth> columnWidthsList;
  // 自定义参数 - 终

  // 构造函数
  WMSAccountTicketModel({
    // 自定义参数 - 始
    required this.rootContext,
    required this.companyId,
    required this.formKbn,
    required this.idList,
    this.tableOneData = const {},
    this.tableTwoList = const [],
    this.tableThreeList = const [],
    this.formData = const {},
    this.formDetailList = const [],
    this.fieldsOneList = const [],
    this.fieldsTwoList = const [],
    this.fieldsThreeList = const [],
    this.editableRegionsNumber = Config.NUMBER_ZERO,
    this.contentSummaryList = const [],
    this.tableHeadersList = const [],
    this.tableHeadersTextList = const [],
    this.columnWidthsList = const {},
    // 自定义参数 - 终
  });
}
