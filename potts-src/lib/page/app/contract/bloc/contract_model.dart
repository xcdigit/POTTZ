import 'package:flutter/widgets.dart';
import 'package:wms/page/app/contract/bloc/contract_bloc.dart';
import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：サービス解約-参数
 * 作者：王光顺
 * 时间：2023/12/07
 */

class ContractModel extends WmsTableModel {
  // 克隆
  factory ContractModel.clone(ContractModel src) {
    ContractModel dest =
        ContractModel(context: src.context, companyId: src.companyId);
    dest.copy(src);
    // 自定义参数 - 始
    dest.formInfo = src.formInfo;
    dest.formDateInfo = src.formDateInfo;
    dest.companyId = src.companyId;
    dest.languageList = src.languageList;
    dest.selectedLanguage = src.selectedLanguage;

    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  //登录者会社id
  int companyId = 0;

  // 会社情报
  Map<String, dynamic> formInfo = {};
  // 会社时间情报
  Map<String, dynamic> formDateInfo = {};

  // 结构树
  BuildContext context;

  // 右上角多语言列表
  List<Map<String, dynamic>> languageList = [];
  // 选中语言
  int selectedLanguage = 2;
  // 自定义参数 - 终

  // 构造函数
  ContractModel({
    required this.context,
    required this.companyId,
    this.formInfo = const {},
    this.formDateInfo = const {},
    this.languageList = const [],
    this.selectedLanguage = 2,
  });

  void add(InitEvent initEvent) {}
}
