import 'package:flutter/material.dart';

import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：操作ログ-参数
 * 作者：luxy
 * 时间：2023/11/27
 */
class OperateLogModel extends WmsTableModel {
  // 克隆
  factory OperateLogModel.clone(OperateLogModel src) {
    OperateLogModel dest = OperateLogModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.context = src.context;
    dest.conditionList = src.conditionList;
    dest.searchContent = src.searchContent;
    dest.searchTypeKbn = src.searchTypeKbn;
    dest.searchCompanyName = src.searchCompanyName;
    dest.typeKbn = src.typeKbn;
    dest.searchTypeKbnList = src.searchTypeKbnList;
    dest.company = src.company;
    dest.companyList = src.companyList;
    dest.companyId = src.companyId;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext context;
  // 检索条件集合
  List<String> conditionList = [];
  // 查询：操作内容
  String searchContent = '';
  // 查询：ログレベル
  String searchTypeKbn = '';
  //查询：会社
  String searchCompanyName = '';
  int companyId = 0;
  //ログレベル数据
  Map<String, dynamic> typeKbn = {};
  // ログレベル 列表
  List<Map<String, dynamic>> searchTypeKbnList = [
    {'name': 'INFO'},
    {'name': 'ERROR'},
    {'name': 'WARN'},
  ];
  Map<String, dynamic> company = {};
  List<dynamic> companyList = [];
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'create_time';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  OperateLogModel({
    // 自定义参数 - 始
    required this.context,
    this.conditionList = const [],
    this.loadingFlag = true,
    this.searchContent = '',
    this.companyId = 0,
    this.sortCol = 'create_time',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
