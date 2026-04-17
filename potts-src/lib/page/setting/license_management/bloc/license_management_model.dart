import 'package:flutter/cupertino.dart';

import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：ライセンス管理-参数
 * 作者：王光顺
 * 时间：2023/12/05
 */
class LicenseManagementModel extends WmsTableModel {
  factory LicenseManagementModel.clone(LicenseManagementModel src) {
    LicenseManagementModel dest = LicenseManagementModel(
        context: src.context, flag_num: src.flag_num, flag_data: src.flag_data);
    dest.copy(src);
    //自定义参数 - 始
    dest.formInfo = src.formInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.searchKbn = src.searchKbn;
    dest.tableTabIndex = src.tableTabIndex;
    dest.stateFlg = src.stateFlg;
    dest.loadingFlag = src.loadingFlag;
    dest.salesRoleInfoList = src.salesRoleInfoList;
    dest.flag_num = src.flag_num;
    dest.flag_data = src.flag_data;
    dest.nowRoleId = src.nowRoleId;
    // 赵士淞 - 始
    dest.completeRoleList = src.completeRoleList;
    // 赵士淞 - 终
    //自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 结构树
  BuildContext context;

  //当前状态 1登录/修正 2查看
  String stateFlg;

  // 表单情报
  Map<String, dynamic> formInfo = {};

  //检索条件
  Map<String, dynamic> searchInfo = {};

  List<Map<String, dynamic>> conditionList = [];

  //当前角色ID
  int? nowRoleId;

  String searchKbn = '';

  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;

  // 加载标记
  bool loadingFlag = true;

  // role集合
  List salesRoleInfoList = const [];

  //sp跳转状态
  String? flag_num;

  //sp跳转数据
  Map<String, dynamic>? flag_data;

  // 赵士淞 - 始
  // 完整角色列表
  List<dynamic> completeRoleList;
  // 赵士淞 - 终
  // 自定义参数 - 终

  //构造函数
  LicenseManagementModel({
    required this.context,
    this.nowRoleId,
    this.formInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.searchKbn = '',
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.stateFlg = '1',
    this.loadingFlag = true,
    this.flag_num,
    this.flag_data,
    // 赵士淞 - 始
    this.completeRoleList = const [],
    // 赵士淞 - 终
  });
}
