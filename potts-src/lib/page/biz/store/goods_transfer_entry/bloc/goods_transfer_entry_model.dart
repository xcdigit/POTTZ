import 'package:flutter/material.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * content：在庫移動入力-参数
 * author：张博睿
 * date：2023/09/07
 */

class GoodsTransferEntryModel extends WmsTableModel {
  factory GoodsTransferEntryModel.clone(GoodsTransferEntryModel src) {
    GoodsTransferEntryModel dest =
        GoodsTransferEntryModel(context: src.context, detail: false);
    dest.copy(src);
    dest.context = src.context;
    dest.companyId = src.companyId;
    dest.userId = src.userId;
    dest.locationIdFrom = src.locationIdFrom;
    dest.locationCodeFrom = src.locationCodeFrom;
    dest.productId = src.productId;
    dest.productCode = src.productCode;
    dest.productName = src.productName;
    dest.expirationDate = src.expirationDate;
    dest.goodImage = src.goodImage;
    dest.lotNo = src.lotNo;
    dest.serialNo = src.serialNo;
    dest.supplementaryInformation = src.supplementaryInformation;
    dest.stockCount = src.stockCount;
    dest.lockCount = src.lockCount;
    dest.locationIdTo = src.locationIdTo;
    dest.locationCodeTo = src.locationCodeTo;
    dest.moveCount = src.moveCount;
    dest.moveReason = src.moveReason;
    dest.pageFlag = src.pageFlag;
    return dest;
  }

  BuildContext context;
  // 当前用户所属会社ID
  int? companyId;
  // 当前用户ID
  int? userId;
  // 移动前位置主键
  int locationIdFrom = 0;
  // 移动前位置code
  String locationCodeFrom = '';
  // 商品主键
  int productId = 0;
  // 商品code
  String productCode = '';
  // 商品名称
  String productName = '';
  // 消费期限
  String expirationDate = '';
  // 商品写真
  String goodImage = '';
  // 批号
  String lotNo = '';
  // 序列号
  String serialNo = '';
  // 补充资料
  String supplementaryInformation = '';
  // 在庫数
  int stockCount = 0;
  // lock数
  int lockCount = 0;
  // 移动后位置主键
  int locationIdTo = 0;
  // 移动后位置code
  String locationCodeTo = '';
  // 移动数量
  int moveCount = 0;
  // 移动理由
  String moveReason = '';
  bool pageFlag = false;

  GoodsTransferEntryModel({
    required this.context,
    this.companyId,
    this.userId,
    this.locationIdFrom = 0,
    this.locationCodeFrom = '',
    this.productId = 0,
    this.productCode = '',
    this.productName = '',
    this.expirationDate = '',
    this.goodImage = '',
    this.lotNo = '',
    this.serialNo = '',
    this.supplementaryInformation = '',
    this.stockCount = 0,
    this.lockCount = 0,
    this.locationIdTo = 0,
    this.locationCodeTo = '',
    this.moveCount = 0,
    this.moveReason = '',
    required bool detail,
    this.pageFlag = false,
  });
}
