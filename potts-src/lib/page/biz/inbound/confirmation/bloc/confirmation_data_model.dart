import 'package:wms/model/receive.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * 内容：入荷確定データ出力 -参数
 * 作者：cuihr
 * 时间：2023/09/07
 */
class ConfirmationDataModel extends WmsTableModel {
  factory ConfirmationDataModel.clone(ConfirmationDataModel src) {
    ConfirmationDataModel dest =
        ConfirmationDataModel(receive: src.receive, rcvSchDate: src.rcvSchDate);
    dest.copy(src);
    dest.loadingFlag = src.loadingFlag;
    // 自定义参数 - 始
    dest.schDate = src.schDate;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }
  // 自定义参数 - 始
  //入荷确定出力 入荷予定日
  DateTime rcvSchDate = DateTime.now();
  //入荷确定
  Receive receive = Receive.empty();
  Map<String, dynamic> schDate = {};
  //排序字段
  String sortCol = 'rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;

  // 加载标记
  bool loadingFlag = true;
  // 自定义参数 - 终
  // 构造函数
  ConfirmationDataModel({
    required this.receive,
    required this.rcvSchDate,
    this.loadingFlag = true,
    this.schDate = const {},
    this.sortCol = 'rcv_sch_date',
    this.ascendingFlg = false,
  });
}
