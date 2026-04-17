import 'package:flutter/material.dart';

import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：帳票マスタ明细-参数
 * 作者：赵士淞
 * 时间：2023/12/25
 */
class FormMasterDetailModel extends WmsTableModel {
  // 克隆
  factory FormMasterDetailModel.clone(FormMasterDetailModel src) {
    FormMasterDetailModel dest =
        FormMasterDetailModel(rootContext: src.rootContext, formId: src.formId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.loadingFlag = src.loadingFlag;
    dest.formCustomize = src.formCustomize;
    dest.locationList = src.locationList;
    dest.assortList = src.assortList;
    dest.tableList = src.tableList;
    dest.contentFieldsList = src.contentFieldsList;
    dest.calculationFields1List = src.calculationFields1List;
    dest.calculationFields2List = src.calculationFields2List;
    dest.calculationModeList = src.calculationModeList;
    dest.showList = src.showList;
    dest.formDetailCustomize = src.formDetailCustomize;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 账票ID
  int formId;
  // 加载标记
  bool loadingFlag = true;
  // 账票-定制
  Map<String, dynamic> formCustomize = {};
  // 位置列表
  List<Map<String, dynamic>> locationList = [];
  // 分类列表
  List<Map<String, dynamic>> assortList = [];
  // 表列表
  List<Map<String, dynamic>> tableList = [];
  // 内容字段列表
  List<Map<String, dynamic>> contentFieldsList = [];
  // 计算字段1列表
  List<Map<String, dynamic>> calculationFields1List = [];
  // 计算字段2列表
  List<Map<String, dynamic>> calculationFields2List = [];
  // 计算模式列表
  List<Map<String, dynamic>> calculationModeList = [];
  // 显示列表
  List<Map<String, dynamic>> showList = [];
  // 账票明细-定制
  Map<String, dynamic> formDetailCustomize = {};
  // 自定义参数 - 终

  // 构造函数
  FormMasterDetailModel({
    // 自定义参数 - 始
    required this.rootContext,
    required this.formId,
    this.loadingFlag = true,
    this.formCustomize = const {},
    this.locationList = const [],
    this.assortList = const [],
    this.tableList = const [],
    this.contentFieldsList = const [],
    this.calculationFields1List = const [],
    this.calculationFields2List = const [],
    this.calculationModeList = const [],
    this.showList = const [],
    this.formDetailCustomize = const {
      'id': '',
      'location': '',
      'location_title': '',
      'sequence_number': '',
      'assort': '',
      'assort_title': '',
      'content_table': '',
      'content_table_title': '',
      'content_fields': '',
      'content_fields_title': '',
      'calculation_table1': '',
      'calculation_table1_title': '',
      'calculation_fields1': '',
      'calculation_fields1_title': '',
      'calculation_table2': '',
      'calculation_table2_title': '',
      'calculation_fields2': '',
      'calculation_fields2_title': '',
      'calculation_mode': '',
      'calculation_mode_title': '',
      'show_field_name': '',
      'show_field_name_title': '',
      'word_size': '',
      'prefix_text': '',
      'suffix_text': '',
    },
    // 自定义参数 - 终
  });
}
