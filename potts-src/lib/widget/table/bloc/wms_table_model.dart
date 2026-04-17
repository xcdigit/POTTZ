import 'package:wms/widget/table/bloc/wms_record_model.dart';

import '../../../db/model/filter_criteria.dart';

class WmsTableModel {
  // 页数
  int pageNum = 0;
  // 条数
  int pageSize = 10;
  // 总页数
  int total = 0;
  // 列表数据
  List<WmsRecordModel> records = [];
  // match条件
  Map? matchCriteria = {};
  // filter条件
  List<FilterCriteria>? filterCriteria = [];
  // 操作弹窗选项
  List<dynamic> operatePopupOptions;
  // 操作弹窗高度
  double operatePopupHeight;

  WmsTableModel({
    this.pageNum = 0,
    this.pageSize = 10,
    this.matchCriteria,
    this.filterCriteria,
    this.operatePopupOptions = const <List>[],
    this.operatePopupHeight = 134,
  });

  void copy(WmsTableModel src) {
    this.pageNum = src.pageNum;
    this.pageSize = src.pageSize;
    this.total = src.total;
    this.records = src.records;
    this.matchCriteria = src.matchCriteria;
    this.filterCriteria = src.filterCriteria;
    this.operatePopupOptions = src.operatePopupOptions;
    this.operatePopupHeight = src.operatePopupHeight;
  }

  int getMaxPage() {
    return (total / pageSize).ceil();
  }

  List<WmsRecordModel> checkedRecords() {
    List<WmsRecordModel> result = <WmsRecordModel>[];
    records.forEach((element) {
      if (element.checked) {
        result.add(element);
      }
    });
    return result;
  }

  int checkedRecordCnt() {
    int count = 0;
    records.forEach((element) {
      if (element.checked) {
        count++;
      }
    });
    return count;
  }
}
