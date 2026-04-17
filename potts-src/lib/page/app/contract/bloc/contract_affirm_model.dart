import 'package:wms/page/app/contract/bloc/contract_bloc.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：サービス解約-参数
 * 作者：王光顺
 * 时间：2023/12/07
 */

class ContractAffirmModel extends WmsTableModel {
  // 克隆
  factory ContractAffirmModel.clone(ContractAffirmModel src) {
    ContractAffirmModel dest = ContractAffirmModel(DateList: src.DateList);
    dest.copy(src);
    // 自定义参数 - 始
    dest.DateList = src.DateList;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 传参
  List<Map<String, dynamic>> DateList = [];
  // 自定义参数 - 终

  // 构造函数
  ContractAffirmModel({
    required this.DateList,
  });

  void add(InitEvent initEvent) {}
}
