import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import 'payment_success_model.dart';

/**
 * 内容：支付成功-BLOC
 * 作者：赵士淞
 * 时间：2023/12/07
 */
// 事件
abstract class PaymentSuccessEvent {}

// 初始化事件
class InitEvent extends PaymentSuccessEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始

// 自定义事件 - 终

class PaymentSuccessBloc
    extends Bloc<PaymentSuccessEvent, PaymentSuccessModel> {
  // 刷新补丁
  PaymentSuccessModel clone(PaymentSuccessModel src) {
    return PaymentSuccessModel.clone(src);
  }

  PaymentSuccessBloc(PaymentSuccessModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 判断场景号
      if (state.sceneNo == Config.NUMBER_ONE) {
        // 判断订单号
        if (state.orderNo != '') {
          // 更新申込一時
          List<Map<String, dynamic>> applicationTmpData =
              await SupabaseUtils.getClient()
                  .from('ytb_application_tmp')
                  .update({
                    'pay_status': Config.NUMBER_ONE.toString(),
                  })
                  .eq('pay_no', state.orderNo)
                  .select('*');
          // 判断申込一時数量
          if (applicationTmpData.length == 0) {
            // 错误提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                    .payment_status_update_failed);
          }
        } else {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .payment_status_update_failed);
        }
      } else if (state.sceneNo == Config.NUMBER_TWO) {
        // 判断订单号
        if (state.orderNo != '') {
          // 更新運用会社ユーザー
          List<Map<String, dynamic>> userManageData =
              await SupabaseUtils.getClient()
                  .from('ytb_user_manage')
                  .update({
                    'pay_status': Config.NUMBER_ONE.toString(),
                  })
                  .eq('pay_no', state.orderNo)
                  .select('*');
          // 判断運用会社ユーザー数量
          if (userManageData.length == 0) {
            // 错误提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                    .payment_status_update_failed);
            return;
          }

          // 当前運用会社ユーザー
          Map<String, dynamic> currentUserManageData = userManageData[0];

          // 更新ユーザー
          List<Map<String, dynamic>> userData = await SupabaseUtils.getClient()
              .from('mtb_user')
              .update({
                'end_date': currentUserManageData['end_date'],
                'status': Config.NUMBER_ONE.toString()
              })
              .eq('company_id', currentUserManageData['company_id'])
              .eq('id', currentUserManageData['user_id'])
              .select('*');
          // 判断ユーザー数量
          if (userData.length == 0) {
            // 错误提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                    .payment_status_update_failed);
            return;
          }

          // 当前ユーザー
          Map<String, dynamic> currentUserData = userData[0];

          // 判断当前ユーザー角色
          if (currentUserData['role_id'] == 2) {
            // 更新運用会社
            List<Map<String, dynamic>> companyManageData =
                await SupabaseUtils.getClient()
                    .from('ytb_company_manage')
                    .update({'end_date': currentUserManageData['end_date']})
                    .eq('company_id', currentUserManageData['company_id'])
                    .eq('user_id', currentUserManageData['user_id'])
                    .select('*');
            // 判断運用会社数量
            if (companyManageData.length == 0) {
              // 错误提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootContext)!
                      .payment_status_update_failed);
              return;
            }
          }
        } else {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .payment_status_update_failed);
        }
      } else {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .payment_status_update_failed);
      }
    });

    // 自定义事件 - 始

    // 自定义事件 - 终

    add(InitEvent());
  }
}
