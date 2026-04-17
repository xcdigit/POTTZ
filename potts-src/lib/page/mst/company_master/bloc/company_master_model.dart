import 'package:flutter/widgets.dart';
import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：会社マスタ管理-参数
 * 作者：穆政道
 * 时间：2023/09/21
 */
class CompanyMasterModel extends WmsTableModel {
  // 克隆
  factory CompanyMasterModel.clone(CompanyMasterModel src) {
    CompanyMasterModel dest = CompanyMasterModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.onlyMyselfData = src.onlyMyselfData;
    dest.statusList = src.statusList;
    dest.forcedList = src.forcedList;
    dest.formInfo = src.formInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.stateFlg = src.stateFlg;
    dest.tableTabIndex = src.tableTabIndex;
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
  // 仅自己数据
  bool onlyMyselfData = false;
  // 状态列表
  List<Map<String, dynamic>> statusList = [];
  // 強制出荷列表
  List<Map<String, dynamic>> forcedList = [];
  // 会社情报
  Map<String, dynamic> formInfo = {};
  // 检索条件
  Map<String, dynamic> searchInfo = {};
  // 检索条件展示用
  List<Map<String, dynamic>> conditionList = [];
  // 结构树
  BuildContext context;
  //当前状态 1登录/修正 2查看
  String stateFlg;
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
  CompanyMasterModel({
    required this.context,
    this.onlyMyselfData = false,
    this.statusList = const [],
    this.forcedList = const [],
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
