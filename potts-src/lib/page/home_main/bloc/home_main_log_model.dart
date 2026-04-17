import 'package:flutter/cupertino.dart';

import '../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：操作log-参数
 * 作者：luxy
 * 时间：2023/10/11
 */
class HomeMainLogModel extends WmsTableModel {
  // 克隆
  factory HomeMainLogModel.clone(HomeMainLogModel src) {
    HomeMainLogModel dest = HomeMainLogModel(rootContext: src.rootContext);
    dest.logList = src.logList;
    dest.copy(src);

    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  List<dynamic> logList = [];

  // 构造函数
  HomeMainLogModel({
    required this.rootContext,
    this.logList = const [],
  });
}
