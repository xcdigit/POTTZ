import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:otp/otp.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/check_utils.dart';
import '../../../../common/utils/encryption_utils.dart';
import '../../../../common/utils/mail_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/application_tmp.dart';
import '../../../../model/user.dart';
import '../../../../redux/wms_state.dart';
import 'corporate_management_model.dart';

/**
 * 内容：法人管理-BLOC
 * 作者：赵士淞
 * 时间：2024/07/01
 */
// 事件
abstract class CorporateManagementEvent {}

// 初始化事件
class InitEvent extends CorporateManagementEvent {
  // 初始化事件
  InitEvent();
}

// 设置当前菜单下标事件
class SetCurrentMenuIndexEvent extends CorporateManagementEvent {
  // 当前菜单下标
  int currentMenuIndex;

  // 设置当前菜单下标事件
  SetCurrentMenuIndexEvent(this.currentMenuIndex);
}

// 设置搜索内容事件
class SetSearchContentEvent extends CorporateManagementEvent {
  // 值
  String value;

  // 设置搜索内容事件
  SetSearchContentEvent(this.value);
}

// 变更搜索用户类型下标事件
class ChangeSearchUserTypeIndexEvent extends CorporateManagementEvent {
  // 根结构树
  BuildContext dialogContext;
  // 搜索用户类型下标
  int searchUserTypeIndex;

  // 变更搜索用户类型下标事件
  ChangeSearchUserTypeIndexEvent(this.dialogContext, this.searchUserTypeIndex);
}

// 账户确认事件
class AccountConfirmEvent extends CorporateManagementEvent {
  // 选中用户下标
  int selectUserIndex;

  // 账户确认事件
  AccountConfirmEvent(this.selectUserIndex);
}

// 设置当前标签下标事件
class SetCurrentTabIndexEvent extends CorporateManagementEvent {
  // 当前标签下标
  int currentTabIndex;

  // 设置当前标签下标事件
  SetCurrentTabIndexEvent(this.currentTabIndex);
}

// 设置弹窗临时值事件
class SetDialogTempValue1Event extends CorporateManagementEvent {
  // 值
  String value;

  // 设置弹窗临时值事件
  SetDialogTempValue1Event(this.value);
}

// 设置弹窗临时值事件（电子邮件地址）
class SetDialogTempValue1EmailAddressEvent extends CorporateManagementEvent {
  // 值
  String value;

  // 设置弹窗临时值事件（电子邮件地址）
  SetDialogTempValue1EmailAddressEvent(this.value);
}

// 设置弹窗临时值事件
class SetDialogTempValue2Event extends CorporateManagementEvent {
  // 值
  String value;

  // 设置弹窗临时值事件
  SetDialogTempValue2Event(this.value);
}

// 设置弹窗临时值事件
class SetDialogTempValue3Event extends CorporateManagementEvent {
  // 值
  String value;

  // 设置弹窗临时值事件
  SetDialogTempValue3Event(this.value);
}

// 关闭变更弹窗事件
class CloseChangeDialogEvent extends CorporateManagementEvent {
  // 上下文
  BuildContext context;

  // 关闭变更弹窗事件
  CloseChangeDialogEvent(this.context);
}

// 添加用户事件
class AddUserEvent extends CorporateManagementEvent {
  // 上下文
  BuildContext context;

  // 添加用户事件
  AddUserEvent(this.context);
}

// 添加帐户事件
class AddAccountEvent extends CorporateManagementEvent {
  // 上下文
  BuildContext context;

  // 添加帐户事件
  AddAccountEvent(this.context);
}

// 变更注册名称事件
class ChangeLoginNameEvent extends CorporateManagementEvent {
  // 上下文
  BuildContext context;

  // 变更注册名称事件
  ChangeLoginNameEvent(this.context);
}

// 变更地址事件
class ChangeAddressEvent extends CorporateManagementEvent {
  // 上下文
  BuildContext context;

  // 变更地址事件
  ChangeAddressEvent(this.context);
}

// 设置公司名称事件
class SetCompanyNameEvent extends CorporateManagementEvent {
  // 值
  String value;

  // 设置公司名称事件
  SetCompanyNameEvent(this.value);
}

// 设置联系人姓名事件
class SetPersonChargeEvent extends CorporateManagementEvent {
  // 值
  String value;

  // 设置联系人姓名事件
  SetPersonChargeEvent(this.value);
}

// 设置电子邮件地址事件
class SetEmailAddressEvent extends CorporateManagementEvent {
  // 值
  String value;

  // 设置电子邮件地址事件
  SetEmailAddressEvent(this.value);
}

// 设置电话号码事件
class SetPhoneNumberEvent extends CorporateManagementEvent {
  // 值
  String value;

  // 设置电话号码事件
  SetPhoneNumberEvent(this.value);
}

// 设置活动代码事件
class SetCampaignCodeEvent extends CorporateManagementEvent {
  // 值
  String value;

  // 设置活动代码事件
  SetCampaignCodeEvent(this.value);
}

// 添加帐户提交事件
class AddAccountSubmitEvent extends CorporateManagementEvent {
  // 添加帐户提交事件
  AddAccountSubmitEvent();
}

class CorporateManagementBloc
    extends Bloc<CorporateManagementEvent, CorporateManagementModel> {
  // 刷新补丁
  CorporateManagementModel clone(CorporateManagementModel src) {
    return CorporateManagementModel.clone(src);
  }

  CorporateManagementBloc(CorporateManagementModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询用户数据
      await selectUserData(state);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置当前菜单下标事件
    on<SetCurrentMenuIndexEvent>((event, emit) async {
      // 当前菜单下标
      state.currentMenuIndex = event.currentMenuIndex;
      // 详情页面标记
      state.detailPageSign = Config.NUMBER_NEGATIVE;

      // 更新
      emit(clone(state));
    });

    // 设置搜索内容事件
    on<SetSearchContentEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 搜索内容
      state.searchContent = event.value;
      // 查询用户数据
      await selectUserData(state);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 变更搜索用户类型下标事件
    on<ChangeSearchUserTypeIndexEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 搜索用户类型下标
      state.searchUserTypeIndex = event.searchUserTypeIndex;
      // 查询用户数据
      await selectUserData(state);
      // 关闭弹窗
      Navigator.pop(event.dialogContext);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 账户确认事件
    on<AccountConfirmEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 选中用户下标
      state.selectUserIndex = event.selectUserIndex;
      // 详情页面标记
      state.detailPageSign = Config.NUMBER_ZERO;
      // 当前标签下标
      state.currentTabIndex = Config.NUMBER_ZERO;
      // 空间使用数量
      state.spaceUsageNumber =
          state.userList[state.selectUserIndex]['storage_size'] == null ||
                  state.userList[state.selectUserIndex]['storage_size'] == ''
              ? 0.0
              : double.parse(double.parse(state.userList[state.selectUserIndex]
                          ['storage_size']
                      .toString())
                  .toStringAsFixed(2));
      // 空间最大数量
      state.spaceMaxNumber =
          state.userList[state.selectUserIndex]['storage'] == null ||
                  state.userList[state.selectUserIndex]['storage'] == ''
              ? 99999999.0
              : double.parse(
                  state.userList[state.selectUserIndex]['storage'].toString());
      // 角色3用户最大数量
      state.role3UserMaxNumber =
          state.userList[state.selectUserIndex]['account_num'];
      // 查询角色2用户数据
      await selectRole2UserData(state);
      // 查询角色3用户数据
      await selectRole3UserData(state);
      // 查询申请临时列表
      List<dynamic> applicationTmpList = await SupabaseUtils.getClient()
          .from('ytb_application_tmp')
          .select('*')
          .eq('user_email',
              state.userList[state.selectUserIndex]['user_email']);
      // 临时申请数据
      state.applicationTmpData =
          applicationTmpList.length != 0 ? applicationTmpList[0] : {};
      // 判断计划ID是否为空
      if (state.applicationTmpData['plan_id'] != null &&
          state.applicationTmpData['plan_id'] != '') {
        // 查询计划列表
        List<dynamic> planList = await SupabaseUtils.getClient()
            .from('ytb_plan')
            .select('*')
            .eq('id', state.applicationTmpData['plan_id']);
        // 临时申请数据
        state.applicationTmpData['plan_name'] = planList[0]['plan_name'];
      }

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置当前标签下标事件
    on<SetCurrentTabIndexEvent>((event, emit) async {
      // 当前标签下标
      state.currentTabIndex = event.currentTabIndex;

      // 更新
      emit(clone(state));
    });

    // 设置弹窗临时值事件
    on<SetDialogTempValue1Event>((event, emit) async {
      // 弹窗临时值
      state.dialogTempValue1 = event.value;
    });

    // 设置弹窗临时值事件（电子邮件地址）
    on<SetDialogTempValue1EmailAddressEvent>((event, emit) async {
      // 格式校验
      if (event.value != '' && CheckUtils.check_Email(event.value)) {
        // 错误提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.app_cceptance_user_email +
                WMSLocalizations.i18n(state.rootContext)!.input_email_check);
      } else {
        // 查询申请临时列表
        List<dynamic> applicationTmpList = await SupabaseUtils.getClient()
            .from('ytb_application_tmp')
            .select('*')
            .eq('user_email', event.value);
        // 判断申请临时列表数量
        if (applicationTmpList.length == 0) {
          // 弹窗临时值
          state.dialogTempValue1 = event.value;
        } else {
          // 错误提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_application_email_address_error_exist);
        }
      }

      // 刷新
      emit(clone(state));
    });

    // 设置弹窗临时值事件
    on<SetDialogTempValue2Event>((event, emit) async {
      // 弹窗临时值
      state.dialogTempValue2 = event.value;
    });

    // 设置弹窗临时值事件
    on<SetDialogTempValue3Event>((event, emit) async {
      // 弹窗临时值
      state.dialogTempValue3 = event.value;
    });

    // 关闭变更弹窗事件
    on<CloseChangeDialogEvent>((event, emit) async {
      // 关闭变更弹窗
      closeChangeDialog(state, event.context);

      // 更新
      emit(clone(state));
    });

    // 添加用户事件
    on<AddUserEvent>((event, emit) async {
      // 添加用户验证
      bool flag = addUserCheck(state);
      // 判断验证结果
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 新增用户
        User user = User.empty();
        user.name = state.dialogTempValue2;
        user.role_id = Config.ROLE_ID_2;
        user.company_id = state.userList[state.selectUserIndex]['company_id'];
        user.email = state.dialogTempValue1;
        user.language_id = 2;
        user.status = '1';
        user.start_date = DateTime.now().toString();
        user.end_date = '20991231';
        user.create_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        user.create_time = DateTime.now().toString();
        user.update_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        user.update_time = DateTime.now().toString();
        await SupabaseUtils.getClient()
            .from('mtb_user')
            .insert([user.toJson()]).select('*');
        // 查询角色2用户数据
        await selectRole2UserData(state);
        // 消息提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!.plan_content_text_23 +
                WMSLocalizations.i18n(state.rootContext)!.create_success);
        // 关闭变更弹窗
        closeChangeDialog(state, event.context);

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 添加帐户事件
    on<AddAccountEvent>((event, emit) async {
      // 添加用户验证
      bool flag = addUserCheck(state);
      // 判断验证结果
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 新增用户
        User user = User.empty();
        user.name = state.dialogTempValue2;
        user.role_id = Config.ROLE_ID_3;
        user.company_id = state.userList[state.selectUserIndex]['company_id'];
        user.email = state.dialogTempValue1;
        user.language_id = 2;
        user.status = '1';
        user.start_date = DateTime.now().toString();
        user.end_date = '20991231';
        user.create_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        user.create_time = DateTime.now().toString();
        user.update_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        user.update_time = DateTime.now().toString();
        await SupabaseUtils.getClient()
            .from('mtb_user')
            .insert([user.toJson()]).select('*');
        // 查询角色3用户数据
        await selectRole3UserData(state);
        // 消息提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!.plan_content_text_24 +
                WMSLocalizations.i18n(state.rootContext)!.create_success);
        // 关闭变更弹窗
        closeChangeDialog(state, event.context);

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 变更注册名称事件
    on<ChangeLoginNameEvent>((event, emit) async {
      // 变更注册名称验证
      bool flag = changeLoginNameCheck(state);
      // 判断验证结果
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 原ID
        int oldId = state.userList[state.selectUserIndex]['id'];
        // 变更用户
        await SupabaseUtils.getClient()
            .from('mtb_user')
            .update({'name': state.dialogTempValue1}).eq(
                'id', state.userList[state.selectUserIndex]['user_id']);
        // 查询用户数据
        await selectUserData(state);
        // 计算选中用户下标
        countSelectUserIndex(state, oldId);
        // 关闭变更弹窗
        closeChangeDialog(state, event.context);

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 变更地址事件
    on<ChangeAddressEvent>((event, emit) async {
      // 变更地址事件
      bool flag = changeAddressCheck(state);
      // 判断验证结果
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 原ID
        int oldId = state.userList[state.selectUserIndex]['id'];
        // 变更用户
        await SupabaseUtils.getClient().from('mtb_company').update({
          'addr_1': state.dialogTempValue1,
          'addr_2': state.dialogTempValue2,
          'addr_3': state.dialogTempValue3
        }).eq('id', state.userList[state.selectUserIndex]['company_id']);
        // 查询用户数据
        await selectUserData(state);
        // 计算选中用户下标
        countSelectUserIndex(state, oldId);
        // 关闭变更弹窗
        closeChangeDialog(state, event.context);

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
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
      }

      // 刷新
      emit(clone(state));
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
      emit(clone(state));
    });

    // 设置活动代码事件
    on<SetCampaignCodeEvent>((event, emit) async {
      // 格式校验
      if (event.value != '') {
        // 查询活动列表
        List<dynamic> campaignList = await SupabaseUtils.getClient()
            .rpc('func_zhaoss_campaign_code_check', params: {
          'campaign_code': event.value,
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
          state.campaignCode = event.value;
        }
      } else {
        // 活动代码
        state.campaignCode = event.value;
      }

      // 刷新
      emit(clone(state));
    });

    // 添加帐户提交事件
    on<AddAccountSubmitEvent>((event, emit) async {
      // 添加帐户提交验证
      bool flag = addAccountSubmitCheck(state);
      // 判断验证结果
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 申请临时
        ApplicationTmp applicationTmp = ApplicationTmp.fromJson({});
        applicationTmp.channel_id = '1';
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
        await SupabaseUtils.getClient()
            .from('ytb_application_tmp')
            .insert([applicationTmp.toJson()]);
        // 发送新增邮件
        await sendAddEmail(state);
        // 公司名称
        state.companyName = '';
        // 联系人姓名
        state.personCharge = '';
        // 电子邮件地址
        state.emailAddress = '';
        // 电话号码
        state.phoneNumber = '';
        // 活动代码
        state.campaignCode = '';
        // 消息提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!.legal_person_add_success);

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    add(InitEvent());
  }

  // 查询用户数据
  Future<void> selectUserData(CorporateManagementModel state) async {
    // 会社用户关联情报
    List<dynamic> formList = [];
    // 判断搜索用户类型下标
    if (state.searchUserTypeIndex == Config.NUMBER_NEGATIVE) {
      // 查询会社用户关联情报
      formList = await SupabaseUtils.getClient().rpc(
          'func_zhaoss_query_table_ytb_company_manage_corporation',
          params: {
            'p_company_name': state.searchContent,
            'p_company_id': null,
          }).select("*");
    } else {
      // 查询会社用户关联情报
      formList = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_ytb_company_manage_corporation',
              params: {
                'p_company_name': state.searchContent,
                'p_company_id': null,
              })
          .select("*")
          .order('create_time',
              ascending: state.searchUserTypeIndex == Config.NUMBER_ZERO
                  ? false
                  : true);
    }
    // 用户列表
    state.userList = formList;
  }

  // 查询角色2用户数据
  Future<void> selectRole2UserData(CorporateManagementModel state) async {
    // 查询会社管理员
    List<dynamic> role2UserList = await SupabaseUtils.getClient()
        .from('mtb_user')
        .select('*')
        .eq('role_id', Config.ROLE_ID_2)
        .eq('company_id', state.userList[state.selectUserIndex]['company_id']);
    // 角色2用户数量
    state.role2UserNumber = role2UserList.length;
  }

  // 查询角色3用户数据
  Future<void> selectRole3UserData(CorporateManagementModel state) async {
    // 查询普通用户
    List<dynamic> role3UserList = await SupabaseUtils.getClient()
        .from('mtb_user')
        .select('*')
        .eq('role_id', Config.ROLE_ID_3)
        .eq('company_id', state.userList[state.selectUserIndex]['company_id']);
    // 角色3用户数量
    state.role3UserNumber = role3UserList.length;
  }

  // 关闭变更弹窗
  void closeChangeDialog(CorporateManagementModel state, BuildContext context) {
    // 弹窗临时值
    state.dialogTempValue1 = '';
    state.dialogTempValue2 = '';
    state.dialogTempValue3 = '';
    // 关闭弹窗
    Navigator.pop(context);
  }

  // 添加用户验证
  bool addUserCheck(CorporateManagementModel state) {
    // 判断是否为空
    if (state.dialogTempValue1 == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.app_cceptance_user_email +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    } else if (state.dialogTempValue2 == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.account_profile_user +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    }

    // 返回
    return true;
  }

  // 变更注册名称验证
  bool changeLoginNameCheck(CorporateManagementModel state) {
    // 判断是否为空
    if (state.dialogTempValue1 == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.account_profile_user +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    }

    // 返回
    return true;
  }

  // 变更地址事件
  bool changeAddressCheck(CorporateManagementModel state) {
    // 判断是否为空
    if (state.dialogTempValue1 == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.delivery_form_prefecture +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    } else if (state.dialogTempValue2 == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.delivery_form_municipal +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    } else if (state.dialogTempValue3 == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.delivery_form_address +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    }

    // 返回
    return true;
  }

  // 计算选中用户下标
  void countSelectUserIndex(CorporateManagementModel state, int oldId) {
    // 循环用户列表
    for (int i = 0; i < state.userList.length; i++) {
      // 判断是否相等
      if (state.userList[i]['id'] == oldId) {
        // 选中用户下标
        state.selectUserIndex = i;
      }
    }
  }

  // 添加帐户提交验证
  bool addAccountSubmitCheck(CorporateManagementModel state) {
    // 判断是否为空
    if (state.companyName == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .login_application_company_name +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    } else if (state.personCharge == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .login_application_person_charge +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    } else if (state.emailAddress == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .login_application_email_address +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    } else if (state.phoneNumber == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .login_application_phone_number +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    }

    // 返回
    return true;
  }

  // 发送新增邮件
  Future<void> sendAddEmail(CorporateManagementModel state) async {
    String h1 =
        WMSLocalizations.i18n(state.rootContext)!.legal_person_email_title;
    String p1 =
        WMSLocalizations.i18n(state.rootContext)!.legal_person_email_text1;
    String p2 =
        WMSLocalizations.i18n(state.rootContext)!.legal_person_email_text2;
    String p3 =
        WMSLocalizations.i18n(state.rootContext)!.legal_person_email_text3;
    String p4 =
        WMSLocalizations.i18n(state.rootContext)!.legal_person_email_text4;
    String url = Config.BASE_URL + '/loginApplication/1/again';
    String content =
        '<h2>$h1</h2><p>$p1</p><p>$p2</p><p>$p3</p><p>$p4</p><p><a href="$url">$url</a></p>';
    await MailUtils.sendEmailWithSMTP(
        state.emailAddress,
        WMSLocalizations.i18n(state.rootContext)!.legal_person_email_title,
        content);
  }
}
