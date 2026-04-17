import 'package:flutter/cupertino.dart';

import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：倉庫マスタ管理-参数
 * 作者：王光顺
 * 时间：2023/10/10
 */
class WarehouseMasterModel extends WmsTableModel {
  // 克隆
  factory WarehouseMasterModel.clone(WarehouseMasterModel src) {
    WarehouseMasterModel dest =
        WarehouseMasterModel(context: src.context, companyId: src.companyId);
    dest.copy(src);
    // 自定义参数 - 始
    // 赵士淞 - 始
    dest.companyList = src.companyList;
    // 赵士淞 - 终
    dest.formInfo = src.formInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.stateFlg = src.stateFlg;
    dest.companyId = src.companyId;
    dest.loadingFlag = src.loadingFlag;
    dest.searchFlag = src.searchFlag;
    dest.searchDataFlag = src.searchDataFlag;
    dest.searchButtonHovered = src.searchButtonHovered;
    dest.onlyMyselfData = src.onlyMyselfData;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }
  // 自定义参数 - 始
  // 赵士淞 - 始
  // 会社列表
  List<dynamic> companyList = [];
  // 赵士淞 - 终
  // 菜单情报
  Map<String, dynamic> formInfo = {};
  // 检索条件
  Map<String, dynamic> searchInfo = {};
  // 检索条件展示用
  List<Map<String, dynamic>> conditionList = [];

  int companyId = 0;
  //当前状态 1登录/修正 2查看
  String stateFlg;
  // 加载标记
  bool loadingFlag = true;
  //
  bool searchFlag = false;
  //
  bool searchDataFlag = false;
  //
  bool searchButtonHovered = false;
  //
  bool onlyMyselfData = false;
  //排序字段
  String sortCol = 'id';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终
  // 结构树
  BuildContext context;
  // 构造函数
  WarehouseMasterModel({
    required this.context,
    required this.companyId,
    // 赵士淞 - 始
    this.companyList = const [],
    // 赵士淞 - 终
    this.formInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.loadingFlag = true,
    this.stateFlg = '1',
    this.searchFlag = false,
    this.searchDataFlag = false,
    this.searchButtonHovered = false,
    this.onlyMyselfData = false,
    this.sortCol = 'id',
    this.ascendingFlg = false,
  });
}
