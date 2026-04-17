import 'package:flutter/material.dart';
import 'package:wms/model/location.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * content：入庫入力-参数
 * author：张博睿
 * date：2023/09/27
 */

class GoodsInputModel extends WmsTableModel {
  factory GoodsInputModel.clone(GoodsInputModel src) {
    GoodsInputModel dest = GoodsInputModel(rootContext: src.rootContext);
    dest.copy(src);
    dest.companyId = src.companyId;
    dest.userId = src.userId;
    dest.incomingBarCode = src.incomingBarCode;
    dest.incomingNumber = src.incomingNumber;
    dest.supplier = src.supplier;
    dest.goodsBarCode = src.goodsBarCode;
    dest.goodsId = src.goodsId;
    dest.goodsCode = src.goodsCode;
    dest.goodsName = src.goodsName;
    dest.stock = src.stock;
    dest.goodsImage1 = src.goodsImage1;
    dest.goodsImage2 = src.goodsImage2;
    dest.expirationDate = src.expirationDate;
    dest.lotNo = src.lotNo;
    dest.serialNo = src.serialNo;
    dest.supplementaryInformation = src.supplementaryInformation;
    dest.location = src.location;
    dest.locationBarCodeList = src.locationBarCodeList;
    dest.receiveId = src.receiveId;
    dest.labelNum = src.labelNum;
    return dest;
  }
  //树结构
  BuildContext rootContext;
  // 当前用户所属会社ID
  int? companyId;
  // 当前用户ID
  int? userId;
  // 入荷予定一覧バーコード
  String incomingBarCode = '';
  // 入荷予定番号
  String incomingNumber = '';
  // 仕入先
  String supplier = '';
  // 入荷予定明細行No/商品ラベルのバーコード
  String goodsBarCode = '';
  // 商品ID
  int? goodsId;
  // 商品编码
  String goodsCode = '';
  // 商品名称
  String goodsName = '';
  // 在库数
  int stock = 0;
  // 商品写真
  String goodsImage1 = '';
  // 商品写真
  String goodsImage2 = '';
  // 消费期限
  String expirationDate = '';
  // 批号
  String lotNo = '';
  // 序列号
  String serialNo = '';
  // 补充资料
  String supplementaryInformation = '';
  // ロケーションのバーコード
  Location location = Location.empty();
  // locationList
  List locationBarCodeList = [];
  // 入荷予定ID
  String receiveId = '';
  String labelNum = '';

  GoodsInputModel({
    required this.rootContext,
    this.companyId,
    this.userId,
    this.incomingBarCode = '',
    this.incomingNumber = '',
    this.supplier = '',
    this.goodsBarCode = '',
    this.goodsId,
    this.goodsCode = '',
    this.goodsName = '',
    this.stock = 0,
    this.goodsImage1 = '',
    this.goodsImage2 = '',
    this.expirationDate = '',
    this.lotNo = '',
    this.serialNo = '',
    this.supplementaryInformation = '',
    this.locationBarCodeList = const [],
    this.receiveId = '',
    this.labelNum = '',
  });
}
