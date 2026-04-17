import 'package:flutter/material.dart';

import '../../../../common/config/config.dart';

/**
 * 内容：支付成功-参数
 * 作者：赵士淞
 * 时间：2023/12/07
 */
class PaymentSuccessModel {
  // 克隆
  factory PaymentSuccessModel.clone(PaymentSuccessModel src) {
    PaymentSuccessModel dest =
        PaymentSuccessModel(rootContext: src.rootContext);
    // 自定义参数 - 始
    dest.sceneNo = src.sceneNo;
    dest.orderNo = src.orderNo;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 场景号
  int sceneNo;
  // 订单号
  String orderNo;
  // 自定义参数 - 终

  // 构造函数
  PaymentSuccessModel({
    // 自定义参数 - 始
    required this.rootContext,
    this.sceneNo = Config.NUMBER_ZERO,
    this.orderNo = '',
    // 自定义参数 - 终
  });
}
