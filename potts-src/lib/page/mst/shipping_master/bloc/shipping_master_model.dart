import 'package:flutter/cupertino.dart';

import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：荷主マスタ-参数
 * 作者：王光顺
 * 时间：2023/11/29
 */
class ShippingMasterModel extends WmsTableModel {
  factory ShippingMasterModel.clone(ShippingMasterModel src) {
    ShippingMasterModel dest = ShippingMasterModel(
        context: src.context,
        companyId: src.companyId,
        roleId: src.roleId,
        flag_num: src.flag_num,
        flag_data: src.flag_data);
    dest.copy(src);
    //自定义参数 - 始
    dest.companyId = src.companyId;
    dest.roleId = src.roleId;
    dest.formInfo = src.formInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.searchKbn = src.searchKbn;
    dest.tableTabIndex = src.tableTabIndex;
    dest.stateFlg = src.stateFlg;
    dest.loadingFlag = src.loadingFlag;
    dest.salesCompanyInfoList = src.salesCompanyInfoList;
    dest.flag_num = src.flag_num;
    dest.flag_data = src.flag_data;
    dest.nowCompanyId = src.nowCompanyId;
    dest.searchFlag = src.searchFlag;
    dest.searchDataFlag = src.searchDataFlag;
    dest.searchButtonHovered = src.searchButtonHovered;
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
  //显示检索条件
  List<Map<String, dynamic>> conditionList = [];

  // 设置当前会社ID
  int? nowCompanyId;

  String searchKbn = '';
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  // 加载标记
  bool loadingFlag = true;

  // 会社名集合
  List salesCompanyInfoList = const [];

  //判断修改或登录状态flg
  String? flag_num;

  //跳转所用数据
  Map<String, dynamic>? flag_data;
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
  ShippingMasterModel({
    required this.context,
    required this.companyId,
    required this.roleId,
    this.nowCompanyId,
    this.formInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.searchKbn = '',
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.stateFlg = '1',
    this.loadingFlag = true,
    this.flag_num,
    this.flag_data,
    this.searchFlag = false,
    this.searchDataFlag = false,
    this.searchButtonHovered = false,
    this.sortCol = 'id',
    this.ascendingFlg = false,
  });
}
