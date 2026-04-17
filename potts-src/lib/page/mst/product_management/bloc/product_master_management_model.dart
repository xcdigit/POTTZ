import 'package:flutter/widgets.dart';
import '../../../../common/config/config.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：商品マスタ管理-参数
 * 作者：穆政道
 * 时间：2023/09/21
 */
class ProductMasterManagementModel extends WmsTableModel {
  // 克隆
  factory ProductMasterManagementModel.clone(ProductMasterManagementModel src) {
    ProductMasterManagementModel dest =
        ProductMasterManagementModel(context: src.context);
    dest.copy(src);
    // 自定义参数 - 始
    dest.productInfo = src.productInfo;
    dest.searchInfo = src.searchInfo;
    dest.conditionList = src.conditionList;
    dest.image1Network = src.image1Network;
    dest.image2Network = src.image2Network;
    dest.tableTabIndex = src.tableTabIndex;
    dest.stateFlg = src.stateFlg;
    dest.loadingFlag = src.loadingFlag;
    dest.roleId = src.roleId;
    dest.companyInfoList = src.companyInfoList;
    dest.productNameLength = src.productNameLength;
    dest.searchFlag = src.searchFlag;
    dest.searchDataFlag = src.searchDataFlag;
    dest.searchButtonHovered = src.searchButtonHovered;
    dest.importButtonHovered = src.importButtonHovered;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 商品情报
  Map<String, dynamic> productInfo = {};
  // 检索条件
  Map<String, dynamic> searchInfo = {};
  // 检索条件展示用
  List<Map<String, dynamic>> conditionList = [];
  // 结构树
  BuildContext context;
  //写真1展示路径
  String image1Network;
  //写真2展示路径
  String image2Network;
  //当前状态 1登录/修正 2查看
  String stateFlg;
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  // 加载标记
  bool loadingFlag = true;
  // 角色ID
  int roleId;
  // 公司列表
  List<dynamic> companyInfoList;
  // 商品名初始长度
  double productNameLength;
  //
  bool searchFlag = false;
  //
  bool searchDataFlag = false;
  //
  bool searchButtonHovered = false;
  //
  bool importButtonHovered = false;
  //排序字段
  String sortCol = 'code';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  ProductMasterManagementModel({
    required this.context,
    this.productInfo = const {},
    this.searchInfo = const {},
    this.conditionList = const [],
    this.image1Network = '',
    this.image2Network = '',
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.loadingFlag = true,
    this.stateFlg = '1',
    this.roleId = 0,
    this.companyInfoList = const [],
    this.productNameLength = 0.6,
    this.searchFlag = false,
    this.searchDataFlag = false,
    this.searchButtonHovered = false,
    this.importButtonHovered = false,
    this.sortCol = 'code',
    this.ascendingFlg = false,
  });
}
