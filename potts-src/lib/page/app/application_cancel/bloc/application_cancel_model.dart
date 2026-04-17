import 'package:flutter/material.dart';

import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：解约受付-参数
 * 作者：赵士淞
 * 时间：2025/01/08
 */
class ApplicationCancelModel extends WmsTableModel {
  // 克隆
  factory ApplicationCancelModel.clone(ApplicationCancelModel src) {
    ApplicationCancelModel dest =
        ApplicationCancelModel(rootContext: src.rootContext);
    dest.copy(src);
    dest.companyList = src.companyList;
    dest.loadingFlag = src.loadingFlag;
    dest.tableTabIndex = src.tableTabIndex;
    dest.queryButtonFlag = src.queryButtonFlag;
    dest.searchCompanyId = src.searchCompanyId;
    dest.searchCompanyName = src.searchCompanyName;
    dest.searchUserName = src.searchUserName;
    dest.searchUserEmail = src.searchUserEmail;
    dest.queryCompanyId = src.queryCompanyId;
    dest.queryCompanyName = src.queryCompanyName;
    dest.queryUserName = src.queryUserName;
    dest.queryUserEmail = src.queryUserEmail;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 公司列表
  List<Map<String, dynamic>> companyList;
  // 加载标记
  bool loadingFlag;
  // 表格标签下标
  int tableTabIndex;
  // 检索按钮标记
  bool queryButtonFlag;
  // 查询：公司ID
  int searchCompanyId;
  // 查询：公司名称
  String searchCompanyName;
  // 查询：用户名称
  String searchUserName;
  // 查询：用户邮箱
  String searchUserEmail;
  // 检索：公司ID
  int queryCompanyId;
  // 查询：公司名称
  String queryCompanyName;
  // 检索：用户名称
  String queryUserName;
  // 检索：用户邮箱
  String queryUserEmail;
  //排序字段
  String sortCol = 'create_time';
  // 升降排序
  bool ascendingFlg = false;

  // 构造函数
  ApplicationCancelModel({
    required this.rootContext,
    this.companyList = const [],
    this.loadingFlag = true,
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.queryButtonFlag = false,
    this.searchCompanyId = Config.NUMBER_ZERO,
    this.searchCompanyName = '',
    this.searchUserName = '',
    this.searchUserEmail = '',
    this.queryCompanyId = Config.NUMBER_ZERO,
    this.queryCompanyName = '',
    this.queryUserName = '',
    this.queryUserEmail = '',
    this.sortCol = 'create_time',
    this.ascendingFlg = false,
  });
}
