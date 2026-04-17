import 'package:wms/widget/table/bloc/wms_table_model.dart';

import '../../../../../common/config/config.dart';

class WarehouseInspectionModel extends WmsTableModel {
  // 克隆
  factory WarehouseInspectionModel.clone(WarehouseInspectionModel src) {
    WarehouseInspectionModel dest =
        WarehouseInspectionModel(compareId: src.compareId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.receiveKbnList = src.receiveKbnList;
    dest.rcv_sch_date = src.rcv_sch_date;
    dest.receive_no = src.receive_no;
    dest.receiveKbn_state = src.receiveKbn_state;
    dest.receiveKbn_state_no = src.receiveKbn_state_no;
    dest.count = src.count;
    dest.currentIndex = src.currentIndex;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }
  // 自定义参数 - 始
  int compareId = 0;
  //入荷状态列表 2,3,4,5
  List<Map<String, dynamic>> receiveKbnList;
  //入荷予定日
  String rcv_sch_date = '';
  //选中入荷予定番号
  String receive_no = '';
  // 选中的入荷状态
  String receiveKbn_state = '';
  dynamic receiveKbn_state_no;
  int count = 0;

  int currentIndex = 0;
  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终
  WarehouseInspectionModel({
    required this.compareId,
    this.loadingFlag = true,
    this.receiveKbnList = const [
      {'receive_kbn': Config.RECEIVE_KBN_WAIT_INBOUND, 'receive_text': '入庫待ち'},
      {
        'receive_kbn': Config.RECEIVE_KBN_IS_BEING_INBOUND,
        'receive_text': '入庫中'
      },
      {
        'receive_kbn': Config.RECEIVE_KBN_WAIT_RECEIVE_CONFIRM,
        'receive_text': '入荷確定待ち'
      },
      {'receive_kbn': Config.RECEIVE_KBN_RECEIVED, 'receive_text': '入荷済み'},
    ],
    this.sortCol = 'rcv_sch_date',
    this.ascendingFlg = false,
  });
}
