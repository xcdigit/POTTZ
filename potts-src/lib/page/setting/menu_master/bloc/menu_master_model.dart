import 'package:flutter/widgets.dart';

import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：菜单マスタ管理-参数
 * 作者：穆政道
 * 时间：2023/10/08
 */
class MenuMasterModel extends WmsTableModel {
  // 克隆
  factory MenuMasterModel.clone(MenuMasterModel src) {
    MenuMasterModel dest = MenuMasterModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.parentList = src.parentList;
    dest.formInfo = src.formInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.stateFlg = src.stateFlg;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 父菜单情报
  List<dynamic> parentList = [];
  // 菜单情报
  Map<String, dynamic> formInfo = {};
  // 检索条件
  Map<String, dynamic> searchInfo = {};
  // 检索条件展示用
  List<Map<String, dynamic>> conditionList = [];
  // 结构树
  BuildContext context;
  //当前状态 1登录/修正 2查看
  String stateFlg;
  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'id';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  MenuMasterModel({
    required this.context,
    this.parentList = const [],
    this.formInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.loadingFlag = true,
    this.stateFlg = '1',
    this.sortCol = 'id',
    this.ascendingFlg = false,
  });
}
