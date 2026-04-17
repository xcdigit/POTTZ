import 'package:flutter/cupertino.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';
import '../../../../common/config/config.dart';

/**
 * 内容：配送業者マスタ管理-参数
 * 作者：ciuhr
 * 时间：2023/12/01
 */
class DeliveryOperatorsMasterModel extends WmsTableModel {
  factory DeliveryOperatorsMasterModel.clone(DeliveryOperatorsMasterModel src) {
    DeliveryOperatorsMasterModel dest = DeliveryOperatorsMasterModel(
        context: src.context, companyId: src.companyId, roleId: src.roleId);
    dest.copy(src);
    //自定义参数 - 始
    dest.companyList = src.companyList;
    dest.companyId = src.companyId;
    dest.roleId = src.roleId;
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
    //自定义参数 - 终
    return dest;
  }
  // 自定义参数 - 始

  // 父菜单情报
  List<Map<String, dynamic>> companyList = [];
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

  List<Map<String, dynamic>> conditionList = [];

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

  //构造函数
  DeliveryOperatorsMasterModel({
    required this.context,
    this.companyList = const [],
    required this.companyId,
    required this.roleId,
    this.formInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.stateFlg = '1',
    this.loadingFlag = true,
    this.searchFlag = false,
    this.searchDataFlag = false,
    this.searchButtonHovered = false,
    this.sortCol = 'id',
    this.ascendingFlg = false,
  });
}
