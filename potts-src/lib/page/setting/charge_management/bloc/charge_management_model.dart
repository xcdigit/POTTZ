import 'package:flutter/widgets.dart';
import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：課金法人管理-参数
 * 作者：熊草云
 * 时间：2023/12/05
 */
class ChargeManagementModel extends WmsTableModel {
  // 克隆
  factory ChargeManagementModel.clone(ChargeManagementModel src) {
    ChargeManagementModel dest = ChargeManagementModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.formInfo = src.formInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.stateFlg = src.stateFlg;
    dest.tableTabIndex = src.tableTabIndex;
    dest.loadingFlag = src.loadingFlag;
    dest.salesCompanyInfoList = src.salesCompanyInfoList;
    dest.salesUserInfoList = src.salesUserInfoList;
    dest.nowCompanyId = src.nowCompanyId;
    dest.nowUserId = src.nowUserId;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
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
  // 会社名列表
  List salesCompanyInfoList = [];
  // 管理员列表
  List salesUserInfoList = [];
  // 当前选择的会社id
  int? nowCompanyId;
  // 当前选择的管理员ID
  int? nowUserId;
  // 自定义参数 - 终

  // 构造函数
  ChargeManagementModel({
    required this.context,
    this.formInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.loadingFlag = true,
    this.stateFlg = '1',
    this.salesCompanyInfoList = const [],
    this.salesUserInfoList = const [],
    this.nowCompanyId,
    this.nowUserId,
  });
}
