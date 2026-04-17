import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../bloc/payment_success_bloc.dart';
import '../bloc/payment_success_model.dart';

/**
 * 内容：支付成功
 * 作者：赵士淞
 * 时间：2023/12/07
 */
// ignore: must_be_immutable
class PaymentSuccessPage extends StatefulWidget {
  // 场景号
  int sceneNo;
  // 订单号
  String orderNo;

  PaymentSuccessPage({
    super.key,
    this.sceneNo = Config.NUMBER_ZERO,
    this.orderNo = '',
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentSuccessBloc>(
      create: (context) {
        return PaymentSuccessBloc(
          PaymentSuccessModel(
            rootContext: context,
            sceneNo: widget.sceneNo,
            orderNo: widget.orderNo,
          ),
        );
      },
      child: PaymentSuccessContent(),
    );
  }
}

// 支付成功内容
class PaymentSuccessContent extends StatefulWidget {
  const PaymentSuccessContent({super.key});

  @override
  State<PaymentSuccessContent> createState() => _PaymentSuccessContentState();
}

class _PaymentSuccessContentState extends State<PaymentSuccessContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentSuccessBloc, PaymentSuccessModel>(
      builder: (context, state) {
        return Container(
          child: Center(
            child: Text(
              WMSLocalizations.i18n(context)!
                  .congratulations_payment_successful,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Color.fromRGBO(44, 167, 176, 1),
              ),
            ),
          ),
        );
      },
    );
  }
}
