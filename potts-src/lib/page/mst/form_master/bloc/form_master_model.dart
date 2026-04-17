import 'package:flutter/material.dart';

import '../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：帳票マスタ-参数
 * 作者：赵士淞
 * 时间：2023/12/22
 */
class FormMasterModel extends WmsTableModel {
  // 克隆
  factory FormMasterModel.clone(FormMasterModel src) {
    FormMasterModel dest = FormMasterModel(rootContext: src.rootContext);
    dest.copy(src);
    // 自定义参数 - 始
    dest.loadingFlag = src.loadingFlag;
    dest.formKbnList = src.formKbnList;
    dest.formDirectionList = src.formDirectionList;
    dest.formCustomize = src.formCustomize;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 加载标记
  bool loadingFlag = true;
  // 区分列表
  List<Map<String, dynamic>> formKbnList = [];
  // 纸张方向列表
  List<Map<String, dynamic>> formDirectionList = [];
  // 账票-定制
  Map<String, dynamic> formCustomize = {};
  // 自定义参数 - 终

  // 构造函数
  FormMasterModel({
    // 自定义参数 - 始
    required this.rootContext,
    this.loadingFlag = true,
    this.formKbnList = const [],
    this.formDirectionList = const [],
    this.formCustomize = const {
      'id': '',
      'form_kbn': '',
      'form_kbn_title': '',
      'form_picture': '',
      'form_picture_network': '',
      'form_direction_title': '',
      'form_direction': '',
      'description': '',
    },
    // 自定义参数 - 终
  });
}
