import 'package:wms/common/config/config.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * 内容：ロケーションマスタ管理 -参数
 * 作者：cuihr
 * 时间：2023/09/11
 */
class LocationMasterModel extends WmsTableModel {
  factory LocationMasterModel.clone(LocationMasterModel src) {
    LocationMasterModel dest =
        LocationMasterModel(companyId: src.companyId, roleId: src.roleId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.loadingFlag = src.loadingFlag;
    dest.warehouseList = src.warehouseList;
    dest.detailsMap = src.detailsMap;
    dest.formFlag = src.formFlag;
    dest.locationKbn = src.locationKbn;
    dest.tableTabIndex = src.tableTabIndex;
    dest.searchFlag = src.searchFlag;
    dest.searchDataFlag = src.searchDataFlag;
    dest.searchButtonHovered = src.searchButtonHovered;
    dest.conditionList = src.conditionList;
    dest.searchInfo = src.searchInfo;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }
  // 自定义参数 - 始
  //会社id
  int? companyId;
  //角色id
  int? roleId;
  // 加载标记
  bool loadingFlag = true;
  //仓库列表
  List<dynamic> warehouseList = [];
  //form数据
  Map<String, dynamic> detailsMap = {};
  //表格 明细/修改状态
  String formFlag;
  //自定义区分列表
  List<Map<String, dynamic>> locationKbn = [];
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  //
  bool searchFlag = false;
  //
  bool searchDataFlag = false;
  //
  bool searchButtonHovered = false;
  // 检索条件展示用
  List<Map<String, dynamic>> conditionList = [];
  // 检索条件
  Map<String, dynamic> searchInfo = {};
  //排序字段
  String sortCol = 'id';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  LocationMasterModel({
    required this.companyId,
    required this.roleId,
    this.loadingFlag = true,
    this.warehouseList = const [],
    this.detailsMap = const {},
    this.formFlag = '',
    this.locationKbn = const [
      {'kbn': Config.LOCATION_KBN_S},
      {'kbn': Config.LOCATION_KBN_B},
      {'kbn': Config.LOCATION_KBN_C}
    ],
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.searchFlag = false,
    this.searchDataFlag = false,
    this.searchButtonHovered = false,
    this.conditionList = const [],
    this.searchInfo = const {},
    this.sortCol = 'id',
    this.ascendingFlg = false,
  });
}
