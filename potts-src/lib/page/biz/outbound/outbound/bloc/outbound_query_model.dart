import '../../../../../model/ship.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：出庫照会-参数
 * 作者：王光顺
 * 时间：2023/09/12
 */
class OutboundQueryModel extends WmsTableModel {
  // 克隆
  factory OutboundQueryModel.clone(OutboundQueryModel src) {
    OutboundQueryModel dest = OutboundQueryModel(companyId: src.companyId);
    dest.copy(src);
    dest.companyId = src.companyId;
    dest.ckId = src.ckId;
    dest.ckIdList = src.ckIdList;
    dest.count = src.count;
    dest.count1 = src.count1;
    dest.count2 = src.count2;
    dest.count3 = src.count3;
    dest.loadingFlag = src.loadingFlag;
    // 自定义参数 - 始

    dest.shipCustomize = src.shipCustomize;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }
  int companyId;
  int count = 0; //总数

  int count1 = 0;
  int count2 = 0;
  int count3 = 0;

  // 自定义参数 - 始
  // 客户列表
  List<Map<String, dynamic>> customerList = [];
  // 收件人列表
  List<Map<String, dynamic>> customerAddressList = [];
  // 仓库列表
  List<Map<String, dynamic>> warehouseList = [];
  // 商品列表
  List<Map<String, dynamic>> productList = [];
  // 出库入力
  int ckId = 0;
  List<int> ckIdList = [];
  // 出荷指示条件-定制
  Map<String, dynamic> shipCustomize = {};

  // 出荷指示
  Ship ship = Ship.empty();

  DateTime? rcvSchDate;

  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;

  // 自定义参数 - 终

  // 构造函数
  OutboundQueryModel({
    // 自定义参数 - 始
    this.shipCustomize = const {},
    this.customerList = const [],
    this.customerAddressList = const [],
    this.warehouseList = const [],
    this.productList = const [],
    required this.companyId,
    this.loadingFlag = true,
    this.ckId = 0,
    this.sortCol = 'rcv_sch_date',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
