import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:otp/otp.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as LoginUser;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/mail_utils.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/check_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../env/dev.dart';
import '../../../../env/env_config.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../model/cancel.dart';
import '../../../../model/message.dart';
import '../../../../model/message_history.dart';
import '../../../../model/user.dart' as systm_user;
import '../../../../redux/login_user_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../../../login/sp/login_page.dart'
    if (dart.library.html) '../../../login/pc/login_page.dart';
import 'account_model.dart';

/**
 * 内容：账户-BLOC
 * 作者：赵士淞
 * 时间：2023/09/18
 */
// 事件
abstract class AccountEvent {}

// 初始化事件
class InitEvent extends AccountEvent {
  // 初始化事件
  InitEvent();
}

// 保存账户事件
class SaveUserEvent extends AccountEvent {
  // 账户-结构
  Map<String, dynamic> userStructure = {};
  // 保存账户事件
  SaveUserEvent(this.userStructure);
}

// 保存登录事件
class SaveLoginEvent extends AccountEvent {
  // 保存登录事件
  SaveLoginEvent();
}

// 保存临时值事件
class SaveTempValueEvent extends AccountEvent {
  // 临时值
  String tempValue;
  // 保存临时值事件
  SaveTempValueEvent(this.tempValue);
}

// 保存位置标记和位置下标
class SaveLocationFlagAndLocationIndexEvent extends AccountEvent {
  // 位置标记
  bool locationFlag;
  // 位置下标
  int locationIndex;
  // 保存位置标记和位置下标
  SaveLocationFlagAndLocationIndexEvent(this.locationFlag, this.locationIndex);
}

//发送解约邮件
class SendCancellationMailEvent extends AccountEvent {
  SendCancellationMailEvent();
}

// 设置头像提示文本显示事件
class SetAvatarTooltipShowEvent extends AccountEvent {
  // 头像提示文本显示
  bool avatarTooltipShow;
  // 设置头像提示文本显示事件
  SetAvatarTooltipShowEvent(this.avatarTooltipShow);
}

// 设置弹窗临时值事件
class SetDialogTempValue1Event extends AccountEvent {
  // 值
  String value;

  // 设置弹窗临时值事件
  SetDialogTempValue1Event(this.value);
}

// 设置弹窗临时值事件
class SetDialogTempValue2Event extends AccountEvent {
  // 值
  String value;

  // 设置弹窗临时值事件
  SetDialogTempValue2Event(this.value);
}

// 设置弹窗临时值事件
class SetDialogTempValue3Event extends AccountEvent {
  // 值
  String value;

  // 设置弹窗临时值事件
  SetDialogTempValue3Event(this.value);
}

// 设置弹窗临时值事件（电子邮件地址）
class SetDialogTempValue1EmailAddressEvent extends AccountEvent {
  // 值
  String value;

  // 设置弹窗临时值事件（电子邮件地址）
  SetDialogTempValue1EmailAddressEvent(this.value);
}

// 关闭变更弹窗事件
class CloseChangeDialogEvent extends AccountEvent {
  // 上下文
  BuildContext context;

  // 关闭变更弹窗事件
  CloseChangeDialogEvent(this.context);
}

// 变更注册名称事件
class ChangeLoginNameEvent extends AccountEvent {
  // 上下文
  BuildContext context;

  // 变更注册名称事件
  ChangeLoginNameEvent(this.context);
}

// 变更地址事件
class ChangeAddressEvent extends AccountEvent {
  // 上下文
  BuildContext context;

  // 变更地址事件
  ChangeAddressEvent(this.context);
}

// 添加用户事件
class AddUserEvent extends AccountEvent {
  // 上下文
  BuildContext context;

  // 添加用户事件
  AddUserEvent(this.context);
}

// 添加帐户事件
class AddAccountEvent extends AccountEvent {
  // 上下文
  BuildContext context;

  // 添加帐户事件
  AddAccountEvent(this.context);
}

// 发起解约事件
class ProposeCancelEvent extends AccountEvent {
  // 发起解约事件
  ProposeCancelEvent();
}

// 确认解约事件
class ConfirmCancelEvent extends AccountEvent {
  // 确认解约事件
  ConfirmCancelEvent();
}

// 生成验证二维码
class JudgeQREvent extends AccountEvent {
  // 生成验证二维码
  JudgeQREvent();
}

class AccountBloc extends Bloc<AccountEvent, AccountModel> {
  // 刷新补丁
  AccountModel clone(AccountModel src) {
    return AccountModel.clone(src);
  }

  AccountBloc(AccountModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询多语言信息
      List<Map<String, dynamic>> languageData =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      // 多语言列表
      state.languageList = languageData;

      // 查询支付信息
      List<Map<String, dynamic>> manageData = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_item_ytb_user_manage', params: {
        'user_id':
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id
      }).select('*');
      // 支付列表
      state.manageList = manageData;

      // 查询解约数据
      await selectCancelData(state);

      // 临时值
      state.tempValue = '';
      // 位置标记
      state.locationFlag = false;
      // 位置下标
      state.locationIndex = Config.NUMBER_ZERO;
      // 查询用户事件
      await selectUserData(state);
      // 查询计划事件
      await selectPlanData(state);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 保存账户事件
    on<SaveUserEvent>((event, emit) async {
      // 头像提示文本显示
      state.avatarTooltipShow = false;

      // 判断账户-结构
      if (event.userStructure['avatar'] == '') {
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      try {
        // 修改账户
        List<Map<String, dynamic>> userData = await SupabaseUtils.getClient()
            .from('mtb_user')
            .update(event.userStructure)
            .eq(
                'id',
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser
                    ?.id)
            .select('*');
        // 判断账户数据
        if (userData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_50_1 +
                  WMSLocalizations.i18n(state.rootContext)!.update_success);
          if (!kIsWeb) {
            //返回上一页
            GoRouter.of(state.rootContext).pop('refresh return');
          }
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_50_1 +
                  WMSLocalizations.i18n(state.rootContext)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.menu_content_50_1 +
                WMSLocalizations.i18n(state.rootContext)!.update_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 临时值
      state.tempValue = '';
      // 位置标记
      state.locationFlag = false;
      // 位置下标
      state.locationIndex = Config.NUMBER_ZERO;
      // 查询用户事件
      await selectUserData(state);
      // 查询计划事件
      await selectPlanData(state);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 保存登录事件
    on<SaveLoginEvent>((event, emit) async {
      // 判断正则表达式
      if (CheckUtils.check_Password(state.tempValue)) {
        // 提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.menu_content_50_1 +
                WMSLocalizations.i18n(state.rootContext)!.check_password);
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 授权用户
      LoginUser.UserAttributes userAttributes = LoginUser.UserAttributes();
      userAttributes.email =
          StoreProvider.of<WMSState>(state.rootContext).state.userInfo?.login;
      userAttributes.password = state.tempValue;

      try {
        // 更新授权
        await SupabaseUtils.getClient().auth.updateUser(userAttributes);
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.menu_content_50_1 +
                WMSLocalizations.i18n(state.rootContext)!.update_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 持久化状态更新
      StoreProvider.of<WMSState>(state.rootContext).state.login = false;
      // 持久化状态更新
      StoreProvider.of<WMSState>(state.rootContext).state.userInfo = null;
      // 持久化状态
      StoreProvider.of<WMSState>(state.rootContext).state.loginUser =
          systm_user.User.empty();
      // 持久化状态
      StoreProvider.of<WMSState>(state.rootContext).state.loginAuthority = [];

      // 提示弹窗
      showDialog(
        context: state.rootContext,
        builder: (context) {
          return WMSDiaLogWidget(
            titleText:
                WMSLocalizations.i18n(context)!.login_tip_title_modify_pwd_text,
            contentText:
                WMSLocalizations.i18n(context)!.password_changed_log_again,
            buttonLeftFlag: false,
            buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
            onPressedRight: () {
              // 跳转页面
              GoRouter.of(context).replaceNamed(LoginPage.sName);
              // 关闭弹窗
              Navigator.pop(context);
            },
          );
        },
      );

      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 保存临时值事件
    on<SaveTempValueEvent>((event, emit) async {
      // 临时值
      state.tempValue = event.tempValue;
      // 更新
      emit(clone(state));
    });

    // 保存位置标记和位置下标
    on<SaveLocationFlagAndLocationIndexEvent>((event, emit) async {
      // 判断位置下标
      if (event.locationIndex == Config.NUMBER_FIVE) {
        // 查询会社情报
        List<dynamic> companyData = await SupabaseUtils.getClient()
            .from('mtb_company')
            .select('*')
            .eq(
                'id',
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser
                    ?.company_id);
        // 判断会社状态
        if (companyData[0]['status'] == Config.NUMBER_THREE.toString() ||
            companyData[0]['status'] == Config.NUMBER_FOUR.toString()) {
          // 提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .is_termination_no_apply_again);
          return;
        }
      }
      // 位置标记
      state.locationFlag = event.locationFlag;
      // 位置下标
      state.locationIndex = event.locationIndex;
      // 更新
      emit(clone(state));
    });

    //发送解约邮件
    on<SendCancellationMailEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      try {
        String? toMail =
            StoreProvider.of<WMSState>(state.rootContext).state.userInfo?.login;
        if (toMail == null) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_confirm_text_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        String url = Config.BASE_URL + '/contract';
        String content = '''
               <h2>購買依頼終了の確認</h2>

               <p>このリンクをクリックしてキャンセル：</p>
               <p><a href="$url">$url</a></p>
            ''';

        MailUtils.sendEmailWithSMTP(toMail, "購買依頼終了の確認", content);
        // 成功提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .login_confirm_text_success);

        // 临时值
        state.tempValue = '';
        // 位置标记
        state.locationFlag = false;
        // 位置下标
        state.locationIndex = Config.NUMBER_ZERO;
        // 查询用户事件
        await selectUserData(state);

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.login_confirm_text_error);
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 设置头像提示文本显示事件
    on<SetAvatarTooltipShowEvent>((event, emit) async {
      // 头像提示文本显示
      state.avatarTooltipShow = event.avatarTooltipShow;
      // 更新
      emit(clone(state));
    });

    // 设置弹窗临时值事件
    on<SetDialogTempValue1Event>((event, emit) async {
      // 弹窗临时值
      state.dialogTempValue1 = event.value;
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

    // 关闭变更弹窗事件
    on<CloseChangeDialogEvent>((event, emit) async {
      // 关闭变更弹窗
      closeChangeDialog(state, event.context);

      // 更新
      emit(clone(state));
    });

    // 变更注册名称事件
    on<ChangeLoginNameEvent>((event, emit) async {
      // 变更注册名称验证
      bool flag = changeLoginNameCheck(state);
      // 判断验证结果
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 变更用户
        await SupabaseUtils.getClient()
            .from('mtb_user')
            .update({'name': state.dialogTempValue1}).eq(
                'id',
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser
                    ?.id);
        // 关闭变更弹窗
        closeChangeDialog(state, event.context);

        // 查询用户事件
        await selectUserData(state);
        // 查询计划事件
        await selectPlanData(state);

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

        // 变更用户
        await SupabaseUtils.getClient().from('mtb_company').update({
          'addr_1': state.dialogTempValue1,
          'addr_2': state.dialogTempValue2,
          'addr_3': state.dialogTempValue3
        }).eq(
            'id',
            StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.company_id);
        // 关闭变更弹窗
        closeChangeDialog(state, event.context);

        // 查询用户事件
        await selectUserData(state);
        // 查询计划事件
        await selectPlanData(state);

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 添加用户事件
    on<AddUserEvent>((event, emit) async {
      // 添加用户验证
      bool flag = addUserCheck(state);
      // 判断验证结果
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 注册账号
        String? uid = await signUpNewUser(state);
        if (uid == '') {
          // 关闭加载
          BotToast.closeAllLoading();
        } else {
          // 新增用户
          systm_user.User user = await createUser(state);
          user.role_id = Config.ROLE_ID_2;
          user.code = uid;
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

        // 注册账号
        String? uid = await signUpNewUser(state);
        if (uid == '') {
          // 关闭加载
          BotToast.closeAllLoading();
        } else {
          // 新增用户
          systm_user.User user = await createUser(state);
          user.role_id = Config.ROLE_ID_3;
          user.code = uid;
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
      }
    });

    // 发起解约事件
    on<ProposeCancelEvent>((event, emit) async {
      // 判断是否存在解约数据
      if (state.cancelData['id'] == null || state.cancelData['id'] == '') {
        // 打开加载状态
        BotToast.showLoading();

        // 新增解约数据
        Cancel cancel = Cancel.empty();
        cancel.user_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        cancel.company_id = StoreProvider.of<WMSState>(state.rootContext)
            .state
            .loginUser
            ?.company_id;
        cancel.admin_confirm_status = Config.NUMBER_ZERO.toString();
        cancel.create_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        cancel.create_time = DateTime.now().toString();
        cancel.update_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        cancel.update_time = DateTime.now().toString();
        List<Map<String, dynamic>> cancelList = await SupabaseUtils.getClient()
            .from('ytb_cancel')
            .insert([cancel.toJson()]).select('*');
        // 解约数据
        state.cancelData = cancelList[0];
        // 新增消息数据
        Message message = Message.empty();
        message.title = '【重要】解約申請されました';
        message.message = state.planData['user_name'] +
            '様から解約申請が来ております。\n' +
            '解約のご返信をお願いいたします。\n\n' +
            '----------------------------------\n' +
            '◆ 削除するユーザー\n\n' +
            'メールアドレス：' +
            state.planData['user_email'] +
            '\n' +
            '登録名：' +
            state.planData['user_name'] +
            '\n' +
            '----------------------------------\n\n' +
            'ご不便をおかけいたしますが、解約URLのご送信よろしくお願い致します。';
        message.push_kbn = Config.NUMBER_TWO;
        message.del_kbn = Config.NUMBER_TWO.toString();
        message.create_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        message.create_time = DateTime.now().toString();
        message.update_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
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
        messageHistory.create_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        messageHistory.create_time = DateTime.now().toString();
        messageHistory.update_id =
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
        messageHistory.update_time = DateTime.now().toString();
        await SupabaseUtils.getClient()
            .from('ytb_message_history')
            .insert([messageHistory.toJson()]).select('*');
        // 消息提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .account_application_has_been_sent);
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .account_application_initiated_please_wait);
      }
    });

    // 确认解约事件
    on<ConfirmCancelEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 修改公司信息
      await SupabaseUtils.getClient().from('mtb_company').update({
        'status': Config.NUMBER_THREE.toString(),
        'update_id':
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id,
        'update_time': DateTime.now().toString()
      }).eq(
          'id',
          StoreProvider.of<WMSState>(state.rootContext)
              .state
              .loginUser
              ?.company_id);
      // 消息提示
      WMSCommonBlocUtils.successTextToast(
          WMSLocalizations.i18n(state.rootContext)!.app_cancel_finish);
      // 持久化状态更新
      StoreProvider.of<WMSState>(state.rootContext).state.login = false;
      // 持久化状态更新
      StoreProvider.of<WMSState>(state.rootContext).state.userInfo = null;
      // 持久化状态
      StoreProvider.of<WMSState>(state.rootContext).state.loginUser =
          systm_user.User.empty();
      // 持久化状态
      StoreProvider.of<WMSState>(state.rootContext).state.loginAuthority = [];
      // 跳转页面
      GoRouter.of(state.rootContext).go('/login');

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });
    // 生成验证二维码
    on<JudgeQREvent>((event, emit) async {
      if (state.userCustomize['authenticator_key'] == null ||
          state.userCustomize['authenticator_key'] == '') {
        // 查询用户列表
        List<dynamic> userTempList = await SupabaseUtils.getClient()
            .from('mtb_user')
            .select('*')
            .eq(
                'id',
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser
                    ?.id);
        if (userTempList.length > 0 &&
            (userTempList[0]['authenticator_key'] == null ||
                userTempList[0]['authenticator_key'] == '')) {
          //生成二维码秘钥
          String authenticatorKey = OTP.randomSecret();
          state.userCustomize['authenticator_key'] = authenticatorKey;
          // 保存二维码秘钥
          await SupabaseUtils.getClient().from('mtb_user').update({
            'authenticator_key': authenticatorKey,
            'update_id': StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.id,
            'update_time': DateTime.now().toString()
          }).eq(
              'id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.id);
        }
      }
      // 更新
      emit(clone(state));
    });

    add(InitEvent());
  }

  // 查询解约数据
  Future<void> selectCancelData(AccountModel state) async {
    // 查询解约管理
    List<dynamic> cancelData = await SupabaseUtils.getClient()
        .from('ytb_cancel')
        .select('*')
        .eq(
            'company_id',
            StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.company_id);
    // 解约数据
    state.cancelData = cancelData.length != 0 ? cancelData[0] : {};
  }

  // 查询用户数据
  Future<void> selectUserData(AccountModel state) async {
    // 查询用户信息
    List<Map<String, dynamic>> userData = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_query_item_mtb_user', params: {
      'id': StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id
    }).select('*');

    // 判断用户信息数量
    if (userData.length != 0) {
      // 持久化状态更新
      StoreProvider.of<WMSState>(state.rootContext).dispatch(
          RefreshLoginUserAction(systm_user.User.fromJson(userData[0])));
      // 用户-定制
      state.userCustomize = userData[0];

      // 判断账户头像
      if (userData[0]['avatar'] != null && userData[0]['avatar'] != '') {
        // 头像线上路径
        state.avatarNetwork =
            await WMSCommonFile().previewImageFile(userData[0]['avatar']);
      } else {
        // 头像线上路径
        state.avatarNetwork = '';
      }
    } else {
      // 持久化状态更新
      StoreProvider.of<WMSState>(state.rootContext).state.login = false;
      // 持久化状态更新
      StoreProvider.of<WMSState>(state.rootContext).state.userInfo = null;
      // 持久化状态
      StoreProvider.of<WMSState>(state.rootContext).state.loginUser =
          systm_user.User.empty();
      // 持久化状态
      StoreProvider.of<WMSState>(state.rootContext).state.loginAuthority = [];

      // 提示弹窗
      showDialog(
        context: state.rootContext,
        builder: (context) {
          return WMSDiaLogWidget(
            titleText:
                WMSLocalizations.i18n(context)!.login_tip_title_modify_pwd_text,
            contentText: WMSLocalizations.i18n(context)!.login_user_error,
            buttonLeftFlag: false,
            buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
            onPressedRight: () {
              // 跳转页面
              GoRouter.of(context).replaceNamed(LoginPage.sName);
              // 关闭弹窗
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  // 查询计划数据
  Future<void> selectPlanData(AccountModel state) async {
    // 查询计划信息
    List<Map<String, dynamic>> planList = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_query_table_ytb_company_manage_corporation', params: {
      'p_company_name': null,
      'p_company_id': StoreProvider.of<WMSState>(state.rootContext)
          .state
          .loginUser
          ?.company_id
    }).select("*");
    // 计划数据
    state.planData = planList.length != 0 ? planList[0] : {};
    // 空间使用数量
    state.spaceUsageNumber = state.planData['storage_size'] == null ||
            state.planData['storage_size'] == ''
        ? 0.0
        : double.parse(double.parse(state.planData['storage_size'].toString())
            .toStringAsFixed(2));
    // 空间最大数量
    state.spaceMaxNumber =
        state.planData['storage'] == null || state.planData['storage'] == ''
            ? 99999999.0
            : double.parse(state.planData['storage'].toString());
    // 查询角色2用户数据
    await selectRole2UserData(state);
    // 查询角色3用户数据
    await selectRole3UserData(state);
  }

  // 查询角色2用户数据
  Future<void> selectRole2UserData(AccountModel state) async {
    // 查询会社管理员
    List<dynamic> role2UserList = await SupabaseUtils.getClient()
        .from('mtb_user')
        .select('*')
        .eq('role_id', Config.ROLE_ID_2)
        .eq(
            'company_id',
            StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.company_id);
    // 角色2用户数量
    state.role2UserNumber = role2UserList.length;
  }

  // 查询角色3用户数据
  Future<void> selectRole3UserData(AccountModel state) async {
    // 查询普通用户
    List<dynamic> role3UserList = await SupabaseUtils.getClient()
        .from('mtb_user')
        .select('*')
        .eq('role_id', Config.ROLE_ID_3)
        .eq(
            'company_id',
            StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.company_id);
    // 角色3用户数量
    state.role3UserNumber = role3UserList.length;
  }

  // 关闭变更弹窗
  void closeChangeDialog(AccountModel state, BuildContext context) {
    // 弹窗临时值
    state.dialogTempValue1 = '';
    state.dialogTempValue2 = '';
    state.dialogTempValue3 = '';
    // 关闭弹窗
    Navigator.pop(context);
  }

  // 变更注册名称验证
  bool changeLoginNameCheck(AccountModel state) {
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
  bool changeAddressCheck(AccountModel state) {
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

  // 添加用户验证
  bool addUserCheck(AccountModel state) {
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

  // 注册账号
  // Supabase.instance.client.auth.
  Future<String?> signUpNewUser(AccountModel state) async {
    // 配置文件
    EnvConfig? envConfig = EnvConfig.fromJson(config);
    // 初始化Supabase
    final supabase =
        SupabaseClient(envConfig.supabase_url, envConfig.supabase_role_key);
    try {
      // 更新授权
      final response = await supabase.auth.admin.createUser(AdminUserAttributes(
        email: state.dialogTempValue1,
        password: '123456',
        emailConfirm: true,
      ));
      final LoginUser.User? user = response.user;
      return user?.id;
    } catch (e) {
      // 失败提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!.menu_content_98_24 +
              WMSLocalizations.i18n(state.rootContext)!.create_error);
      return '';
    }
  }

  // 新建用户
  Future<systm_user.User> createUser(AccountModel state) async {
    // 新增用户
    systm_user.User user = systm_user.User.empty();
    user.name = state.dialogTempValue2;
    user.company_id = StoreProvider.of<WMSState>(state.rootContext)
        .state
        .loginUser
        ?.company_id;
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
    return user;
  }
}
