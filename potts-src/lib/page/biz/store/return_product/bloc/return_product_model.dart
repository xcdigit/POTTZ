import 'package:wms/model/location.dart';
import 'package:wms/model/product.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

import '../../../../../common/config/config.dart';

/**
 * content：返品入力-参数
 * author：张博睿
 * date：2023/10/09
 */

class ReturnProductModel extends WmsTableModel {
  factory ReturnProductModel.clone(ReturnProductModel src) {
    ReturnProductModel dest = ReturnProductModel();
    dest.copy(src);
    dest.companyId = src.companyId;
    dest.userId = src.userId;
    dest.shipId = src.shipId;
    dest.shipNumber = src.shipNumber;
    dest.salesProduct = src.salesProduct;
    dest.salesReturnQuantity = src.salesReturnQuantity;
    dest.salesLocation = src.salesLocation;
    dest.salesProductInfoList = src.salesProductInfoList;
    dest.salesLocationList = src.salesLocationList;
    dest.receiveId = src.receiveId;
    dest.receiveNumber = src.receiveNumber;
    dest.product = src.product;
    dest.returnQuantity = src.returnQuantity;
    dest.location = src.location;
    dest.locationList = src.locationList;
    dest.productInfoList = src.productInfoList;
    dest.salesFlag = src.salesFlag;
    dest.deliverFlag = src.deliverFlag;
    dest.currentIndex = src.currentIndex;
    return dest;
  }

  // 当前用户所属会社ID
  int? companyId;
  // 当前用户ID
  int? userId;
  // 出荷指示Id
  String shipId = '';
  // 出荷指示番号
  String shipNumber = '';
  // 売上商品名
  Product salesProduct = Product.empty();
  // 売上返品数量
  String salesReturnQuantity = '';
  // 売上ロケーションのバーコード
  Location salesLocation = Location.empty();
  // 売上商品名集合
  List salesProductInfoList = const [];
  // 売上location下拉列表
  List salesLocationList = const [];
  // 入荷指示Id
  String receiveId = '';
  // 入荷予定番号
  String receiveNumber = '';
  // 仕入商品名
  Product product = Product.empty();
  // 仕入返品数量
  String returnQuantity = '';
  // 仕入ロケーションのバーコード
  Location location = Location.empty();
  // 仕入商品名集合
  List productInfoList = const [];
  // 仕入location下拉列表
  List locationList = const [];
  // 出荷指示番号检索标识
  bool salesFlag = false;
  // 入荷指示番号检索标识
  bool deliverFlag = false;
  // 当前下标
  int currentIndex = Config.NUMBER_ZERO;

  ReturnProductModel({
    this.companyId,
    this.userId,
    this.shipId = '',
    this.shipNumber = '',
    this.salesReturnQuantity = '',
    this.salesProductInfoList = const [],
    this.salesLocationList = const [],
    this.receiveId = '',
    this.receiveNumber = '',
    this.returnQuantity = '',
    this.productInfoList = const [],
    this.locationList = const [],
    this.salesFlag = false,
    this.deliverFlag = false,
    this.currentIndex = Config.NUMBER_ZERO,
  });
}
