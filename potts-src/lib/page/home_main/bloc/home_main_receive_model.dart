import 'package:flutter/cupertino.dart';

import '../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：入何予定照会-参数
 * 作者：luxy
 * 时间：2023/10/10
 */
class HomeMainReceiveModel extends WmsTableModel {
  // 克隆
  factory HomeMainReceiveModel.clone(HomeMainReceiveModel src) {
    HomeMainReceiveModel dest =
        HomeMainReceiveModel(rootContext: src.rootContext);
    dest.receiveList = src.receiveList;
    dest.copy(src);

    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  List<dynamic> receiveList = [];

  // 构造函数
  HomeMainReceiveModel({
    required this.rootContext,
    this.receiveList = const [],
  });
}
