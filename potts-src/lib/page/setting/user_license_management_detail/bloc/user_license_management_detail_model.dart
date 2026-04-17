import 'package:flutter/widgets.dart';
import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：ユーザーライセンス管理明细-参数
 * 作者：熊草云
 * 时间：2023/12/07
 */
class UserLicenseManagementDetailModel extends WmsTableModel {
  // 克隆
  factory UserLicenseManagementDetailModel.clone(
      UserLicenseManagementDetailModel src) {
    UserLicenseManagementDetailModel dest = UserLicenseManagementDetailModel(
        context: src.context,
        formInfo: src.formInfo,
        companyId: src.companyId,
        roleId: src.roleId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.companyId = src.companyId;
    dest.roleId = src.roleId;
    dest.formInfo = src.formInfo;
    dest.detailFormTypeInfo = src.detailFormTypeInfo;
    dest.detailFormManageInfo = src.detailFormManageInfo;
    dest.conditionList = src.conditionList;
    dest.tableTabIndex = src.tableTabIndex;
    dest.loadingFlag = src.loadingFlag;
    dest.salesCompanyInfoList = src.salesCompanyInfoList;
    dest.salesRoleInfoList = src.salesRoleInfoList;
    dest.salesOrganizationfoList = src.salesOrganizationfoList;
    dest.salesStatusInfoList = src.salesStatusInfoList;
    dest.salesLanguageInfoList = src.salesLanguageInfoList;
    dest.nowOrganizationId = src.nowOrganizationId;
    dest.salesTypeInfoList = src.salesTypeInfoList;
    dest.salesPaymentStatusInfoList = src.salesPaymentStatusInfoList;
    dest.backpayNo = src.backpayNo;
    dest.updateForm = src.updateForm;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  int roleId;
  int companyId;
  // 会社情报
  Map<String, dynamic> formInfo = {};
  // 明细弹窗数据
  Map<String, dynamic> detailFormTypeInfo = {};
  Map<String, dynamic> detailFormManageInfo = {};
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
  // type列表
  List salesTypeInfoList = [];
  // 支払状態列表
  List salesPaymentStatusInfoList = [];
  // 当前选择的组织id
  int? nowOrganizationId;
  // 支付页面返回的订单编号
  String? backpayNo;
  // 修正
  bool updateForm = false;
  // 自定义参数 - 终

  // 构造函数
  UserLicenseManagementDetailModel({
    required this.context,
    required this.formInfo,
    required this.companyId,
    required this.roleId,
    this.detailFormTypeInfo = const {},
    this.detailFormManageInfo = const {},
    this.conditionList = const [],
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.loadingFlag = true,
    this.salesCompanyInfoList = const [],
    this.salesOrganizationfoList = const [],
    this.salesRoleInfoList = const [],
    this.salesStatusInfoList = const [],
    this.salesLanguageInfoList = const [],
    this.salesTypeInfoList = const [],
    this.salesPaymentStatusInfoList = const [],
    this.nowOrganizationId,
    this.backpayNo,
    this.updateForm = false,
  });
}
