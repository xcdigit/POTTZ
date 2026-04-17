import 'package:wms/model/ship.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * 内容：出荷确定 -参数
 * 作者：cuihr
 * 时间：2023/09/19
 */
class ShipmentDeterminationModel extends WmsTableModel {
  factory ShipmentDeterminationModel.clone(ShipmentDeterminationModel src) {
    ShipmentDeterminationModel dest = ShipmentDeterminationModel(
        receive: src.receive,
        rcvSchDate: src.rcvSchDate,
        companyId: src.companyId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.schDate = src.schDate;
    dest.count1 = src.count1;
    dest.count2 = src.count2;
    dest.count3 = src.count3;
    dest.currentIndex = src.currentIndex;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }
  // 自定义参数 - 始
  //会社id
  int? companyId;
  //出荷确定 出荷指示日 当前时间
  // DateTime rcvSchDate = DateTime.now();
  String rcvSchDate = '';
  //出荷确定
  Ship receive = Ship.empty();
  Map<String, dynamic> schDate = {};
  //tab未确定个数
  int count1 = 0;
  //tab已确定个数
  int count2 = 0;
  //ta一览个数
  int count3 = 0;

  int currentIndex = 0;
  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  ShipmentDeterminationModel({
    required this.companyId,
    required this.receive,
    required this.rcvSchDate,
    this.loadingFlag = true,
    this.schDate = const {},
    this.sortCol = 'rcv_sch_date',
    this.ascendingFlg = false,
  });
}
