class WmsRecordModel {
  // 行番号
  int index;
  // 选中状态
  bool checked;
  // 行数据
  Map<String, dynamic> data;

  WmsRecordModel(this.index, this.data, {this.checked = false});
}