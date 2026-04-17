import 'package:flutter/cupertino.dart';

import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：纳入先マスタ管理-参数
 * 作者：ciuhr
 * 时间：2023/10/9
 */
class DeliveryModel extends WmsTableModel {
  // 克隆
  factory DeliveryModel.clone(DeliveryModel src) {
    DeliveryModel dest = DeliveryModel(
        context: src.context, companyId: src.companyId, roleId: src.roleId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.companyId = src.companyId;
    dest.roleId = src.roleId;
    dest.count = src.count;
    dest.companyList = src.companyList;
    dest.formInfo = src.formInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.tableTabIndex = src.tableTabIndex;
    dest.stateFlg = src.stateFlg;
    dest.loadingFlag = src.loadingFlag;
    dest.searchFlag = src.searchFlag;
    dest.searchDataFlag = src.searchDataFlag;
    dest.searchButtonHovered = src.searchButtonHovered;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }
  // 自定义参数 - 始
  //会社id
  int? companyId;
  // 角色id
  int? roleId;
  // 结构树
  BuildContext context;
  // 会社情报集合
  List<dynamic> companyList = [];
  // 会社情报
  Map<String, dynamic> formInfo = {};
  // 检索条件
  Map<String, dynamic> searchInfo = {};
  // 检索条件展示用
  List<Map<String, dynamic>> conditionList = [];
  //当前状态 1登录/修正 2查看
  String stateFlg;
  //一览总数
  int count = 0;
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  // 加载标记
  bool loadingFlag = true;
  //
  bool searchFlag = false;
  //
  bool searchDataFlag = false;
  //
  bool searchButtonHovered = false;
  //排序字段
  String sortCol = 'id';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  DeliveryModel({
    required this.context,
    required this.companyId,
    required this.roleId,
    this.companyList = const [],
    this.formInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.loadingFlag = true,
    this.stateFlg = '1',
    this.searchFlag = false,
    this.searchDataFlag = false,
    this.searchButtonHovered = false,
    this.sortCol = 'id',
    this.ascendingFlg = false,
  });
}
