import 'package:wms/page/sys/information_management/bloc/information_management_bloc.dart';

import '../../../../model/ship.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：運用基本情報管理-参数
 * 作者：王光顺
 * 时间：2023/09/12
 */
class InformationManagementModel extends WmsTableModel {
  // 克隆
  factory InformationManagementModel.clone(InformationManagementModel src) {
    InformationManagementModel dest = InformationManagementModel();
    dest.records = src.records;
    dest.total = src.total;
    dest.customerList = src.customerList;

    // 自定义参数 - 始

    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始

  // 基本情报-定制
  Map<String, dynamic> customerList = {};

  // 出荷指示
  Ship ship = Ship.empty();

  // 自定义参数 - 终

  // 构造函数
  InformationManagementModel({
    // 自定义参数 - 始
    this.customerList = const {},
    // 自定义参数 - 终
  });

  void add(SetInformationValueEvent setInformationValueEvent) {}
}
