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
import '../../../common/utils/mail_utils.dart';
import '../../../common/utils/stripe_utils.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../model/company_plan_manage.dart';
import '../../../model/login.dart';
import '../../../model/user.dart';
import '../../../redux/wms_state.dart';
import '../../login/pc/login_page.dart';
import 'login_renewal_model.dart';

/**
 * 内容：续费-BLOC
 * 作者：赵士淞
 * 时间：2025/01/10
 */
// 事件
abstract class LoginRenewalEvent {}

// 初始化事件
class InitEvent extends LoginRenewalEvent {
  // 初始化事件
  InitEvent();
}

// 选中语言变更事件
class SelectedLanguageChangeEvent extends LoginRenewalEvent {
  // 选中语言ID
  int selectedLanguageId;
  // 选中语言变更事件
  SelectedLanguageChangeEvent(this.selectedLanguageId);
}

// 设置电子邮件地址事件
class SetEmailAddressEvent extends LoginRenewalEvent {
  // 值
  String value;
  // 设置电子邮件地址事件
  SetEmailAddressEvent(this.value);
}

// 设置密码事件
class SetPasswordEvent extends LoginRenewalEvent {
  // 值
  String value;
  // 设置密码事件
  SetPasswordEvent(this.value);
}

// 设置活动代码事件
class SetCampaignCodeEvent extends LoginRenewalEvent {
  // 值
  String value;
  // 设置活动代码事件
  SetCampaignCodeEvent(this.value);
}

// 步骤1按钮点击事件
class Step1ButtonClickEvent extends LoginRenewalEvent {
  // 步骤1按钮点击事件
  Step1ButtonClickEvent();
}

// 设置验证指数事件
class SetVerifyIndexEvent extends LoginRenewalEvent {
  // 值
  int value;
  // 设置验证指数事件
  SetVerifyIndexEvent(this.value);
}

// 发送邮件点击事件
class SendMailClickEvent extends LoginRenewalEvent {
  // 发送邮件点击事件
  SendMailClickEvent();
}

// 设置验证码事件
class SetVerifyCodeEvent extends LoginRenewalEvent {
  // 值
  String value;
  // 设置验证码事件
  SetVerifyCodeEvent(this.value);
}

// 步骤2按钮点击事件
class Step2ButtonClickEvent extends LoginRenewalEvent {
  // 步骤2按钮点击事件
  Step2ButtonClickEvent();
}

// 选中出荷管理变更事件
class SelectedShippingChangeEvent extends LoginRenewalEvent {
  // 选中出荷管理变更事件
  SelectedShippingChangeEvent();
}

// 选中入荷管理变更事件
class SelectedEntryChangeEvent extends LoginRenewalEvent {
  // 选中入荷管理变更事件
  SelectedEntryChangeEvent();
}

// 选中在库管理变更事件
class SelectedInventoryChangeEvent extends LoginRenewalEvent {
  // 选中在库管理变更事件
  SelectedInventoryChangeEvent();
}

// 选中计划变更事件
class SelectedPlanChangeEvent extends LoginRenewalEvent {
  // 计划ID
  int planId;
  // 计划金额
  int planAmount;
  // 选中计划变更事件
  SelectedPlanChangeEvent(this.planId, this.planAmount);
}

// 选中账户变更事件
class SelectedAccountChangeEvent extends LoginRenewalEvent {
  // 账户指数
  int accountIndex;
  // 账户金额
  int accountAmount;
  // 选中账户变更事件
  SelectedAccountChangeEvent(this.accountIndex, this.accountAmount);
}

// 设置添加账户数量事件
class SetAddAccountNumber extends LoginRenewalEvent {
  // 值
  String value;
  // 设置添加账户数量事件
  SetAddAccountNumber(this.value);
}

// 选中补充变更事件
class SelectedSupplyChangeEvent extends LoginRenewalEvent {
  // 补充指数
  int supplyIndex;
  // 补充金额
  int supplyAmount;
  // 选中补充变更事件
  SelectedSupplyChangeEvent(this.supplyIndex, this.supplyAmount);
}

// 选中周期变更事件
class SelectedCycleChangeEvent extends LoginRenewalEvent {
  // 周期指数
  int cycleIndex;
  // 选中周期变更事件
  SelectedCycleChangeEvent(this.cycleIndex);
}

// 步骤3按钮点击事件
class Step3ButtonClickEvent extends LoginRenewalEvent {
  // 步骤3按钮点击事件
  Step3ButtonClickEvent();
}

// 选中交易法变更事件
class SelectedExchangeActChangeEvent extends LoginRenewalEvent {
  // 选中交易法变更事件
  SelectedExchangeActChangeEvent();
}

// 选中隐私协议变更事件
class SelectedPrivacyPolicyChangeEvent extends LoginRenewalEvent {
  // 选中隐私协议变更事件
  SelectedPrivacyPolicyChangeEvent();
}

// 步骤4按钮点击事件
class Step4ButtonClickEvent extends LoginRenewalEvent {
  // 步骤4按钮点击事件
  Step4ButtonClickEvent();
}

class LoginRenewalBloc extends Bloc<LoginRenewalEvent, LoginRenewalModel> {
  // 刷新补丁
  LoginRenewalModel clone(LoginRenewalModel src) {
    return LoginRenewalModel.clone(src);
  }

  LoginRenewalBloc(LoginRenewalModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 查询多语言列表
      List<Map<String, dynamic>> languageList =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      // 多语言列表
      state.languageList = languageList;
      // 判断页面标识
      if (state.pageFlag != 'once') {
        // 选中步骤
        state.selectedStep = 4;
        // 更新会社计划
        List<dynamic> updateCompanyPlanList = await SupabaseUtils.getClient()
            .from('ytb_company_plan_manage')
            .update({
              'pay_status': '1',
              'update_time': DateTime.now().toString(),
              'update_id': 1
            })
            .eq('pay_no', state.pageFlag)
            .select('*');
        // 会社计划订单情报
        state.companyPlanOrderData = updateCompanyPlanList[0];
      }
      // 刷新
      emit(LoginRenewalModel.clone(state));
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
      emit(LoginRenewalModel.clone(state));
      // 关闭弹窗
      Navigator.pop(state.rootContext);
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
        // 电子邮件地址
        state.emailAddress = event.value;
      }
      // 刷新
      emit(LoginRenewalModel.clone(state));
    });

    // 设置密码事件
    on<SetPasswordEvent>((event, emit) async {
      // 密码
      state.password = event.value;
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
        // 活动信息
        state.campaignData = {};
      }
      // 刷新
      emit(LoginRenewalModel.clone(state));
    });

    // 步骤1按钮点击事件
    on<Step1ButtonClickEvent>((event, emit) async {
      // 步骤1按钮点击检查
      bool flag = step1ButtonClickCheck(state);
      // 判断结果
      if (flag) {
        // 打开加载
        BotToast.showLoading();
        // 登录
        var loginRes = await SupabaseUtils.loginByMail(
            state.emailAddress, state.password, false);
        if (!loginRes) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.login_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // Supabase登录信息
        Login? login = await SupabaseUtils.getCurrentUser();
        // 查询登录用户
        List<dynamic> userList = await SupabaseUtils.getClient()
            .from('mtb_user')
            .select('*')
            .eq('code', login?.id);
        if (userList.length > 1) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .email_multiple_accounts);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        } else if (userList.length == 0) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.email_not_exist);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 查询会社管理员
        List<dynamic> companyManageList = await SupabaseUtils.getClient()
            .from('ytb_company_manage')
            .select('*')
            .eq('company_id', userList[0]['company_id'])
            .eq('user_id', userList[0]['id']);
        if (companyManageList.length == 0) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .user_not_company_application_admin);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 查询会社计划
        List<dynamic> companyPlanList = await SupabaseUtils.getClient()
            .from('ytb_company_plan_manage')
            .select('*')
            .eq('company_id', userList[0]['company_id'])
            .eq('pay_status', '1')
            .order('next_date', ascending: false);
        if (companyPlanList.length == 0) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .last_payment_record_not_found);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 查询计划列表
        List<dynamic> planList = await SupabaseUtils.getClient()
            .from('ytb_plan')
            .select('*')
            .eq('del_kbn', Config.DELETE_NO)
            .order('id', ascending: true);
        // 计划列表
        state.planList = planList;
        // 查询普通用户
        List<dynamic> role3UserList = await SupabaseUtils.getClient()
            .from('mtb_user')
            .select('*')
            .eq('role_id', Config.ROLE_ID_3)
            .eq('company_id', userList[0]['company_id']);
        // 角色3用户数量
        state.role3UserNumber = role3UserList.length;
        // 用户情报
        state.userData = userList[0];
        // 会社计划情报
        state.companyPlanData = companyPlanList[0];
        // 判断下次时间是否在未来三天内
        if (DateTime.now().millisecondsSinceEpoch -
                DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                    .parse(state.companyPlanData['next_date'])
                    .millisecondsSinceEpoch >=
            -7 * 24 * 60 * 60 * 1000) {
          // 能否续费
          state.canRenewal = true;
        } else {
          // 能否续费
          state.canRenewal = false;
        }
        // 判断结束时间是否在未来三天内
        if (DateTime.now().millisecondsSinceEpoch -
                DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                    .parse(state.companyPlanData['end_date'])
                    .millisecondsSinceEpoch >=
            -7 * 24 * 60 * 60 * 1000) {
          // 能否改变年度项
          state.canChangeYearly = true;
        } else {
          // 能否改变年度项
          state.canChangeYearly = false;
        }
        // 选中出荷管理
        state.selectedShipping =
            state.companyPlanData['base_ship'] == '1' ? true : false;
        // 选中入荷管理
        state.selectedEntry =
            state.companyPlanData['base_receive'] == '1' ? true : false;
        // 选中在库管理
        state.selectedInventory =
            state.companyPlanData['base_store'] == '1' ? true : false;
        // 选中计划ID
        state.selectedPlanId = state.companyPlanData['plan_id'];
        // 循环计划列表
        for (int i = 0; i < state.planList.length; i++) {
          // 判断是否是选中计划
          if (state.planList[i]['id'] == state.selectedPlanId) {
            // 选中计划金额
            state.selectedPlanAmount = state.planList[i]['plan_amount'];
          }
        }
        // 选中账户指数
        state.selectedAccountIndex =
            int.parse(state.companyPlanData['account_type']);
        // 选中账户金额
        state.selectedAccountAmount =
            state.companyPlanData['account_type'] == '2' ? 1000 : 0;
        // 添加账户数量
        state.addAccountNumber = state.companyPlanData['account_num'] - 3;
        // 选中补充指数
        state.selectedSupplyIndex = int.parse(state.companyPlanData['option']);
        // 选中补充金额
        state.selectedSupplyAmount = state.companyPlanData['option'] == '2'
            ? 19800
            : state.companyPlanData['option'] == '3'
                ? 29800
                : state.companyPlanData['option'] == '4'
                    ? 19800
                    : 0;
        // 选中周期指数
        state.selectedCycleIndex =
            int.parse(state.companyPlanData['pay_cycle']);
        // 计算相关金额
        calculateRelevantAmount(state);
        // 选中步骤
        state.selectedStep = 2;
        // 刷新
        emit(LoginRenewalModel.clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 设置验证指数事件
    on<SetVerifyIndexEvent>((event, emit) async {
      // 验证指数
      state.verifyIndex = event.value;
      // 刷新
      emit(LoginRenewalModel.clone(state));
    });

    // 发送邮件点击事件
    on<SendMailClickEvent>((event, emit) async {
      // 判断上次发送时间是否在五分钟内
      if (state.userData['send_time'] == null ||
          state.userData['send_time'].toString() == '' ||
          DateTime.now().millisecondsSinceEpoch -
                  DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
                      .parse(state.userData['send_time'])
                      .millisecondsSinceEpoch >=
              1 * 60 * 1000) {
        // 随机数
        var random = Random();
        // 生成匹配验证码
        var randomCode = random.nextInt(900000) + 100000;
        // 更新用户列表
        List<Map<String, dynamic>> userList = await SupabaseUtils.getClient()
            .from('mtb_user')
            .update({
              'send_time': DateTime.now().toString(),
              'mail_code': randomCode,
              'update_id': 1,
              'update_time': DateTime.now().toString()
            })
            .eq('id', state.userData['id'])
            .select('*');
        // 用户情报
        state.userData = userList[0];
        // 发送邮件
        String h1 = WMSLocalizations.i18n(state.rootContext)!
            .login_application_mail_send_text_1;
        String p2 = WMSLocalizations.i18n(state.rootContext)!
                .login_application_mail_send_text_2 +
            randomCode.toString();
        String content = '<h2>$h1</h2><p>$p2</p>';
        bool res = await MailUtils.sendEmailWithSMTP(
            state.userData['email'],
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
          state.userData['authenticator_key'],
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
        if (state.verifyCode != state.userData['mail_code']) {
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
      emit(LoginRenewalModel.clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 选中出荷管理变更事件
    on<SelectedShippingChangeEvent>((event, emit) async {
      // 选项能否变更检查2
      bool flag = optionCanChangeCheck2(state);
      // 判断结果
      if (flag) {
        // 选中出荷管理
        state.selectedShipping = !state.selectedShipping;
        // 计算相关金额
        calculateRelevantAmount(state);
        // 刷新
        emit(LoginRenewalModel.clone(state));
      }
    });

    // 选中入荷管理变更事件
    on<SelectedEntryChangeEvent>((event, emit) async {
      // 选项能否变更检查2
      bool flag = optionCanChangeCheck2(state);
      // 判断结果
      if (flag) {
        // 选中入荷管理
        state.selectedEntry = !state.selectedEntry;
        // 计算相关金额
        calculateRelevantAmount(state);
        // 刷新
        emit(LoginRenewalModel.clone(state));
      }
    });

    // 选中在库管理变更事件
    on<SelectedInventoryChangeEvent>((event, emit) async {
      // 选项能否变更检查2
      bool flag = optionCanChangeCheck2(state);
      // 判断结果
      if (flag) {
        // 选中在库管理
        state.selectedInventory = !state.selectedInventory;
        // 计算相关金额
        calculateRelevantAmount(state);
        // 刷新
        emit(LoginRenewalModel.clone(state));
      }
    });

    // 选中计划变更事件
    on<SelectedPlanChangeEvent>((event, emit) async {
      // 选项能否变更检查1
      bool flag1 = optionCanChangeCheck1(state);
      // 选中计划变更检查
      bool flag2 = selectedPlanChangeCheck(state, event.planId);
      // 判断结果
      if (flag1 && flag2) {
        // 选中计划ID
        state.selectedPlanId = event.planId;
        // 选中计划金额
        state.selectedPlanAmount = event.planAmount;
        // 计算相关金额
        calculateRelevantAmount(state);
        // 刷新
        emit(LoginRenewalModel.clone(state));
      }
    });

    // 选中账户变更事件
    on<SelectedAccountChangeEvent>((event, emit) async {
      // 选项能否变更检查1
      bool flag = optionCanChangeCheck1(state);
      // 判断结果
      if (flag) {
        // 判断选中账户指数及角色3用户数量
        if (event.accountIndex == 1 && state.role3UserNumber > 3) {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .users_in_use_than_3_option_cannot_changed);
          return;
        }
        // 选中账户指数
        state.selectedAccountIndex = event.accountIndex;
        // 选中账户金额
        state.selectedAccountAmount = event.accountAmount;
        // 计算相关金额
        calculateRelevantAmount(state);
        // 刷新
        emit(LoginRenewalModel.clone(state));
      }
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
          // 判断选中账户指数及角色3用户数量
          if (inputValue + 3 < state.role3UserNumber) {
            // 错误提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                    .users_enter_must_then_users_in_use);
          } else {
            // 添加账户数量
            state.addAccountNumber = inputValue;
          }
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
      emit(LoginRenewalModel.clone(state));
    });

    // 选中补充变更事件
    on<SelectedSupplyChangeEvent>((event, emit) async {
      // 选项能否变更检查2
      bool flag = optionCanChangeCheck2(state);
      // 判断结果
      if (flag) {
        // 选中补充指数
        state.selectedSupplyIndex = event.supplyIndex;
        // 选中补充金额
        state.selectedSupplyAmount = event.supplyAmount;
        // 计算相关金额
        calculateRelevantAmount(state);
        // 刷新
        emit(LoginRenewalModel.clone(state));
      }
    });

    // 选中周期变更事件
    on<SelectedCycleChangeEvent>((event, emit) async {
      // 选项能否变更检查2
      bool flag = optionCanChangeCheck2(state);
      // 判断结果
      if (flag) {
        // 选中周期指数
        state.selectedCycleIndex = event.cycleIndex;
        // 计算相关金额
        calculateRelevantAmount(state);
        // 刷新
        emit(LoginRenewalModel.clone(state));
      }
    });

    // 步骤3按钮点击事件
    on<Step3ButtonClickEvent>((event, emit) async {
      // 选项能否变更检查1
      bool flag1 = optionCanChangeCheck1(state);
      // 步骤3按钮点击检查
      bool flag2 = step3ButtonClickCheck(state);
      // 选中计划变更检查
      bool flag3 = selectedPlanChangeCheck(state, state.selectedPlanId);
      // 判断
      if (flag1 && flag2 && flag3) {
        // 打开加载
        BotToast.showLoading();
        // 当前时间
        DateTime nowDateTime = DateTime.now();
        // 旧开始日期
        DateTime oldStartDateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parse(state.companyPlanData['start_date']);
        // 旧下次日期
        DateTime oldNextDateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parse(state.companyPlanData['next_date']);
        // 旧结束日期
        DateTime oldEndDateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parse(state.companyPlanData['end_date']);
        // 新开始日期
        DateTime newStartDateTime = DateTime.now();
        // 新下次日期
        DateTime newNextDateTime = DateTime.now();
        // 新结束日期
        DateTime newEndDateTime = DateTime.now();
        // 判断能否改变年度项
        if (state.canChangeYearly) {
          // 判断当前时间是否在旧结束日期之后
          if (nowDateTime.millisecondsSinceEpoch >
              oldEndDateTime.millisecondsSinceEpoch) {
            // 新开始日期
            newStartDateTime = nowDateTime;
          } else {
            // 新开始日期
            newStartDateTime = oldEndDateTime;
          }
          // 判断选中周期指数
          if (state.selectedCycleIndex == 1) {
            // 新结束日期
            newEndDateTime = DateTime(newStartDateTime.year,
                newStartDateTime.month + 1, newStartDateTime.day);
          } else {
            // 新结束日期
            newEndDateTime = DateTime(newStartDateTime.year + 1,
                newStartDateTime.month, newStartDateTime.day);
          }
          // 新下次日期
          newNextDateTime = DateTime(newStartDateTime.year,
              newStartDateTime.month + 1, newStartDateTime.day);
        } else {
          // 新开始日期
          newStartDateTime = oldStartDateTime;
          // 新结束日期
          newEndDateTime = oldEndDateTime;
          // 判断当前时间是否在旧下次日期之后
          if (nowDateTime.millisecondsSinceEpoch >
              oldNextDateTime.millisecondsSinceEpoch) {
            // 新下次日期
            newNextDateTime = DateTime(
                nowDateTime.year, nowDateTime.month + 1, nowDateTime.day);
          } else {
            // 新下次日期
            newNextDateTime = DateTime(oldNextDateTime.year,
                oldNextDateTime.month + 1, oldNextDateTime.day);
          }
        }
        // 新增会社计划
        CompanyPlanManage companyPlanManage = CompanyPlanManage.empty();
        companyPlanManage.company_id = state.userData['company_id'];
        companyPlanManage.promotion_code = state.campaignCode;
        companyPlanManage.base_ship = state.selectedShipping ? '1' : '0';
        companyPlanManage.base_receive = state.selectedEntry ? '1' : '0';
        companyPlanManage.base_store = state.selectedInventory ? '1' : '0';
        companyPlanManage.plan_id = state.selectedPlanId;
        companyPlanManage.account_type = state.selectedAccountIndex.toString();
        companyPlanManage.account_num = state.addAccountNumber + 3;
        companyPlanManage.option = state.selectedSupplyIndex.toString();
        companyPlanManage.pay_cycle = state.selectedCycleIndex.toString();
        companyPlanManage.start_date = newStartDateTime.toString();
        companyPlanManage.next_date = newNextDateTime.toString();
        companyPlanManage.end_date = newEndDateTime.toString();
        companyPlanManage.pay_status = '0';
        companyPlanManage.pay_total =
            state.campaignData['promotion_type'] != null &&
                    state.campaignData['promotion_type'] != ''
                ? state.discountSumAmount.toDouble()
                : state.totalSumAmount.toDouble();
        companyPlanManage.create_time = DateTime.now().toString();
        companyPlanManage.create_id = state.userData['id'];
        companyPlanManage.update_time = DateTime.now().toString();
        companyPlanManage.update_id = state.userData['id'];
        List<dynamic> companyPlanList = await SupabaseUtils.getClient()
            .from('ytb_company_plan_manage')
            .insert([companyPlanManage.toJson()]).select('*');
        // 会社计划订单情报
        state.companyPlanOrderData = companyPlanList[0];
        // 判断付款金额
        if (state.companyPlanOrderData['pay_total'] == 0) {
          // 更新会社计划
          List<dynamic> updateCompanyPlanList = await SupabaseUtils.getClient()
              .from('ytb_company_plan_manage')
              .update({
                'pay_status': '1',
                'update_time': DateTime.now().toString(),
                'update_id': state.userData['id']
              })
              .eq('id', state.companyPlanOrderData['id'])
              .select('*');
          // 会社计划订单情报
          state.companyPlanOrderData = updateCompanyPlanList[0];
          // 选中步骤
          state.selectedStep = 4;
        } else {
          // 跳转支付页面
          String orderNo = await StripeUtils.createCheckoutSessions(
              state.rootContext, state.companyPlanOrderData['id'], 2);
          // 更新会社计划
          List<dynamic> updateCompanyPlanList = await SupabaseUtils.getClient()
              .from('ytb_company_plan_manage')
              .update({
                'pay_no': orderNo,
                'update_time': DateTime.now().toString(),
                'update_id': state.userData['id']
              })
              .eq('id', state.companyPlanOrderData['id'])
              .select('*');
          // 会社计划订单情报
          state.companyPlanOrderData = updateCompanyPlanList[0];
        }
        // 刷新
        emit(LoginRenewalModel.clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 选中交易法变更事件
    on<SelectedExchangeActChangeEvent>((event, emit) async {
      // 选中交易法
      state.selectedExchangeAct = !state.selectedExchangeAct;
      // 刷新
      emit(LoginRenewalModel.clone(state));
    });

    // 选中隐私协议变更事件
    on<SelectedPrivacyPolicyChangeEvent>((event, emit) async {
      // 选中隐私协议
      state.selectedPrivacyPolicy = !state.selectedPrivacyPolicy;
      // 刷新
      emit(LoginRenewalModel.clone(state));
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
  Future<void> selectCampaignData(String value, LoginRenewalModel state) async {
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
  bool step1ButtonClickCheck(LoginRenewalModel state) {
    // 标记
    bool flag = true;
    // 判断
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
          WMSLocalizations.i18n(state.rootContext)!.login_application_password +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 标记
      flag = false;
    }
    return flag;
  }

  // 计算相关金额
  void calculateRelevantAmount(LoginRenewalModel state) {
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
    // 判断能否改变年度项
    if (!state.canChangeYearly) {
      // 合计模块金额
      state.totalModuleAmount = 0;
      // 选中补充金额
      state.selectedSupplyAmount = 0;
    }
    // 判断能否续费
    if (!state.canRenewal) {
      // 合计初期金额
      state.totalInitialAmount = 0;
      // 合计模块金额
      state.totalModuleAmount = 0;
      // 选中计划金额
      state.selectedPlanAmount = 0;
      // 合计账户金额
      state.totalAccountAmount = 0;
      // 选中补充金额
      state.selectedSupplyAmount = 0;
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

  // 选项能否变更检查1
  bool optionCanChangeCheck1(LoginRenewalModel state) {
    // 标记
    bool flag = true;
    // 判断
    if (!state.canRenewal) {
      // 错误提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
              .option_cannot_changed_text_1);
      // 标记
      flag = false;
    }
    return flag;
  }

  // 选项能否变更检查2
  bool optionCanChangeCheck2(LoginRenewalModel state) {
    // 标记
    bool flag = true;
    // 判断
    if (!state.canRenewal) {
      // 错误提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
              .option_cannot_changed_text_1);
      // 标记
      flag = false;
    } else if (!state.canChangeYearly) {
      // 错误提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
              .option_cannot_changed_text_2);
      // 标记
      flag = false;
    }
    return flag;
  }

  // 步骤3按钮点击检查
  bool step3ButtonClickCheck(LoginRenewalModel state) {
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

  // 选中计划变更检查
  bool selectedPlanChangeCheck(LoginRenewalModel state, int selectedPlanId) {
    // 标记
    bool flag = true;
    // 循环计划列表
    for (int i = 0; i < state.planList.length; i++) {
      // 判断选中计划ID
      if (selectedPlanId == state.planList[i]['id']) {
        //
        double databaseSize = state.companyPlanData['database_size'] == null ||
                state.companyPlanData['database_size'] == ''
            ? 0
            : state.companyPlanData['database_size'];
        //
        double dbCapacity = state.planList[i]['db_capacity'] == null ||
                state.planList[i]['db_capacity'] == ''
            ? 99999999
            : state.planList[i]['db_capacity'];
        //
        double storageSize = state.companyPlanData['storage_size'] == null ||
                state.companyPlanData['storage_size'] == ''
            ? 0
            : state.companyPlanData['storage_size'];
        //
        double storage = state.planList[i]['storage'] == null ||
                state.planList[i]['storage'] == ''
            ? 99999999
            : state.planList[i]['storage'];
        // 判断数据大小和存储大小
        if (databaseSize >= dbCapacity) {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .database_space_low_upgrade_plan);
          // 标记
          flag = false;
        } else if (storageSize >= storage) {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .storage_space_low_upgrade_plan);
          // 标记
          flag = false;
        }
      }
    }
    return flag;
  }
}
