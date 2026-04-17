import 'package:flutter/cupertino.dart';

import '../../../../../common/config/config.dart';
import '../../../../../model/receive.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：入荷予定入力-参数
 * 作者：王光顺
 * 时间：2023/09/12
 * 作者：luxy
 * 时间：2023/10/16
 */
class ReserveInputModel extends WmsTableModel {
  // 克隆
  factory ReserveInputModel.clone(ReserveInputModel src) {
    ReserveInputModel dest = ReserveInputModel(
        rootContext: src.rootContext,
        receiveId: src.receiveId,
        companyId: src.companyId);
    dest.rootContext = src.rootContext;
    dest.receiveId = src.receiveId;
    dest.records = src.records;
    dest.total = src.total;
    dest.companyId = src.companyId;
    dest.customerList = src.customerList;
    dest.code = src.code;
    dest.product_price = src.product_price;
    dest.product_num = src.product_num;
    dest.note1 = src.note1;
    dest.note2 = src.note2;
    dest.customer = src.customer;
    dest.dataLength = src.dataLength;
    dest.num = src.num;
    dest.productList = src.productList;
    dest.currentIndex = src.currentIndex;
    dest.currentContent = src.currentContent;
    dest.isOk = src.isOk;
    // 赵士淞 - 始
    dest.supplierList = src.supplierList;
    // 赵士淞 - 终
    return dest;
  }

  // 自定义参数 - 终
  // 根结构树
  BuildContext rootContext;
  int num = 0;
  // 入荷予定ID
  int receiveId = 0;
  //会社id
  int companyId;
  String code = '';
  double product_price = 0;
  int product_num = 0;
  String note1 = '';
  String note2 = '';
  // 基本情报-定制
  Map<String, dynamic> customerList = {};
  // 弹窗数据-定制
  Map<String, dynamic> customer = {};
  int dataLength = 0;
  // 入荷予定
  Receive receive = Receive.empty();
  // 商品列表
  List<dynamic> productList = [];
  // 当前下标-SP
  int currentIndex = Config.NUMBER_ZERO;
  // 当前内容-SP
  Widget currentContent = Wrap();
  bool isOk = false;
  // 赵士淞 - 始
  // 仕入先列表
  List<dynamic> supplierList = [];
  // 赵士淞 - 终
  // 自定义参数 - 终

  // 构造函数
  ReserveInputModel({
    // 自定义参数 - 始
    required this.rootContext,
    required this.receiveId,
    required this.companyId,
    this.customerList = const {},
    this.customer = const {},
    this.productList = const [],
    this.currentIndex = Config.NUMBER_ZERO,
    this.isOk = false,
    // 赵士淞 - 始
    this.supplierList = const [],
    // 赵士淞 - 终
    // 自定义参数 - 终
  });
}
