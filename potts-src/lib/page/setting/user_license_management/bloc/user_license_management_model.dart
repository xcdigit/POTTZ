import 'package:flutter/widgets.dart';
import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：ユーザーライセンス管理-参数
 * 作者：熊草云
 * 时间：2023/12/07
 */
class UserLicenseManagementModel extends WmsTableModel {
  // 克隆
  factory UserLicenseManagementModel.clone(UserLicenseManagementModel src) {
    UserLicenseManagementModel dest = UserLicenseManagementModel(
        context: src.context, roleId: src.roleId, companyId: src.companyId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.roleId = src.roleId;
    dest.companyId = src.companyId;
    dest.companyName = src.companyName;
    dest.formInfo = src.formInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.tableTabIndex = src.tableTabIndex;
    dest.loadingFlag = src.loadingFlag;
    dest.salesCompanyInfoList = src.salesCompanyInfoList;
    dest.salesRoleInfoList = src.salesRoleInfoList;
    dest.salesOrganizationfoList = src.salesOrganizationfoList;
    dest.salesStatusInfoList = src.salesStatusInfoList;
    dest.salesLanguageInfoList = src.salesLanguageInfoList;
    dest.nowCompanyId = src.nowCompanyId;
    dest.nowRoleId = src.nowRoleId;
    dest.nowOrganizationId = src.nowOrganizationId;
    dest.nowLanguageId = src.nowLanguageId;
    dest.searchRoleId = src.searchRoleId;
    dest.userCode = src.userCode;
    dest.searchStatusId = src.searchStatusId;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 角色id
  int roleId;
  int companyId;
  String companyName = '';
  // 会社情报
  Map<String, dynamic> formInfo = {};
  // 检索条件
  Map<String, dynamic> searchInfo = {};
  // 检索条件展示用
  List<Map<String, dynamic>> conditionList = [];
  // 结构树
  BuildContext context;
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  // 加载标记
  bool loadingFlag = true;
  // 会社名列表
  List salesCompanyInfoList = [];
  // ロール列表
  List salesRoleInfoList = [];
  // 組織名列表
  List salesOrganizationfoList = [];
  // 状態列表
  List salesStatusInfoList = [];
  // 言語列表
  List salesLanguageInfoList = [];
  // 当前选择的会社id
  int? nowCompanyId;
  // 当前选择的角色ID
  int? nowRoleId;
  // 当前选择的组织id
  int? nowOrganizationId;
  // 当前选择的语言ID
  int? nowLanguageId;
  // 检索角色id
  int? searchRoleId;
  // 检索状态id
  String? searchStatusId;
  // code
  String? userCode;
  //排序字段
  String sortCol = 'id';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  UserLicenseManagementModel({
    required this.context,
    required this.roleId,
    required this.companyId,
    this.companyName = '',
    this.formInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.loadingFlag = true,
    this.salesCompanyInfoList = const [],
    this.salesOrganizationfoList = const [],
    this.salesRoleInfoList = const [],
    this.salesStatusInfoList = const [],
    this.salesLanguageInfoList = const [],
    this.nowCompanyId,
    this.nowRoleId,
    this.nowOrganizationId,
    this.nowLanguageId,
    this.searchRoleId,
    this.userCode,
    this.searchStatusId,
    this.sortCol = 'id',
    this.ascendingFlg = false,
  });
}
