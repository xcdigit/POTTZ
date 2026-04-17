import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/wms_common_bloc_utils.dart';
import '../../stripe/stripe.dart';
import '../config/config.dart';
import '../localization/default_localizations.dart';
import 'supabase_untils.dart';

/**
 * Stripe工具类
 * 作者：赵士淞
 * 时间：2024-12-12
 */
class StripeUtils {
  // 公钥
  // static String _publicKey =
  //     'pk_test_51NS92eKFYHrVQvTLYDHHjrNIXNgS3IB16Bk7ZK979d2GvLlT9x8QSsxgS3AAmFnBB6kEeC4KOMWdpKFwGzm56g6F00erU28z96';
  // 秘钥
  static String _secretKey =
      'sk_test_51NS92eKFYHrVQvTLr1KtCfeE6An5j66kzbuKFRIdwoV3iIfOYt4lJaTvqZ3dLKInxAxSDjlfySPJCdigFtoI7gS300ooMwSfWu';
  // 网址
  static String _webUrl = Config.BASE_URL;

  // 创建结帐会话
  // context：上下文；businessId：业务ID；sceneIndex：场景标志（1：申请页面；2：续费页面）
  static Future<String> createCheckoutSessions(
      BuildContext context, int businessId, int sceneIndex) async {
    // Stripe初始化
    final stripe = Stripe(_secretKey);

    // 订单号
    String orderTime = DateFormat('yyyyMMddHHmmssSSS').format(DateTime.now());
    int orderRandom = Random().nextInt(9999);
    String orderNo = 'ORDER_' +
        orderTime +
        (orderRandom < 10
            ? '000' + orderRandom.toString()
            : orderRandom < 100
                ? '00' + orderRandom.toString()
                : orderRandom < 1000
                    ? '0' + orderRandom.toString()
                    : orderRandom.toString());

    // 订单金额
    int orderAmount = 0;
    // 判断场景标志
    if (sceneIndex == 1) {
      // 查询申请临时列表
      List<dynamic> applicationTmpList = await SupabaseUtils.getClient()
          .from('ytb_application_tmp')
          .select('*')
          .eq('id', businessId);
      // 判断申请临时列表长度
      if (applicationTmpList.length > 1 || applicationTmpList.length == 0) {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.payment_initiation_failed);
        return '';
      } else {
        // 订单金额
        orderAmount = applicationTmpList[0]['pay_total'];
      }
    } else if (sceneIndex == 2) {
      // 查询会社计划列表
      List<dynamic> companyPlanList = await SupabaseUtils.getClient()
          .from('ytb_company_plan_manage')
          .select('*')
          .eq('id', businessId);
      // 判断会社计划列表长度
      if (companyPlanList.length > 1 || companyPlanList.length == 0) {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.payment_initiation_failed);
        return '';
      } else {
        // 订单金额
        orderAmount = companyPlanList[0]['pay_total'];
      }
    }

    // 创建结帐会话
    CheckoutSession checkoutSession = await stripe.checkoutSession.create(
      CreateCheckoutSessionRequest(
        successUrl: sceneIndex == 1
            ? _webUrl + '/loginApplication/0/' + orderNo
            : sceneIndex == 2
                ? _webUrl + '/loginRenewal/' + orderNo
                : '',
        paymentMethodTypes: [
          PaymentMethodType.card,
        ],
        mode: SessionMode.payment,
        clientReferenceId: orderNo,
        lineItems: [
          LineItem(
            quantity: 1,
            priceData: PriceData(
              currency: 'jpy',
              unitAmount: orderAmount,
              productData: ProductData(
                name: sceneIndex == 1
                    ? '申し込み'
                    : sceneIndex == 2
                        ? '継続料金'
                        : '',
              ),
            ),
          ),
        ],
      ),
    );

    // 结帐会话路径
    final Uri uri = Uri.parse(
      checkoutSession.url.toString(),
    );
    if (kIsWeb) {
      // 判断结帐会话路径
      if (!await launchUrl(uri, webOnlyWindowName: '_self')) {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.transfer_payment_failed);
        return '';
      }
    } else {
      // 判断结帐会话路径
      if (!await launchUrl(uri)) {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.transfer_payment_failed);
        return '';
      }
    }

    return orderNo;
  }
}
