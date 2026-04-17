import 'package:flutter/cupertino.dart';

import '../../../../../common/config/config.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：出荷指示入力-参数
 * 作者：赵士淞
 * 时间：2023/09/04
 */
class InstructionInputModel extends WmsTableModel {
  // 克隆
  factory InstructionInputModel.clone(InstructionInputModel src) {
    InstructionInputModel dest =
        InstructionInputModel(rootContext: src.rootContext, shipId: src.shipId);
    dest.copy(src);
    // 自定义参数 - 始
    // dest.shipId = src.shipId;
    dest.customerList = src.customerList;
    dest.customerAddressList = src.customerAddressList;
    dest.shipCustomize = src.shipCustomize;
    dest.warehouseList = src.warehouseList;
    dest.productList = src.productList;
    dest.shipDetailCustomize = src.shipDetailCustomize;
    dest.loadingFlag = src.loadingFlag;
    dest.currentIndex = src.currentIndex;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 出荷指示ID
  int shipId;
  // 客户列表
  List<dynamic> customerList = [];
  // 收件人列表
  List<dynamic> customerAddressList = [];
  // 出荷指示-定制
  Map<String, dynamic> shipCustomize = {};
  // 仓库列表
  List<dynamic> warehouseList = [];
  // 商品列表
  List<dynamic> productList = [];
  // 出荷指示明细-定制
  Map<String, dynamic> shipDetailCustomize = {};
  // 加载标记
  bool loadingFlag = true;
  // 当前下标
  int currentIndex = Config.NUMBER_ZERO;
  // 自定义参数 - 终

  // 构造函数
  InstructionInputModel({
    // 自定义参数 - 始
    required this.rootContext,
    required this.shipId,
    this.customerList = const [],
    this.customerAddressList = const [],
    this.shipCustomize = const {},
    this.warehouseList = const [],
    this.productList = const [],
    this.shipDetailCustomize = const {},
    this.loadingFlag = true,
    this.currentIndex = Config.NUMBER_ZERO,
    // 自定义参数 - 终
  });
}
