import 'package:flutter/cupertino.dart';

import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：組織マスタ-参数
 * 作者：熊草云
 * 时间：2023/11/29
 */
class OrganizationMasterModel extends WmsTableModel {
  factory OrganizationMasterModel.clone(OrganizationMasterModel src) {
    OrganizationMasterModel dest = OrganizationMasterModel(
        context: src.context,
        companyId: src.companyId,
        roleId: src.roleId,
        flag_num: src.flag_num,
        currentParam: src.currentParam);
    dest.copy(src);
    //自定义参数 - 始
    dest.companyId = src.companyId;
    dest.roleId = src.roleId;
    dest.formInfo = src.formInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.tableTabIndex = src.tableTabIndex;
    dest.stateFlg = src.stateFlg;
    dest.loadingFlag = src.loadingFlag;
    dest.salesCompanyInfoList = src.salesCompanyInfoList;
    dest.allCompanyInfoList = src.allCompanyInfoList;
    dest.nowCompanyId = src.nowCompanyId;
    dest.parentID = src.parentID;
    dest.companyName = src.companyName;
    dest.startparentID = src.startparentID;
    dest.flag_num = src.flag_num;
    dest.currentParam = src.currentParam;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    //自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  //会社id
  int? companyId;
  // 角色id
  int? roleId;
  // 结构树
  BuildContext context;
  //当前状态 1登录/修正 2查看
  String stateFlg;
  // 表单情报
  Map<String, dynamic> formInfo = {};
  //检索条件
  Map<String, dynamic> searchInfo = {};
  // 检索条件展示用
  List<Map<String, dynamic>> conditionList = [];
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  // 加载标记
  bool loadingFlag = true;
  // 会社名集合
  List salesCompanyInfoList = const [];
  // 会社名集合（包括退社）
  List allCompanyInfoList = const [];
  // 当前选择的会社id
  int? nowCompanyId;
  // 父节点
  int? parentID;
  // 初始会社名
  String? companyName;
  // 初始父节点
  int? startparentID;
  // SP跳转携带的参数-判断是登录/修正/明细
  String? flag_num;
  // SP跳转携带的参数-被选中的table数据
  Map<String, dynamic>? currentParam;
  //排序字段
  String sortCol = 'code';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  //构造函数
  OrganizationMasterModel({
    required this.context,
    required this.companyId,
    required this.roleId,
    this.formInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.stateFlg = '1',
    this.loadingFlag = true,
    this.salesCompanyInfoList = const [],
    this.allCompanyInfoList = const [],
    this.nowCompanyId,
    this.parentID,
    this.companyName,
    this.startparentID,
    this.flag_num,
    this.currentParam,
    this.sortCol = 'code',
    this.ascendingFlg = false,
  });
}
