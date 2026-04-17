import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:otp/otp.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

import '../../../bloc/wms_common_bloc_utils.dart';
import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/storage/local_storage.dart';
import '../../../common/utils/check_utils.dart';
import '../../../common/utils/common_utils.dart';
import '../../../common/utils/encryption_utils.dart';
import '../../../common/utils/mail_utils.dart';
import '../../../common/utils/stripe_utils.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../model/application_tmp.dart';
import '../../../model/message.dart';
import '../../../model/message_history.dart';
import '../../../model/user.dart';
import '../../../redux/wms_state.dart';
import '../../login/pc/login_page.dart';
import 'login_application_model.dart';

/**
 * 内容：申请-BLOC
 * 作者：赵士淞
 * 时间：2024/12/04
 */
// 事件
abstract class LoginApplicationEvent {}

// 初始化事件
class InitEvent extends LoginApplicationEvent {
  // 初始化事件
  InitEvent();
}

// 选中语言变更事件
class SelectedLanguageChangeEvent extends LoginApplicationEvent {
  // 选中语言ID
  int selectedLanguageId;
  // 选中语言变更事件
  SelectedLanguageChangeEvent(this.selectedLanguageId);
}

// 设置公司名称事件
class SetCompanyNameEvent extends LoginApplicationEvent {
  // 值
  String value;
  // 设置公司名称事件
  SetCompanyNameEvent(this.value);
}

// 设置联系人姓名事件
class SetPersonChargeEvent extends LoginApplicationEvent {
  // 值
  String value;
  // 设置联系人姓名事件
  SetPersonChargeEvent(this.value);
}

// 设置电子邮件地址事件
class SetEmailAddressEvent extends LoginApplicationEvent {
  // 值
  String value;
  // 设置电子邮件地址事件
  SetEmailAddressEvent(this.value);
}

// 设置电话号码事件
class SetPhoneNumberEvent extends LoginApplicationEvent {
  // 值
  String value;
  // 设置电话号码事件
  SetPhoneNumberEvent(this.value);
}

// 设置活动代码事件
class SetCampaignCodeEvent extends LoginApplicationEvent {
  // 值
  String value;
  // 设置活动代码事件
  SetCampaignCodeEvent(this.value);
}

// 设置密码事件
class SetPasswordEvent extends LoginApplicationEvent {
  // 值
  String value;
  // 设置密码事件
  SetPasswordEvent(this.value);
}

// 步骤1按钮点击事件
class Step1ButtonClickEvent extends LoginApplicationEvent {
  // 步骤1按钮点击事件
  Step1ButtonClickEvent();
}

// 设置验证指数事件
class SetVerifyIndexEvent extends LoginApplicationEvent {
  // 值
  int value;
  // 设置验证指数事件
  SetVerifyIndexEvent(this.value);
}

// 发送邮件点击事件
class SendMailClickEvent extends LoginApplicationEvent {
  // 发送邮件点击事件
  SendMailClickEvent();
}

// 设置验证码事件
class SetVerifyCodeEvent extends LoginApplicationEvent {
  // 值
  String value;
  // 设置验证码事件
  SetVerifyCodeEvent(this.value);
}

// 步骤2按钮点击事件
class Step2ButtonClickEvent extends LoginApplicationEvent {
  // 步骤2按钮点击事件
  Step2ButtonClickEvent();
}

// 选中出荷管理变更事件
class SelectedShippingChangeEvent extends LoginApplicationEvent {
  // 选中出荷管理变更事件
  SelectedShippingChangeEvent();
}

// 选中入荷管理变更事件
class SelectedEntryChangeEvent extends LoginApplicationEvent {
  // 选中入荷管理变更事件
  SelectedEntryChangeEvent();
}

// 选中在库管理变更事件
class SelectedInventoryChangeEvent extends LoginApplicationEvent {
  // 选中在库管理变更事件
  SelectedInventoryChangeEvent();
}

// 选中计划变更事件
class SelectedPlanChangeEvent extends LoginApplicationEvent {
  // 计划ID
  int planId;
  // 计划金额
  int planAmount;
  // 选中计划变更事件
  SelectedPlanChangeEvent(this.planId, this.planAmount);
}

// 选中账户变更事件
class SelectedAccountChangeEvent extends LoginApplicationEvent {
  // 账户指数
  int accountIndex;
  // 账户金额
  int accountAmount;
  // 选中账户变更事件
  SelectedAccountChangeEvent(this.accountIndex, this.accountAmount);
}

// 设置添加账户数量事件
class SetAddAccountNumber extends LoginApplicationEvent {
  // 值
  String value;
  // 设置添加账户数量事件
  SetAddAccountNumber(this.value);
}

// 选中补充变更事件
class SelectedSupplyChangeEvent extends LoginApplicationEvent {
  // 补充指数
  int supplyIndex;
  // 补充金额
  int supplyAmount;
  // 选中补充变更事件
  SelectedSupplyChangeEvent(this.supplyIndex, this.supplyAmount);
}

// 选中周期变更事件
class SelectedCycleChangeEvent extends LoginApplicationEvent {
  // 周期指数
  int cycleIndex;
  // 选中周期变更事件
  SelectedCycleChangeEvent(this.cycleIndex);
}

// 步骤3按钮点击事件
class Step3ButtonClickEvent extends LoginApplicationEvent {
  // 步骤3按钮点击事件
  Step3ButtonClickEvent();
}

// 选中交易法变更事件
class SelectedExchangeActChangeEvent extends LoginApplicationEvent {
  // 选中交易法变更事件
  SelectedExchangeActChangeEvent();
}

// 选中隐私协议变更事件
class SelectedPrivacyPolicyChangeEvent extends LoginApplicationEvent {
  // 选中隐私协议变更事件
  SelectedPrivacyPolicyChangeEvent();
}

// 步骤4按钮点击事件
class Step4ButtonClickEvent extends LoginApplicationEvent {
  // 步骤4按钮点击事件
  Step4ButtonClickEvent();
}

class LoginApplicationBloc
    extends Bloc<LoginApplicationEvent, LoginApplicationModel> {
  // 刷新补丁
  LoginApplicationModel clone(LoginApplicationModel src) {
    return LoginApplicationModel.clone(src);
  }

  LoginApplicationBloc(LoginApplicationModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 查询多语言列表
      List<Map<String, dynamic>> languageList =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      // 多语言列表
      state.languageList = languageList;
      // 判断页面标识
      if (state.pageFlag != 'once' && state.pageFlag != 'again') {
        // 选中步骤
        state.selectedStep = 4;
        // 更新申请临时列表
        List<Map<String, dynamic>> applicationTmpList =
            await SupabaseUtils.getClient()
                .from('ytb_application_tmp')
                .update({
                  'pay_status': '1',
                  'update_id': 1,
                  'update_time': DateTime.now().toString()
                })
                .eq('pay_no', state.pageFlag)
                .select('*');
        // 申请临时信息
        state.applicationTmpData = applicationTmpList[0];
        // 发送最终邮件
        await sendEndEmail(state);
        // 发送站内信
        await sendInternalMessage(state);
      }
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 选中语言变更事件
    on<SelectedLanguageChangeEvent>((event, emit) async {
      // 切换语言
      CommonUtils.changeLocale(StoreProvider.of<WMSState>(state.rootContext),
          event.selectedLanguageId);
      // 本地存储
      LocalStorage.save(Config.LOCALE, event.selectedLanguageId.toString());
      // 选中语言
      state.selectedLanguage = event.selectedLanguageId;
      // 刷新
      emit(LoginApplicationModel.clone(state));
      // 关闭弹窗
      Navigator.pop(state.rootContext);
    });

    // 设置公司名称事件
    on<SetCompanyNameEvent>((event, emit) async {
      // 公司名称
      state.companyName = event.value;
    });

    // 设置联系人姓名事件
    on<SetPersonChargeEvent>((event, emit) async {
      // 联系人姓名
      state.personCharge = event.value;
    });

    // 设置电子邮件地址事件
    on<SetEmailAddressEvent>((event, emit) async {
      // 格式校验
      if (event.value != '' && CheckUtils.check_Email(event.value)) {
        // 错误提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .login_application_email_address +
                WMSLocalizations.i18n(state.rootContext)!.input_email_check);
      } else {
        // 判断页面标识
        if (state.pageFlag == 'once') {
          // 查询申请临时列表
          List<dynamic> applicationTmpList = await SupabaseUtils.getClient()
              .from('ytb_application_tmp')
              .select('*')
              .eq('user_email', event.value);
          // 判断申请临时列表数量
          if (applicationTmpList.length == 0) {
            // 电子邮件地址
            state.emailAddress = event.value;
          } else {
            // 错误提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                    .login_application_email_address_error_exist);
          }
        } else if (state.pageFlag == 'again') {
          // 电子邮件地址
          state.emailAddress = event.value;
        }
      }
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 设置电话号码事件
    on<SetPhoneNumberEvent>((event, emit) async {
      // 格式校验
      if (event.value != '' &&
          CheckUtils.check_Half_Number_Hyphen(event.value)) {
        // 错误提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .login_application_phone_number +
                WMSLocalizations.i18n(state.rootContext)!
                    .input_half_width_numbers_with_hyphen_check);
      } else {
        // 电话号码
        state.phoneNumber = event.value;
      }
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 设置活动代码事件
    on<SetCampaignCodeEvent>((event, emit) async {
      // 格式校验
      if (event.value != '') {
        // 查询活动数据
        await selectCampaignData(event.value, state);
      } else {
        // 活动代码
        state.campaignCode = event.value;
      }
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 设置密码事件
    on<SetPasswordEvent>((event, emit) async {
      // 密码
      state.password = event.value;
    });

    // 步骤1按钮点击事件
    on<Step1ButtonClickEvent>((event, emit) async {
      // 步骤1按钮点击检查
      bool flag = step1ButtonClickCheck(state);
      // 判断结果
      if (flag) {
        // 打开加载
        BotToast.showLoading();
        // 查询计划列表
        List<dynamic> planList = await SupabaseUtils.getClient()
            .from('ytb_plan')
            .select('*')
            .eq('del_kbn', Config.DELETE_NO)
            .order('id', ascending: true);
        // 计划列表
        state.planList = planList;
        // 判断页面标识
        if (state.pageFlag == 'once') {
          // 申请临时
          ApplicationTmp applicationTmp = ApplicationTmp.fromJson({});
          applicationTmp.channel_id = state.channelId;
          applicationTmp.user_email = state.emailAddress;
          applicationTmp.user_password = Encryption.encodeBase64('123456');
          applicationTmp.user_name = state.personCharge;
          applicationTmp.user_phone = state.phoneNumber;
          applicationTmp.user_language_id = 2;
          applicationTmp.company_name = state.companyName;
          applicationTmp.pay_status = '0';
          applicationTmp.application_status = '0';
          applicationTmp.promotion_code = state.campaignCode;
          applicationTmp.create_time = DateTime.now().toString();
          applicationTmp.create_id = 1;
          applicationTmp.update_time = DateTime.now().toString();
          applicationTmp.update_id = 1;
          applicationTmp.authenticator_key = OTP.randomSecret();
          // 新增申请临时列表
          List<Map<String, dynamic>> applicationTmpList =
              await SupabaseUtils.getClient()
                  .from('ytb_application_tmp')
                  .insert([applicationTmp.toJson()]).select('*');
          // 申请临时信息
          state.applicationTmpData = applicationTmpList[0];
        } else if (state.pageFlag == 'again') {
          // 查询申请临时列表
          List<dynamic> applicationTmpList = await SupabaseUtils.getClient()
              .from('ytb_application_tmp')
              .select('*')
              .eq('user_email', state.emailAddress)
              .eq('user_password', Encryption.encodeBase64(state.password));
          // 判断申请临时列表长度
          if (applicationTmpList.length > 1) {
            // 错误提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                    .login_application_password_error_multiple);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          } else if (applicationTmpList.length == 0) {
            // 错误提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                    .login_application_password_error_invalid);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          } else if (applicationTmpList[0]['pay_status'] == '1') {
            // 错误提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                    .login_application_password_error_paid);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          } else {
            // 申请临时信息
            state.applicationTmpData = applicationTmpList[0];
            // 判断活动代码
            if (state.applicationTmpData['promotion_code'] != null &&
                state.applicationTmpData['promotion_code'] != '') {
              // 查询活动数据
              await selectCampaignData(
                  state.applicationTmpData['promotion_code'], state);
            }
            // 选中出荷管理
            state.selectedShipping =
                state.applicationTmpData['base_ship'] == '1' ? true : false;
            // 选中入荷管理
            state.selectedEntry =
                state.applicationTmpData['base_receive'] == '1' ? true : false;
            // 选中在库管理
            state.selectedInventory =
                state.applicationTmpData['base_store'] == '1' ? true : false;
            // 判断选中计划ID
            if (state.applicationTmpData['plan_id'] != null &&
                state.applicationTmpData['plan_id'] != '') {
              // 选中计划ID
              state.selectedPlanId = state.applicationTmpData['plan_id'];
              // 循环计划列表
              for (var i = 0; i < state.planList.length; i++) {
                // 判断是否为同一计划
                if (state.planList[i]['id'] ==
                    state.applicationTmpData['plan_id']) {
                  // 选中计划金额
                  state.selectedPlanAmount = state.planList[i]['plan_amount'];
                }
              }
            }
            // 判断选中账户指数
            if (state.applicationTmpData['account_type'] != null &&
                state.applicationTmpData['account_type'] != '') {
              // 选中账户指数
              state.selectedAccountIndex =
                  int.parse(state.applicationTmpData['account_type']);
              // 选中账户金额
              state.selectedAccountAmount =
                  state.applicationTmpData['account_type'] == '1'
                      ? 0
                      : state.applicationTmpData['account_type'] == '2'
                          ? 1000
                          : 0;
              // 添加账户数量
              state.addAccountNumber = state.applicationTmpData['account_num'];
            }
            // 判断选中补充指数
            if (state.applicationTmpData['option'] != null &&
                state.applicationTmpData['option'] != '') {
              // 选中补充指数
              state.selectedSupplyIndex =
                  int.parse(state.applicationTmpData['option']);
              // 选中补充金额
              state.selectedSupplyAmount =
                  state.applicationTmpData['option'] == '1'
                      ? 0
                      : state.applicationTmpData['option'] == '2'
                          ? 19800
                          : state.applicationTmpData['option'] == '3'
                              ? 29800
                              : state.applicationTmpData['option'] == '4'
                                  ? 19800
                                  : 0;
            }
            // 判断选中周期指数
            if (state.applicationTmpData['pay_cycle'] != null &&
                state.applicationTmpData['pay_cycle'] != '') {
              // 选中周期指数
              state.selectedCycleIndex =
                  int.parse(state.applicationTmpData['pay_cycle']);
            }
          }
        }
        // 计算相关金额
        calculateRelevantAmount(state);
        // 选中步骤
        state.selectedStep = 2;
        // 刷新
        emit(LoginApplicationModel.clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 设置验证指数事件
    on<SetVerifyIndexEvent>((event, emit) async {
      // 验证指数
      state.verifyIndex = event.value;
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 发送邮件点击事件
    on<SendMailClickEvent>((event, emit) async {
      // 判断上次发送时间是否在五分钟内
      if (state.applicationTmpData['send_time'] == null ||
          state.applicationTmpData['send_time'].toString() == '' ||
          DateTime.now().millisecondsSinceEpoch -
                  DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
                      .parse(state.applicationTmpData['send_time'])
                      .millisecondsSinceEpoch >=
              1 * 60 * 1000) {
        // 随机数
        var random = Random();
        // 生成匹配验证码
        var randomCode = random.nextInt(900000) + 100000;
        // 更新申请临时列表
        List<Map<String, dynamic>> applicationTmpList =
            await SupabaseUtils.getClient()
                .from('ytb_application_tmp')
                .update({
                  'send_time': DateTime.now().toString(),
                  'mail_code': randomCode,
                  'update_id': 1,
                  'update_time': DateTime.now().toString()
                })
                .eq('id', state.applicationTmpData['id'])
                .select('*');
        // 申请临时信息
        state.applicationTmpData = applicationTmpList[0];
        // 发送邮件
        String h1 = WMSLocalizations.i18n(state.rootContext)!
            .login_application_mail_send_text_1;
        String p2 = WMSLocalizations.i18n(state.rootContext)!
                .login_application_mail_send_text_2 +
            randomCode.toString();
        String content = '<h2>$h1</h2><p>$p2</p>';
        bool res = await MailUtils.sendEmailWithSMTP(
            state.applicationTmpData['user_email'],
            WMSLocalizations.i18n(state.rootContext)!
                .login_application_mail_subject,
            content);
        if (res) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_confirm_text_success);
        } else {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_confirm_text_error);
        }
      } else {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .login_application_verify_tab_2_error_text);
      }
    });

    // 设置验证码事件
    on<SetVerifyCodeEvent>((event, emit) async {
      // 验证码
      state.verifyCode = event.value;
    });

    // 步骤2按钮点击事件
    on<Step2ButtonClickEvent>((event, emit) async {
      // 打开加载
      BotToast.showLoading();
      // 判断验证指数
      if (state.verifyIndex == 1) {
        // 生成匹配验证码
        final now = DateTime.now();
        timezone.initializeTimeZones();
        final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
        final date = timezone.TZDateTime.from(now, pacificTimeZone);
        String otpCode = OTP.generateTOTPCodeString(
          state.applicationTmpData['authenticator_key'],
          date.millisecondsSinceEpoch,
          algorithm: Algorithm.SHA1,
          isGoogle: true,
        );
        // 判断验证码是否一致
        if (state.verifyCode != otpCode) {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_application_button_2_error_1);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else if (state.verifyIndex == 2) {
        // 判断验证码是否一致
        if (state.verifyCode != state.applicationTmpData['mail_code']) {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_application_button_2_error_1);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }
      // 选中步骤
      state.selectedStep = 3;
      // 刷新
      emit(LoginApplicationModel.clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 选中出荷管理变更事件
    on<SelectedShippingChangeEvent>((event, emit) async {
      // 选中出荷管理
      state.selectedShipping = !state.selectedShipping;
      // 计算相关金额
      calculateRelevantAmount(state);
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 选中入荷管理变更事件
    on<SelectedEntryChangeEvent>((event, emit) async {
      // 选中入荷管理
      state.selectedEntry = !state.selectedEntry;
      // 计算相关金额
      calculateRelevantAmount(state);
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 选中在库管理变更事件
    on<SelectedInventoryChangeEvent>((event, emit) async {
      // 选中在库管理
      state.selectedInventory = !state.selectedInventory;
      // 计算相关金额
      calculateRelevantAmount(state);
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 选中计划变更事件
    on<SelectedPlanChangeEvent>((event, emit) async {
      // 选中计划ID
      state.selectedPlanId = event.planId;
      // 选中计划金额
      state.selectedPlanAmount = event.planAmount;
      // 计算相关金额
      calculateRelevantAmount(state);
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 选中账户变更事件
    on<SelectedAccountChangeEvent>((event, emit) async {
      // 选中账户指数
      state.selectedAccountIndex = event.accountIndex;
      // 选中账户金额
      state.selectedAccountAmount = event.accountAmount;
      // 计算相关金额
      calculateRelevantAmount(state);
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 设置添加账户数量事件
    on<SetAddAccountNumber>((event, emit) async {
      // 输入值是否为整数
      bool isInteger = int.tryParse(event.value) != null;
      // 判断输入值是否为整数
      if (isInteger) {
        // 输入值
        int inputValue = int.parse(event.value);
        // 判断输入值
        if (inputValue > 0) {
          // 添加账户数量
          state.addAccountNumber = inputValue;
        } else {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_application_choose_account_input_error);
        }
      } else {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .login_application_choose_account_input_error);
      }
      // 计算相关金额
      calculateRelevantAmount(state);
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 选中补充变更事件
    on<SelectedSupplyChangeEvent>((event, emit) async {
      // 选中补充指数
      state.selectedSupplyIndex = event.supplyIndex;
      // 选中补充金额
      state.selectedSupplyAmount = event.supplyAmount;
      // 计算相关金额
      calculateRelevantAmount(state);
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 选中周期变更事件
    on<SelectedCycleChangeEvent>((event, emit) async {
      // 选中周期指数
      state.selectedCycleIndex = event.cycleIndex;
      // 计算相关金额
      calculateRelevantAmount(state);
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 步骤3按钮点击事件
    on<Step3ButtonClickEvent>((event, emit) async {
      // 步骤3按钮点击检查
      bool flag = step3ButtonClickCheck(state);
      // 判断
      if (flag) {
        // 打开加载
        BotToast.showLoading();
        // 更新申请临时列表
        List<Map<String, dynamic>> applicationTmpList =
            await SupabaseUtils.getClient()
                .from('ytb_application_tmp')
                .update({
                  'base_ship': state.selectedShipping ? 1 : 0,
                  'base_receive': state.selectedEntry ? 1 : 0,
                  'base_store': state.selectedInventory ? 1 : 0,
                  'plan_id': state.selectedPlanId,
                  'account_type': state.selectedAccountIndex,
                  'account_num': state.addAccountNumber,
                  'option': state.selectedSupplyIndex,
                  'pay_cycle': state.selectedCycleIndex,
                  'pay_total': state.campaignData['promotion_type'] != null &&
                          state.campaignData['promotion_type'] != ''
                      ? state.discountSumAmount
                      : state.totalSumAmount,
                  'update_id': 1,
                  'update_time': DateTime.now().toString()
                })
                .eq('id', state.applicationTmpData['id'])
                .select('*');
        // 申请临时信息
        state.applicationTmpData = applicationTmpList[0];
        // 判断付款金额
        if (state.applicationTmpData['pay_total'] != 0) {
          // 跳转支付页面
          String orderNo = await StripeUtils.createCheckoutSessions(
              state.rootContext, state.applicationTmpData['id'], 1);
          // 更新申请临时列表
          List<Map<String, dynamic>> applicationTmpList =
              await SupabaseUtils.getClient()
                  .from('ytb_application_tmp')
                  .update({
                    'pay_no': orderNo,
                    'update_id': 1,
                    'update_time': DateTime.now().toString()
                  })
                  .eq('id', state.applicationTmpData['id'])
                  .select('*');
          // 申请临时信息
          state.applicationTmpData = applicationTmpList[0];
        } else {
          // 更新申请临时列表
          List<Map<String, dynamic>> applicationTmpList =
              await SupabaseUtils.getClient()
                  .from('ytb_application_tmp')
                  .update({
                    'pay_status': '1',
                    'update_id': 1,
                    'update_time': DateTime.now().toString()
                  })
                  .eq('id', state.applicationTmpData['id'])
                  .select('*');
          // 申请临时信息
          state.applicationTmpData = applicationTmpList[0];
          // 发送最终邮件
          await sendEndEmail(state);
          // 发送站内信
          await sendInternalMessage(state);
          // 选中步骤
          state.selectedStep = 4;
        }
        // 刷新
        emit(LoginApplicationModel.clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 选中交易法变更事件
    on<SelectedExchangeActChangeEvent>((event, emit) async {
      // 选中交易法
      state.selectedExchangeAct = !state.selectedExchangeAct;
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 选中隐私协议变更事件
    on<SelectedPrivacyPolicyChangeEvent>((event, emit) async {
      // 选中隐私协议
      state.selectedPrivacyPolicy = !state.selectedPrivacyPolicy;
      // 刷新
      emit(LoginApplicationModel.clone(state));
    });

    // 步骤4按钮点击事件
    on<Step4ButtonClickEvent>((event, emit) async {
      // 恢复迁移元
      StoreProvider.of<WMSState>(state.rootContext).state.contractFlag = false;
      // 持久化状态更新
      StoreProvider.of<WMSState>(state.rootContext).state.login = false;
      // 持久化状态更新
      StoreProvider.of<WMSState>(state.rootContext).state.userInfo = null;
      // 持久化状态
      StoreProvider.of<WMSState>(state.rootContext).state.loginUser =
          User.empty();
      // キャンセル按钮跳转登录页面
      GoRouter.of(state.rootContext).replaceNamed(LoginPage.sName);
    });

    add(InitEvent());
  }

  // 查询活动数据
  Future<void> selectCampaignData(
      String value, LoginApplicationModel state) async {
    // 查询活动列表
    List<dynamic> campaignList = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_campaign_code_check', params: {
      'campaign_code': value,
    }).select('*');
    // 判断活动列表长度
    if (campaignList.length > 1) {
      // 错误提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
              .login_application_campaign_code_error_multiple);
    } else if (campaignList.length == 0) {
      // 错误提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
              .login_application_campaign_code_error_invalid);
    } else {
      // 活动代码
      state.campaignCode = value;
      // 活动信息
      state.campaignData = campaignList[0];
    }
  }

  // 步骤1按钮点击检查
  bool step1ButtonClickCheck(LoginApplicationModel state) {
    // 标记
    bool flag = true;
    // 判断页面标识
    if (state.pageFlag == 'once') {
      // 判断
      if (state.companyName == '') {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .login_application_company_name +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 标记
        flag = false;
      } else if (state.personCharge == '') {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .login_application_person_charge +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 标记
        flag = false;
      } else if (state.emailAddress == '') {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .login_application_email_address +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 标记
        flag = false;
      } else if (state.phoneNumber == '') {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .login_application_phone_number +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 标记
        flag = false;
      }
    } else if (state.pageFlag == 'again') {
      if (state.emailAddress == '') {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .login_application_email_address +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 标记
        flag = false;
      } else if (state.password == '') {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .login_application_password +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 标记
        flag = false;
      }
    } else {
      // 标记
      flag = false;
    }
    return flag;
  }

  // 计算相关金额
  void calculateRelevantAmount(LoginApplicationModel state) {
    // 模块计数
    int moduleCount = 0;
    // 判断选中出荷管理
    if (state.selectedShipping) {
      // 模块计数
      moduleCount++;
    }
    // 判断选中入荷管理
    if (state.selectedEntry) {
      // 模块计数
      moduleCount++;
    }
    // 判断选中在库管理
    if (state.selectedInventory) {
      // 模块计数
      moduleCount++;
    }
    // 判断模块计数
    if (moduleCount == 1) {
      // 合计模块金额
      state.totalModuleAmount = 19800;
    } else if (moduleCount == 2) {
      // 合计模块金额
      state.totalModuleAmount = 29800;
    } else if (moduleCount == 3) {
      // 合计模块金额
      state.totalModuleAmount = 39800;
    } else {
      // 合计模块金额
      state.totalModuleAmount = 0;
    }
    // 判断选中账户指数
    if (state.selectedAccountIndex == 2) {
      // 合计账户金额 = 选中账户金额 * 添加账户数量
      state.totalAccountAmount =
          state.selectedAccountAmount * state.addAccountNumber;
    } else {
      // 账户总金额 = 选中账户金额
      state.totalAccountAmount = state.selectedAccountAmount;
    }
    // 合计总金额 = 合计初期金额 + 合计模块金额 + 选中计划金额 + 合计账户金额 + 选中补充金额
    state.totalSumAmount = state.totalInitialAmount +
        state.totalModuleAmount * (state.selectedCycleIndex == 2 ? 12 : 1) +
        state.selectedPlanAmount +
        state.totalAccountAmount +
        state.selectedSupplyAmount * (state.selectedCycleIndex == 2 ? 12 : 1);
    // 判断活动种类
    if (state.campaignData['promotion_type'] == '1') {
      // 折扣初期金额
      state.discountInitialAmount = 0;
      // 折扣模块金额
      state.discountModuleAmount = 0;
      // 折扣计划金额
      state.discountPlanAmount = 0;
      // 折扣账户金额
      state.discountAccountAmount = 0;
      // 折扣补充金额
      state.discountSupplyAmount = 0;
      // 折扣总金额
      state.discountSumAmount = 0;
    } else if (state.campaignData['promotion_type'] == '0') {
      // 折扣初期金额 = 合计初期金额 * 初期折扣
      state.discountInitialAmount = state.totalInitialAmount *
          (state.campaignData['initial_rate'] / 100) as int;
      // 折扣模块金额 = 合计模块金额 * 模块折扣
      state.discountModuleAmount = state.totalModuleAmount *
          (state.campaignData['base_rate'] / 100) as int;
      // 折扣计划金额 = 选中计划金额 * 计划折扣
      state.discountPlanAmount = state.selectedPlanAmount *
          (state.campaignData['accounting_rate'] / 100) as int;
      // 折扣账户金额 = 合计账户金额 * 账户折扣
      state.discountAccountAmount = state.totalAccountAmount *
          (state.campaignData['account_rate'] / 100) as int;
      // 折扣补充金额 = 选中补充金额 * 补充折扣
      state.discountSupplyAmount = state.selectedSupplyAmount *
          (state.campaignData['option_rate'] / 100) as int;
      // 折扣总金额
      state.discountSumAmount = state.discountInitialAmount +
          state.discountModuleAmount *
              (state.selectedCycleIndex == 2 ? 12 : 1) +
          state.discountPlanAmount +
          state.discountAccountAmount +
          state.discountSupplyAmount * (state.selectedCycleIndex == 2 ? 12 : 1);
    }
  }

  // 步骤3按钮点击检查
  bool step3ButtonClickCheck(LoginApplicationModel state) {
    // 标记
    bool flag = true;
    // 判断
    if (!state.selectedShipping &&
        !state.selectedEntry &&
        !state.selectedInventory) {
      // 错误提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
                  .login_application_choose_required +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 标记
      flag = false;
    } else if (state.selectedPlanId == 0) {
      // 错误提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
                  .login_application_choose_plan_title +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 标记
      flag = false;
    } else if (!state.selectedExchangeAct) {
      // 错误提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
              .login_application_step_button_1_tip_text_1);
      // 标记
      flag = false;
    } else if (!state.selectedPrivacyPolicy) {
      // 错误提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
              .login_application_step_button_1_tip_text_2);
      // 标记
      flag = false;
    }
    return flag;
  }

  // 发送最终邮件
  Future<void> sendEndEmail(LoginApplicationModel state) async {
    String h1 = WMSLocalizations.i18n(state.rootContext)!
        .login_application_end_email_text1;
    String p1 = WMSLocalizations.i18n(state.rootContext)!
        .login_application_end_email_text2;
    String p2 = WMSLocalizations.i18n(state.rootContext)!
        .login_application_end_email_text3;
    String content = '<h2>$h1</h2><p>$p1</p><p>$p2</p>';
    await MailUtils.sendEmailWithSMTP(
        state.applicationTmpData['user_email'],
        WMSLocalizations.i18n(state.rootContext)!
            .login_application_end_email_title,
        content);
  }

  // 发送站内信
  Future<void> sendInternalMessage(LoginApplicationModel state) async {
    // 新增消息数据
    Message message = Message.empty();
    message.title = '【重要】新規でお申し込みされました';
    message.message = state.applicationTmpData['company_name'] +
        '様がお申し込み完了しました。\n' +
        'すでに決済も完了しておりますので、受付のご判断とお客様へのご報告をお願いいたします。\n\n' +
        '----------------------------------\n' +
        '◆ 新規ユーザー情報\n\n' +
        '会社名：' +
        state.applicationTmpData['company_name'] +
        '\n' +
        '担当者名：' +
        state.applicationTmpData['user_name'] +
        '\n' +
        '電話番号：' +
        state.applicationTmpData['user_phone'] +
        '\n' +
        'メールアドレス：' +
        state.applicationTmpData['user_email'] +
        '\n' +
        '----------------------------------\n\n' +
        'ご不便をおかけいたしますが、受付結果のご報告よろしくお願い致します。';
    message.push_kbn = Config.NUMBER_ONE;
    message.del_kbn = Config.NUMBER_TWO.toString();
    message.create_id = 1;
    message.create_time = DateTime.now().toString();
    message.update_id = 1;
    message.update_time = DateTime.now().toString();
    List<Map<String, dynamic>> messageList = await SupabaseUtils.getClient()
        .from('ytb_message')
        .insert([message.toJson()]).select('*');
    // 新增消息历史数据
    MessageHistory messageHistory = MessageHistory.empty();
    messageHistory.message_kbn = 'ytb';
    messageHistory.message_id = messageList[0]['id'];
    messageHistory.status = Config.NUMBER_ONE.toString();
    messageHistory.read_status = Config.NUMBER_TWO.toString();
    messageHistory.user_id = 1;
    messageHistory.create_id = 1;
    messageHistory.create_time = DateTime.now().toString();
    messageHistory.update_id = 1;
    messageHistory.update_time = DateTime.now().toString();
    await SupabaseUtils.getClient()
        .from('ytb_message_history')
        .insert([messageHistory.toJson()]).select('*');
  }
}
