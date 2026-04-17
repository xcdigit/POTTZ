import 'package:flutter/material.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * content：返品照会-参数
 * author：熊草云
 * date：2023/10/10
 */

class ReturnNoteModel extends WmsTableModel {
  factory ReturnNoteModel.clone(ReturnNoteModel src) {
    ReturnNoteModel dest = ReturnNoteModel(context: src.context);
    dest.copy(src);
    dest.context = src.context;
    dest.deteleFlag = src.deteleFlag;
    src.returnKbn;
    src.productCode;
    src.productName;
    src.revShipNo;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    return dest;
  }
  // 根结构树
  BuildContext context;
  // 删除标记
  bool deteleFlag = true;
  // 返品区分
  String? returnKbn;
  // 商品コード
  String? productCode;
  // 商品名
  String? productName;
  // 入荷予定番号/出荷指示番号
  String? revShipNo;
  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'id';
  // 升降排序
  bool ascendingFlg = false;
  ReturnNoteModel({
    required this.context,
    this.deteleFlag = true,
    this.returnKbn,
    this.productCode,
    this.productName,
    this.revShipNo,
    this.loadingFlag = true,
    this.sortCol = 'id',
    this.ascendingFlg = false,
  });
}
